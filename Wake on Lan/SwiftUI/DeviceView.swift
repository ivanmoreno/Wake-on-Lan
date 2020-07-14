//
//  DeviceView.swift
//  Wake on Lan
//
//  Created by Iván Moreno Test on 13/07/2020.
//

import SwiftUI

struct DeviceView: View {
    
    @ObservedObject var device: WOLDevice
    
    public var body: some View {
        HStack {
            Image(systemName: "pc")
                .font(.title)
            VStack(alignment: .leading) {
                Text(device.name)
                Text(device.mac)
                    .font(.caption)
            }
        }
        .padding(8)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .cornerRadius(8)
        .contextMenu {
            Button(action:{device.awake()}){
                Text("Send WOL")
            }
            Button(action:{CDManager.shared.deleteDevices(devices: [device])}){
                Text("Delete")
            }
        }
    }
}
