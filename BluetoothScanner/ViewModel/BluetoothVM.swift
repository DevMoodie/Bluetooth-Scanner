//
//  BluetoothVM.swift
//  BluetoothScanner
//
//  Created by Mahmoud Youssef on 2022-11-08.
//

import SwiftUI
import CoreBluetooth

enum BluetoothStatus {
    case stop
    case start
}

class BluetoothViewModel: NSObject, ObservableObject {
    
    // Bluetooth Properties
    private var centralManager: CBCentralManager?
    private var connectedPeripheral: Peripheral?
    
    // Adjustable BLE Connectivity/Sorting Properties
    @Published var deviceStatus: BluetoothStatus = .stop
    @Published var activeSort: SortBy = .name
    
    // List of BLE devices to connect to
    @Published var foundPeripherals: [Peripheral] = []
    @Published var foundServices: [Service] = []
    @Published var foundCharacteristics: [Characteristic] = []
    @Published var foundDescriptors: [Descriptor] = []
    
    private let serviceUUID: CBUUID = CBUUID()
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    
    private func resetConfigure() {
        withAnimation {
            deviceStatus = .stop
            
            foundPeripherals = []
            foundServices = []
            foundCharacteristics = []
        }
    }
    
    func startScanning() {
        let scanOption = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        self.centralManager?.scanForPeripherals(withServices: nil, options: scanOption)
        print("Scanning...")
        deviceStatus = .start
    }
    
    func stopScanning() {
        disconnect()
        self.centralManager?.stopScan()
        deviceStatus = .stop
    }
    
    func connect(_ peripheral: Peripheral?) {
        disconnect()
        guard let connectPeripheral = peripheral else { return }
        connectedPeripheral = peripheral
        guard let index = foundPeripherals.firstIndex(where: { $0.name == connectPeripheral.name }) else { return }
        self.foundPeripherals[index].state = .connecting
        self.centralManager?.connect(connectPeripheral.peripheral)
        print("Connecting to: \(connectPeripheral.name)")
    }
    
    func disconnect() {
        guard let connectedPeripheral = connectedPeripheral else { return }
        self.centralManager?.cancelPeripheralConnection(connectedPeripheral.peripheral)
        guard let index = foundPeripherals.firstIndex(where: { $0.name == connectedPeripheral.name }) else { return }
        self.foundPeripherals[index].state = .disconnected
        print("Disconnected from: \(connectedPeripheral.name)")
    }
    
    func sortBy(_ by: SortBy) {
        switch by {
        case .name:
            self.foundPeripherals.sort(by: { $0.name < $1.name })
        case .mac:
            self.foundPeripherals.sort(by: { $0.macAddress < $1.macAddress })
        case .last:
            self.foundPeripherals.sort(by: { $0.date < $1.date })
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Device Powered On!")
        case .poweredOff:
            print("Device Powered Off!")
        case .resetting:
            print("Device Resetting!")
        case .unauthorized:
            print("Device Unauthorized!")
        case .unknown:
            print("Device Unknown!")
        case .unsupported:
            print("Device Not Supported!")
        @unknown default:
            print("Unknown Device State!")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if RSSI.intValue >= 0 { return }
        
        let peripheralName = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? nil
        var name = "UNKNOWN DEVICE"
        
        if peripheralName != nil {
            name = String(peripheralName!)
        } else if peripheral.name != nil {
            name = String(peripheral.name!)
        }
        
        let foundPeripheral: Peripheral = Peripheral(peripheral: peripheral,
                                                     name: name, macAddress: "",
                                                     date: Date(), state: peripheral.state, advData: advertisementData,
                                                     rssi: RSSI, discoverCount: 0)
        
        if let index = foundPeripherals.firstIndex(where: { $0.peripheral.identifier.uuidString == peripheral.identifier.uuidString }) {
            if foundPeripherals[index].discoverCount % 50 == 0 {
                foundPeripherals[index].name = name
                foundPeripherals[index].rssi = RSSI.intValue
                foundPeripherals[index].discoverCount += 1
            } else {
                foundPeripherals[index].discoverCount += 1
            }
        } else {
            foundPeripherals.append(foundPeripheral)
        }
        
        sortBy(self.activeSort)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let connectedPeripheral = connectedPeripheral, let index = self.foundPeripherals.firstIndex(where: { $0.name == peripheral.name}) else { return }
        
        connectedPeripheral.peripheral.delegate = self
        connectedPeripheral.peripheral.discoverServices(nil)
        
        self.foundPeripherals[index].state = .connected
        print("Connected!")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        disconnect()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected!")
        resetConfigure()
    }
}

extension BluetoothViewModel: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?.forEach { service in
            let ser = Service(uuid: service.uuid, service: service)
            foundServices.append(ser)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        service.characteristics?.forEach { characteristic in
            let char = Characteristic(characteristic: characteristic,
                                      description: "", uuid: characteristic.uuid,
                                      readValue: "", service: characteristic.service)
            
            foundCharacteristics.append(char)
            peripheral.readValue(for: characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        characteristic.descriptors?.forEach { descriptor in
            let desc = Descriptor(descriptor: descriptor,
                                  uuid: descriptor.uuid, readValue: "")
            
            foundDescriptors.append(desc)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let characteristicValue = characteristic.value else { return }
        
        if let index = foundCharacteristics.firstIndex(where: { $0.uuid.uuidString == characteristic.uuid.uuidString }) {
            foundCharacteristics[index].readValue = characteristicValue.map({ String(format: "%02x", $0) }).joined()
        }
    }
}
