//
//  WOLDevice+CoreDataProperties.swift
//  Wake on Lan
//
//  Created by Iván Moreno Zambudio on 13/07/2020.
//
//

import Foundation
import CoreData


extension WOLDevice {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WOLDevice> {
        return NSFetchRequest<WOLDevice>(entityName: "WOLDevice")
    }
    
    @NSManaged public var broadcast: String
    @NSManaged public var id: UUID
    @NSManaged public var mac: String
    @NSManaged public var name: String
    @NSManaged public var port: String
    
}

extension WOLDevice {
    var device: Awake.Device {
        Awake.Device(MAC: mac, BroadcastAddr: broadcast, Port: UInt16(port) ?? UInt16(Defaults.devicePort)!)
    }
    
    func awake() {
        let error = Awake.target(device: device)
        if error != nil {
            print(error)
        }
        print(device)
    }
}
