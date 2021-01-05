//
//  ContentView.swift
//  Takimatik
//
//  Created by Metin Öztürk on 25.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userViewModel: UserViewModel
            
    @State var isLoading = false
    @State var isShowingLoginView = false
    
    @State var downloadedEvents = [UserSpecificEvent]()
    
    @State var isUserDetailsBeingPresented = false
    
    @State private var profilePhoto = Image("profilePhoto")
    
    private let activityLabels = [
        ["Benim Etkinliklerim", Util.shared.hexStringToColor(hex: "#96261a")],
        ["Davet Edildiklerim",Util.shared.hexStringToColor(hex: "#626e85")],
        ["Takı Taktıklarım", Util.shared.hexStringToColor(hex: "#79a68c")]
    ]
    
    
    var body: some View {
        GeometryReader { geometry in
            BaseView(isLoading: self.isLoading) {
            VStack {
                NavigationLink(destination: LoginView(), isActive: self.$isShowingLoginView) { EmptyView() }.isDetailLink(false)
                HStack {
                    Spacer()
                    self.profilePhoto
                        .resizable()
                        .cornerRadius(30)
                        .frame(width: 60, height: 60, alignment: .center)
                        .overlay(
                                Circle()
                                    .stroke(Util.shared.firstColor, lineWidth: 2.5)
                                    .shadow(color: Util.shared.firstColor, radius: 2.5, x: 0, y: 0)
                        )
                    Text(self.userViewModel.user.name.isEmpty ? "Anonim" : self.userViewModel.user.name)
                    Spacer()
                }
                .padding(.all, 2.5)
                .frame(width: 200, height: 70, alignment: .center)
                .background(Util.shared.hexStringToColor(hex: "#87898a").opacity(0.3))
                .cornerRadius(75, corners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight])
                .onTapGesture {
                    self.isUserDetailsBeingPresented = true
                }
                .sheet(isPresented: self.$isUserDetailsBeingPresented, onDismiss: {
                    if let userImage = self.userViewModel.userImage {
                        self.profilePhoto = Image(uiImage: userImage)
                    }
                }) {
                    UserDetailView(isUserDetailViewBeingPresented: self.$isUserDetailsBeingPresented).environmentObject(self.userViewModel)
                }
                
                Spacer()
                
                ZStack {
                    Image("takimatik")
                        .resizable()
                        .renderingMode(.original)
                        .opacity(0.7)
                        .aspectRatio(1, contentMode: .fit)
                    if !self.downloadedEvents.isEmpty {
                        VStack(alignment: .center, spacing: 0) {
                            ScrollView(.horizontal, showsIndicators: false, content: {
                                HStack(alignment: .center, spacing: 0) {
                                    ForEach(self.downloadedEvents) {
                                        EventFeedView(userSpecificEvent: $0).padding(.horizontal)
                                    }
                                }.frame(width: self.downloadedEvents.count < 3 ? geometry.size.width : .none ,alignment: .center)
                            })
                        }.padding(0)
                    } else {
                        Text("Henüz gösterilebilecek bir etkinliğiniz yok.")
                    }
                }
                
                Spacer()
                HStack {
                    Spacer()
                    
                    ZStack {
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: CreateEventView(createEventViewModel: CreateEventViewModel(selectedContacts: [], selectedImage: nil))) {
                                Image("createEvent")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Util.shared.firstColor)
                                    .edgesIgnoringSafeArea(.all)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 75, height: 75, alignment: .center)
                            }
                            .padding(.bottom)
                            
                            
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            VStack {
                                ForEach(0..<self.activityLabels.count) { (idx) in
                                    HStack {
                                        Circle().fill(self.activityLabels[idx][1] as! Color)
                                            .frame(width: 10, height: 10, alignment: .leading)
                                        Text(self.activityLabels[idx][0] as! String)
                                            .font(Font.system(size: 10))
                                        Spacer()
                                    }.padding(.all, 3)
                                }
                            }.frame(width: 125)
                                .background(Util.shared.hexStringToColor(hex: "#87898a").opacity(0.15))
                                .cornerRadius(10)
                        }
                        
                        
                    }
                    
                    
                }
                
            }
            .navigationBarHidden(false)
            .navigationBarTitle("Ana Sayfa", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: Button(action: {
                self.userViewModel.clearUserInfo()
                self.isShowingLoginView.toggle()
            }, label: {
                Text("Çıkış Yap")
            }))
                .onAppear {                    
                    _ = Util.shared.checkForLocationServices()
                    Util.shared.checkForContactsAccess { (accessGiven) in
                        accessGiven ? print("Access to Contacts Granted") : print("Access to Contacts rejected")
                    }
                    
                    self.userViewModel.getUserSpecificEvents { (userSpecificEvent) in
                        if let userSpecificEvent = userSpecificEvent {
                            self.downloadedEvents = userSpecificEvent
                        }
                    }
                    
                    if let userImage = self.userViewModel.userImage {
                        self.profilePhoto = Image(uiImage: userImage)
                    }
                    
            }
        }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environmentObject(UserViewModel())
//    }
//}


