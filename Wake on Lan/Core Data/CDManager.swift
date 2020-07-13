//
//  CDManager.swift
//  Waken on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//

import AppKit
import CoreData

struct CDManager {
    
    static var shared = CDManager()
    
    private var moc: NSManagedObjectContext
    
    private init(){
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        moc = appDelegate.moc
    }
    
    private func save(){
        if moc.hasChanges {
            do {
                try moc.save()
            }catch {
                fatalError("Error saving CoreData context")
            }
        }
    }
    
    func addDevice(name: String, mac: String, broadcast: String, port: String){
        let device = WOLDevice(context: moc)
        device.id = UUID()
        device.name = name
        device.mac = mac
        device.broadcast = broadcast
        device.port = port
        save()
    }
    
    func editDevice(device: WOLDevice, name: String, mac: String, broadcast: String, port: String) {
        device.name = name
        device.mac = mac
        device.broadcast = broadcast
        device.port = port
        save()
    }
    
    func deleteDevices(devices: [WOLDevice]){
        devices.forEach {
            moc.delete($0)
        }
        DispatchQueue.main.async {
            save()
        }
    }
}
