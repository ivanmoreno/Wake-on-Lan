//
//  AppDelegate.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import Cocoa
import CoreData

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var statusBarItem: NSStatusItem!
    private let statusBarMenu = NSMenu(title: "Status Bar Menu")
    
    var moc: NSManagedObjectContext!
    private var fetchedResultsController: NSFetchedResultsController<WOLDevice>!
    private var coreDataCancellable: NSObjectProtocol?
    
    private lazy var preferencesWindow: NSWindow = AKPreferencesWindow()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Status Bar Item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        statusBarItem.menu = statusBarMenu
        if let button = self.statusBarItem.button {
            button.image = NSImage(systemSymbolName: "network", accessibilityDescription: "Wake on Lan")
        }
        
        // Core Data Context
        let container = NSPersistentContainer(name: "WOL")
        container.loadPersistentStores { storeDescription, error in
            if error != nil {
                fatalError("Could not initialize CoreData")
            }
        }
        moc = container.viewContext
        
        // Core Data Fetch Request
        let fetchRequest = NSFetchRequest<WOLDevice>(entityName: "WOLDevice")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Core Data Controller
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        // Init menu
        fetchAndUpdate()
        
        // Suscribe to Core Data changes when Context saves changes
        coreDataCancellable = NotificationCenter.default
            .addObserver(forName: .NSManagedObjectContextDidSave,
                         object: nil,
                         queue: nil) { _ in
                self.fetchAndUpdate()
            }
        
    }
    
}

// MARK: - Fetch and fill menu {
extension AppDelegate {
    
    func fillMenu(with objects: [WOLDevice]){
        
        statusBarMenu.removeAllItems()
        
        objects.forEach { object in
            let item = NSMenuItem(title: object.name,
                                  action: #selector(AppDelegate.sendWOL(_:)),
                                  keyEquivalent: "")
            item.representedObject = object
            statusBarMenu.addItem(item)
        }
        
        statusBarMenu.addItem(.separator())
        statusBarMenu.addItem(withTitle: "Preferences",
                              action: #selector(AppDelegate.openPreferences),
                              keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "Quit",
                              action: #selector(AppDelegate.quitApp),
                              keyEquivalent: "")
    }
    
    func fetchAndUpdate(){
        do {
            try fetchedResultsController.performFetch()
            let wolDevices = (fetchedResultsController.fetchedObjects ?? [])
            fillMenu(with: wolDevices)
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
}

// MARK: - Selectors
extension AppDelegate {
    @objc func openPreferences(_ sender: AnyObject?){
        NSApp.activate(ignoringOtherApps: true)
        preferencesWindow.makeKeyAndOrderFront(nil)
        preferencesWindow.isReleasedWhenClosed = false
    }
    
    @objc func quitApp(_ sender: AnyObject?){
        NSApplication.shared.terminate(self)
    }
    
    @objc func sendWOL(_ sender: AnyObject?){
        let wolDevice = sender?.representedObject as! WOLDevice
        wolDevice.awake()
    }
}
