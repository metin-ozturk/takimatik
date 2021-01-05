//
//  DonationView.swift
//  Takimatik
//
//  Created by Metin Ozturk on 16.08.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct DonationView : View {
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Takı:")
                        .foregroundColor(Color.white)
                        .padding(.all)
                    Spacer()
                }.background(Util.shared.firstColor)



                HStack {
                    VStack {
                        Image("money")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("Para")

                    }
                    
                    VStack {
                        Image("gold")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("Altın")

                    }
                    
                    VStack {
                        Image("gift")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("Hediye")

                    }
                }
            }
            
            VStack {
                Text("Miktar:")
            }
        }
    }
}
