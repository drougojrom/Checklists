//
//  AddedItemViewController.swift
//  Checklists
//
//  Created by Roman Ustiantcev on 15/04/16.
//  Copyright © 2016 Roman Ustiantcev. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    // var and let
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    var dueDate = NSDate()
    var datePickerVisible = false
    
    // MARK: Outlets
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK : @IBActions
    
    @IBAction func dateChanged(datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        delegate?.itemDetailViewControllerDidCancel(self)
    }

    @IBAction func done(sender: UIBarButtonItem) {
        
        if let item = itemToEdit {
            item.text = textFiled.text!
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        } else {
        
            let item = ChecklistItem()
            item.text = textFiled.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
            
        }
    }
    
    @IBAction func shouldRemindToggled(switchControl: UISwitch) {
        textFiled.resignFirstResponder()
        
        if switchControl.on {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        textFiled.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textFiled.text = item.text
            doneBarButton.enabled = true
            shouldRemindSwitch.on = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }

    // MARK : override
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        textFiled.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible{
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    // MARK: func's
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textFiled.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }
    
    func showDatePicker(){
        datePickerVisible = true
        
        let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        
        if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    func hideDatePicker(){
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
    }
    
    
}
