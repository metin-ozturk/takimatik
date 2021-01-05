//
//  TMInviteeButtonStyle.swift
//  Takimatik
//
//  Created by Metin Öztürk on 27.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI


struct TMInviteeButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .foregroundColor(Color.black)
        .background(Color.white)
        .cornerRadius(5)
  }

}


