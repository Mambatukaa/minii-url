//
//  ContentView.swift
//  miniiurl
//
//  Created by Mambatukaa on 2024.09.03.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
      Text("Welcome to MiniiURL").padding(64)
      
    }
}

#Preview {
    ContentView()
}
