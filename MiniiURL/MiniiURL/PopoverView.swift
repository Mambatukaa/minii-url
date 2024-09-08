//
//  PopoverView.swift
//  MiniiURL
//
//  Created by Mambatukaa on 2024.09.04.
//

import SwiftUI


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
            longURL: link.wrappedLongUrl.absoluteString,
            shortURL: link.wrappedShortUrl.absoluteString,
            copyAction: {
              // Copy action logic
              NSPasteboard.general.clearContents()
              NSPasteboard.general.setString(link.wrappedShortUrl.absoluteString, forType: .string)
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
  
  @State private var linkURL: String = ""
  @State private var responseData: String = ""
  
  func isValidURL(urlString: String) -> Bool {
    
    let regex = #"((http|https):\/\/)?(www\.)?([a-zA-Z0-9-]+\.)+([a-zA-Z]{2,})(\/[a-zA-Z0-9#?&=._-]*)*\/?"#
    
    let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
    return predicate.evaluate(with: urlString)
  }
  
  func sendPostRequest() {
    guard let url = URL(string: "https://6b63-50-35-120-194.ngrok-free.app/url") else {
      print("Invalid URL")
      return
    }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Error: \(error)")
        return
      }
      
      guard let data = data else {
        print("No data")
        return
      }
      
      
      // Convert data to string (or process it as JSON, etc.)
      if let responseDataString = String(data: data, encoding: .utf8) {
        DispatchQueue.main.async {
          responseData = responseDataString
          print("Response received: \(responseDataString)")
          
        }
      }
      
      
    }.resume()
  }
  
  
  
  var body: some View {
    VStack() {
      
      HStack {
        TextField("Copy an URL to shorten", text: $linkURL).disableAutocorrection(true).padding().background(.white).textFieldStyle(.plain).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)}
      
      if isValidURL(urlString: linkURL) {
        // Shorten URL ACTION
        Button(action:{
          // Send request to the api
          // sendPostRequest()
          cacheManager.setLink(shortUrl: linkURL, forLongUrl: linkURL)
        }) {
          Text("Shorten").font(.title2).bold()
        }.buttonStyle(MyActionButtonStyle()).padding(.horizontal, 8).padding(.bottom, 4)
      }
      
      URLItemListView()
      
    }.padding(.bottom, 12).background(.white)
    
  }
}


#Preview {
  PopoverView()
}
