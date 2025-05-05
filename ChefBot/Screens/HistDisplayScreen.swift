//
//  HistDisplayScreen.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/4/25.
//

import SwiftUI

struct HistDisplayScreen: View {
    
    @Environment(\.colorScheme) var mode
    var context: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                Text(context)
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .foregroundStyle(mode == .light ? Color.black : Color.white)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 0.5)
                            .foregroundStyle(Color(.systemGray4))
                            .shadow(color: .black.opacity(0.4), radius: 2)
                    }
                    .background(mode == .light ? Color.white : DARK_GRAY)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding()
            }
        }
        .navigationTitle("Full Text")
    }
}

#Preview {
    HistDisplayScreen()
}
