//
//  WordAdder.swift
//  New Words
//
//  Created by Dmitri Urbanowicz on 29/01/2017.
//  Copyright © 2017 Dmitri Urbanowicz. All rights reserved.
//

import UIKit

/*
 WordAdder delegate is a receiver of new words.
 Its responsibility is to make entered word into the word list.
 */
protocol WordAdderDelegate {
    func newWord(_ word: String)
}

/*
 WordAdder incapsulates an alert with text field to enter new word.
 It exposes a method to show the alert.
 Alert has two buttons: Cancel and Add.
 Add is disabled iff text field is empty.
 Both buttons make the alert disappear, but Add makes a delegate call.
 */
class WordAdder {
    let alert = UIAlertController(
        title: "Adding New Word",
        message: "Enter new word",
        preferredStyle: .alert
    )
    
    var defaultAction: UIAlertAction?
    let delegate: WordAdderDelegate
    
    init(delegate: WordAdderDelegate) {
        self.delegate = delegate
        defaultAction = UIAlertAction(
            title: "Add",
            style: .default,
            handler: { (action: UIAlertAction) -> Void in
                let word = self.alert.textFields!.first!.text!
                self.delegate.newWord(word)
            }
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(defaultAction!)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: { field in
            field.addTarget(
                self,
                action: #selector(self.textChanged(sender:)),
                for: .editingChanged
            )
        })
    }
    
    @objc func textChanged(sender: UITextField) {
        defaultAction!.isEnabled = !(sender.text!.isEmpty)
    }
    
    func present(sender: UIViewController) {
        alert.textFields!.first!.text = ""
        defaultAction!.isEnabled = false
        sender.present(alert, animated: true, completion: nil)
    }
}
