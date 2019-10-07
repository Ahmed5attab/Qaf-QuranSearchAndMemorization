//
//  AyaTableViewCell.swift
//  Quran
//
//  Created by Eyad Shokry on 2/14/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class AyaTableViewCell: UITableViewCell {
    @IBOutlet weak var chapterNumberLabel: UILabel!
    @IBOutlet weak var suraNameLabel: UILabel!
    @IBOutlet weak var ayaTextView: UITextView!
    
    func configureCellWith(chapterNumber: String, suraName: String, ayaText: String) {
        chapterNumberLabel.text = chapterNumber
        suraNameLabel.text = suraName
        ayaTextView.text = ayaText
    }
}
