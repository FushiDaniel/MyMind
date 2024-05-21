//
//  JournalDetailViewController.swift
//  MyMind
//
//  Created by STDC_30 on 20/05/2024.
//

import UIKit

class JournalDetailViewController: UIViewController {
    
    var journal: Journal?
    
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let journal = journal {
            titleLabel.text = journal.title
        }

    }
}
