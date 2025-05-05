//
//  HomeView.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/3/25.
//

import SwiftUI

struct HomeScreen: View {
    
    @Environment(\.colorScheme) var mode
    @AppStorage(UserDe.userID) var userID: String?
    @State var user: User = .initUser
    
    @State var showSetting: Bool = false
    @State var showHistory: Bool = false
    @State var showMealScreen: Bool = false
    @State var errMessage: String = ""
    
    @State var ingredientList: [Ingredient] = essentialIngredients
    
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Text("Your ingredients")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.top)
                
                FlowLayout(
                    data: ingredientList,
                    horizontalSpacing: 8,
                    verticalSpacing: 8
                ) { ingredient in
                    IngredientCell(name: ingredient.name, ingredientList: $ingredientList)
                        .transition(.opacity)
                }
                
            }
            .padding(.horizontal)
            
            if !readyAPI() {
                Text("Please add more ingredients to your list to generate your meals. We are here to make the most with what you have.")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .padding()
                    .foregroundStyle(.gray)
                    .background(mode == .light ? LIGHT_GRAY : DARK_GRAY)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
            }
            
            Button {
                showMealScreen.toggle()
            } label: {
                ContBtnView(context: "Generate meals")
                    .opacity(readyAPI() ? 1 : 0.5)
            }
            .disabled(!readyAPI())
        }
        .navigationTitle("ChefBot")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await fetchUserInfo()
            }
        }
        .alert("Oops", isPresented: .constant(errMessage != "")) {
            Button("Try Again", role: .cancel, action: {
                errMessage = ""
            })
        } message: {
            Text(errMessage)
        }
        .sheet(isPresented: $showSetting, content: {
            SettingScreen(showSetting: $showSetting, user: $user)
        })
        .sheet(isPresented: $showHistory, content: {
            NavigationStack {
                HistoryScreen(showHistScr: $showHistory, user: $user)
            }
        })
        .sheet(isPresented: $showMealScreen, content: {
            NavigationStack {
                MealScreen(showMealScreen: $showMealScreen, ingredientList: $ingredientList)
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showSetting.toggle()
                } label: {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .fontWeight(.semibold)
                        .foregroundStyle(.pink)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showHistory.toggle()
                } label: {
                    Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                        .imageScale(.large)
                        .fontWeight(.semibold)
                        .foregroundStyle(.pink)
                }
            }
        }
    }
    
//MARK: - Function
    
    private func readyAPI() -> Bool {
        return ingredientList.count > essentialIngredients.count
    }
    
    private func fetchUserInfo() async {
        do {
            user = try await AuthService.shared.fetchUserData(uid: userID ?? "")
        } catch {
            errMessage = error.localizedDescription
            print("DEBUG_HomeScr: \(errMessage)")
        }
    }
    
}

#Preview {
    HomeScreen()
}
