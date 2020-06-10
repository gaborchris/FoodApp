//
//  FoodLog.swift
//  Final
//
//  Created by Christian Gabor on 5/28/20.
//  Copyright © 2020 Christian Gabor. All rights reserved.
//

import SwiftUI
import UIKit

struct FoodLog: View {
    
    @State private var editMode: EditMode = .inactive
    @EnvironmentObject var store: FoodStore
    static let appThemeColor = UIColor(red: 0.1, green: 0.7, blue: 0.1, alpha: 1.0)
    var camera = CameraViewModel()

    var body: some View {

        UINavigationBar.appearance().backgroundColor = .clear
        

        return NavigationView {
            VStack{
                NavigationLink(destination: CameraView(camera: camera)
                    .navigationBarTitle("Capture Food")
                    .environmentObject(self.store))
                {
                    HStack {
                        Text("New Food")
                        Image(systemName: "camera").imageScale(.large)
                            .wobble()
                    }
                    .padding()
                    .background(Color.green)
                    .border(Color.green, width: 4)
                    .cornerRadius(10)
                    .padding()
                    .foregroundColor(Color.primary)
                }
                
                Log().environmentObject(self.store)
            }
            .navigationBarTitle("My Food Diary", displayMode: .inline)
            .navigationBarItems(
                
                leading: Burger().stroke().foregroundColor(Color.yellow).frame(minWidth: 20 , minHeight: 20),
            trailing: EditButton()
            ).environment(\.editMode, $editMode)
        }
    }
    

}

struct Log: View {
    
    @EnvironmentObject var store: FoodStore
    let dateFormatter = DateFormatter()
    
    var body: some View {
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        return List {
             ForEach(store.foods) { food in
                 HStack {
                     Text("\(food.name)").font(.body)
                     Spacer()
                     Text(self.dateFormatter.string(from: food.date))
                 }
             }.onDelete{ index in
                 index.map { self.store.foods[$0]}.forEach { food in
                     self.store.foods.remove(at: self.store.foods.firstIndex(matching: food)!)
                 }
            }
        }
    }
}

