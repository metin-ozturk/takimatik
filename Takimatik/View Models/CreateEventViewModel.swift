//
//  ContactsViewModel.swift
//  Takimatik
//
//  Created by Metin Öztürk on 28.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

class CreatEventViewModel : ObservableObject {
    @Published var selectedContacts: [Invitee]
    @Published var selectedImage : Image?
    
    init(selectedContacts : [Invitee], selectedImage: Image?) {
        self.selectedContacts = selectedContacts
        self.selectedImage = selectedImage
    }
}
