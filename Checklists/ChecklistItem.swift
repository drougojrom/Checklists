//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Roman Ustiantcev on 15/04/16.
//  Copyright © 2016 Roman Ustiantcev. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}