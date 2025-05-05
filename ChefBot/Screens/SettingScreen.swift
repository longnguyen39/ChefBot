//
//  SettingView.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/3/25.
//

import SwiftUI

struct SettingScreen: View {
    
    @Environment(\.colorScheme) var mode
    @Binding var showSetting: Bool
    @Binding var user: User
    
    @State var showTextBox: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 8) {
                    NameHeader
                        .onTapGesture {
                            showTextBox.toggle()
                        }
                    
                    SupportSection
                }
                .padding(.top)
            }
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Change your name", isPresented: $showTextBox) {
                TextField("Your new name", text: $user.name)
                Button("Cancel", role: .none, action: {})
                Button("Update", role: .cancel, action: {
                    Task { //should handle err here
                        if !user.name.isEmpty {
                            try await AuthService.shared.updateUsername(userID: user.id, newName: user.name)
                        }
                    }
                })
            } message: {}
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSetting.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                            .fontWeight(.semibold)
                            .foregroundStyle(.pink)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingScreen(showSetting: .constant(true), user: .constant(User.mockUser))
}


extension SettingScreen {
    
    var NameHeader: some View {
        HStack {
            Image(systemName: generateImgName(username: user.name))
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundStyle(pickImgColor())
                .padding(.trailing, 12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text("Verified ChefBot user!")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.green)
            }
            
            Spacer()
        }
        .padding()
        .padding(.vertical, 8)
        .background(mode == .light ? Color.white : DARK_GRAY)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay { //for highlight in light mode
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding(.horizontal)
    }
    
    private func pickImgColor() -> Color {
        let arr: [Color] = [.red, .blue, .pink, .yellow, .green, .orange, .purple, .teal, .gray, .yellow, .brown, .cyan, .indigo, .mint]
        return arr.randomElement()!
    }
}

extension SettingScreen {
    
    var SupportSection: some View {
        VStack {
            HStack {
                Text("Support")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .padding(.top, 12)
            .padding(.horizontal)
            
            VStack(spacing: 8) {
                SettingRow(imgName: "camera.aperture", context: "Follow us on Instagram")
                    .padding(.top)
                
                Divider()
                    .padding(.horizontal)
                    .padding(.top, -10)
                
                SettingRow(imgName: "hand.thumbsup", context: "Leave us a review")
                
                Divider()
                    .padding(.horizontal)
                    .padding(.top, -10)
                
                SettingRow(imgName: "square.and.arrow.up", context: "Share ChefBot")
            }
            .background(mode == .light ? Color.white : DARK_GRAY)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay{
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 0.5)
                    .foregroundStyle(Color(.systemGray4))
                    .shadow(color: .black.opacity(0.4), radius: 2)
            }
            .padding(.horizontal)
        }
        
    }
}
