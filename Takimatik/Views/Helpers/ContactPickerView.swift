//
//  ContactPickerView.swift
//  Takimatik
//
//  Created by Metin Öztürk on 28.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct ContactPickerView: View {
    @ObservedObject var createEventViewModel: CreateEventViewModel
    @Binding var isShowing : Bool
    
    var initialContacts : [Invitee]
        
    var body: some View {
        VStack {
            
            ZStack {
                HStack {
                    Button(action: {
                        if !self.createEventViewModel.selectedContacts.isEmpty {
                            self.createEventViewModel.selectedContacts.removeAll()
                        } else {
                            self.isShowing = false
                        }
                    }) {
                        if !self.createEventViewModel.selectedContacts.isEmpty {
                            Text("Temizle")
                        } else {
                            Text("Kapat")
                        }
                        
                        }
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text("Rehber").foregroundColor(.white).padding()
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.isShowing = false
                    }) {
                        if !createEventViewModel.selectedContacts.isEmpty {
                            Text("Ekle")

                        }
                        }
                        .foregroundColor(.white)
                        .padding()
                }
                
            }.background(Util.shared.firstColor)
            

            
            List(initialContacts) { (invitee) in
                InviteeRowView(invitee: invitee, isSelected: self.createEventViewModel.selectedContacts.contains(invitee)) {
                    if self.createEventViewModel.selectedContacts.contains(invitee) {
                        self.createEventViewModel.selectedContacts.removeAll(where: { $0 == invitee })
                    } else {
                        self.createEventViewModel.selectedContacts.append(invitee)
                    }
                }
            }
        }

    }
}

//struct ContactPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactPickerView()
//    }
//}
