//
//  Wobble.swift
//  Final
//
//  Created by Christian Gabor on 6/10/20.
//  Copyright © 2020 Christian Gabor. All rights reserved.
//

import SwiftUI

struct Wobble: ViewModifier {
    @State var isRunning = false
    @State var runAnimation = true
    
    
    func body(content: Content) -> some View {
        Group {
            if self.runAnimation {
                content
                    .rotationEffect(Angle(degrees: self.isRunning ? -15: 15))
                    .animation(Animation.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true))
                    .onAppear {
                        self.isRunning = true
                        self.toggleAnimation(afterTime: 3*0.1)
                }
                
            } else {
                content.onAppear {
                    self.toggleAnimation(afterTime: 5)
                    self.isRunning = false}
            }
        }
    }
    
   private func toggleAnimation(afterTime delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.runAnimation.toggle()
        }
    }
        
    
 
}

struct WobblingView: View {
    var content: Image
    
    var body: some View {
        content
            .rotationEffect(Angle(degrees: -20))
            .rotationEffect(Angle(degrees: 20))
            .animation(Animation.easeInOut(duration: 0.1).repeatCount(20, autoreverses: true))
    }
}

extension View {
    func wobble() -> some View {
        self.modifier(Wobble())
    }
}
