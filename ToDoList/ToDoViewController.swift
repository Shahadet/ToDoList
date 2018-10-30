//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Md. Shahadet Hossain on 2018-10-19.
//  Copyright © 2018 Md. Shahadet Hossain. All rights reserved.
//

import UIKit
import os.log

class ToDoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var titleToDo: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inputDatePickerDueDate: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var priorityControl: UISegmentedControl!
    
    let datePicker = UIDatePicker()
    /*     This value is either passed by `ToDOTableViewController` in `prepare(for:sender:)` or constructed as part of adding a new meal.    */
    var toDo: ToDo?
    var lastSavedPriority: String
    
    @IBAction func setPriority(_ sender: Any) {
        
        switch priorityControl.selectedSegmentIndex
        {
        case 0:
            lastSavedPriority = "High";
        case 1:
            lastSavedPriority = "Low";
        case 2:
            lastSavedPriority = "Medium";
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Handle the text field’s user input through delegate callbacks.
        titleToDo.delegate = self
        
        // Set up views if editing an existing Meal.
        if let toDo = toDo {
            navigationItem.title = toDo.title
            titleToDo.text   = toDo.title
            imageView.image = toDo.photo
            inputDatePickerDueDate.text = toDo.notes
        }

        //************* Date Picker ************
        //To support to close the editor if tapped on the application blanksapce
        let tagGesture = UITapGestureRecognizer(target: self, action: #selector(ToDoViewController.viewTapped(gestureRecognized:)))
        view.addGestureRecognizer(tagGesture)
        
        //set datepicker
        datePicker.datePickerMode = .dateAndTime
        
        //Create a toolbar for dateicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDateChanged))
        toolbar.setItems([doneButton], animated: true)
        
        inputDatePickerDueDate.inputView = datePicker
        inputDatePickerDueDate.inputAccessoryView = toolbar
        
        // Enable the Save button only if the text field has a valid ToDo name.
        updateSaveButtonState()
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let title = titleToDo.text ?? ""
        let photo = imageView.image
        let inputDate = inputDatePickerDueDate.text ?? ""
        
        //if priority == ToDo.Priority.high {
            //cell.priorityImage.backgroundColor = UIColor.red
        //} else if priority == ToDo.Priority.medium {
            //cell.priorityImage.backgroundColor = UIColor.gray
        //} else {
            //cell.priorityImage.backgroundColor = UIColor.green
        //}
        
        // Set the toDo to be passed to ToDOTableViewController after the unwind segue.

        var priority:ToDo.Priority
//        if lastSavedPriority == ToDo.Priority.high{
//            priority = 
//        }
        toDo = ToDo(title: title, photo: photo, notes: "Will Take later \(inputDate)", createdDate:"",dueDate:"",priority:priority)
        
    }
    
    
    
    //MARK: Action
    
    @objc func viewTapped(gestureRecognized: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func doneDateChanged(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy hh:mm aa"
        inputDatePickerDueDate.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        //UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imageTakingController = UIImagePickerController()
        imageTakingController.delegate = self
        //Give the user option to choose the source of the photo
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imageTakingController.sourceType = .camera
            
            //check if the device has a camera or not and if no camerais there, show an alert message
            if !UIImagePickerController.isSourceTypeAvailable(.camera){
                let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "Alright", style: .default, handler: {(alert: UIAlertAction!) in })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                imageTakingController.sourceType = .photoLibrary
            }
            else{
                self.present(imageTakingController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imageTakingController.sourceType = .photoLibrary
            self.present(imageTakingController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image=image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    //this method is called after the text field resigns its first-responder status, in the above method
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = titleToDo.text ?? ""
        
        saveButton.isEnabled = !text.isEmpty
    }
}

