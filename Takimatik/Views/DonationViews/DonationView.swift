//
//  DonationView.swift
//  Takimatik
//
//  Created by Metin Ozturk on 16.08.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct DonationView : View {
    
    
    @Binding var isShowingDonationView : Bool
    
    @State var isSelected : DonationType = .Money 
    @State var donationAmount : Float = 1
    @State var donationNote : String = ""
    
    @State var isLoading = false
    @State var isShowingAlert = false
    
    var body: some View {
        BaseView(isLoading: isLoading, isModal: true) {
            VStack {
                VStack {
                    HStack {
                        Text("Takı:")
                            .foregroundColor(Color.white)
                            .padding(.all)
                        Spacer()
                    }.background(Util.shared.firstColor)
                    
                    HStack {
                        Spacer()
                        DonationTypeView(donationText: "Para", donationType: .Money, donationAmount: self.$donationAmount, isSelected: self.$isSelected)
                        Spacer()
                        DonationTypeView(donationText: "Altın", donationType: .Gold, donationAmount: self.$donationAmount, isSelected: self.$isSelected)
                        Spacer()
                        DonationTypeView(donationText: "Hediye", donationType: .Gift, donationAmount: self.$donationAmount, isSelected: self.$isSelected)
                        Spacer()
                    }
                }
                HStack {
                    Text("Miktar:")
                        .foregroundColor(Color.white)
                        .padding(.all)
                    Spacer()
                }
                .background(Util.shared.firstColor)
                .padding(.vertical)
                
                VStack {
                    HStack {
                        Slider(value: self.$donationAmount, in:(isSelected == .Money ? 0 : 1)...(isSelected == .Money ? 1000: 5), step: isSelected == .Money ? 5 : 1)
                            .padding(.vertical)
                            .padding(.leading)
                            .accentColor(Util.shared.thirdColor)
                        Text(String(format: isSelected == .Money ? "%.0f ₺" : "%.0f Gram", self.donationAmount))
                            .padding(.all, 10)
                            .background(Util.shared.thirdColor)
                            .foregroundColor(.white)
                            .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                            .frame(width: 80, alignment: .trailing)
                    }
                }
                
                HStack {
                    Text("Takı Notu:")
                        .foregroundColor(Color.white)
                        .padding(.all)
                    Spacer()
                }
                .background(Util.shared.firstColor)
                .padding(.vertical)
                
                TextField("Notunuzu yazınız.", text: $donationNote)
                    .textFieldStyle(TMTextFieldStyle())
                
                
                Spacer()
                
                HStack {
                    Button(action: {
                        self.isShowingAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Onayla")
                            Spacer()
                        }
                    }.buttonStyle(TMButtonStyleInverted())
                    .padding()
                    .alert(isPresented: $isShowingAlert) {
                        Alert(title: Text("Bilgi"), message: Text("Bu özellik ileriki versiyonlarda eklenecektir."), dismissButton: Alert.Button.default(Text("Tamam")))
                    }
                    
                    Button(action: {
                        self.isShowingDonationView = false
                    }) {
                        HStack {
                            Spacer()
                            Text("İptal")
                            Spacer()
                        }
                    }.buttonStyle(TMButtonStyleInverted())
                        .padding()
                }
                
                
            }
        }
    }
}

struct DonationView_Previews: PreviewProvider {
    static var previews: some View {
        DonationView(isShowingDonationView: .constant(true), isSelected: .Money)
    }
}
