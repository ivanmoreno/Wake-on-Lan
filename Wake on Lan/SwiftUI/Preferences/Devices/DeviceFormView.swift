//
//  DeviceFormView.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import SwiftUI

struct DeviceFormView: View {
    
    @Binding var name: String
    @Binding var mac: String
    @Binding var broadcast: String
    @Binding var port: String
    
    @State var cancelAction: () -> Void
    @State var confirmLabel: String
    @State var confirmAction: () -> Void
    
    var body: some View {
        Form {
            field("Name", text: $name)
            field("MAC Address", text: $mac)
            field("Broadcast Address", text: $broadcast)
            field("Port", text: $port)
            
            HStack(alignment:.center) {
                Button(action:cancelAction){
                    Text("Cancel")
                }
                Button(action:confirmAction){
                    Text(confirmLabel)
                }
                .disabled(!canAddNewDevice())
            }
        }
    }
    
    private func field(_ label: String, description: String = "", text: Binding<String>) -> some View {
        HStack {
            Text(label)
            Spacer()
            TextField(label, text: text)
            Spacer()
        }
    }
    
    private func canAddNewDevice() -> Bool{
        return
            !name.isEmpty &&
            !mac.isEmpty &&
            !broadcast.isEmpty &&
            !port.isEmpty
    }
}
