//
//  PopoverView.swift
//  miniiurl
//
//  Created by Mambatukaa on 2024.09.03.
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
              RoundedRectangle(cornerRadius: 20).fill(hover ? Color.teal: Color.blue).shadow(color: .white, radius: 5, x: 0, y: 0)).onHover { isHovered in
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
  
  @FetchRequest(sortDescriptors: [])
  var links: FetchedResults<QLLink>
  
  @State private var linkURL: String = ""
  
  func isValidURL(urlString: String) -> Bool {
      return false
  }
  
  var body: some View {
    VStack() {
      
      HStack {
        TextField("Copy an URL to shorten", text: $linkURL).disableAutocorrection(true).padding().background(.white).textFieldStyle(.plain).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)}
      
      if isValidURL(urlString: linkURL) {
        Button(action:{
          print("Hello")
        }) {
          Text("Shorten").font(.title2).bold()
        }.buttonStyle(MyActionButtonStyle()).padding()

      }
      
      
    }.background(.white)
  }
}

#Preview {
    PopoverView()
}
