//
//  DataModel.swift
//  Checklists
//
//  Created by Roman Ustiantcev on 26/04/16.
//  Copyright © 2016 Roman Ustiantcev. All rights reserved.
//

import Foundation

class DataModel {

    var lists = [Checklist]()
    
    init(){
        loadChecklists()
        registerDefaults()
    }
    
    func registerDefaults(){
        let dictionary = ["ChecklistIndex": -1]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    
    // MARK: - func's and directories for saving files
    func documentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentDirectory() as NSString).stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveChecklist(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists(){
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
                unarchiver.finishDecoding()
            }
        }
    }
    
}