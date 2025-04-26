//
//  ContentView.swift
//  ChefBot
//
//  Created by Long Nguyen on 4/26/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var name: String = ""
    
    var body: some View {
        NavigationStack {
                ZStack {
                    VStack {
                        VStack {
                            
                            Text("Welcome to ChefBot!")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .padding(.vertical)
                            
                            Image("logo")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.bottom)
                            
                            //userInput is store in viewModel.email
                            TextField("What is your name?", text: $name)
                                .textInputAutocapitalization(.never)
                                //.modifier(TxtFieldModifier())
                                //.focused($keyboardFocused)
                                .keyboardType(.alphabet)
                                .disableAutocorrection(true)
                                
                            
                            NavigationLink {
                                //PurposeScreen(user: $user)
                            } label: {
//                                ContBtnView()
//                                    .opacity(user.username.isEmpty ? 0.5 : 1)
                            }
                            .padding(.vertical, 4)
                            
                            NavigationLink {
                                //LoginScreen()
                            } label: {
                                HStack(spacing: 3) {
                                    Text("Already have an account?  - ")
                                        .fontWeight(.regular)
                                        .foregroundStyle(.gray)
                                    Text(" Login")
                                        .fontWeight(.bold)
                                        .foregroundStyle(.blue)
                                }
                                .font(.footnote)
                            }
                        }
    //                    .ignoresSafeArea()
                        
                        Spacer()
                    }
                    
//                    if showLoading {
//                        LoadingView()
//                    }
                }
            }
        
    }
}

#Preview {
    ContentView()
}
