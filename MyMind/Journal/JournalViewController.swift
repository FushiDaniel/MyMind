//
//  JournallViewController.swift
//  MyMind
//
//  Created by STDC_30 on 19/05/2024.
//

import UIKit

class JournalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, AddJournalViewControllerDelegate {
    
    var journalItems: [JournalItem] = [.newJournal]
    var journalCount = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.journalItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let item = journalItems[indexPath.row]
        
        switch item
        {
        case .newJournal:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewJournalCell", for: indexPath) as! NewJournalCollectionViewCell
            cell.newJournalLabel.text = "New Journal"
            cell.backgroundColor = UIColor.lightGray
            return cell
            
        case .savedjournal(let journal):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedJournalCell", for: indexPath) as! JournalCollectionViewCell
            cell.titleLabel.text = journal.title
            cell.backgroundColor = UIColor.lightGray
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let item = journalItems[indexPath.row]
        
        switch item
        {
        case .newJournal:
            handleNewJournalTap()
            
        case .savedjournal(let journal):
            // Handle journal selection detailViewController
            performSegue(withIdentifier: "ShowJournalDetailSegue", sender: journal)
            break
        }
    }
    
    //newJournal
    @IBAction func addNewJournalTapped(_ sender: UIBarButtonItem){
        handleNewJournalTap()
    }
    
    func handleNewJournalTap()
    {
        performSegue(withIdentifier: "AddJournalSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "AddJournalSegue"
        {
            if let addJournalVC = segue.destination as? AddJournalViewController
            {
                addJournalVC.delegate = self
            }
        } else if segue.identifier == "ShowJournalDetailSegue" {
            if let detailVC = segue.destination as? JournalDetailViewController, let journal = sender as? Journal {
                detailVC.journal = journal
            }
        }
    }
    // MARK: - AddJournalViewControllerDelegate
    func didSaveNewJournal(title: String, content: String, image: UIImage?)
     {
         journalCount += 1
         let newJournalTitle = "Journal \(journalCount)"
         let newJournal = Journal(title: newJournalTitle, content: content, date: Date())
         journalItems.insert(.savedjournal(newJournal), at: 1) // Add saved journal after "New Journal" item
         collectionView.reloadData()
         
         if let image = image {
             if let detailViewController = navigationController?.viewControllers.first(where: {$0 is JournalDetailViewController}) as? JournalDetailViewController {
                 detailViewController.journalImage = image
             }
         }
     }
    
    /*func didSaveNewJournal(title: String, content: String)
    {
        if let editedIndex = journalItems.firstIndex(where: { item in
            if case .savedjournal(let journal) = item {
                return journal.title == title
            }
            return false
        }) {
            if case .savedjournal(let journal) = journalItems[editedIndex] {
                // Update existing journal
                let updatedJournal = Journal(title: title, content: content, date: journal.date)
                journalItems[editedIndex] = .savedjournal(updatedJournal)
                collectionView.reloadItems(at: [IndexPath(item: editedIndex, section: 0)])
            }
        } else {
            // Add new journal entry
            journalCount += 1
            let newJournalTitle = "Journal \(journalCount)"
            let newJournal = Journal(title: newJournalTitle, content: content, date: Date())
            journalItems.insert(.savedjournal(newJournal), at: 1) // Add saved journal after "New Journal" item
            collectionView.reloadData()
        }
    }*/
}
