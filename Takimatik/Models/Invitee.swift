//
//  Invitee.swift
//  Takimatik
//
//  Created by Metin Öztürk on 25.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation
import SwiftUI

enum InviteeDonationType : Int, Codable {
    case money = 1
    case none = -1
}


struct InviteeDonation : Hashable, Codable {
    let type : InviteeDonationType
    let amount : Int?
}


struct Invitee : Identifiable, Hashable, Equatable, Codable {
    let id : String
    let name : String
    let phoneNumber : String
    
    var image : String? = nil
    var donation = InviteeDonation(type: .none, amount: nil)
    
    static func == (lhs: Invitee, rhs: Invitee) -> Bool {
        return lhs.id == rhs.id
    }
}
