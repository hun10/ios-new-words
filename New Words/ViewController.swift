//
//  ViewController.swift
//  New Words
//
//  Created by Dmitri Urbanowicz on 25/01/2017.
//  Copyright © 2017 Dmitri Urbanowicz. All rights reserved.
//

/*
 This view is a generic table view for static data, which consists of array of sections.
 Where each section has a title and an array of DetailedTextCell.
 DetailedTextCell is a structure of two strings: for main and details texts.
 
 Updating a view model reloads the table.
 
 Also the table provides two intents: Cell remove and Cell tapped.
 */

import UIKit

struct Section {
    let title: String
    let cells: [DetailedTextCell]
}

class DetailedTextCell {
    var main: String = ""
    var details: NSMutableAttributedString = NSMutableAttributedString()
    var id: Int = 0
}

class ViewController: UITableViewController, WordAdderDelegate {

    var model: [Section] = Model.modelView()
    var wordAdder: WordAdder?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wordAdder = WordAdder(delegate: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(showAdder)
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadViewModel),
            name: NSNotification.Name(rawValue: "updateView"),
            object: nil
        )
    }
    
    func showAdder() {
        wordAdder?.present(sender: self)
    }
    
    func loadViewModel() {
        model = Model.modelView()
        tableView?.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model[section].title
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return model[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailedTextCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "detailedTextCell")
        
        let detailedTextCell = model[indexPath.section].cells[indexPath.row]
        cell.textLabel?.text = detailedTextCell.main
        cell.detailTextLabel?.attributedText = detailedTextCell.details
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            Model.delete(index: model[indexPath.section].cells[indexPath.row].id)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDef(model[indexPath.section].cells[indexPath.row].main)
    }
    
    func showDef(_ word: String) {
        let ref = UIReferenceLibraryViewController(term: word)
        present(ref, animated: true)
    }
    
    func newWord(_ word: String) {
        Model.add(word: word, date: Date())
        showDef(word)
    }
}
