//
//  Appdelegate.swift
//  MiniiURL
//
//  Created by Mambatukaa on 2024.09.04.
//

import SwiftUI


class AppDelegate: NSObject, NSApplicationDelegate {
  static var popover = NSPopover()
  var statusBar: StatusBarController?
  
  func applicationDidFinishLaunching(_ notification: Notification){
    Self.popover.contentViewController = NSHostingController(rootView: PopoverView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext))
    
    Self.popover.behavior = .transient
    
    statusBar = StatusBarController(Self.popover)
  }
  
}
