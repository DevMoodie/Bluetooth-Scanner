//
//  SortByButton.swift
//  BluetoothScanner
//
//  Created by Mahmoud Youssef on 2022-11-08.
//

import SwiftUI

struct SortByButton: View {
    @State var title: SortBy
    @Binding var active: SortBy
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 35.0)
                .foregroundColor(active == title ? .white : .black)
                .frame(width: 70, height: 30)
            Text(title.rawValue)
                .foregroundColor(active == title ? .black : .white)
                .font(.headline.bold().smallCaps())
        }
    }
}

struct SortByButton_Previews: PreviewProvider {
    static var previews: some View {
        SortByButton(title: .name, active: .constant(.name))
    }
}
