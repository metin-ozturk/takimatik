//
//  Util.swift
//  Takimatik
//
//  Created by Metin Öztürk on 25.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation
import Contacts
import AWSS3

class Util {
    static let shared = Util()
    
    lazy var firstColor = hexStringToColor(hex: "3c4245")
    lazy var secondColor : Color = hexStringToColor(hex: "5f6769")
    lazy var thirdColor : Color = hexStringToColor(hex: "719192")
    lazy var fourthColor : Color = hexStringToColor(hex: "bdaeaf")
    
    lazy var buttonColor = thirdColor
    
    private lazy var documentsUrl: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    func checkForLocationServices() -> Bool {
        let rValue : Bool
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            DataManager.shared.locationManager.requestWhenInUseAuthorization()
            rValue = false
        case .authorizedAlways, .authorizedWhenInUse:
            rValue = true
        case .restricted, .denied:
            rValue = false
        @unknown default:
            rValue = false
        }
        
        return rValue
    }
    
    func checkForContactsAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            completionHandler(false)
        case .restricted, .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        @unknown default:
            completionHandler(false)
        }
    }
    
    func convertPhoneNumberToUserPresentableForm(rPhoneNumber: String) -> String? {
        guard rPhoneNumber.count == 10 else { return nil}
        
        var phoneNumberToBeModified = rPhoneNumber
        phoneNumberToBeModified = "(" + phoneNumberToBeModified.substring(with: 0..<3) + ") " + phoneNumberToBeModified.substring(with: 3..<6) + "-" + phoneNumberToBeModified.substring(with: 6..<8) + "-" + phoneNumberToBeModified.substring(with: 8..<10)
        
        return phoneNumberToBeModified
    }
    
    func deleteFile(fileName:String){
        let fileManager = FileManager.default
       
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent(fileName)
        
        do {
            try fileManager.removeItem(at: fileUrl)
            print("Cleared temp folder")
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func downloadImageAws(fileName: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.EUWest1, identityPoolId:"eu-west-1:b010dab4-d171-43e2-9d51-57cdeb6ff822")
        let configuration = AWSServiceConfiguration(region:.EUWest1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let transferUtility = AWSS3TransferUtility.default()
        
        let bucketName = "takimatikabplus"

        transferUtility.downloadData(fromBucket: bucketName, key: fileName, expression: nil) { (task, url, data, error) in
            var resultImage: UIImage?

            if let data = data {
                resultImage = UIImage(data: data)
            }

            completion(resultImage, error)

        }
    }
    
    func generateFileName(type: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        let dateStr = dateFormatter.string(from: Date())
        
        let name = generateRandomStringWithLength(length: 32) + "" + dateStr + "." + type
        return name
    }
    
    func generateRandomStringWithLength(length: Int) -> String {
        
        var randomString = ""
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for _ in 1...length {
            let randomIndex  = Int(arc4random_uniform(UInt32(letters.count)))
            let a = letters.index(letters.startIndex, offsetBy: randomIndex)
            randomString +=  String(letters[a])
        }
        
        return randomString
    }
    
    func hexStringToColor (hex:String) -> Color {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return Color.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return Color(
            red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgbValue & 0x0000FF) / 255.0
        )
    }
    
    func uploadImageAws(fileUrl : URL, fileName:String, result:@escaping ((Bool)->())){

        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.EUWest1, identityPoolId:"eu-west-1:b010dab4-d171-43e2-9d51-57cdeb6ff822")
        let configuration = AWSServiceConfiguration(region:.EUWest1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = "takimatikabplus"
        uploadRequest?.key = fileName
        uploadRequest?.acl = AWSS3ObjectCannedACL.publicRead
        uploadRequest?.body = fileUrl
        
        uploadRequest?.contentType = "image/jpeg"
        
        
        let transferManager = AWSS3TransferManager.default()
        
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task) -> Any? in
            Util.shared.deleteFile(fileName: fileName)
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        print("Uploading cancelled or paused: \(uploadRequest?.key ?? "") Error: \(error)")
                        break
                    default:
                        print("Error uploading: \(uploadRequest?.key ?? "") Error: \(error)")
                        break
                    }
                } else {
                    print("Error uploading: \(uploadRequest?.key ?? "") Error: \(error)")
                }
                result(false)
                return nil
            }
            result(true)
            
            return nil
        })
    }
    
    func writeImageToFile(img: UIImage) -> (Optional<URL>, Optional<String>, Int, String){
        
        if let data = img.jpegData(compressionQuality: 0.5) {
            //print("\(data.count)")
            let fileName = Util.shared.generateFileName(type: "jpg")
            
            let fileUrl = documentsUrl.appendingPathComponent(fileName)//getDocumentsDirectory().appendingPathComponent(fileName)
            try? data.write(to: fileUrl)
            return (fileUrl,fileName,data.count,"jpg")
        }
        return (nil,"",0,"")
    }
    
}
