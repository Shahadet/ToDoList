//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Md. Shahadet Hossain on 2018-10-28.
//  Copyright © 2018 Md. Shahadet Hossain. All rights reserved.
//

import UIKit
import os.log

//controller class to control Table View

class ToDoTableViewController: UITableViewController {

    //MARK: Properties
    var toDoList = ToDoList()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample toDo.
        loadSampleToDos()
        
    }

   
    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.toDos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ToDoTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ToDoTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let toDo = toDoList.toDos[indexPath.row]
        
        cell.titleLabel.text = toDo.title
        cell.photoImageView.image = toDo.photo
        
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let toDoDetailViewController = segue.destination as? ToDoViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedToDOCell = sender as? ToDoTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "unknown")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedToDOCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedToDo = toDoList.toDos[indexPath.row]
            toDoDetailViewController.toDo = selectedToDo
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "unknown")")
        }
    }

    //MARK: Action
    @IBAction func unwindToToDoList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ToDoViewController, let toDo = sourceViewController.toDo {
            
            //check if a user tapped one of the table views cells to edit a meal.
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                toDoList.toDos[selectedIndexPath.row] = toDo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: toDoList.toDos.count, section: 0)
                
                toDoList.toDos.append(toDo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the toDos.
            saveToDos()
        }
    }
    
    
    //MARK: Private Methods
    
    private func loadSampleToDos() {
        let photo1 = UIImage(named: "todo1")
        let photo2 = UIImage(named: "todo2")
        let photo3 = UIImage(named: "todo3")
        
        guard let todo1 = ToDo(title: "First task to do", photo: photo1, notes : "I Have do this task as soon as possible") else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let todo2 = ToDo(title: "Second Task To Do", photo: photo2, notes: "I Have do this task later") else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let todo3 = ToDo(title: "Last task to do", photo: photo3, notes: "I have to do this at last") else {
            fatalError("Unable to instantiate meal2")
        }
        
        toDoList.toDos += [todo1, todo2, todo3]
    }
    
    private func saveToDos() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(toDoList.toDos, toFile: ToDo.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("ToDos successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save ToDos...", log: OSLog.default, type: .error)
        }
    }
}
