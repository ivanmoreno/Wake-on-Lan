//
//  DevicesPreferences.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import SwiftUI

struct DevicePreferences: View {
    
    @State var selection: Set<Int> = [0]
    @State var showAddNew = false
    @State var showEdit = false
    
    @FetchRequest(
        entity: WOLDevice.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \WOLDevice.name, ascending: true)
        ]
    ) var devices: FetchedResults<WOLDevice>
    
    var body: some View {
        contentView
            .frame(width: 600, height: 300)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.leading)
            .padding(.trailing)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if showAddNew {
            AddDeviceView(showAddDeviceView: $showAddNew)
        }
        
        if showEdit {
            EditDeviceView(showEditDeviceView: $showEdit, device: devices[selection.first!])
        }
        
        if !showEdit && !showAddNew {
            list
        }
    }
    
    private var list: some View {
        VStack {
            HStack {
                Button(action: {showAddNew.toggle()}){
                    Text("New")
                }
                Button(action: {showEdit.toggle()}){
                    Text("Edit")
                }.disabled(selection.count != 1 || devices.isEmpty)
                Button(action: deleteDevices){
                    Text("Delete")
                }.disabled(selection.isEmpty || devices.isEmpty)
            }
            List(selection: $selection) {
                ForEach(Array(devices.enumerated()), id:\.1.id){ index, device in
                    DeviceView(device: device)
                        .tag(index)
                }
            }
            
        }
        .padding(.leading)
        .padding(.trailing)
    }
    
    private func deleteDevices() {
        var delDevices = [WOLDevice]()
        selection.forEach{
            delDevices.append(devices[$0])
        }
        // without main.async app would crash
        DispatchQueue.main.async {
            CDManager.shared.deleteDevices(devices: delDevices)
        }
        selection = [0]
    }
}
