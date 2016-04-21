//
//  ViewController.swift
//  Checklists
//
//  Created by Roman Ustiantcev on 15/04/16.
//  Copyright © 2016 Roman Ustiantcev. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController, ItemDetailViewControllerDelegate {

    // MARK: var and let
    
    var items: [ChecklistItem]
    
    required init?(coder aDecoder: NSCoder){
        
        items = [ChecklistItem]()
        super.init(coder: aDecoder)
        loadChecklistItems()
        
        print("Document folder is \(documentsDirectory())")
        print("DataFile path is \(dataFilePath())")
    }
    
    // MARK : func's
    
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "✓"
        } else {
            label.text = ""
        }
    }
    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItem(){
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    
    }
    
    func loadChecklistItems(){
        // 1 - result of decoding into a temp constant
        let path = dataFilePath()
        
        // 2 - if they actually exist
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            // 3 - load everyting 
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                items = unarchiver.decodeObjectForKey("ChecklistItems") as! [ChecklistItem]
                
                unarchiver.finishDecoding()
            }
        }
    }
    
    
    @IBAction func addItem(sender: AnyObject) {
        
        let newRowIndex = items.count
        let item = ChecklistItem()
        item.text = "I am a new row"
        item.checked = false
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
    }
    
    // MARK : override's
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        
        let item = items[indexPath.row]

        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            let item = items[indexPath.row]
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        saveChecklistItem()
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        saveChecklistItem()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    
    // MARK : delegate func's
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem){
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
        saveChecklistItem()
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem){
        if let index = items.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        saveChecklistItem()
    }
    

}

