//
//  QuranResultViewController.swift
//  Quran
//
//  Created by Ahmed KKhattab on 4/30/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class QuranResultViewController: UIViewController {
    
    @IBOutlet weak var suraNameLabel: UILabel!
    @IBOutlet weak var chapterNumberLabel: UILabel!
    @IBOutlet weak var SuraVersesTextView: UITextView!
    
    var suraName = ""
    var ChapterID: String?
    var Verses: [String] = []
    var RecitationVerses: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suraNameLabel.text = suraName
        chapterNumberLabel.text = " الجزء (\(ChapterID!))"
        if(self.RecitationVerses.count == 0)
        {
            self.RecitationVerses = ["IsEmpty"]
        }
        let result = Result(Quran: self.Verses,Recitation: self.RecitationVerses)
        SuraVersesTextView.text = "\(result)"
        let encoding = result.data(using: String.Encoding.utf16)!
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html]
        do {
            let string = try! NSAttributedString(data: encoding,options:options,documentAttributes:nil)
            SuraVersesTextView.attributedText = string
        }
        // Do any additional setup after loading the view.
    }
    
    func Result(Quran: [String],Recitation:[String])-> String{
        var review = "<div style=\"text-align:right\"><font size=30>"
        var count = -1
        var count2 = 0
        var compare = ""
        for test in Recitation
        {
            compare = test
            count2 += 1
            while(count + 1 < Quran.count)
            {
                count += 1
                if (compare == Quran[count])
                {
                    review += "<font color = green>\(Quran[count]) </font>"
                    if (count2 < Recitation.count)
                    {
                        break
                    }
                    compare = "done"
                    
                }
                else
                {
                    review += "<font color = red>\(Quran[count]) </font>"
                }
            }
        }
        review += "</font></div>"
        return review
    }
    
}

