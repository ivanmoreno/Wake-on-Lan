//
//  PreferencesView.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import SwiftUI

struct PreferencesView: View {
    
    enum Preferences {
        case devices, about
    }
    
    @State var preferencesSelection: Set<Preferences> = [.devices]
    
    var body: some View {
        
        NavigationView {
            List(selection: $preferencesSelection) {
                NavigationLink(destination: DevicePreferences()){
                    Label("Devices", systemImage: "pc")
                }
                .tag(Preferences.devices)
                
                NavigationLink(destination: AboutView()){
                    Label("About", systemImage: "info.circle")
                }
                .tag(Preferences.about)
            }
            .listStyle(SidebarListStyle())
            
            DevicePreferences()
            
        }
    }
}
