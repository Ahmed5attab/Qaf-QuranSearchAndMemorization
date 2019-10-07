//
//  SurasTableViewController.swift
//  Quran
//
//  Created by Ahmed khattab on 1/24/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class SurasTableViewController: UITableViewController,UISearchBarDelegate {
    
    
    @IBOutlet var suarTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var surasNamesArray = [String]()
    var numberOfVersesArray = [Int]()
    var surasTypeArray = [Int]()
    var surasChapterArray = [String]()
    var versesNumber = 0
    var versesArray = [Int]()
    var suraName = ""
    var isSearching = false
    var searchingResult = [[String]]()
    
    func getSurasFromJSON(fileName: String) {
        let pathForJsonFile = Bundle.main.path(forResource: fileName, ofType: "json")
        let rawData = try? Data(contentsOf: URL(fileURLWithPath: pathForJsonFile!))
        let parsedJSONData = try! JSONSerialization.jsonObject(with: rawData!) as! [String : Any]
        for sura in parsedJSONData["SuraData"] as! [Dictionary<String , Any>]  {
            self.surasNamesArray.append(sura["SuraName"] as! String)
            self.numberOfVersesArray.append(sura["NumberofVerses"] as! Int)
            self.surasTypeArray.append(sura["Type"] as! Int)
            self.surasChapterArray.append(sura["Chapter"] as! String)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableCell = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(tableCell, forCellReuseIdentifier: "cell")
    
        let searchingCell = UINib(nibName: "SearchViewCell", bundle: nil)
        self.tableView.register(searchingCell, forCellReuseIdentifier: "SearchCell")
        
        getSurasFromJSON(fileName: "suraNames")
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if( searchBar.text == nil || searchBar.text == "" )
        {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else
        {
            isSearching = true
            // caling the search func
            searchingResult = SearchForWord(Word: searchBar.text!)
            tableView.reloadData()
        }
    }
}


extension SurasTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return searchingResult.count
        }
        return surasNamesArray.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearching{
            return UITableViewAutomaticDimension
        }
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Creating the table cells
        
        if isSearching
        {
            let searchingCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchViewCell
            searchingCell.searchSuraName.text =  searchingResult[indexPath.row][4]
            searchingCell.chapter.text = "الجزء رقم"
            searchingCell.CN.text = searchingResult[indexPath.row][0]
            searchingCell.searchVerse.text = "\(searchingResult[indexPath.row][6]) {\(searchingResult[indexPath.row][2])}"
            return searchingCell
            
        }
        else{
            let  tableCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            tableCell.suraName.text = surasNamesArray[indexPath.row]
            tableCell.chapterNumber.text = surasChapterArray[indexPath.row]
            let test = surasTypeArray[indexPath.row] as Int
            if test == 0
            {tableCell.typeImage.image = #imageLiteral(resourceName: "kaaba")}
            else
            {tableCell.typeImage.image = #imageLiteral(resourceName: "madina")}
            return tableCell
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSearching
        {
            self.suraName = surasNamesArray[indexPath.row]
            self.versesNumber = numberOfVersesArray[indexPath.row]
            for i in (1...versesNumber)
            {
                versesArray.append(i)
            }
            
            inistansiatePickerViewController()
        }
    }

}


extension SurasTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return versesNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(versesArray[row])
    }
    
    func inistansiatePickerViewController() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 250)
        
        let alert = UIAlertController(title: "Select Verses", message: "From \t To\n\n", preferredStyle: UIAlertControllerStyle.alert)
        alert.isModalInPopover = true
        alert.setValue(vc, forKey: "contentViewController")
        let pickerFrame = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerFrame.delegate = self
        alert.view.addSubview(pickerFrame)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //Perform Action
            let from = Int(pickerFrame.selectedRow(inComponent: 0))+1
            let to = Int(pickerFrame.selectedRow(inComponent: 1))+1
            if(from > to)
            {
                let alert = UIAlertController(title: "Wrong Input", message: "'From' value must be less than or equal to 'To' value", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let quranReadingVC = self.storyboard?.instantiateViewController(withIdentifier: "QuranReading") as? QuranReadingViewController
                quranReadingVC?.selectedVerses = self.GetVerses(SoraName: self.suraName, start: from, end: to , flag: 1)
                quranReadingVC?.suraName = self.suraName
                quranReadingVC?.from = from
                quranReadingVC?.to = to
                quranReadingVC?.ChapterID = self.GetChapterId(SoraName: self.suraName, start: from, end: to)
                quranReadingVC?.selectedVersesWithoutTashkel = self.GetVerses(SoraName: self.suraName, start: from, end: to, flag: 0)
                self.navigationController?.pushViewController(quranReadingVC!, animated: true)
            }
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
}

