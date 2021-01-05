//
//  DonationTypeView.swift
//  Takimatik
//
//  Created by Metin Ozturk on 16.08.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

enum DonationType : String {
    case Gold = "gold"
    case Money = "money"
    case Gift = "gift"
}

struct DonationTypeView: View {
    let donationText: String
    let donationType : DonationType
    
    @Binding var donationAmount : Float
    
    @Binding var isSelected : DonationType {
        willSet {
            if donationType == .Money {
                donationAmount = 0
            } else {
                donationAmount = 1
            }
        }
    }
    @State private var isShowingAlert = false
    
    var body: some View {
        Button(action: {
            if self.donationType == .Gift {
                self.isShowingAlert = true
            } else {
                self.isSelected = self.donationType
            }
        }) {
            VStack {
                Image(donationType.rawValue)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                Text(donationText)
                    .foregroundColor(isSelected == donationType ? .white : Util.shared.secondColor)
                    .padding(.vertical, 5)
            }
            .padding(.vertical, 10)
            .background(isSelected == donationType ? Util.shared.thirdColor : .white)
            .cornerRadius(10)
        }.alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Bilgi"), message: Text("Bu özellik ileriki versiyonlarda eklenecektir."), dismissButton: Alert.Button.default(Text("Tamam")))
        }
    }
}

struct DonationTypeView_Previews: PreviewProvider {
    static var previews: some View {
        DonationTypeView(donationText: "Para", donationType: .Money, donationAmount: .constant(0), isSelected: .constant(.Money))
    }
}
