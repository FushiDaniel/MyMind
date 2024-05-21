//
//  TextBViewController.swift
//  MyMind
//
//  Created by STDC_10 on 21/05/2024.
//

import UIKit

class TextBViewController: UIViewController {

    @IBOutlet var email: UITextField!
    
    @IBOutlet var pass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UITextField {
    func clipToCircle(){
        self.layoutIfNeeded()
        self.layer.borderColor = UIColor.systemYellow.cgColor
        self.layer.borderWidth = 10.0

    }
}
