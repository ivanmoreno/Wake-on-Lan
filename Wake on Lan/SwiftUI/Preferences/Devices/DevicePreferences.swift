//
//  DevicesPreferences.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import SwiftUI

struct DevicePreferences: View {
    
    @State var selection: Set<Int> = [0]
    @State var showSheet = false
    @State var sheet = Sheet.add
    
    enum Sheet {
        case add, edit
    }
    
    @FetchRequest(
        entity: WOLDevice.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \WOLDevice.name, ascending: true)
        ]
    ) var devices: FetchedResults<WOLDevice>
    
    var body: some View {
        contentView
            .frame(width: 500, height: 300)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }
    
    @ViewBuilder
    private var contentView: some View {
        VStack {
            HStack {
                Button(action: {presentSheet(.add)}){
                    Text("New")
                }
                Button(action: {presentSheet(.edit)}){
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
            .sheet(isPresented: $showSheet) {
                if sheet == .add {
                    AddDeviceView(showAddDeviceView: $showSheet)
                        .frame(width: 350)
                }
                if sheet == .edit {
                    EditDeviceView(showEditDeviceView: $showSheet, device: devices[selection.first!])
                        .frame(width: 350)
                }
            }
            
        }
    }
    
    private func presentSheet(_ sheet: Sheet){
        self.sheet = sheet
        showSheet = true
        
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
