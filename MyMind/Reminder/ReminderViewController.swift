//
//  ReminderViewController.swift
//  MyMind
//
//  Created by STDC_41 on 16/05/2024.
//

import UIKit

// Model to store reminders
struct Reminder {
    var title: String
    var isCompleted: Bool
}

class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reminders: [Reminder] = []
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup your table view
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath)
        let reminder = reminders[indexPath.row]
        
        // Display task, date, and time
        let strikeThroughText = NSMutableAttributedString(string: reminder.title)
        if reminder.isCompleted {
            strikeThroughText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, strikeThroughText.length))
        }
        cell.textLabel?.attributedText = strikeThroughText
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath)
        let reminder = reminders[indexPath.row]
        cell.textLabel?.text = reminder.title
        if reminder.isCompleted {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: reminder.title)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.textLabel?.attributedText = attributeString
            } else {
                cell.textLabel?.attributedText = nil
            }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        return cell
    }*/
    
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell)
        else {
            return
        }
        let reminder = reminders[indexPath.row]
        let alert = UIAlertController(title: reminder.title, message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {_ in self.reminders[indexPath.row].isCompleted = true
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Add Reminder Button Action
    @IBAction func addReminderTapped(_ sender: UIBarButtonItem) {
        // Present AddReminderViewController to add a new reminder
        let addReminderVC = storyboard?.instantiateViewController(withIdentifier: "AddReminderViewController") as! AddReminderViewController
        addReminderVC.delegate = self
        navigationController?.pushViewController(addReminderVC, animated: true)
    }
    
}

extension ReminderViewController: AddReminderDelegate {
    func didAddReminder(_ reminder: Reminder) {
        var newReminder = reminder
        newReminder.isCompleted = false
        reminders.append(reminder)
        tableView.reloadData()
    }
}
