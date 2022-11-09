//
//  Descriptors.swift
//  BluetoothScanner
//
//  Created by Mahmoud Youssef on 2022-11-08.
//

import CoreBluetooth

class Descriptor: Identifiable, Hashable {
    var id: UUID
    var descriptor: CBDescriptor
    var description: String
    var uuid: CBUUID
    
    init(descriptor: CBDescriptor, uuid: CBUUID, readValue: String) {
        self.id = UUID()
        self.descriptor = descriptor
        self.description = descriptorDescription(for: descriptor)
        self.uuid = uuid
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: Descriptor, rhs: Descriptor) -> Bool {
        return lhs.descriptor == rhs.descriptor
    }
}
