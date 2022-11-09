//
//  ScanButton.swift
//  BluetoothScanner
//
//  Created by Mahmoud Youssef on 2022-11-08.
//

import SwiftUI

struct ScanButton: View {
    @State var status: BluetoothStatus
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 35.0)
                .foregroundColor(.white)
                .frame(width: 150, height: 50)
            Text(status == .stop ? "Start" : "Stop")
                .foregroundColor(.black)
                .font(.title2.bold().smallCaps())
        }
    }
}

struct ScanButton_Previews: PreviewProvider {
    static var previews: some View {
        ScanButton(status: .stop)
    }
}
