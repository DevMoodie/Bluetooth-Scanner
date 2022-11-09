//
//  Peripheral.swift
//  BluetoothScanner
//
//  Created by Mahmoud Youssef on 2022-11-08.
//

import CoreBluetooth

class Peripheral: Identifiable, Hashable {
    var id: UUID
    var peripheral: CBPeripheral
    var name: String
    var advertisementData: [String: Any]
    var macAddress: String
    var date: Date
    var state: CBPeripheralState
    var rssi: Int
    var discoverCount: Int
    
    init(peripheral: CBPeripheral, name: String, macAddress: String, date: Date, state: CBPeripheralState, advData: [String: Any], rssi: NSNumber, discoverCount: Int) {
        self.id = UUID()
        self.peripheral = peripheral
        self.name = name
        self.advertisementData = advData
        self.macAddress = macAddress
        self.date = date
        self.state = state
        self.rssi = rssi.intValue
        self.discoverCount = discoverCount + 1
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: Peripheral, rhs: Peripheral) -> Bool {
        return lhs.peripheral == rhs.peripheral
    }
}
