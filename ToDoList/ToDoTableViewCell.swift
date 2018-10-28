//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by Md. Shahadet Hossain on 2018-10-20.
//  Copyright © 2018 Md. Shahadet Hossain. All rights reserved.
//

import UIKit

//View Class

class ToDoTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
