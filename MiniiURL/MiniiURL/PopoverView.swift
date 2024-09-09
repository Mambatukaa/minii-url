//
//  PopoverView.swift
//  MiniiURL
//
//  Created by Mambatukaa on 2024.09.04.
//

import SwiftUI
import AppKit


struct MyActionButtonStyle: ButtonStyle {
  
  @State private var hover: Bool = false
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.headline.bold())
      .foregroundColor(.white)
      .frame(height: 44)
      .frame(maxWidth: .infinity)
      .background(
        RoundedRectangle(cornerRadius: 10).fill(hover ? Color.teal: Color.blue).shadow(color: .white, radius: 5, x: 0, y: 0)).onHover { isHovered in
          self.hover = isHovered
          DispatchQueue.main.async { //<-- Here
            if (self.hover) {
              NSCursor.pointingHand.push()
            } else {
              NSCursor.pop()
            }
          }
        }
  }
}

struct URLItemView: View {
  // Dynamic properties that you can pass into the component
  var longURL: String
  var shortURL: String
  var copyAction: () -> Void
  var deleteAction: () -> Void
  
  @State private var isHoveringCopy = false
  @State private var isHoveringTrash = false
  
  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading) {
          Text(AttributedString(shortURL))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text(AttributedString(longURL))
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.caption)
        }
        .padding(8)
        
        HStack {
          // Copy Button
          Button(action: {
            copyAction()
          }) {
            Image(systemName: "doc.on.doc")
              .foregroundColor(isHoveringCopy ? .blue : Color(.lightGray))
              .onHover { hovering in
                isHoveringCopy = hovering
                DispatchQueue.main.async {
                  if isHoveringCopy {
                    NSCursor.pointingHand.push()
                  } else {
                    NSCursor.pop()
                  }
                }
              }
          }.buttonStyle(PlainButtonStyle())
          
          // Delete Button
          Button(action: {
            deleteAction()
          }) {
            Image(systemName: "trash")
              .foregroundColor(isHoveringTrash ? .red : Color(.lightGray))
              .onHover { hovering in
                isHoveringTrash = hovering
                DispatchQueue.main.async {
                  if isHoveringTrash {
                    NSCursor.pointingHand.push()
                  } else {
                    NSCursor.pop()
                  }
                }
              }
          }.buttonStyle(PlainButtonStyle())
        }
        .padding(.trailing, 12)
      }
      .background(Color.gray.opacity(0.4))
      .frame(maxWidth: .infinity)
      .cornerRadius(8)
      .padding(.horizontal, 8).padding(.bottom, 5)
    }
  }
}


struct URLItemListView: View {
  // FetchRequest sorted by timestamp in descending order (newest first)
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \QLLink.timestamp, ascending: false)]
  ) var links: FetchedResults<QLLink>
  
  @Environment(\.managedObjectContext) private var viewContext
  
  @State private var contentHeight: CGFloat = .zero // Track the content height
  
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack {
        ForEach(links) { link in
          URLItemView(
            longURL: link.wrappedLongURL.absoluteString,
            shortURL: link.wrappedShortURL.absoluteString,
            copyAction: {
              // Copy action logic
              NSPasteboard.general.clearContents()
              NSPasteboard.general.setString(link.wrappedShortURL.absoluteString, forType: .string)
              AppDelegate.popover.performClose(nil)
            },
            deleteAction: {
              viewContext.delete(link)
              
              do {
                try viewContext.save() // Save the context to persist the deletion
              } catch {
                // Handle error (e.g., show an alert or log the error)
                print("Failed to delete the item: \(error.localizedDescription)")
              }
            }
          ).background(GeometryReader { geometry in
            Color.clear.onAppear {
              print("size:", contentHeight, geometry.size.height)
              contentHeight += geometry.size.height
              
              if contentHeight > 200 {
                contentHeight = 200
              }
            }
          })
        }
      }
    }.frame(height: min(contentHeight, 200)) // ScrollView will expand to content height but max 400
      .onAppear {
        // Reset content height on appearance to recalculate
        contentHeight = .zero
      }
    
  }
}

struct PopoverView: View {
  @Environment(\.managedObjectContext) var viewContext
  
  var cacheManager: CacheManager {
    return CacheManager(context: viewContext)
  }
  
  @FetchRequest(sortDescriptors: [])
  var links: FetchedResults<QLLink>
  
  @State private var longURL: String = ""
  @State private var shortURLCode: String = "NONE"
  
  @State private var isLoading = false
  @State private var showClearButton = false
  
  
  
  func isValidURL(urlString: String) -> Bool {
    let regex = #"((http|https):\/\/)?(www\.)?([a-zA-Z0-9-]+\.)+([a-zA-Z]{2,})(\/[a-zA-Z0-9#?&=._-]*)*\/?"#
    
    let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
    return predicate.evaluate(with: urlString)
  }
  
  
  var body: some View {
    VStack() {
      
      HStack {
        TextField("Copy an URL to shorten", text: $longURL).onChange(of: longURL){
          if showClearButton {
            showClearButton = false
          }
          
        }.disableAutocorrection(true).padding().background(.white).textFieldStyle(.plain).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)}
      
      if isValidURL(urlString: longURL) {
        if !isLoading && !showClearButton {
          // Shorten URL ACTION
          Button(action:{
            
            // Start the loader
            isLoading = true
            
            NSSound(named: "Blow")?.play()
            
            Task {
              do {
                let APP_URL = try Utils.shared.getConfigItem(name: "APP_URL")
                
                // Await the result of getShortUrlCode() and capture the short URL code
                let shortURLCode = try await APIService.shared.getShortUrlCode(longURL: longURL)
                
                let shortUrl: String = (APP_URL) + "/" + shortURLCode
                
                NSPasteboard.general.setString(shortUrl, forType: .string)
                
                // Set the short URL code in the cache manager
                cacheManager.setLink(shortURL: shortUrl, forLongURL: longURL)
                
                showClearButton = true
                isLoading = false
                
              } catch {
                // Handle any errors that occurred during getShortUrlCode
                print("Failed to get short URL code: \(error)")
                isLoading = false
              }
            }
            
            
          }) {
            Text("Shorten").font(.title2).bold()
          }.buttonStyle(MyActionButtonStyle()).padding(.horizontal, 8).padding(.bottom, 4)
          
          
        }
        
        // Show the loader while the task is running
        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle()).padding(4)
        }
        
        // Show the "Clear" button after the task is complete
        if showClearButton {
          Button(action: {
            // Clear action
            NSSound(named: "Basso")?.play()
            
            showClearButton = false  // Hide the Clear button
            
            longURL = ""
          }) {
            Text("Clear").font(.title2).bold()
          }
          .buttonStyle(MyActionButtonStyle())
          .padding(.horizontal, 8)
          .padding(.bottom, 4)
        }
      }
      
      // Render URL Items
      URLItemListView()
      
    }.padding(.bottom, 12).background(.white)
    
  }
}


#Preview {
  PopoverView()
}
