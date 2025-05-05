//
//  ChatHistCell.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/4/25.
//

import SwiftUI

struct ChatHistCell: View {
    
    @Environment(\.colorScheme) var mode
    
    @Binding var user: User
    @Binding var historyChats: [ChatHistory]
    @State var showADelete: Bool = false
    @State var showLoading: Bool = false
    var chat: ChatHistory
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Text(chat.name)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .foregroundStyle(.pink)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                Divider().padding(.top, 4)
                
                Text(chat.chat)
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .foregroundStyle(mode == .light ? Color.black : Color.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxHeight: 56)
                    .padding(.horizontal)
                
                Divider().padding(.bottom, 8)
                
                Button {
                    showADelete.toggle()
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("Delete")
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                            .multilineTextAlignment(.leading)
                        
                        Image(systemName: "trash")
                            .imageScale(.small)
                            .fontWeight(.regular)
                    }
                    .padding(.bottom)
                    .padding(.horizontal)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 0.5)
                    .foregroundStyle(Color(.systemGray4))
                    .shadow(color: .black.opacity(0.4), radius: 2)
            }
            .background(mode == .light ? Color.white : DARK_GRAY)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
            .confirmationDialog("Delete chat?", isPresented: $showADelete, titleVisibility: .visible, actions: {
                Button("Cancel", role: .cancel, action: {})
                Button("Remove from History", role: .destructive, action: {
                    Task {
                        await deleteAChat()
                    }
                })
            })
            
            if showLoading {
                LoadingView()
            }
        }
        
    }
    
    private func deleteAChat() async {
        showLoading = true
        //API called
        await ServiceUpload.shared.deleteHistChat(userID: user.id, docID: chat.id)
        
        //update UI
        historyChats = historyChats.filter { $0.id != chat.id }
        showLoading = false
    }
    
}
