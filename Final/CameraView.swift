//
//  ContentView.swift
//  Final
//
//  Created by Christian Gabor on 5/28/20.
//  Copyright © 2020 Christian Gabor. All rights reserved.
//

import SwiftUI
import UIKit


struct CameraView: View {
    @ObservedObject var camera: CameraViewModel
    @ObservedObject var store: FoodStore
    
    @State var numDisplayed = 5
    @State var height: CGFloat = 300
       

    var body: some View {
        UINavigationBar.appearance().backgroundColor = .clear
  
        return ZStack {
            if self.camera.showCapture {
                CaptureImageView(camera: self.camera)
            } else {
                VStack {
                    self.camera.image?.resizable()
                    Button(action: {
                        self.camera.showCapture.toggle()
                        
                    })
                    {
                        Text("Retake Photo")
                    }.buttonStyle(GreenButton()).padding()
      
                    PredictionView(predictions: self.camera.predictions[0..<numDisplayed], store: self.store, height: self.height)
                 
                    
                        .gesture(self.collapseGesture())
                }.padding(.top)
            }
        }
    }
    
    @State private var previousDragHeight: CGFloat = 0
    
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private func collapseGesture() -> some Gesture {
        DragGesture()
            .onEnded { finalDragGesture in
                withAnimation {
                    if self.previousDragHeight < finalDragGesture.translation.height {
                    self.numDisplayed = 1
                    self.height = 50
                } else {
                    self.numDisplayed = 5
                    self.height = 250
                }
                }
                self.previousDragHeight = finalDragGesture.translation.height
        }
    }
}

struct PredictionView: View {
    
    var predictions: ArraySlice<Food>
    @ObservedObject var store: FoodStore
    var height: CGFloat
    
    var body: some View {
        return GeometryReader {geometry in
            self.body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View {
        let frameHeight = min(size.height, height)
        return ZStack {
            HStack (alignment: .bottom){
            VStack {
                ForEach(predictions) { food in
                    
                    HStack {
                        Text(food.name)
                        Spacer()
                        Button(action: {
                            self.store.foods.append(food)
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                }}.padding().frame(height: frameHeight)
            RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: self.edgeLineWidth).foregroundColor(.secondary).frame(height: frameHeight).padding(.top).padding(.bottom)
            
        }
    }
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
}


struct GreenButton: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .padding()
            .foregroundColor(.primary)
            .background(Color(FoodLog.appThemeColor))
        .cornerRadius(40)
            .padding(5)
        
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
