//
//  DeviceView.swift
//  Wake on Lan
//
//  Created by Iván Moreno Test on 13/07/2020.
//

import SwiftUI

struct DeviceView: View {
    
    @ObservedObject var device: WOLDevice
    @State var enableHover = false
    @State private var hover = false
    
    
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
        .background(hover && enableHover ? Color(NSColor.controlAccentColor) : Color.white.opacity(0))
        .foregroundColor(hover && enableHover ? Color.white : Color(NSColor.textColor))
        .cornerRadius(8)
        .onHover { hovering in
            self.hover = hovering
        }
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
