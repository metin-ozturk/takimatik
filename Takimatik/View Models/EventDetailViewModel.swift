//
//  SwiftUI.swift
//  Takimatik
//
//  Created by Metin Ozturk on 7.08.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

class EventDetailViewModel : ObservableObject {
    @Published var eventDetail : Event = Event(title: "", eventType: .Wedding, participationStatus: .Participated, latitude: "", longitude: "", startDate: "", endDate: "", image: "", founderPhoneNumber: "")
    
    func getEventDetail(eventID: String, completion: @escaping (Event?, Image?) -> Void) {
        struct EventID : Encodable {
            let eventID : String
        }
        
        RemoteDataManager.makeRequest(requestUrl: "eventDetail", requestMethod: "POST", sentData: EventID(eventID: eventID)) { (data, statusCode) in
            if let data = data, let rEvent = try? JSONDecoder().decode(Event.self, from: data), statusCode == 200 {
                Util.shared.downloadImageAws(fileName: rEvent.image + ".jpg") { (image, error) in
                    if let image = image {
                        DispatchQueue.main.async {
                            completion(rEvent, Image(uiImage: image))
                        }
                    } else {
                        print("Error while dowloading event image: ", error?.localizedDescription ?? "")
                        completion(nil, nil)
                    }
                    return
                }
            } else {
                completion(nil, nil)
            }
            
        }
    }
}
