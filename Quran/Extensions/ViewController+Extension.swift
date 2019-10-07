//
//  ViewController+Extension.swift
//  Quran
//
//  Created by Eyad Shokry on 3/31/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertController(withTitle: String, withMessage: String, action: (() -> Void)? = nil) {
        performUIUpdatesOnMain {
            let alertController = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(alertController, animated: true)
        }
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!
    {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func cleanRows(file:String)->String
    {
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }
    func csv(data: String) -> [[String]]
    {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    func Newcsv(data: String) -> [String]
    {
        let rows = data.components(separatedBy: "\n")
        return rows
    }
    
    //flag = 0 ( mn 8yr t4kyl 34an Ltsmy3 )
    //flag = 1 ( b Lt4kyl 34an Lqraya )
    func GetVerses(SoraName: String , start: Int , end: Int , flag: Int) -> String
    {
        var data = readDataFromCSV(fileName: "newcsv(small)" , fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        var Info = [Int]()
        //for index in 1...114
        for index in 1...114
        {
            if(csvRows[index][1] == SoraName)
            {
                Info.append(Int(csvRows[index][0])!)//SoraID
                Info.append(Int(csvRows[index][2])!)//Number Of Verses per Sora
                Info.append(Int(csvRows[index][3])!)//With BigDataSet
                break
            }
        }
        var data2 = readDataFromCSV(fileName: "BigDataSet(small)" , fileType: "csv")
        data2 = cleanRows(file: data2!)
        let Rows = Newcsv(data: data2!)
        var result: [[String]] = []
        for index in Info[2]...(Info[2]+Info[1])
        {
            let columns = Rows[index].components(separatedBy: ",")
            result.append(columns)
        }
        
        var EntireVerses = ""
        if(flag == 0)
        {
            for index in 0...(result.count-1)//Checkit
            {
                if(Int(result[index][2])! == start || Int(result[index][2])! > start && Int(result[index][2])! < end || Int(result[index][2])! == end)
                {
                    EntireVerses = EntireVerses + result[index][3] + " "
                }
                if(Int(result[index][2])! == end)
                {
                    break
                }
            }
        }
        else
        {
            for index in 0...(result.count-1)//Checkit
            {
                if(Int(result[index][2])! == start || Int(result[index][2])! > start && Int(result[index][2])! < end || Int(result[index][2])! == end)
                {
                    EntireVerses = EntireVerses + result[index][6] + "{\(result[index][2])}"
                }
                if(Int(result[index][2])! == end)
                {
                    break
                }
            }
        }
        
        return EntireVerses
    }
    
    func GetChapterId(SoraName: String , start: Int , end: Int) -> String
    {
        var data = readDataFromCSV(fileName: "newcsv(small)" , fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        var Info = [Int]()
        //for index in 1...114
        for index in 1...114
        {
            if(csvRows[index][1] == SoraName)
            {
                Info.append(Int(csvRows[index][0])!)//SoraID
                Info.append(Int(csvRows[index][2])!)//Number Of Verses per Sora
                Info.append(Int(csvRows[index][3])!)//With BigDataSet
                break
            }
        }
        var data2 = readDataFromCSV(fileName: "BigDataSet(small)" , fileType: "csv")
        data2 = cleanRows(file: data2!)
        let Rows = Newcsv(data: data2!)
        var result: [[String]] = []
        for index in Info[2]...(Info[2]+Info[1])
        {
            let columns = Rows[index].components(separatedBy: ",")
            result.append(columns)
        }
        
        return result[0][0]
        
    }
    
    func SearchForWord(Word: String ) -> [[String]]
    {
        
        var data = readDataFromCSV(fileName: "BigDataSet(small)" , fileType: "csv")
        data = cleanRows(file: data!)
        let rows = Newcsv(data: data!)
        var result: [[String]] = []
        for index in 1...(rows.count-1)//Checkit
        {
            if(rows[index].contains(Word))
            {
                let columns = rows[index].components(separatedBy: ",")
                result.append(columns)
            }
        }
        
        return result
        
    }
    
    
    func RetrieveVerses(Name: String ,Type: String , SoraName: String, start: Int , end: Int) -> String
    {
        var data = readDataFromCSV(fileName: Name, fileType: Type)
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        var EntireVerses = ""
        let SoraID = GetSoraID(SoraName: SoraName)
        for index in 1...6236
        {
            if(Int(csvRows[index][1]) == SoraID)
            {
                if(Int(csvRows[index][2])! == start || Int(csvRows[index][2])! > start && Int(csvRows[index][2])! < end || Int(csvRows[index][2])! == end)
                {
                    EntireVerses = EntireVerses + csvRows[index][6] + " "
                }
                if(Int(csvRows[index][2])! == end)
                {
                    break
                }
            }
        }
        return EntireVerses
    }
    
    func GetSoraID(SoraName: String) -> Int
    {
        var data = readDataFromCSV(fileName: "newcsv(small)" , fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        var SoraID = 0
        for index in 1...114
        {
            if(csvRows[index][1] == SoraName)
            {
                SoraID = Int(csvRows[index][0])!
                break
            }
        }
        return SoraID
    }
    
    
    func longestCommonSubsequence(_ other: [String] , sec : [String]) -> [String] {
        
        // Computes the length of the lcs using dynamic programming.
        // Output is a matrix of size (n+1)x(m+1), where matrix[x][y] is the length
        // of lcs between substring (0, x-1) of self and substring (0, y-1) of other.
        func lcsLength(_ other: [String]) -> [[Int]] {
            
            // Create matrix of size (n+1)x(m+1). The algorithm needs first row and
            // first column to be filled with 0.
            var matrix = [[Int]](repeating: [Int](repeating: 0, count: other.count+1), count: sec.count+1)
            
            for (i, selfChar) in sec.enumerated() {
                for (j, otherChar) in other.enumerated() {
                    if (otherChar == selfChar) {
                        // Common char found, add 1 to highest lcs found so far.
                        matrix[i+1][j+1] = matrix[i][j] + 1
                    } else {
                        // Not a match, propagates highest lcs length found so far.
                        matrix[i+1][j+1] = max(matrix[i][j+1], matrix[i+1][j])
                    }
                }
            }
            
            // Due to propagation, lcs length is at matrix[n][m].
            return matrix
        }
        
        // Backtracks from matrix[n][m] to matrix[1][1] looking for chars that are
        // common to both strings.
        func backtrack(_ matrix: [[Int]]) -> [String] {
            var i = sec.count
            var j = other.count
            
            // charInSequence is in sync with i so we can get self[i]
            var charInSequence = sec.endIndex
            
            var lcs = String()
            
            while i >= 1 && j >= 1 {
                // Indicates propagation without change: no new char was added to lcs.
                if matrix[i][j] == matrix[i][j - 1] {
                    j -= 1
                }
                    // Indicates propagation without change: no new char was added to lcs.
                else if matrix[i][j] == matrix[i - 1][j] {
                    i -= 1
                    // As i was decremented, move back charInSequence.
                    charInSequence = sec.index(before: charInSequence)
                }
                    // Value on the left and above are different than current cell.
                    // This means 1 was added to lcs length (line 17).
                else {
                    i -= 1
                    j -= 1
                    charInSequence = sec.index(before: charInSequence)
                    
                    lcs.append(sec[charInSequence])
                    lcs.append(" ")
                    
                    
                }
            }
            let li = lcs.components(separatedBy: " ")
            let  result = li.reversed()
            
            
            // Due to backtrack, chars were added in reverse order: reverse it back.
            // Append and reverse is faster than inserting at index 0.
            return result.filter { $0 != "" }
        }
        
        // Combine dynamic programming approach with backtrack to find the lcs.
        return backtrack(lcsLength(other))
    }

}
