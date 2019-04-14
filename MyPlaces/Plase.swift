//
//  Plase.swift
//  MyPlaces
//
//  Created by Vasiliy Oschepkov on 14/04/2019.
//  Copyright © 2019 Vasiliy Oschepkov. All rights reserved.
//

import Foundation

struct Plase {
    var name: String
    var location: String
    var type: String
    var image: String
    
    static let restauransNames = ["Балкан Гриль", "Бочка", "Вкусные истории", "Дастархан", "Индокитай", "Классик", "Шок", "Bonsai", "Burger Heroes", "Kitchen", "Love&Life", "Morris Pub", "Sherlock Holmes", "Speak Easy", "X.O"]
    
    static func getPlaces() -> [Plase] {
        var places = [Plase]()
        for name in restauransNames {
            places.append(Plase(name: name, location: "Москва", type: "Ресторан", image: name))
        }
        
        return places
    }
}
