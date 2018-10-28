//
//  ToDo.swift
//  ToDoList
//
//  Created by Md. Shahadet Hossain on 2018-10-26.
//  Copyright © 2018 Md. Shahadet Hossain. All rights reserved.
//

import UIKit

//Model Class to store tasks to do

class ToDo {
    
    //MARK: Initialization
    
    init? (title: String, photo: UIImage?, notes: String) {
        self.title = title
        self.photo = photo
        self.notes = notes
        //self.rating = rating
    }
    
    //MARK: Properties
    
    var title: String
    var photo: UIImage?
    var notes: String
    //var rating: Int
    
}
