//
//  AddReminderViewController.swift
//  MyMind
//
//  Created by STDC_30 on 23/05/2024.
//

import UIKit

protocol AddReminderDelegate: AnyObject {
    func didAddReminder(_ reminder: Reminder)
}

class AddReminderViewController: UIViewController, UITextViewDelegate {
    
    weak var delegate: AddReminderDelegate?
    
    @IBOutlet var taskField: UITextView!
    @IBOutlet var descField: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set the date picker mode to date and time
            datePicker.datePickerMode = .dateAndTime
            
            // Set up the task and description text views
            setupTextView(taskField, placeholder: "Your Task")
            setupTextView(descField, placeholder: "Description (Optional)")
        }
        
        // MARK: - UITextViewDelegate
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = textView.tag == 0 ? "Your Task" : "Description (Optional)"
                textView.textColor = UIColor.lightGray
            }
        }
        
        private func setupTextView(_ textView: UITextView, placeholder: String) {
            textView.delegate = self
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            textView.tag = textView == taskField ? 0 : 1
        }
        
    @IBAction func saveReminderTapped(_ sender: UIButton) {
        guard let taskText = taskField.text, !taskText.isEmpty, taskText != "Your Task" else {
            let alert = UIAlertController(title: "Error", message: "Please enter your task", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        present(alert, animated: true, completion: nil)
                        return
        }
    
        var reminder = Reminder(title: taskText, isCompleted: false)
        let selectedDate = datePicker.date
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let formattedDate = formatter.string(from: selectedDate)
        let reminderWithDateTime = "\(taskText) - \(formattedDate)"
        reminder.title = reminderWithDateTime
        delegate?.didAddReminder(reminder)
        navigationController?.popViewController(animated: true)
    }
}
