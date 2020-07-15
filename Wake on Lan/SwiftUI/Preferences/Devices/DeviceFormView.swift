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
            field("Name", description: "John's PC", text: $name)
            field("MAC", description: "xx:xx:xx:xx:xx:xx", text: $mac)
            field("Broadcast", description: "255.255.255.255", text: $broadcast)
            field("Port", description: "If you're not sure: 9", text: $port)
            
            HStack(alignment:.center) {
                if #available(OSX 10.16, *) {
                    Button(action:cancelAction){
                        Text("Cancel")
                    }
                    .keyboardShortcut(.cancelAction)
                } else {
                    Button(action:cancelAction){
                        Text("Cancel")
                    }
                }
                Spacer()
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
                .frame(minWidth: 100)
            Spacer()
            TextField(description, text: text)
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
