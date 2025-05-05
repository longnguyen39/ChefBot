//
//  ContBtnView.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/3/25.
//

import SwiftUI

struct ContBtnView: View {
    
    var context: String = "Continue"
    
    var body: some View {
        Text(context)
            .font(.headline)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .frame(width: UIScreen.width-64, height: 48)
            .background(Color.pink)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
    }
}

#Preview {
    ContBtnView()
}
