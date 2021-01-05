//
//  UserDetailsView.swift
//  Takimatik
//
//  Created by Metin Ozturk on 8.08.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct UserDetailView: View {    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @Binding var isUserDetailViewBeingPresented : Bool
    
    @State var isImagePickerBeingPresented : Bool = false {
        didSet {
            self.hideKeyboard()
        }
    }
    @State var retrievedImage : UIImage? = nil
    
    @State private var rUserName : String = ""
    @State private var rPhoneNumber : String = ""
    @State private var rImage : Image = Image("placeholder")
    
    @State private var isLoading = false
    
    var body: some View {
        GeometryReader { geometry in
            BaseView(isLoading: self.isLoading, isModal: true) {
                VStack {
                    ZStack {
                        HStack {
                            Button(action: {
                                self.isUserDetailViewBeingPresented.toggle()
                            }) {
                                Text("İptal")
                            }
                            .foregroundColor(Color.white)
                            .padding()
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("Kullanıcı Bilgileri")
                                .foregroundColor(.white)
                                .padding()
                            Spacer()
                        }
                    }.background(Util.shared.firstColor)
                    
                    
                    
                    self.rImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width - 16, height: (geometry.size.height - 16) * 9 / 16)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Util.shared.thirdColor, lineWidth: 2.5)
                                .shadow(color: Util.shared.thirdColor, radius: 2.5, x: 0, y: 0))
                        .padding()
                        .sheet(isPresented: self.$isImagePickerBeingPresented, onDismiss: {
                            if let retrievedImage = self.retrievedImage {
                                self.rImage = Image(uiImage: retrievedImage)
                                self.userViewModel.userImage = retrievedImage
                            }
                        }, content: {
                            ImagePickerView(isBeingPresented: self.$isImagePickerBeingPresented, retrievedImage: self.$retrievedImage)
                        })
                        .onTapGesture {
                            self.isImagePickerBeingPresented.toggle()
                    }
                    
                    
                    VStack(alignment: .center, spacing: 10) {
                        TextField("Telefon Numarası", text: self.$rPhoneNumber)
                            .disabled(true)
                        Rectangle().frame(height: 2, alignment: .center)
                            .foregroundColor(Util.shared.thirdColor)
                        TextField("Kullanıcı Adı", text: self.$rUserName)
                        Rectangle().frame(height: 2, alignment: .center)
                            .foregroundColor(Util.shared.thirdColor)
                    }.padding()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.isLoading = true
                            self.userViewModel.updateUser(rUserName: self.rUserName, retrievedImage: self.retrievedImage) {
                                self.isLoading = false
                                if $0 {
                                    self.isUserDetailViewBeingPresented = false
                                }
                            }
                        }) {
                            Text("Güncelle")
                        }
                        .buttonStyle(TMButtonStyleInverted())
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                }
                .onAppear {
                    let readablePhoneNumber = Util.shared.convertPhoneNumberToUserPresentableForm(rPhoneNumber: self.userViewModel.user.phoneNumber)
                    self.rPhoneNumber = readablePhoneNumber ?? "Telefon numarası alınırken bir hata oluştu"
                    self.rUserName = self.userViewModel.user.name
                    if let userImage = self.userViewModel.userImage {
                        self.rImage = Image(uiImage: userImage)
                    }
                }
            }
        }
    }
    
}

//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView()
//    }
//}
