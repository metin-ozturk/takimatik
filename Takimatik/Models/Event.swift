//
//  Activity.swift
//  Takimatik
//
//  Created by Metin Öztürk on 25.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation


enum EventType : Int, CaseIterable, Identifiable, Codable  {
    var id: Int { self.rawValue }
    
    case Wedding = 1
    case BabyShower = 2
    case Birthday = 3
    
    func getEventTypeDescription() -> String {
        switch self {
        case .Wedding:
            return "Düğün"
        case .BabyShower:
            return "Baby Shower"
        case .Birthday:
            return "Doğum Günü"
        }
    }
    
    func getEventImageName() -> String {
        switch self {
        case .Wedding:
            return "wedding"
        case .BabyShower:
            return "babyshower"
        case .Birthday:
            return "birthday"
        }
    }
}

enum EventParticipationStatus : Int, Codable {
    case Founded = 1
    case Invited = 2
    case Participated = 3
}

struct Event : Identifiable, Codable {
    let id = UUID()
    
    let title : String
    let eventType : EventType
    let participationStatus : EventParticipationStatus
    let latitude : String
    let longitude : String
    let startDate : String
    let endDate : String
    let image : String
    let founderPhoneNumber : String

    var invitees = [Invitee]()
    
}

