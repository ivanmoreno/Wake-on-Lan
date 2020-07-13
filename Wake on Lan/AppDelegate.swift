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
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        statusBarItem.menu = statusBarMenu
        if let button = self.statusBarItem.button {
            button.image = NSImage(systemSymbolName: "network", accessibilityDescription: "Wake on Lan")
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
        
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    
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
    
    @objc func quitWOL(_ sender: AnyObject?){
        NSApplication.shared.terminate(self)
    }
    
    @objc func sendWOL(_ sender: AnyObject?){
        let wolDevice = sender?.representedObject as! WOLDevice
        wolDevice.awake()
    }
    
    func fillMenu(objects: [WOLDevice]){
        statusBarMenu.removeAllItems()
        objects.forEach { object in
            
            let item = NSMenuItem(title: object.name, action: #selector(AppDelegate.sendWOL(_:)), keyEquivalent: "")
            item.representedObject = object
            statusBarMenu.addItem(item)
        }
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(withTitle: "Preferences",
                              action: #selector(AppDelegate.openPreferences),
                              keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "Quit",
                              action: #selector(AppDelegate.quitWOL),
                              keyEquivalent: "")
    }
    
}
