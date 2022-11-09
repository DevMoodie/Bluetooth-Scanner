//
//  Service.swift
//  BluetoothScanner
//
//  Created by Mahmoud Youssef on 2022-11-08.
//

import CoreBluetooth

class Service: Identifiable, Hashable {
    
    var id: UUID
    var uuid: CBUUID
    var service: CBService
    
    init(uuid: CBUUID, service: CBService) {
        self.id = UUID()
        self.uuid = uuid
        self.service = service
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: Service, rhs: Service) -> Bool {
        return lhs.service == rhs.service
    }
}

