//
//  ContentView.swift
//  Wake on Lan
//
//

import SwiftUI

struct ContentView: View {
    
    @FetchRequest(
        entity: WOLDevice.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \WOLDevice.name, ascending: true)
        ]
    ) var devices: FetchedResults<WOLDevice>
        
    var body: some View {
        VStack {
            
            // Main content
            if devices.isEmpty {
                emptyView
            }else {
                deviceList
                    .listStyle(SidebarListStyle())
                
            }
            
            // Footer content
            HStack {
                Text("Wake on Lan")
                Spacer()
                Button(action:openPreferencesWindow){
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .padding(3)
                }.buttonStyle(PlainButtonStyle())
            }
            .padding()
            .padding(.bottom, 0)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Child views
    private var deviceList: some View {
        List {
            ForEach(devices, id:\.id){ device in
                DeviceView(device: device, enableHover: true)
                    .onTapGesture {
                        device.awake()
                        print("hello?")
                    }
            }
        }
        
    }
    
    @ViewBuilder
    private var emptyView: some View {
        Spacer()
        Button(action:openPreferencesWindow){
            HStack {
                Text("Add a new device")
                Image(systemName: "plus")
            }
        }.buttonStyle(PlainButtonStyle())
        Spacer()
    }
    
    private func openPreferencesWindow() {
        let window = AKPreferencesWindow()
        window.makeKeyAndOrderFront(nil)
        window.isReleasedWhenClosed = false
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
