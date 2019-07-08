//
//  NewsTableCell.swift
//  NewsApp
//
//  Created by Mukesh Gami on 08/07/19.
//  Copyright © 2019 Mukesh Gami. All rights reserved.
//

import UIKit

class NewsTableCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
