//
//  DevicesPreferences.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import SwiftUI

struct DevicePreferences: View {
    
    @State var selection: Set<Int> = [0]
    @State var activeSheet: Sheet? = nil
    @State var showDeleteAlert = false
    
    enum Sheet: String, Identifiable {
        var id: String {
            rawValue
        }
        case none, add, edit
    }
    
    @FetchRequest(
        entity: WOLDevice.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \WOLDevice.name, ascending: true)
        ]
    ) var devices: FetchedResults<WOLDevice>
    
    var body: some View {
        contentView
            .frame(width: Defaults.preferencesWindowWidth,
                   height: Defaults.preferencesWindowHeight)
            .padding()
    }
    
    @ViewBuilder
    private var contentView: some View {
        HStack(alignment: .top) {
            VStack {
                Button(action: {presentSheet(.add)}) {
                    Text("New")
                        .frame(minWidth: 50,
                               maxWidth: .infinity)
                }
                
                Button(action: {presentSheet(.edit)}) {
                    Text("Edit")
                        .frame(minWidth: 50,
                               maxWidth: .infinity)
                }
                .disabled(selection.count != 1 || devices.isEmpty)
                
                Button(action: {showDeleteAlert.toggle()}) {
                    Text("Delete")
                        .frame(minWidth: 50,
                               maxWidth: .infinity)
                }
                .disabled(selection.isEmpty || devices.isEmpty)
                .alert(isPresented:$showDeleteAlert) {
                    Alert(
                        title: Text("Are you sure you want to delete this?"),
                        message: Text("There is no undo"),
                        primaryButton: .destructive(Text("Delete"), action: deleteSelectedDevices),
                        secondaryButton: .cancel()
                    )
                }
                .disabled(selection.isEmpty || devices.isEmpty)
            }
            List(selection: $selection) {
                ForEach(Array(devices.enumerated()), id:\.1.id){ index, device in
                    DeviceView(device: device)
                        .tag(index)
                }
            }
            .onDeleteCommand {
                showDeleteAlert = true
            }
            .cornerRadius(8)
            .sheet(item: $activeSheet) { sheet in
                if sheet == .add {
                    AddDeviceView(showAddDeviceView: $activeSheet)
                        .frame(width: Defaults.preferencesWindowWidth)
                }
                if sheet == .edit {
                    let device = devices[selection.first!]
                    EditDeviceView(
                        showEditDeviceView: $activeSheet,
                        device: device,
                        name: device.name,
                        mac: device.mac,
                        broadcast: device.broadcast,
                        port: device.port
                    )
                    .frame(width: Defaults.preferencesWindowWidth)
                }
            }
            
            
        }
    }
    
    private func deleteSelectedDevices() {
        var delDevices = [WOLDevice]()
        selection.forEach{
            delDevices.append(devices[$0])
        }
        CDManager.shared.deleteDevices(devices: delDevices)
        selection = [0]
    }
    
    private func presentSheet(_ sheet: Sheet){
        self.activeSheet = sheet
    }
}
