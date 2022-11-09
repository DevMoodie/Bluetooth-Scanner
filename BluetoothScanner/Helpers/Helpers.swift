//
//  Helpers.swift
//  BluetoothScanner
//
//  Created by Mahmoud Youssef on 2022-11-08.
//

import Foundation
import CoreBluetooth

extension CBPeripheralState {

    // Returns the name of a `CBPeripheralState` as a string.
    public func string() -> String {
        switch self {
        case .connected: return "Connected"
        case .connecting: return "Connecting"
        case .disconnected: return "Disconnected"
        case .disconnecting: return "Disconnecting"
        @unknown default:
            return "Unknown"
        }
    }
}

extension Data {
    
    // Parse the Data received by the BLE device
    func hexEncodedString() -> String {
        let hexDigits = Array("0123456789abcdef".utf16)
        var hexChars = [UTF16.CodeUnit]()
        hexChars.reserveCapacity(count * 2)
        
        for byte in self {
            let (index1, index2) = Int(byte).quotientAndRemainder(dividingBy: 16)
            hexChars.insert(hexDigits[index2], at: 0)
            hexChars.insert(hexDigits[index1], at: 0)
        }
        return String(utf16CodeUnits: hexChars, count: hexChars.count)
    }
}

extension String {
    
    // Add seperators to the MAC ADDRESS
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}

func descriptorDescription(for descriptor: CBDescriptor) -> String {

    var description: String?
    var value: String?

    switch descriptor.uuid.uuidString {
    case CBUUIDCharacteristicFormatString:
        if let data = descriptor.value as? Data {
            description = "Characteristic format: "
            value = data.description
        }
    case CBUUIDCharacteristicUserDescriptionString:
        if let val = descriptor.value as? String {
            description = "User description: "
            value = val
        }
    case CBUUIDCharacteristicExtendedPropertiesString:
        if let val = descriptor.value as? NSNumber {
            description = "Extended Properties: "
            value = val.description
        }
    case CBUUIDClientCharacteristicConfigurationString:
        if let val = descriptor.value as? NSNumber {
            description = "Client characteristic configuration: "
            value = val.description
        }
    case CBUUIDServerCharacteristicConfigurationString:
        if let val = descriptor.value as? NSNumber {
            description = "Server characteristic configuration: "
            value = val.description
        }
    case CBUUIDCharacteristicAggregateFormatString:
        if let val = descriptor.value as? String {
            description = "Characteristic aggregate format: "
            value = val
        }
    default:
        break
    }

    if let desc = description, let val = value  {
        return "\(desc)\(val)"
    } else {
        return "No Description"
    }
}
