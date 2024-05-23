import UIKit
import AVFoundation
import CoreLocation
import Photos

protocol AddJournalViewControllerDelegate: AnyObject {
    func didSaveNewJournal(title: String, content: String, image: UIImage?, mood: String)
}

class AddJournalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, AVAudioRecorderDelegate {

    weak var delegate: AddJournalViewControllerDelegate?
    var journalToEdit: Journal?
    var selectedImage: UIImage?
    
    @IBOutlet weak var journalContentTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var emojiButton: [UIButton]!
    
    let locationManager = CLLocationManager()
    var audioRecorder: AVAudioRecorder?
    var audioFilename: URL?
    var selectedEmojiButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in emojiButton {
            button.addTarget(self, action: #selector(emojiButtonTapped(_:)), for: .touchUpInside)
        }
        
        setupNavigationBar()
        
        moodLabel.text = "Choose your mood today: "
        
        // Set the initial text for the text view
        journalContentTextView.text = "Start writing..."
        journalContentTextView.textColor = UIColor.lightGray
        
        // Set the delegate to handle text view events
        journalContentTextView.delegate = self
        
        // Location Manager setup
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Audio setup
        setupRecorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let journal = journalToEdit {
            journalContentTextView.text = journal.content
            journalContentTextView.textColor = UIColor.black
        }
    }
    
    private func setupNavigationBar() {
        // Create the label for the day and date
        let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.boldSystemFont(ofSize: 17)
        dateLabel.textColor = .black
        
        // Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMM yyyy"
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.font = UIFont.boldSystemFont(ofSize: 17) // Set to bold
        
        // Set the label as the title view
        navigationItem.titleView = dateLabel
        
        // Add the Done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Save Button Delegate
    @objc private func doneButtonTapped() {
        guard let selectedEmojiButton = selectedEmojiButton else {
                // Show an alert if no emoji button is selected
                let alert = UIAlertController(title: "Select Mood", message: "Please select your mood by tapping an emoji.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
        
        if let newJournalContent = journalContentTextView.text, !newJournalContent.isEmpty, newJournalContent != "Start writing..." {
            let selectedEmoji = selectedEmojiButton.titleLabel?.text ?? ""
            
            //Edit Journal
            if var journal = journalToEdit {
                journal.content = newJournalContent
                journal.mood = selectedEmoji
                delegate?.didSaveNewJournal(title: journal.title, content: journal.content, image: selectedImage, mood: journal.mood)
                navigationController?.popViewController(animated: true)
            } else {
            
            //New Journal
                let newJournalTitle = "Journal Entry" // Or derive a title from the content
                delegate?.didSaveNewJournal(title: newJournalTitle, content: newJournalContent, image: selectedImage, mood: selectedEmoji)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Emoji Picker Delegate
    @objc func emojiButtonTapped(_ sender: UIButton) {
        selectedEmojiButton?.isSelected = false
        
        sender.isSelected = true
        selectedEmojiButton = sender
    }
    
    func getSelectedEmoji() -> String? {
        return selectedEmojiButton?.titleLabel?.text
    }
    
    @IBAction func addImageTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func voiceTapped(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    @IBAction func locationTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func doodleTapped(_ sender: UIButton) {
        // Implement doodling functionality
    }
    
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
        if imageView.image != nil {
            journalContentTextView.frame.origin.y = imageView.frame.origin.y + imageView.frame.size.height + 10
        } else {
            journalContentTextView.frame.origin.y = 0
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // MARK: - Audio Recording
    func setupRecorder() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func startRecording() {
        audioRecorder?.record()
    }
    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        
        if success {
            print("Recording succeeded")
        } else {
            print("Recording failed")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// MARK: - UITextViewDelegate
extension AddJournalViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Start writing..." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Start writing..."
            textView.textColor = UIColor.lightGray
        }
    }
}
