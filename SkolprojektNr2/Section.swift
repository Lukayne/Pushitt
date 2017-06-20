//
//  Section.swift
//  SkolprojektNr2
//
//  Created by Richard Smith on 2017-06-21.
//  Copyright © 2017 Richard Smith. All rights reserved.
//

import Foundation

struct Section {
    var type: String!
    var messages: [String]!
    var expanded: Bool!
    
    init(type: String, messages: [String], expanded: Bool) {
        self.type = type
        self.messages = messages
        self.expanded = expanded
    }
}
