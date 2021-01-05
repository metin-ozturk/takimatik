//
//  TMButton.swift
//  Takimatik
//
//  Created by Metin Öztürk on 26.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct TMButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .foregroundColor(configuration.isPressed ? Color.white : Util.shared.buttonColor)
        .background(configuration.isPressed ? Util.shared.buttonColor : Color.white)
        .cornerRadius(5)
  }

}

struct TMButtonStyleInverted: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .foregroundColor(configuration.isPressed ? Util.shared.buttonColor : Color.white)
        .background(configuration.isPressed ? Color.white : Util.shared.buttonColor)
        .cornerRadius(5)

  }

}
