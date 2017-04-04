//
//  Model.swift
//  New Words
//
//  Created by Dmitri Urbanowicz on 29/01/2017.
//  Copyright © 2017 Dmitri Urbanowicz. All rights reserved.
//

/*
 Model is stored in UserDefaults as an array "words".
 Each item is a dictionary with keys "word" and "date",
 which store string and date correspondingly.
 An array stores items in descending order of addition.
 
 Model reacts to two types of update:
 1. New word (String, Date)
 2. Delete word at index
 */

import Foundation

class Model {
    
    static let timeFormat = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()
    
    static let relativeDateFormat = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        return formatter
    }()
    
    static func words() -> [[String : Any]] {
        return UserDefaults.standard.array(forKey: "words") as? [[String : Any]] ?? []
    }
    
    static func modelView() -> [Section] {
        var view: [Section] = []
        
        var currentSectionTitle = ""
        var currentSection: [DetailedTextCell] = []
        var index = 0
        for item in words() {
            let date = item["date"] as! Date
            let itemDate = relativeDateFormat.string(from: date)
            if (currentSectionTitle != itemDate) {
                if (currentSection.count > 0) {
                    view.append(Section(title: currentSectionTitle, cells: currentSection))
                }
                currentSectionTitle = itemDate
                currentSection = []
            }
            currentSection.append(DetailedTextCell(
                main: item["word"] as! String,
                details: timeFormat.string(from: date),
                id: index
            ))
            index += 1
        }
        if (currentSection.count > 0) {
            view.append(Section(title: currentSectionTitle, cells: currentSection))
        }
        
        return view
    }
    
    static func save(_ list: [[String : Any]]) {
        UserDefaults.standard.set(list, forKey: "words")
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "updateView"),
            object: nil
        )
    }
    
    static func add(word: String, date: Date) {
        var list = words()
        list.insert(["word" : word, "date" : date], at: 0)
        save(list)
    }
    
    static func delete(index: Int) {
        var list = words()
        list.remove(at: index)
        save(list)
    }
}
