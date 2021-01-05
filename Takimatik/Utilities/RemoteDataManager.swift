//
//  RemoteDataManager.swift
//  Takimatik
//
//  Created by Metin Öztürk on 1.08.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation

struct RemoteDataManager {
//    static let baseUrl = "http://localhost:3000/"
    static let baseImageUrl = "https://takimatikabplus.s3.eu-west-1.amazonaws.com/"
    static let baseUrl = "https://takimatik.herokuapp.com/"
    
    static func makeRequest(requestUrl: String, requestMethod: String, sentData: Encodable?, completion : @escaping (Data?, Int?) -> Void) {
        if let url = URL(string: baseUrl + requestUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = requestMethod
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
                        
            if let rememberToken: String = UserDefaults.standard.string(forKey:"RememberToken"), !rememberToken.isEmpty {
                request.addValue("Bearer " + rememberToken, forHTTPHeaderField: "Authorization")
            }
                                    
            if let dataToBeSent = sentData?.toJSONData() {
                request.httpBody = dataToBeSent
            }

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let httpResponseCode = (response as? HTTPURLResponse)?.statusCode ?? 0

                if let error = error {
                    print("Error while sending data: \(error)")
                    completion(nil, nil)
                    
                    return
                }
                

                if let data = data, 200...299 ~= httpResponseCode {
                    completion(data, httpResponseCode)
                } else {
                    completion(nil, httpResponseCode)
                }
                
            }
            
            task.resume()            
        }
    }
}
