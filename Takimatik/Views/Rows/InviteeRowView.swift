//
//  InviteeRowView.swift
//  Takimatik
//
//  Created by Metin Öztürk on 27.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct InviteeRowView: View {
    
    var invitee : Invitee
    var isSelected: Bool
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text("\(invitee.name)")
                Divider()
                Text("\(invitee.phoneNumber)")
                if self.isSelected {
                    Spacer()
                    Image("checkmark")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Util.shared.thirdColor)
                        .frame(width: 25, height: 25, alignment: .center)
                }
            }
        }.buttonStyle(TMInviteeButtonStyle())
            .frame(width: nil, height: 40, alignment: .leading)
    }
    
}
