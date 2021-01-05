//
//  File.swift
//  Takimatik
//
//  Created by Metin Öztürk on 26.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation
import CoreLocation

struct DataManager {
    static let shared = DataManager()
    
    let locationManager = CLLocationManager()
    
    
    func storeUserInfo(phoneNumber: String, rememberToken: String){
        UserDefaults.standard.set(phoneNumber, forKey: "PhoneNumber")
        UserDefaults.standard.set(rememberToken, forKey: "RememberToken")
    }
    
    func getStoredUserInfo() -> [String]?{
        if let phoneNumber : String = UserDefaults.standard.string(forKey: "PhoneNumber"),
            let rememberToken: String = UserDefaults.standard.string(forKey:"RememberToken"){
            return [phoneNumber, rememberToken]
        }
        
        return nil
    }
    
    func clearStoredUserInfo() {
        storeUserInfo(phoneNumber: "", rememberToken: "")
    }
    
}
