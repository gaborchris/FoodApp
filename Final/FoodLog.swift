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
    let dateFormatter = DateFormatter()
    @State private var editMode: EditMode = .inactive
    @ObservedObject var store: FoodStore
    static let appThemeColor = UIColor(red: 0.1, green: 0.7, blue: 0.1, alpha: 1.0)
    var camera = CameraViewModel()
    

    
    var body: some View {

        UINavigationBar.appearance().backgroundColor = .clear
        dateFormatter.dateFormat = "HH:mm E, d MMM y"

        return NavigationView {
            VStack{
                List {
                    ForEach(store.foods) { food in
                        HStack {
                            Text("\(food.name)").font(.body)
                            Spacer()
                            Text(self.dateFormatter.string(from: food.date))
                        }
                    }.onDelete{ index in
                        // Todo remove food item
                        print("Removing item")}
                }
                
            }
            .navigationBarTitle("Food Log", displayMode: .inline)
            .navigationBarItems(
            leading: EditButton(),
            trailing:
                NavigationLink(destination:
                    CameraView(camera: camera, store: store).navigationBarTitle("Capture Food"))
                    {
                        Image(systemName: "camera").imageScale(.large)
                    }
//                    camera.imageCapture.navigationBarTitle("Capture Food"))
//                {
//                    Image(systemName: "camera").imageScale(.large)
//                }
            ).environment(\.editMode, $editMode)
        }
    }
}


//
//struct FoodLog_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodLog()
//    }
//}
