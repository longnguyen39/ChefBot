//
//  TxtFieldModifier.swift
//  Daily Boost!
//
//  Created by Long Nguyen on 3/2/25.
//

import SwiftUI

struct TxtFieldModifier: ViewModifier {
    
    @Environment(\.colorScheme) var mode
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(mode == .light ? Color(.systemGray6) : DARK_GRAY)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 32)
    }
}
