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
    
    // MARK: Outlets
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textFiled: UITextField!
    
    // MARK : @IBActions
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        delegate?.itemDetailViewControllerDidCancel(self)
    }

    @IBAction func done(sender: UIBarButtonItem) {
        
        if let item = itemToEdit {
            item.text = textFiled.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        } else {
        
        let item = ChecklistItem()
        item.text = textFiled.text!
        item.checked = false
        delegate?.itemDetailViewController(self, didFinishAddingItem: item)
            
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
        }
    }

    // MARK : override
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        return nil
    }
    
    // MARK: func's
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textFiled.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    
}
