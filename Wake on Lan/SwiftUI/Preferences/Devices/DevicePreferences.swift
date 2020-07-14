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
    @State var activeSheet = Sheet.edit
    @State var showDeleteAlert = false
    
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
                Button("New"){
                    presentSheet(.add)
                }
                
                Button("Edit"){
                    presentSheet(.edit)
                }.disabled(selection.count != 1 || devices.isEmpty)
                
                Button("Delete"){
                    showDeleteAlert.toggle()
                }
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
            .sheet(isPresented: $showSheet) {
                if activeSheet == .add {
                    AddDeviceView(showAddDeviceView: $showSheet)
                        .frame(width: 350)
                }
                if activeSheet == .edit {
                    EditDeviceView(showEditDeviceView: $showSheet, device: devices[selection.first!])
                        .frame(width: 350)
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
        showSheet = true
        
    }
}
