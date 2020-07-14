//
//  AKPreferencesWindow.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import AppKit
import SwiftUI

class AKPreferencesWindow : NSWindow {
    
    let preferencesWindowToolbarIdentifier = NSToolbar.Identifier("PreferencesWindowToolbar")
    let toolbarItemDevices = NSToolbarItem.Identifier("ToolbarDevicesItem")
    let toolbarItemAbout = NSToolbarItem.Identifier("ToolbarAboutItem")
    
    let moc = (NSApplication.shared.delegate as! AppDelegate).moc!
    
    init() {
        let frame = NSRect(x: 0,
                           y: 0,
                           width: Defaults.preferencesWindowWidth,
                           height: Defaults.preferencesWindowHeight)
        
        let styleMask: NSWindow.StyleMask = [.titled, .closable]
        super.init(contentRect: frame, styleMask: styleMask, backing: .buffered, defer: false)
        
        setFrameAutosaveName("Preferences")
        
        let newToolbar = NSToolbar(identifier: self.preferencesWindowToolbarIdentifier)
        newToolbar.delegate = self
        newToolbar.displayMode = .default
        
        title = "Wake on Lan"
        if #available(OSX 10.16, *) {
            toolbarStyle = .preference
            subtitle = "Preferences"
        }
        
        toolbar = newToolbar
        toolbar?.selectedItemIdentifier = toolbarItemDevices
        toolbar?.validateVisibleItems()
        
        changePreferencePanel(NSToolbarItem(itemIdentifier: toolbarItemDevices))
    }
    
    @objc func changePreferencePanel(_ sender:Any){
        if let toolbarItem = sender as? NSToolbarItem {
            
            if toolbarItemDevices == toolbarItem.itemIdentifier {
                contentView = NSHostingView(rootView: DevicePreferences().environment(\.managedObjectContext, moc))
            }
            
            if toolbarItemAbout == toolbarItem.itemIdentifier {
                contentView = NSHostingView(rootView: AboutView())
            }
            
        }
    }
    
}

extension AKPreferencesWindow: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem?
    {
        if  itemIdentifier == self.toolbarItemDevices {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(changePreferencePanel(_:))
            toolbarItem.label = "Devices"
            toolbarItem.toolTip = "Open Devices panel"
            if #available(OSX 10.16, *) {
                toolbarItem.image = NSImage(systemSymbolName: "pc", accessibilityDescription: "")
                toolbarItem.isBordered = true
            }else {
                toolbarItem.image = NSImage(named: NSImage.bonjourName)
            }
            
            return toolbarItem
        }
        
        if  itemIdentifier == self.toolbarItemAbout {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(changePreferencePanel(_:))
            toolbarItem.label = "About"
            toolbarItem.toolTip = "Open About panel"
            if #available(OSX 10.16, *) {
                toolbarItem.image = NSImage(systemSymbolName: "info.circle", accessibilityDescription: "")
                toolbarItem.isBordered = true
            }else {
                toolbarItem.image = NSImage(named: NSImage.bonjourName)
            }
            
            return toolbarItem
        }
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]
    {
        return [
            self.toolbarItemDevices,
            self.toolbarItemAbout,
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]
    {
        return [self.toolbarItemDevices,
                self.toolbarItemAbout,
        ]
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]
    {
        // Return the identifiers you'd like to show as "selected" when clicked.
        // Similar to how they look in typical Preferences windows.
        return [self.toolbarItemDevices,
                self.toolbarItemAbout,
        ]
    }
    
    // MARK: - Toolbar Validation
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool
    {
        // let itemIdentifier = item.itemIdentifier
        // print("Validating \(itemIdentifier)")
        
        // Use this method to enable/disable toolbar items as user takes certain
        // actions. For example, so items may not be applicable if a certain UI
        // element is selected. This is called on your behalf. Return false if
        // the toolbar item needs to be disabled.
        
        return true
    }
}
