//
//  ActivityFeedView.swift
//  Takimatik
//
//  Created by Metin Öztürk on 25.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct EventFeedView: View {
    let userSpecificEvent : UserSpecificEvent

    @State private var isShowingEventDetailView = false
    
    var borderColor : Color {
        switch userSpecificEvent.involvementStatus {
        case .Founded:
            return Util.shared.hexStringToColor(hex: "#96261a")
        case .Invited:
            return Util.shared.hexStringToColor(hex: "#626e85")
        case .Participated:
            return Util.shared.hexStringToColor(hex: "#79a68c")
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            NavigationLink(destination: EventDetailView(eventID: userSpecificEvent.eventID, eventDetailViewModel: EventDetailViewModel()), isActive: self.$isShowingEventDetailView) { EmptyView() }
            Image(userSpecificEvent.type.getEventImageName())
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Util.shared.fourthColor)
                .aspectRatio(contentMode: .fit)
                .padding(.all, 5)
                .frame(width: 135, height: 135, alignment: .center)
            Text(userSpecificEvent.title)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(Util.shared.firstColor)
                .padding([.bottom, .leading, .trailing], 5)
                .frame(idealWidth: 135, minHeight:30, maxHeight: 55, alignment: .center)
        }
        .background(Color.white.cornerRadius(20).opacity(0.7))
        .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(borderColor, lineWidth: 2.5)
                    .shadow(color: borderColor, radius: 2.5, x: 0, y: 0)
        )
            .frame(idealWidth: 145, minHeight: 175, maxHeight: 225, alignment: .center)
            .onTapGesture {
                self.isShowingEventDetailView.toggle()
        }
    }
}

//struct EventFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventFeedView(event: Event(id: "0", title: "Deneme", eventType: EventType(rawValue: "Deneme")!, participationStatus: .Founded))
//    }
//}
