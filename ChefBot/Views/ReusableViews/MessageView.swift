//
//  MessageView.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/1/25.
//
import SwiftUI

// Simple View to display a single message bubble
struct MessageView: View {
    
    @AppStorage(UserDe.userID) var userID: String?
    let message: ChatMessage
    @State var didSave: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if message.role == .user {
                    Spacer()
                }
                
                Text(message.content)
                    .padding(12)
                    .background(message.role == .user ? Color.blue.opacity(0.8) : Color.gray.opacity(0.4))
                    .foregroundColor(message.role == .user ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if message.role == .assistant {
                    Spacer()
                }
            }
            
            if message.role == .assistant {
                Button {
                    //save to hist
                    Task {
                        await saveToHistory()
                    }
                } label: {
                    Text(didSave ? "Saved!" : "Save this answer")
                        .font(.caption)
                        .padding(8)
                        .foregroundColor(didSave ? .gray : .blue)
                }
                .disabled(didSave)
                
            }
        }
        .id(message.id)
    }
    
    private func saveToHistory() async {
        let chat = ChatHistory(id: "\(Date.now)", chat: message.content, name: "\(Date.now)", timestamp: Date.now)
        await ServiceUpload.shared.uploadChatToHist(userID: userID ?? "", chat: chat)
        didSave = true
    }
    
}
