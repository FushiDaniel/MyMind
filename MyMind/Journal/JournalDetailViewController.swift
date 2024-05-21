
//
//  JournalDetailViewController.swift
//  MyMind
//
//  Created by STDC_30 on 20/05/2024.
//

import UIKit

class JournalDetailViewController: UIViewController {
    
    var journal: Journal?
    var journalImage: UIImage?
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let journal = journal {
            let titleLabel = UILabel()
            titleLabel.text = journal.title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.textColor = .black
            contentLabel.text = journal.content
            navigationItem.titleView = titleLabel
            
            if let image = journal.image {
                imageView.image = image
                imageView.isHidden = false
                
                contentLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
            } else {
                imageView.isHidden = true
                
                contentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
            }
            
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
            navigationItem.rightBarButtonItem = editButton
        }
    }
    
    @objc func editButtonTapped() {
        performSegue(withIdentifier: "EditJournalSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditJournalSegue" {
            if let addJournalVC = segue.destination as? AddJournalViewController {
                addJournalVC.journalToEdit = journal
                addJournalVC.delegate = self
            }
        } else if segue.identifier == "ShowJournalDetailSegue" {
            if let detailVC = segue.destination as? JournalDetailViewController,
               let journal = sender as? Journal {
                detailVC.journal = journal
                detailVC.journalImage = journalImage
            }
        }
    }
    
    func updateContentLabel(with content: String) {
        contentLabel.text = content
    }
    
    func updateImage(with image: UIImage?) {
        imageView.image = image
    }
}

extension JournalDetailViewController: AddJournalViewControllerDelegate {
    func didSaveNewJournal(title: String, content: String, image: UIImage?) {
        updateContentLabel(with: content)
        updateImage(with: image)
    }
}
