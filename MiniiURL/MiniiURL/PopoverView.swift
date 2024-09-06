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

struct PopoverView: View {
  @Environment(\.managedObjectContext) var viewContext
  
  @FetchRequest(sortDescriptors: [])
  var links: FetchedResults<QLLink>
  
  @State private var isHoveringCopy = false
  @State private var isHoveringTrash = false
  
  @State private var linkURL: String = ""
  
  func isValidURL(urlString: String) -> Bool {
    return true
  }
  
  var body: some View {
    VStack() {
      
      HStack {
        TextField("Copy an URL to shorten", text: $linkURL).disableAutocorrection(true).padding().background(.white).textFieldStyle(.plain).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)}
      
      if isValidURL(urlString: linkURL) {
        Button(action:{
          print(linkURL, "====================")
          
          if !linkURL.isEmpty {
            let qllink = QLLink(context: viewContext)
            qllink.id = UUID()
            qllink.title = "Test"
            qllink.url = linkURL
            
            try? viewContext.save()
            
          }
          
          print("Hello")
        }) {
          Text("Shorten").font(.title2).bold()
        }.buttonStyle(MyActionButtonStyle()).padding()
        
      }
      
      //      ForEach(links, id: \.wrappedID) { link in
      //        HStack {
      //          Link(link.wrappedTitle, destination: link.wrappedURL)
      //
      //          Spacer()
      //
      //          Button {
      //            NSPasteboard.general.clearContents()
      //            NSPasteboard.general.setString(link.url!, forType: .string)
      //
      //            AppDelegate.popover.performClose(nil)
      //          } label: {
      //            Image(systemName: "arrow.right.docon.clipboard")
      //          }
      //        }
      //
      //      }
      
      HStack() {
        VStack {
          Text(AttributedString("https://miniiurl.site/")).foregroundStyle(.black).frame(maxWidth: .infinity, alignment: .leading)
          
          Text(AttributedString("https://stackoverflow.com/questions/62649566/add-variable-to-url-in-swift")).foregroundStyle(.gray).frame(maxWidth: .infinity, alignment: .leading).font(.caption)
        }.padding(10)
        
        HStack {
          
          Image(systemName: "doc.on.doc")
            .foregroundColor(isHoveringCopy ? .blue : Color(.lightGray)) // Change color on hover
            .onHover { hovering in
              isHoveringCopy = hovering
              
              DispatchQueue.main.async { //<-- Here
                if (self.isHoveringTrash) {
                  NSCursor.pointingHand.push()
                } else {
                  NSCursor.pop()
                }
              }
              
            }
          
          Image(systemName: "trash")
            .foregroundColor(isHoveringTrash ? .red : Color(.lightGray)) // Change color on hover
            .onHover { hovering in
              isHoveringTrash = hovering
              DispatchQueue.main.async { //<-- Here
                if (self.isHoveringTrash) {
                  NSCursor.pointingHand.push()
                } else {
                  NSCursor.pop()
                }
              }
              
            }
          
          
        }.padding(.trailing, 10)
        
        
      }.background(.gray.opacity(0.4)).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/).cornerRadius(8).padding([.horizontal, .bottom])
      
      
    }.background(.white)
    
  }
}

#Preview {
  PopoverView()
}
