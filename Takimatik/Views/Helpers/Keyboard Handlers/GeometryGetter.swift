//
//  GeometryGetter.swift
//  Takimatik
//
//  Created by Metin Ozturk on 17.08.2020.
//  Copyright © 2020 abplus. All rights reserved.
//
import SwiftUI

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    if geometry.size.width > 0 && geometry.size.height > 0 {
                        self.rect = geometry.frame(in: .global)
                    }
                }

                return AnyView(Color.clear)
            }
        }
    }
}
