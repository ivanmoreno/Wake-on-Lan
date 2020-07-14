//
//  AddNewDeviceView.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import SwiftUI

struct AddDeviceView: View {
    
    @Binding var showAddDeviceView: Bool
    
    @State private var name = ""
    @State private var mac = ""
    @State private var broadcast  = Defaults.deviceBroadcast
    @State private var port = Defaults.devicePort
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "plus.circle")
                    .font(.title)
                Text("Add device")
                    .padding(.leading, 10)
                    .font(.title)
            }
            DeviceFormView(
                name: $name,
                mac: $mac,
                broadcast: $broadcast,
                port: $port,
                cancelAction: exitDeviceFormCreation,
                confirmLabel: "Add",
                confirmAction: addDevice
            )
            Spacer()
        }
        .padding()
    }
    
    private func exitDeviceFormCreation() {
        showAddDeviceView = false
    }
    
    private func addDevice() {
        // create new device
        CDManager.shared.addDevice(name: name, mac: mac, broadcast: broadcast, port: port)
        // exit form
        exitDeviceFormCreation()
    }
    
    private func canAddNewDevice() -> Bool{
        return
            !name.isEmpty &&
            !mac.isEmpty &&
            !broadcast.isEmpty &&
            !port.isEmpty
    }
}
