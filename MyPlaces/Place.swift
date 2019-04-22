//
//  Plase.swift
//  MyPlaces
//
//  Created by Vasiliy Oschepkov on 14/04/2019.
//  Copyright © 2019 Vasiliy Oschepkov. All rights reserved.
//


import RealmSwift

class Place: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var image: Data?
    @objc dynamic var date = Date()
    
    convenience init(name: String, location: String?, type: String?, image: Data?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.image = image
        
    }
}
