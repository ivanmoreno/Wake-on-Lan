//
//  AKPreferencesWindow.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import AppKit
import SwiftUI

class AKPreferencesWindow : NSWindow {
    
    let mainWindowToolbarIdentifier = NSToolbar.Identifier("PreferencesWindowToolbar")
    
    init() {
        let frame = NSRect(x: 20, y: 20, width: 600, height: 300)
        let styleMask: NSWindow.StyleMask = [.titled, .closable]
        super.init(contentRect: frame, styleMask: styleMask, backing: .buffered, defer: false)
        
        center()
        setFrameAutosaveName("Preferences")
        contentView = NSHostingView(rootView: PreferencesView().environment(\.managedObjectContext, CDManager.shared.moc))
        
        title = "Preferences"
        
        let newToolbar = NSToolbar(identifier: self.mainWindowToolbarIdentifier)
        newToolbar.displayMode = .default
        toolbar = newToolbar
    }
    
}
