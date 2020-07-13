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
    
    var moc: NSManagedObjectContext!
    let statusBarMenu = NSMenu(title: "Status Bar Menu")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Create the SwiftUI view that provides the window contents.
        let container = NSPersistentContainer(name: "WOL")
        container.loadPersistentStores { storeDescription, error in
            if error != nil {
                fatalError("Could not initialize CoreData")
            }
        }
        moc = container.viewContext
        
        let contentView = ContentView()
            .environment(\.managedObjectContext, moc)
        
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
        
        let fetchRequest = NSFetchRequest<WOLDevice>(entityName: "WOLDevice")
        // Configure the request's entity, and optionally its predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
            let objects = (controller.fetchedObjects ?? []) as! [WOLDevice]
            fillMenu(objects: objects)
            print("performFetch")
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
                // Setting menu
                statusBarItem.menu = statusBarMenu
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func togglePopover(_ sender: AnyObject?){
    }
    
    /*@objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                self.popover.contentViewController?.view.window?.becomeKey()
            }
        }
    }*/
    
}


extension AppDelegate : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let objects = (controller.fetchedObjects ?? []) as [WOLDevice]
        print(objects)
        fillMenu(objects: objects)
        
    }
    
    @objc func openPreferences(_ sender: AnyObject?){
        let window = AKPreferencesWindow()
        window.makeKeyAndOrderFront(nil)
        window.isReleasedWhenClosed = false
    }
    
    func fillMenu(objects: [WOLDevice]){
        statusBarMenu.removeAllItems()
        objects.forEach { object in
            statusBarMenu.addItem(withTitle: object.name,                     action: #selector(AppDelegate.togglePopover),
                                  keyEquivalent: "")
        }
        statusBarMenu.addItem(withTitle: "Preferences",
                              action: #selector(AppDelegate.openPreferences),
                              keyEquivalent: "")
    }
    
}
