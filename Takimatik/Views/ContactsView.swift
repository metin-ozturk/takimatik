//
//  ContacsView.swift
//  Takimatik
//
//  Created by Metin Öztürk on 27.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation
import SwiftUI
import Contacts
import ContactsUI

struct ContactsView UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let controller = CNContactPickerViewController()
        controller.delegate = context.coordinator
        controller.displayedPropertyKeys = [CNContactGivenNameKey]
        return controller
    }


    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactsView

        init(_ contactsViewController: ContactsView) {
            self.parent = contactsViewController
        }

    }
}
