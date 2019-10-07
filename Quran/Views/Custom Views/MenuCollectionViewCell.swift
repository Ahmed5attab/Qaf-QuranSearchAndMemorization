//
//  MenuCollectionViewCell.swift
//  Quran
//
//  Created by Eyad Shokry on 6/3/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.alpha = 0.6
        titleLabel.textColor = .brown
    }
    
    func setupCell(text: String) {
        titleLabel.text = text
    }
    
    override var isSelected: Bool {
        didSet{
            titleLabel.alpha = isSelected ? 1.0 : 0.6
        }
    }
}
