//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Roman Ustiantcev on 15/04/16.
//  Copyright © 2016 Roman Ustiantcev. All rights reserved.
//

import Foundation

class ChecklistItem {
    
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
    
}