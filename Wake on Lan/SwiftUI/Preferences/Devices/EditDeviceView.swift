//
//  AddNewDeviceView.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import SwiftUI

struct EditDeviceView: View {
    
    @Binding var showEditDeviceView: DevicePreferences.Sheet?
    
    @ObservedObject var device: WOLDevice
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "pc")
                    .font(.title)
                Text("Edit device")
                    .padding(.leading, 10)
                    .font(.title)
            }
            DeviceFormView(
                name: $device.name,
                mac: $device.mac,
                broadcast: $device.broadcast,
                port: $device.port,
                cancelAction: exitEditDeviceForm,
                confirmLabel: "Save",
                confirmAction: saveEdit
            )
            Spacer()
        }
        .padding()
    }
    
    private func saveEdit(){
        CDManager.shared.editDevice(
            device:device,
            name: device.name,
            mac: device.mac,
            broadcast: device.broadcast,
            port: device.port
        )
        exitEditDeviceForm()
    }
    
    private func exitEditDeviceForm(){
        showEditDeviceView = nil
    }
    
    private func canAddNewDevice() -> Bool{
        return
            !device.name.isEmpty &&
            !device.mac.isEmpty &&
            !device.broadcast.isEmpty &&
            !device.port.isEmpty
    }
}
