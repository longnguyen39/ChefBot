//
//  HistoryView.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/3/25.
//

import SwiftUI

struct HistoryScreen: View {
    
    @Environment(\.colorScheme) var mode
    @Binding var showHistScr: Bool
    @Binding var user: User
    
    @State var historyChats: [ChatHistory] = []
    @State var showLoading: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    if historyChats.isEmpty {
                        Text("You have not saved any chat yet.")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                            .padding(.top, 48)
                    } else {
                        HStack {
                            Text("*All saved chats are displayed here.")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding()
                        
                        ForEach(historyChats, id: \.self) { chat in
                            NavigationLink {
                                HistDisplayScreen(context: chat.chat)
                            } label: {
                                ChatHistCell(user: $user, historyChats: $historyChats, chat: chat)
                                    .padding(.bottom, 12)
                                    .transition(.scale)
                            }
                        }
                        
                    }
                }
            }
            
            if showLoading {
                LoadingView()
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showHistScr.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                        .fontWeight(.semibold)
                        .foregroundStyle(.pink)
                }
            }
        }
        .onAppear {
            Task {
                print("DEBUG: fetching history...")
                await fetchHistoryChats()
            }
        }
    }
    
//MARK: - Function
    
    private func fetchHistoryChats() async {
        showLoading = true
        historyChats = await ServiceFetch.shared.fetchChatHistory(userID: user.id)
        print("DEBUG: hist count \(historyChats.count)")
        showLoading = false
    }
    
}

#Preview {
    HistoryScreen(showHistScr: .constant(true), user: .constant(User.mockUser))
}

