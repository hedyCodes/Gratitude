//
//  ViewController.swift
//  Gratitude
//
//  Created by Heather Martin on 12/11/17.
//  Copyright © 2017 Heather Martin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var grat1note: UITextView!
    @IBOutlet weak var grat2note: UITextView!
    @IBOutlet weak var grat3note: UITextView!
    @IBOutlet weak var labelYesterday: UILabel!
    @IBOutlet weak var labelCurrentDate: UILabel!
    
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var viewAll: UIButton!
    @IBOutlet weak var saveyesterday: UIButton!
    
    let dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.grat1note.delegate = self
        self.grat2note.delegate = self
        self.grat3note.delegate = self
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "tulipsbackgd.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.grat1note.cornerRadius = 10
        self.grat2note.cornerRadius = 10
        self.grat3note.cornerRadius = 10 
        self.viewAll.cornerRadius = 10
        self.save.cornerRadius = 10
        self.saveyesterday.cornerRadius = 10
        self.labelYesterday.cornerRadius = 10
        getCurrentDate()
    }

    func getCurrentDate(){
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        let weekDay = dateFormatter.string(from: date as Date)
        self.labelCurrentDate.text = weekDay + ", " + Date().toString(dateFormat: "MM/dd/YY")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        performSave(today: true)
    }
    
    func performSave(today: Bool){
        
        let grat1:String = (grat1note?.text)!
        let grat2:String = (grat2note?.text)!
        let grat3:String = (grat3note?.text)!
        
        if (grat1.isEmpty || grat2.isEmpty || grat3.isEmpty)
        {
            let alert = UIAlertController(title: "Alert", message: "Please fill out all 3", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else
        {
            dataManager.createGrat(inNote: grat1, today: today)
            dataManager.createGrat(inNote: grat2, today: today)
            dataManager.createGrat(inNote: grat3, today: today)
            grat1note.text = ""
            grat2note.text = ""
            grat3note.text = ""
            performSegue(withIdentifier: "tableSegue", sender: self)
        }
    }
    
    @IBAction func buttonViewAll(_ sender: Any) {
        performSegue(withIdentifier: "tableSegue", sender: self)
    }
    
    @IBAction func buttonSaveYesterday(_ sender: Any) {
        performSave(today: false)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}

