//
//  TableViewController.swift
//  CoreSample
//
//  Created by yashn on 01/10/18.
//  Copyright © 2018 yashn. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var itemList = [Items]()
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    
    
    let filePath3 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        print(filePath3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = itemList[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark:.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        itemList[indexPath.row].done = !itemList[indexPath.row].done
        
       context.delete(itemList[indexPath.row])
    itemList.remove(at: indexPath.row)
        
        print(indexPath.row)
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemList[indexPath.row])
            itemList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    @IBAction func AddBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Name",message: "Add a new name",preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",style: .default) {
            [unowned self] action in
            let newItem = Items(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemList.append(newItem)
            self.saveItems()
        }
        alert.addTextField { (textFieldDelegate) in textField.placeholder = "Add new item"
            textField = textFieldDelegate
        }
        alert.addAction(saveAction)
        present(alert, animated: true)
        saveItems()
    }

    func saveItems() {
        do {
            try context.save()
            
        } catch {
            print("Could not save. \(error),")
        }
        self.tableView.reloadData()
        
    }

    func loadItems()
    {
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        do {
            itemList = try context.fetch(request)
        }
        catch{
            print("error fetching data from context")
        }
    }
    

    
 }
