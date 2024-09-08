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
  var mainURL: String
  var subURL: String
  var copyAction: () -> Void
  var deleteAction: () -> Void
  
  @State private var isHoveringCopy = false
  @State private var isHoveringTrash = false
  
  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading) {
          Text(AttributedString(mainURL))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text(AttributedString(subURL))
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

struct PopoverView: View {
  @Environment(\.managedObjectContext) var viewContext
  
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
          
          if !responseData.isEmpty {
            let qllink = QLLink(context: viewContext)
            
            qllink.shortUrl = "https://miniiurl.site/" + responseData
            qllink.longUrl = linkURL
            
            try? viewContext.save()
            
          }
          
          print(links, "Hello", responseData)
        }) {
          Text("Shorten").font(.title2).bold()
        }.buttonStyle(MyActionButtonStyle()).padding(.horizontal, 8).padding(.bottom, 4)
      }
      
      ForEach(links) { link in
        URLItemView(
          mainURL: "https://miniiurl.site/",
          subURL: "https://stackoverflow.com/questions/62649566/add-variable-to-url-in-swift",
          copyAction: {
            // Copy action logic
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString("https://miniiurl.site", forType: .string)
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
        )
        
        
        //        VStack {
        //          HStack() {
        //            VStack {
        //              Text(AttributedString("https://miniiurl.site/")).foregroundStyle(.black).frame(maxWidth: .infinity, alignment: .leading)
        //
        //              Text(AttributedString("https://stackoverflow.com/questions/62649566/add-variable-to-url-in-swift")).foregroundStyle(.gray).frame(maxWidth: .infinity, alignment: .leading).font(.caption)
        //            }.padding(10)
        //
        //            HStack {
        //
        //              Button(action: {
        //
        //                NSPasteboard.general.clearContents()
        //                NSPasteboard.general.setString("https://miniiurl.site", forType: .string)
        //
        //                AppDelegate.popover.performClose(nil)
        //
        //              }) {
        //                Image(systemName: "doc.on.doc")
        //                  .foregroundColor(isHoveringCopy ? .blue : Color(.lightGray)) // Change color on hover
        //                  .onHover { hovering in
        //                    isHoveringCopy = hovering
        //
        //                    DispatchQueue.main.async { //<-- Here
        //                      if (self.isHoveringTrash) {
        //                        NSCursor.pointingHand.push()
        //                      } else {
        //                        NSCursor.pop()
        //                      }
        //                    }
        //
        //                  }
        //              }.buttonStyle(PlainButtonStyle())
        //
        //              Button(action: {
        //                viewContext.delete(link)
        //
        //              }) {
        //                Image(systemName: "trash")
        //                  .foregroundColor(isHoveringTrash ? .red : Color(.lightGray)) // Change color on hover
        //                  .onHover { hovering in
        //                    isHoveringTrash = hovering
        //                    DispatchQueue.main.async { //<-- Here
        //                      if (self.isHoveringTrash) {
        //                        NSCursor.pointingHand.push()
        //                      } else {
        //                        NSCursor.pop()
        //                      }
        //                    }
        //
        //                  }
        //              }.buttonStyle(PlainButtonStyle())
        //
        //
        //            }.padding(.trailing, 10)
        //
        //
        //          }.background(.gray.opacity(0.4)).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/).cornerRadius(8).padding([.horizontal, .bottom])
        //
        //        }
      }
      
      
    }.padding(.bottom, 12).background(.white)
    
  }
}


#Preview {
  PopoverView()
}
