//
//  AllListsTableViewController.swift
//  Checklists
//
//  Created by Roman Ustiantcev on 21/04/16.
//  Copyright © 2016 Roman Ustiantcev. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController {
    
    // MARK : - instances
    
    var lists: [Checklist]
    
    required init?(coder aDecoder: NSCoder) {
        lists = [Checklist]()
        super.init(coder: aDecoder)
        
        var list = Checklist.init(name: "Birthdays" )
        lists.append(list)
        
        list = Checklist.init(name: "Groceries")
        lists.append(list)
        
        list = Checklist.init(name: "Cool Apps")
        lists.append(list)
        
        list = Checklist.init(name: "To Do")
        lists.append(list)
    }
    
    
    func cellForTableView(tableView: UITableView) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = cellForTableView(tableView)
        
        let checkList = lists[indexPath.row]
        cell.textLabel?.text = checkList.name
        cell.accessoryType = .DetailDisclosureButton
    
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destinationViewController as! CheckListViewController
            controller.checklist = sender as! Checklist
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let checklist = lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
        
    }
    
}
