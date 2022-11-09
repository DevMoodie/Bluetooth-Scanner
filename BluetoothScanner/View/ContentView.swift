//
//  ContentView.swift
//  BluetoothScanner
//
//  Created by Mahmoud Youssef on 2022-11-08.
//

import SwiftUI

enum SortBy: String, CaseIterable {
    case name, mac, last
}

struct ContentView: View {
    
    @ObservedObject var bluetoothVM = BluetoothViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Button {
                    if bluetoothVM.deviceStatus == .stop {
                        bluetoothVM.startScanning()
                    } else {
                        bluetoothVM.stopScanning()
                    }
                } label: {
                    if bluetoothVM.deviceStatus == .stop {
                        ScanButton(status: .stop)
                    } else {
                        ScanButton(status: .start)
                    }
                }
                .padding()
                HStack {
                    ForEach(SortBy.allCases, id: \.rawValue) { sort in
                        SortByButton(title: sort, active: $bluetoothVM.activeSort)
                            .padding()
                            .onTapGesture {
                                print("Switched Sorting to: \(sort.rawValue)")
                                bluetoothVM.activeSort = sort
                                bluetoothVM.sortBy(sort)
                            }
                    }
                }
                List($bluetoothVM.foundPeripherals, id: \.self) { $peripheral in
                    if peripheral.name == "UNKNOWN DEVICE" {
                        // 􀄩􀄩 Will Populate Peripheral List with Unknown Devices 􀄩􀄩
                        // PeripheralView(unknown: true, peripheral: peripheral)
                    } else {
                        NavigationLink(destination: PeripheralDetailView(bluetoothVM: bluetoothVM, peripheral: $peripheral)) {
                            PeripheralView(bluetoothVM: bluetoothVM, unknown: false, peripheral: peripheral)
                        }
                    }
                }
            }
            .navigationTitle("Bluetooth Scanner")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
