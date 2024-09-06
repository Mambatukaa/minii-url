//
//  AppDelegate.swift
//  miniiurl
//
//  Created by Mambatukaa on 2024.09.03.
//

import SwiftUI


class AppDelegate: NSObject, NSApplicationDelegate {
  static var popover = NSPopover()
  var statusBar: StatusBarController?
  
  func applicationDidFinishLaunching(_ notification: Notification){
    Self.popover.contentViewController = NSHostingController(rootView: PopoverView())
    
    Self.popover.behavior = .transient
    
    
    statusBar = StatusBarController(Self.popover)
  }
  
}
