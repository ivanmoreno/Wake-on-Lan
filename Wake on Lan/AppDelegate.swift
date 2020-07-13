//
//  AppDelegate.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import Cocoa
import SwiftUI
import CoreData

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Create the SwiftUI view that provides the window contents.
        let container = NSPersistentContainer(name: "WOL")
        container.loadPersistentStores { storeDescription, error in
            if error != nil {
                fatalError("Could not initialize CoreData")
            }
        }
        CDManager.shared.moc = container.viewContext
        let contentView = ContentView()
            .environment(\.managedObjectContext, container.viewContext)
        
        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 250, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(systemSymbolName: "network", accessibilityDescription: "Wake on Lan")
            button.action = #selector(togglePopover(_:))
            
        }
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                self.popover.contentViewController?.view.window?.becomeKey()
            }
        }
    }
    
}

