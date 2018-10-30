//
//  ToDo.swift
//  ToDoList
//
//  Created by Md. Shahadet Hossain on 2018-10-26.
//  Copyright © 2018 Md. Shahadet Hossain. All rights reserved.
//

import UIKit
import os.log

//Model Class to store tasks to do

class ToDo: NSObject, NSCoding {

    //MARK: Properties
    
    var title: String
    var photo: UIImage?
    var dueDate: String
    var createdDate: String
    var priority: Priority
    var notes: String
    var done: Bool
    enum Priority: String {
        case high = "high"
        case medium = "medium"
        case low = "low"
    }
    
    //MARK: Types
    struct PropertyKey {
        static let title = "title"
        static let photo = "photo"
        static let dueDate = "dueDate"
        static let createdDate = "createdDate"
        static let priority = "priority"
        static let notes = "notes"
        static let done = "done"
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(dueDate, forKey: PropertyKey.dueDate)
        aCoder.encode(createdDate, forKey: PropertyKey.createdDate)
        aCoder.encode(priority.rawValue, forKey: PropertyKey.priority)
        aCoder.encode(notes, forKey: PropertyKey.notes)
        aCoder.encode(done, forKey: PropertyKey.done)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObject(forKey: "title") as? String {
            self.title = title
        } else {
            return nil
        }
        
        if let photo = aDecoder.decodeObject(forKey: "photo") as? UIImage {
            self.photo = photo
        } else {
            return nil
        }
        
        if let notes = aDecoder.decodeObject(forKey: "notes") as? String {
            self.notes = notes
        } else {
            return nil
        }
        
        if let createdDate = aDecoder.decodeObject(forKey: "createdDate") as? String {
            self.createdDate = createdDate
        } else {
            return nil
        }
        
        if let dueDate = aDecoder.decodeObject(forKey: "dueDate") as? String {
            self.dueDate = dueDate
        } else {
            return nil
        }
        
        self.priority = Priority(rawValue: (aDecoder.decodeObject( forKey: "priority" ) as! String)) ?? .medium
        
        if aDecoder.containsValue(forKey: "done") {
            self.done = aDecoder.decodeBool(forKey: "done")
        } else {
            return nil
        }
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("toDos")
    
    
    //MARK: Initialization
    
    init? (title: String, photo: UIImage?, notes: String, createdDate: String,dueDate: String, priority: Priority) {
        // The name must not be empty
        guard !title.isEmpty else {
            return nil
        }
        
        self.title = title
        self.photo = photo
        self.notes = notes
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.priority = priority
        self.done = false
    }
    
    

    
}
