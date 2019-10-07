//
//  RetrivedTextTableViewCell.swift
//  Quran
//
//  Created by Eyad Shokry on 6/7/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class RetrivedTextTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    func configureCell(text: String) {
        textView.text = text
    }
}
