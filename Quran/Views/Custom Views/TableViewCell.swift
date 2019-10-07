//
//  TableViewCell.swift
//  Quran
//
//  Created by Ahmed KKhattab on 4/3/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var suraName: UILabel!
    @IBOutlet weak var chapterNumber: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
    }
}
