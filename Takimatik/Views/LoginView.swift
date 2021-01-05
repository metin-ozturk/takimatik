//
//  LoginView.swift
//  Takimatik
//
//  Created by Metin Öztürk on 1.08.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct LoginView : View {
    @EnvironmentObject var userViewModel : UserViewModel
        
    @State var userEntry : String = ""
    
    @State var isGettingPhoneNumber = true
    
    @State var isContentViewBeingShowed = false
    @State var isLoading = false
    
    @State var isShowingAlert = false
    
    var body: some View {
        BaseView(isLoading: isLoading) {
            VStack {
                NavigationLink(destination: ContentView(), isActive: self.$isContentViewBeingShowed) { EmptyView() }
                
                Spacer()
                
                Image("takimatik")
                    .resizable()
                    .frame(width: 250, height: 250, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .padding(0)
                    .padding(.top, -75)
                
                VStack {
                    HStack {
                        Image(isGettingPhoneNumber ? "phone" : "pin")
                            .resizable()
                            .frame(width: 12.8, height: 20, alignment: .center)
                        TextField(isGettingPhoneNumber ? "Telefon Numarası" : "Telefonunuza gönderilen kod" , text: $userEntry)
                    }
                    .padding(.all, 10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Util.shared.firstColor, lineWidth: 1)
                    .shadow(color: Util.shared.firstColor, radius: 2.5, x: 0, y: 0))
                    .padding(.all, 10)
                    
                    
                    Button(action: {
                        if (10...11 ~= self.userEntry.count && Int(self.userEntry) != nil && self.isGettingPhoneNumber ) {
                            self.userViewModel.user.phoneNumber = self.userEntry
                            self.userEntry = ""
                            
                            self.isLoading = true
                            self.userViewModel.getPin { (rData) in
                                self.isLoading = false
                                
                                if rData != nil {
                                    self.isGettingPhoneNumber.toggle()
                                }
                            }
                            
                            
                        } else if !self.isGettingPhoneNumber && self.userEntry.count == 6 {
                            self.userViewModel.user.pin = self.userEntry
                            
                            self.isLoading = true
                            self.userViewModel.loginWithPin { (loggedIn, rStatusCode) in
                                self.isLoading = false
                                if loggedIn {
                                    self.isContentViewBeingShowed.toggle()
                                } else if rStatusCode == 422 {
                                    self.isShowingAlert = true
                                }
                            }
                        } else {
                            self.isShowingAlert = true
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text(isGettingPhoneNumber ?  "Devam Et" : "Giriş Yap")
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 10)
                    .buttonStyle(TMButtonStyleInverted())
                    
                }
                
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("Giriş")
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Hata"), message: Text(isGettingPhoneNumber ? "Lütfen telefon numaranızı doğru girdiğinizden emin olunuz." : "Lütfen telefonunuza gönderilen pin numarasını doğru girdiğinizden emin olunuz."), dismissButton: .default(Text("Tamam")))
            }
        }
    }
}
