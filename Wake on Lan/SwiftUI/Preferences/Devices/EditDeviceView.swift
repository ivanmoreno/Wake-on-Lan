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
    
    @State var name: String
    @State var mac: String
    @State var broadcast: String
    @State var port: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if #available(OSX 10.16, *){
                    Image(systemName: "pc")
                    .font(.title)
                }else {
                    Image(nsImage: NSImage(named: NSImage.bonjourName)!)
                        .font(.title)
                }
                Text("Edit device")
                    .padding(.leading, 10)
                    .font(.title)
            }
            DeviceFormView(
                name: $name,
                mac: $mac,
                broadcast: $broadcast,
                port: $port,
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
            name: name,
            mac: mac,
            broadcast: broadcast,
            port: port
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
