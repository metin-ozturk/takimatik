//
//  User.swift
//  Takimatik
//
//  Created by Metin Öztürk on 29.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation

struct User : Identifiable, Hashable, Equatable, Codable {
    var id : String { phoneNumber }
    var phoneNumber : String
    var pin : String
    
    var rememberToken: String = ""
    var name = ""
    var image = ""
    var involvedEvents = [UserSpecificEvent]()
}
