//
//  PeripheralView.swift
//  BluetoothScanner
//
//  Created by Mahmoud Youssef on 2022-11-08.
//

import SwiftUI

struct PeripheralView: View {
    
    @ObservedObject var bluetoothVM: BluetoothViewModel
    
    @State var unknown: Bool
    @State var peripheral: Peripheral
    
    var body: some View {
        HStack {
            Image(systemName: unknown ? "lock.open.trianglebadge.exclamationmark.fill" : peripheral.state == .disconnected ? "point.3.connected.trianglepath.dotted" : "point.3.filled.connected.trianglepath.dotted")
            VStack (alignment: .leading) {
                Text(peripheral.name)
                    .font(.caption)
                Text("MAC ADDRESS: \(peripheral.macAddress)")
                    .font(.caption2.smallCaps())
            }
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 35.0)
                    .foregroundColor(.white)
                    .frame(width: 100, height: 20)
                Text(peripheral.state.string())
                    .font(.caption2.smallCaps())
                    .foregroundColor(.black)
            }
            .onTapGesture {
                if peripheral.peripheral.state == .connected {
                    bluetoothVM.disconnect()
                } else if peripheral.peripheral.state == .connecting {
                    bluetoothVM.disconnect()
                } else {
                    bluetoothVM.connect(peripheral)
                }
            }
        }
    }
}
