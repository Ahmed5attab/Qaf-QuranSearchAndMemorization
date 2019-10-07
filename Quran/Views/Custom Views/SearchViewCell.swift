//
//  SearchViewCell.swift
//  Quran
//
//  Created by Ahmed KKhattab on 4/12/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    @IBOutlet weak var chapter: UILabel!
    @IBOutlet weak var CN: UILabel!
    @IBOutlet weak var searchVerse: UITextView!
    @IBOutlet weak var searchSuraName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

