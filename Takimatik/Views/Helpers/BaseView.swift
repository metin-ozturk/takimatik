//
//  BaseView.swift
//  Takimatik
//
//  Created by Metin Öztürk on 27.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI

struct BaseView<Content>: View where Content: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    
    private let loadingView = LoadingView()
    private let content : Content
    
    private var isLoading = false
    
    public init(isLoading: Bool, isModal: Bool = false, @ViewBuilder content : () -> Content) {
        self.content = content()
        self.isLoading = isLoading
        self.keyboard.isModal = isModal
    }
    
    var body: some View {
        ZStack {
            content
                .blur(radius: isLoading ? 5 : 0)
            if isLoading {
                loadingView
            }
        }
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut(duration: 0.20))
    }
}
