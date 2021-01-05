//
//  IntroView.swift
//  Takimatik
//
//  Created by Metin Öztürk on 1.08.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct IntroView: View {
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var isShowingLoginView = false
    @State private var isShowingContentView = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            BaseView(isLoading: isLoading) {
                NavigationLink(destination: LoginView(), isActive:self.$isShowingLoginView) {
                    EmptyView()
                }
                
                NavigationLink(destination: ContentView(), isActive: self.$isShowingContentView) { EmptyView() }
                
                Image("takimatik")
                    .resizable()
                    .frame(width: 300, height: 300, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .padding(.all, .zero)
                    
            }
            .navigationBarTitle("Giriş", displayMode: .inline)
        }
        .accentColor(Util.shared.firstColor) // Changes stuff like Picker's Checkmark Color
        .onAppear {
            self.login()
        }

    }
    
    private func login() {
        let storedUserInfo = DataManager.shared.getStoredUserInfo()
        let phoneNumber = storedUserInfo?[0] ?? ""
        let rememberToken = storedUserInfo?[1] ?? ""

        if !rememberToken.isEmpty && !phoneNumber.isEmpty {
            isLoading = true

            userViewModel.loginWithRememberToken(phoneNumber: phoneNumber, rememberToken: rememberToken) { (result) in
                self.isLoading = false
                if result {
                    self.isShowingContentView = true
                } else {
                    self.isShowingLoginView = true
                }
            }
            
        } else {
            self.isShowingLoginView = true
        }
    }
    
}
