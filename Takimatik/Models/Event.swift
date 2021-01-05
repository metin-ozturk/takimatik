//
//  Activity.swift
//  Takimatik
//
//  Created by Metin Öztürk on 25.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation

enum EventType : String {
    case Wedding = "wedding"
    case BabyShower = "babyshower"
    case Birthday = "birthday"
}

struct Event : Identifiable {
    let id : String
    let title : String
    let eventType : EventType
}
