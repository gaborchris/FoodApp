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
    @EnvironmentObject var store: FoodStore
    
    @State var numDisplayed = 5
    @State var height: CGFloat = 300
    


    var body: some View {
        UINavigationBar.appearance().backgroundColor = .clear
  
        return ZStack {
            if self.camera.showCapture {
                CaptureImageView(camera: self.camera)
            } else {
                VStack {
                    Image(uiImage: self.camera.image!).resizable() //.aspectRatio(CGSize(width: 1, height: 2), contentMode: .fit)
                    Button(action: {
                        self.camera.showCapture.toggle()
                    })
                    {
                        Text("Retake Photo")
                    }.buttonStyle(GreenButton()).padding()
                    
                    if self.camera.predictions.isEmpty {
                        Text("Loading...").padding()
                    }
                    else {
                        PredictionView(predictions: self.camera.predictions[0..<numDisplayed], trigger: self.$triggerConfetti, height: self.height)
                            .environmentObject(self.store)
                        .gesture(self.collapseGesture()).transition(.offset(
                            CGSize(width: 0, height: 1000)))
                    }
                }
                .padding(.top)
                .animation(.linear)
                .confetti(isTriggered: self.$triggerConfetti)
            }
        }
    }
    
    @State var triggerConfetti = false
    
    @State private var previousDragHeight: CGFloat = 0
    
    
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private func collapseGesture() -> some Gesture {
        DragGesture()
            .onEnded { finalDragGesture in
                withAnimation {
                    if self.previousDragHeight < finalDragGesture.translation.height {
                    self.numDisplayed = 1
                    self.height = 100
                } else {
                        self.numDisplayed = min(self.camera.predictions.count, 5)
                    self.height = 250
                }
                }
                self.previousDragHeight = finalDragGesture.translation.height
        }
    }
}

struct PredictionView: View {
    var predictions: ArraySlice<Food>
    @EnvironmentObject var store: FoodStore
    @State private var foodToAdd: String = ""
    @Binding var trigger: Bool

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
                    ForEach(self.predictions) { food in
                        HStack {
                            Text(food.name)
                            Spacer()
                            Button(action: {
                                if !self.store.foods.contains(food) {
                                    self.store.foods.append(food)
                                    withAnimation(.easeOut(duration: 0.3)){
                                        self.trigger = true
                                    }
                                    self.resetTrigger(afterTime: 0.3)
                                } else {
                                    self.store.foods.remove(at: self.store.foods.firstIndex(matching: food)!)
                                }
                                
                                
                            }) {
                                if self.store.foods.contains(food) {
                                    Image(systemName: "checkmark")
                                
                                } else {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                    }
                        TextField("New Food", text: $foodToAdd, onEditingChanged: {began in
                            if !began && self.foodToAdd != "" {
                                self.previewNewFood = true
                                
                            }
                        })
                }
            }
            .padding()
            .frame(height: frameHeight)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: self.edgeLineWidth)
                .foregroundColor(.secondary)
                .frame(height: frameHeight)
                .padding(.top)
                .padding(.bottom)
            
        }.alert(isPresented: self.$previewNewFood) {
            Alert(title: Text("Add \(self.foodToAdd)?"),
                  message: Text("Would you like to add \(self.foodToAdd) to your log?"),
                  primaryButton: .default(Text("Yes")) {
                    self.store.foods.append(Food(name: self.foodToAdd, date: Date()))
                                                 self.foodToAdd = ""
                    },
                  secondaryButton: .cancel()
                  )
        }
    }
    
    private func resetTrigger(afterTime delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//            withAnimation(.easeIn) {
                self.trigger = false
//            }
        }
    }
    
    @State private var previewNewFood = false
    @State private var confirmNewFood = false
    
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


