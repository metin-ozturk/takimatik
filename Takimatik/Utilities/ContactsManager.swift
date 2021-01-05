//
//  ContactsManager.swift
//  Takimatik
//
//  Created by Metin Öztürk on 28.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation
import Contacts

class ContactsManager : ObservableObject {
    
    @Published var rContacts = [Invitee]()

    func fetchContacts() {
        do {
            let store = CNContactStore()
            let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                               CNContactFamilyNameKey as CNKeyDescriptor,
                               CNContactPhoneNumbersKey as CNKeyDescriptor
            ]
            let containerId = store.defaultContainerIdentifier()
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            
            var rContacts = [Invitee]()
            
            for (idx, contact) in contacts.enumerated() {
                let rFullName = "\(contact.givenName) \(contact.familyName)"
                
                var rPhoneNumber = (contact.phoneNumbers.first?.value.stringValue ?? "")
                    .replacingOccurrences(of: "-", with: "")
                    .replacingOccurrences(of: "(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                
                if rPhoneNumber.count >= 10 {
                    if rPhoneNumber.substring(with: 0..<3) == "+90" {
                        rPhoneNumber = rPhoneNumber.substring(from: 3)
                    } else if rPhoneNumber.first == "0" {
                        rPhoneNumber = rPhoneNumber.substring(from: 1)
                    }
                }
                                
                rContacts.append(Invitee(id: String(idx), name: rFullName, phoneNumber: rPhoneNumber))
            }
            
            DispatchQueue.main.async {
                self.rContacts = rContacts
            }
            
        } catch {
            print("Error while getting contacts")
        }
    }
}

