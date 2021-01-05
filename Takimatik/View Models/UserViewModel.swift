//
//  User.swift
//  Takimatik
//
//  Created by Metin Öztürk on 29.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

class UserViewModel: ObservableObject {
    @Published var user = User(phoneNumber: "", pin: "")
    @Published var userImage = UIImage(named: "profilePhoto")
    
    func clearUserInfo() {
        user = User(phoneNumber: "", pin: "", rememberToken: "")
        DataManager.shared.clearStoredUserInfo()
    }
    
    func getUserSpecificEvents(completion: @escaping ([UserSpecificEvent]?) -> Void) {
        RemoteDataManager.makeRequest(requestUrl: "userSpecificEvent", requestMethod: "POST", sentData: user) { (data, statusCode) in
            if let data = data, let userSpecificEvent = try? JSONDecoder().decode([UserSpecificEvent].self, from: data) {
                completion(userSpecificEvent)
                return
            }
            completion(nil)
        }
    }
    
    func getPin(completion: @escaping (Data?) -> Void ) {
        let phoneNumber = user.phoneNumber
        
        struct PhoneNumber : Encodable {
            let phoneNumber : String
        }
        
        RemoteDataManager.makeRequest(requestUrl: "askForLoginPin", requestMethod: "POST", sentData: PhoneNumber(phoneNumber: phoneNumber)) { (data, statusCode) in
           completion(data)
        }
    }
    
    func loginWithPin(completion: @escaping (Bool, Int?) -> Void ) {
        let phoneNumber = user.phoneNumber
        let pin = user.pin
        
        RemoteDataManager.makeRequest(requestUrl: "loginWithPin", requestMethod: "POST", sentData: User(phoneNumber: phoneNumber, pin: pin)) { (data, statusCode) in
            if let data = data, let user = try? JSONDecoder().decode(User.self, from: data) {
                if user.image.isEmpty {
                    DataManager.shared.storeUserInfo(phoneNumber: phoneNumber, rememberToken: user.rememberToken)
                    DispatchQueue.main.async {
                        self.user = user
                        completion(true, statusCode)
                    }
                } else {
                    Util.shared.downloadImageAws(fileName: user.image + ".jpg") { (rImage, error) in
                        if let error = error {
                            print("Error while downloading user image ", error)
                        }
                        DispatchQueue.main.async {
                            DataManager.shared.storeUserInfo(phoneNumber: phoneNumber, rememberToken: user.rememberToken)
                            self.user = user
                            self.userImage = rImage
                            completion(true, statusCode)
                        }
                    }
                }

            } else {
                DispatchQueue.main.async {
                    completion(false, statusCode)
                }
            }
        }
    }
    
    func loginWithRememberToken(phoneNumber: String, rememberToken: String, completion: @escaping (Bool) -> Void) {
        struct UpdateRequest : Encodable {
            let phoneNumber: String
            let pin: String
            let rememberToken: String
        }
        
        RemoteDataManager.makeRequest(requestUrl: "loginWithRememberToken", requestMethod: "POST", sentData: UpdateRequest(phoneNumber: phoneNumber, pin: "", rememberToken: rememberToken)) { (data, statusCode) in
            

            if let data = data, let user = try? JSONDecoder().decode(User.self, from: data) {
                if user.image.isEmpty {
                    DispatchQueue.main.async {
                        self.user = user
                        completion(true)
                    }
                } else {
                    Util.shared.downloadImageAws(fileName: user.image + ".jpg") { (rImage, error) in
                        if let error = error {
                            print("Error while downloading user image ", error)
                        }
                        DispatchQueue.main.async {
                            self.user = user
                            self.userImage = rImage
                            completion(true)
                        }
                    }
                }


            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
            
        }
    }
    
    func updateUser(rUserName: String, retrievedImage: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let retrievedImage = retrievedImage else {
            var tempUser = self.user
            tempUser.name = rUserName
            
            RemoteDataManager.makeRequest(requestUrl: "updateUser", requestMethod: "POST", sentData: tempUser) { (data, statusCode) in
                if statusCode == 200 {
                    self.user = tempUser
                    completion(true)
                    return
                }
                completion(false)
            }
            
            return
        }
        
        let (fileUrl,fileName,_,_) = Util.shared.writeImageToFile(img: retrievedImage)
        
        if let fileUrl = fileUrl, let fileName = fileName {
            Util.shared.uploadImageAws(fileUrl: fileUrl, fileName: fileName) { (result) in
                if result == true {
                    var tempUser = self.user
                    tempUser.name = rUserName
                    tempUser.image = fileName.replacingOccurrences(of: ".jpg", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    RemoteDataManager.makeRequest(requestUrl: "updateUser", requestMethod: "POST", sentData: tempUser) { (data, statusCode) in
                        if statusCode == 200 {
                            DispatchQueue.main.async {
                                self.user = tempUser
                                completion(true)
                            }
                            return
                        }
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
    
}
