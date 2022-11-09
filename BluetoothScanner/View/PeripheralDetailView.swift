//
//  PeripheralDetailView.swift
//  BluetoothScanner
//
//  Created by Mahmoud Youssef on 2022-11-08.
//

import SwiftUI

struct PeripheralDetailView: View {
    @ObservedObject var bluetoothVM: BluetoothViewModel
    @Binding var peripheral: Peripheral
    
    var body: some View {
        VStack {
            List {
                ForEach(bluetoothVM.foundServices, id: \.self) { service in
                    Section(header: Text("\(service.uuid.uuidString)")
                        .font(.caption2.smallCaps())
                        .foregroundColor(.white)) {
                        ForEach(bluetoothVM.foundCharacteristics, id: \.self) { characteristic in
                            if let ser = characteristic.service, service.uuid == ser.uuid {
                                Button {
                                    // Write Actions
                                } label: {
                                    VStack (alignment: .leading) {
                                        HStack {
                                            Text("uuid: \(characteristic.uuid.uuidString)")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .padding(.bottom, 2)
                                            Spacer()
                                            Image(systemName: "c.circle.fill")
                                        }
                                        Text("description: \(characteristic.description)")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.bottom, 2)
                                        Text("value: \(characteristic.readValue)")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.bottom, 2)
                                    }
                                }
                                ForEach(bluetoothVM.foundDescriptors, id: \.self) { descriptor in
                                    VStack (alignment: .leading) {
                                        HStack {
                                            Text("uuid: \(descriptor.uuid.uuidString)")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .padding(.bottom, 2)
                                            Spacer()
                                            Image(systemName: "d.circle.fill")
                                        }
                                        Text("description: \(descriptor.description)")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.bottom, 2)
                                    }
                                    .onAppear {
                                        print("\(descriptor.description)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 35.0)
                    .foregroundColor(.white)
                    .frame(width: 150, height: 50)
                Text(peripheral.peripheral.state == .disconnected ? "Connect" : "Disconnect")
                    .foregroundColor(.black)
                    .font(.title2.bold().smallCaps())
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
        .navigationTitle(peripheral.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
