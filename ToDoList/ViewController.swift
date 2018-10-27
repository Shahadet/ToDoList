//
//  ViewController.swift
//  ToDoList
//
//  Created by Md. Shahadet Hossain on 2018-10-19.
//  Copyright © 2018 Md. Shahadet Hossain. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
}

