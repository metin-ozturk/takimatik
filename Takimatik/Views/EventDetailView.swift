//
//  EventDetailView.swift
//  Takimatik
//
//  Created by Metin Öztürk on 30.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI
import EventKit

struct EventDetailView: View {
    @State var event = Event(title: "", eventType: .Wedding, participationStatus: .Invited, latitude: "", longitude: "", startDate: "", endDate: "", image: "", founderPhoneNumber: "")
    
    @State var eventImage = Image("placeholder")
    
    var eventID: String
    
    @ObservedObject var eventDetailViewModel: EventDetailViewModel
    
    @State private var isShowingCalendarAlert = false
    @State private var isLoading = false
    
    var body: some View {
        BaseView(isLoading: isLoading) {
            VStack {
                eventImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Util.shared.firstColor, lineWidth: 2.5)
                            .shadow(color: Util.shared.firstColor, radius: 2.5, x: 0, y: 0))
                    .padding()
                
                ZStack {
                    Image(event.eventType.getEventImageName())
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Util.shared.thirdColor)
                        .aspectRatio(contentMode: .fit)
                    
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            VStack {
                                HStack {
                                    Text("Etkinlik Türü: ").foregroundColor(.white)
                                    Text("\(event.eventType.getEventTypeDescription())").foregroundColor(.white)
                                    Spacer()
                                }
                                
                                HStack {
                                    Text(event.startDate)
                                        .foregroundColor(.white)
                                        .fontWeight(.light)
                                        .font(.caption)
                                    Spacer()
                                }
                                
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                self.isShowingCalendarAlert.toggle()
                            }) {
                                Image("calendar")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.white)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                            }.alert(isPresented: self.$isShowingCalendarAlert) {
                                Alert(title: Text("Bilgi"), message: Text("Bu etkinliği takviminize eklemek istiyor musunuz?"), primaryButton: .default(Text("Ekle"), action: {
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "tr_TR")
                                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                                    
                                    let startDate = dateFormatter.date(from: self.event.startDate) ?? Date()
                                    let endDate = dateFormatter.date(from: self.event.endDate) ?? Date()
                                    
                                    self.checkCalendarAccess(startDate: startDate, endDate: endDate)
                                    
                                }), secondaryButton: .cancel(Text("İptal")))
                            }
                            
                            Button(action: {
                                let directionsURL = "http://maps.apple.com/?saddr=Current%20Location&daddr=\(self.event.latitude ),\(self.event.longitude)"
                                guard let url = URL(string: directionsURL) else { return }
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }) {
                                Image("routeDescription")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.white)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Util.shared.firstColor)
                        
                        
                        List(event.invitees) { invitee in
                            VStack {
                                HStack {
                                    Image(uiImage: UIImage(named: invitee.image ?? "profilePhoto")!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Circle()
                                                .stroke(Util.shared.firstColor, lineWidth: 2.5)
                                                .shadow(color: Util.shared.firstColor, radius: 2.5, x: 0, y: 0)
                                    )
                                        .cornerRadius(15)
                                    
                                    Text("\(invitee.name)")
                                    Spacer()
                                    Text("\(invitee.donation.amount ?? 0) ₺")
                                        .frame(minWidth: 75, alignment: .center)
                                        .foregroundColor(Color.white)
                                        .padding(.all, 2.5)
                                        .background(Util.shared.thirdColor)
                                        .cornerRadius(10)
                                }
                                
                                Divider()
                                    .foregroundColor(Util.shared.thirdColor)
                            }
                            
                        }.padding(.vertical, 0)
                    }.opacity(0.7)
                    
                }
                
                
                Spacer()
                    
                    .navigationBarTitle(event.title)
                    .onAppear {
                        self.isLoading = true
                        self.eventDetailViewModel.getEventDetail(eventID: self.eventID) { (rEvent, rImage) in
                            self.isLoading = false
                            if (rEvent != nil && rImage != nil) {
                                self.event = rEvent!
                                self.eventImage = rImage!
                            }
                        }
                }
            }
        }
    }
    
    func checkCalendarAccess(startDate: Date, endDate: Date) {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore, startDate: startDate, endDate: endDate)
        case .denied:
            print("Access to calendar denied.")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion:
                { (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self.insertEvent(store: eventStore, startDate: startDate, endDate: endDate)
                    } else {
                        print("Access to calendar denied.")
                    }
            })
        default:
            break
        }
    }
    
    func insertEvent(store: EKEventStore, startDate: Date, endDate : Date) {
        let event = EKEvent(eventStore: store)
        event.title = self.event.title
        event.startDate = startDate
        event.endDate = endDate
        event.notes = "Bu etkinlik Takımatik uygulaması tarafından oluşturulmuştur."
        event.calendar = store.defaultCalendarForNewEvents
        
        do {
            try store.save(event, span: .thisEvent)
            let interval = startDate.timeIntervalSinceReferenceDate
            if let url = URL(string: "calshow:\(interval)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } catch let error {
            print("Failed to save event to calendar : \(error)")
        }
    }
}

//struct EventDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailView(event: Event( title: "Deneme", eventType: EventType.Birthday, participationStatus: .Founded, latitude: "32.13", longitude: "29.1",startDate: "12-08-2020 15:00", endDate: "12-08-2020 18:00", image: "", founderPhoneNumber: ""))
//    }
//}
