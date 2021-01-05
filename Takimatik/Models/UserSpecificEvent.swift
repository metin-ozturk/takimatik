//
//  UserSpecificEvent.swift
//  Takimatik
//
//  Created by Metin Ozturk on 7.08.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation

struct UserSpecificEvent : Identifiable, Codable, Hashable {
    let id = UUID()
    
    let eventID : String
    let type : EventType
    let title : String
    let involvementStatus : EventParticipationStatus
}
