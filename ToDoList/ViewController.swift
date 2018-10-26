//
//  ViewController.swift
//  ToDoList
//
//  Created by Md. Shahadet Hossain on 2018-10-19.
//  Copyright © 2018 Md. Shahadet Hossain. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func chooseImage(_ sender: Any) {
         //UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imageTakingController = UIImagePickerController()

        //check if the device has a camera or not
        if !UIImagePickerController.isSourceTypeAvailable(.camera){

            let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)

            let okAction = UIAlertAction.init(title: "Alright", style: .default, handler: {(alert: UIAlertAction!) in
            })

            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

            imageTakingController.sourceType = .photoLibrary


        }
        else{
            imageTakingController.sourceType = .camera

            imageTakingController.delegate = self
            present(imageTakingController, animated: true, completion: nil)

            print("SH:: Test")
        }
    }
}

