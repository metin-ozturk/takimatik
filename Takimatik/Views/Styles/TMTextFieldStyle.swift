//
//  TMTextFieldStyle.swift
//  Takimatik
//
//  Created by Metin Öztürk on 1.08.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct TMTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
      configuration
          .textFieldStyle(RoundedBorderTextFieldStyle())
        .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Util.shared.thirdColor, lineWidth: 1)
                .shadow(color: Util.shared.thirdColor, radius: 2.5, x: 0, y: 0))
        .padding(.horizontal)
        
    }
    
}
