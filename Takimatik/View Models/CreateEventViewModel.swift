//
//  ContactsViewModel.swift
//  Takimatik
//
//  Created by Metin Öztürk on 28.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

class CreateEventViewModel : ObservableObject {
    @Published var event = Event(title: "", eventType: .Wedding, participationStatus: .Participated, latitude: "", longitude: "", startDate: "", endDate: "", image: "", founderPhoneNumber: "")
    
    @Published var selectedContacts: [Invitee]
    @Published var selectedImage : UIImage?
    
    init(selectedContacts : [Invitee], selectedImage: UIImage?) {
        self.selectedContacts = selectedContacts
        self.selectedImage = selectedImage
    }
    
    func createEvent(completion: @escaping (Bool) -> Void) {
        RemoteDataManager.makeRequest(requestUrl: "event", requestMethod: "POST", sentData: event) { (data, statusCode) in
            completion(statusCode == 200)
        }
    }
        
    func clear() {
        self.event = Event(title: "", eventType: .Wedding, participationStatus: .Participated, latitude: "", longitude: "", startDate: "", endDate: "", image: "", founderPhoneNumber: "")
        selectedContacts = []
        selectedImage = nil
    }
    
}
