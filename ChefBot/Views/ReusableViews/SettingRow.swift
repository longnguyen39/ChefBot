//
//  SettingRow.swift
//  Daily Boost!
//
//  Created by Long Nguyen on 4/12/25.
//

import SwiftUI

struct SettingRow: View {
    
    @Environment(\.colorScheme) var mode

    var imgName: String
    var context: String
        
    var body: some View {
        HStack {
            Image(systemName: imgName)
                .imageScale(.medium)
                .padding(.trailing, 8)
                .foregroundStyle(mode == .light ? .black : .white)
            
            Text(context)
                .font(.subheadline)
                .fontWeight(.regular)
                .foregroundStyle(mode == .light ? .black : .white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

#Preview {
    SettingRow(imgName: "crown", context: "haha")
}
