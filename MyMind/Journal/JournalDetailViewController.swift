
//
//  JournalDetailViewController.swift
//  MyMind
//
//  Created by STDC_30 on 20/05/2024.
//

import UIKit

protocol DetailJournalViewControllerDelegate: AnyObject {
    func didDeleteJournal(at index: Int)
}

class JournalDetailViewController: UIViewController {
    
    var journal: Journal?
    var journalImage: UIImage?
    var journalIndex: Int?
    weak var delegate: DetailJournalViewControllerDelegate?
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var moodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let journal = journal {
            let titleLabel = UILabel()
            titleLabel.text = journal.title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.textColor = .black
            contentLabel.text = journal.content
            navigationItem.titleView = titleLabel
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let dateString = dateFormatter.string(from: journal.date)
            moodLabel.text = "Your mood on \(dateString) is: \(journal.mood)"
            moodLabel.font = UIFont.boldSystemFont(ofSize: 16)
            
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
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
            // Show the alert to confirm deletion
            let alertController = UIAlertController(title: "Delete Journal", message: "Are you sure you want to delete this journal entry?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self, let index = self.journalIndex else { return }
                self.delegate?.didDeleteJournal(at: index)
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
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
                detailVC.journalImage = journal.image
                
                print("Journal image set: \(journal.image)") // Add this line to check if the image is being set
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
    func didSaveNewJournal(title: String, content: String, image: UIImage?, mood: String) {
        updateContentLabel(with: content)
        updateImage(with: image)
    }
}
