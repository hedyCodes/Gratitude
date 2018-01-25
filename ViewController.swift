//
//  ViewController.swift
//  Gratitude
//
//  Created by Heather Martin on 12/11/17.
//  Copyright © 2017 Heather Martin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var labelYesterday: UILabel!
    @IBOutlet weak var labelCurrentDate: UILabel!
    @IBOutlet weak var removeGratButton: UIButton!
    
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var viewAll: UIButton!
    @IBOutlet weak var saveyesterday: UIButton!
    
    let dataManager = DataManager()
    let screenHeight = UIScreen.main.bounds.width
    let screenWidth = UIScreen.main.bounds.height
    var gratCount = 0
    
    var saveButtonHeight:CGFloat = 0
    var yestButtonHeight:CGFloat = 0
    var yestLabelHeight:CGFloat = 0
    let topMargin = 100
    let gratHeight:Int = 60
    let gratWidth:Int = 300
    var gratAreaHeight:CGFloat = 0
    
    var maxCharactersInText = 200
    
    var textfieldTags:[Int] = []
    
    @IBAction func addGrat(_ sender: Any) {

        createTextField()
        removeGratButton.isHidden = false
    }
    
    @IBAction func removeGrat(_ sender: Any) {
        self.view.viewWithTag(textfieldTags.last!)?.removeFromSuperview()
        textfieldTags.removeLast()
        gratCount -= 1
        if (textfieldTags.count == 0) {
            removeGratButton.isHidden = true
            gratCount = 0
        }
    }
    
    func createTextField(){
        //escape if there is no room for a new field
        if (gratCount > 0 && (Int(gratAreaHeight) / (gratCount*gratHeight)) < 1) { return }
        //create text field
        let yPosition =  topMargin + ((gratHeight+2)*(gratCount))
        let yPositionSaves = yPosition + gratHeight + 10
        //move buttons down with new textfields
        save.frame.origin = CGPoint(x: 270, y: yPositionSaves)
        labelYesterday.frame.origin = CGPoint(x: 15, y: yPositionSaves)
        saveyesterday.frame.origin = CGPoint(x: 15, y: yPositionSaves + 25)
        
        let newTextView = UITextView(frame: CGRect(x: 15, y: yPosition, width: gratWidth, height: gratHeight))
        newTextView.backgroundColor = UIColor.white
        newTextView.font = UIFont.systemFont(ofSize: 14)
        newTextView.autocorrectionType = UITextAutocorrectionType.default
        newTextView.keyboardType = UIKeyboardType.default
        newTextView.returnKeyType = .done
        newTextView.cornerRadius = 10
            let textTag:Int = Int(arc4random())
            newTextView.tag = textTag
            textfieldTags.append(textTag)
            newTextView.tag = textTag
        newTextView.delegate = self
        self.view.addSubview(newTextView)
        newTextView.translatesAutoresizingMaskIntoConstraints = false
        gratCount += 1
    }
    
    func textViewShouldReturn(textView: UITextView!) -> Bool {
        self.view.endEditing(true);
        return true;
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let input = textView.text as NSString
        let update = input.replacingCharacters(in: range, with: text)
        return update.count <= maxCharactersInText
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "tulipsbackgd.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.viewAll.cornerRadius = 10
        self.save.cornerRadius = 10
        self.saveyesterday.cornerRadius = 10
        self.labelYesterday.cornerRadius = 10
        getCurrentDate()
        saveButtonHeight = save.bounds.height
        yestButtonHeight = saveyesterday.bounds.height
        yestLabelHeight = labelYesterday.bounds.height
        gratAreaHeight = screenHeight - CGFloat(topMargin)
        createTextField()
        removeGratButton.isHidden = true

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
        for textfieldTag in textfieldTags {
            
            if let textView = self.view.viewWithTag(textfieldTag) as? UITextView {
                textView.backgroundColor = UIColor.white
                if let textval:String = textView.text {
                    if (!textval.isEmpty) {
                        dataManager.createGrat(inNote: textval, today: today)
                    }
                }
                //don't remove first text view
                if textfieldTag == textfieldTags.first {
                    textView.text = ""
                } else {
                    textView.removeFromSuperview()
                }
            }
        }
        gratCount = 1
        performSegue(withIdentifier: "tableSegue", sender: self)
    }
    
    @IBAction func buttonViewAll(_ sender: Any) {
        performSegue(withIdentifier: "tableSegue", sender: self)
    }
    
    @IBAction func buttonSaveYesterday(_ sender: Any) {
        performSave(today: false)
    }

}

