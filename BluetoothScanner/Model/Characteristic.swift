//
//  Characteristic.swift
//  BluetoothScanner
//
//  Created by Mahmoud Youssef on 2022-11-08.
//

import CoreBluetooth

class Characteristic: Identifiable, Hashable {
    var id: UUID
    var characteristic: CBCharacteristic
    var description: String
    var properties: [String]
    var uuid: CBUUID
    var readValue: String
    var service: CBService?
    
    init(characteristic: CBCharacteristic, description: String, properties: [String], uuid: CBUUID, readValue: String, service: CBService?) {
        self.id = UUID()
        self.characteristic = characteristic
        self.description = description == "" ? "No Description" : description
        self.properties = properties
        self.uuid = uuid
        self.readValue = readValue == "" ? "No Data" : readValue
        self.service = service
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: Characteristic, rhs: Characteristic) -> Bool {
        return lhs.characteristic == rhs.characteristic
    }
}
