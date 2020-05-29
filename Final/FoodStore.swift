//
//  FoodStore.swift
//  Final
//
//  Created by Christian Gabor on 5/28/20.
//  Copyright © 2020 Christian Gabor. All rights reserved.
//

import Foundation
import Combine

class FoodStore: ObservableObject {
    let name: String
    
    @Published var foods = [Food]()
    
    private var autosave: AnyCancellable?
    
    
    init(named name: String = "Foods") {
        self.name = name
        let defaultsKey = "FoodStore.(name)"
        let savedFoods = UserDefaults.standard.array(forKey: defaultsKey) as? [String] ?? [String]()
        
        for i in 0..<savedFoods.count {
            let json = savedFoods[i].data(using: .utf8)
            if let savedFood = Food(json: json) {
                foods.append(savedFood)
            }
        }
        
        autosave = $foods.sink { food in
            let json = food.map { food in food.json!.utf8 }
            UserDefaults.standard.set(json, forKey: defaultsKey)
        }
        
        
    }
}


struct Food: Identifiable, Codable, Hashable {
    
    var name: String
    var date: Date
    let id: UUID
    
    static func == (lhs: Food, rhs: Food) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(name: String, date: Date, id: UUID? = nil) {
        self.name = name
        self.date = date
        self.id = id ?? UUID()
    }
    
    init?(json: Data?) {
        if json != nil, let newFood = try? JSONDecoder().decode(Food.self, from: json!) {
            self = newFood
        } else {
            return nil
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
}

extension Data {
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}

extension Array where Element == String {
    func concat(first number: Int) -> String {
        var result: String = ""
        for i in 0..<number {
            if i < self.count {
                result = result + self[i]
            }
        }
        return result
    }
}
