//
//  ViewController.swift
//  Gratitude
//
//  Created by Heather Martin on 12/11/17.
//  Copyright © 2017 Heather Martin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

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

        let newTextField = UITextField(frame: CGRect(x: 15, y: yPosition, width: gratWidth, height: gratHeight))
        newTextField.placeholder = ""
        newTextField.target(forAction: #selector(self.textChanged), withSender: UITextField.self)
        newTextField.font = UIFont.systemFont(ofSize: 14)
        newTextField.borderStyle = UITextBorderStyle.roundedRect
        newTextField.autocorrectionType = UITextAutocorrectionType.no
        newTextField.keyboardType = UIKeyboardType.default
        newTextField.returnKeyType = UIReturnKeyType.done
        newTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        newTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        newTextField.cornerRadius = 10
        let textTag:Int = Int(arc4random())
        newTextField.tag = textTag
        textfieldTags.append(textTag)
        newTextField.delegate = self
        self.view.addSubview(newTextField)
        gratCount += 1
    }
    
    lazy var textField: UITextField! = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func textChanged(sender:UITextField!)
    {
        let textfield:UITextField = sender as UITextField
        //save textfield.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

            if let textField = self.view.viewWithTag(textfieldTag) as? UITextField {
                let textval:String = textField.text!
                if (!textval.isEmpty) { dataManager.createGrat(inNote: textval, today: today) }
                textField.removeFromSuperview()
            }
        }
        performSegue(withIdentifier: "tableSegue", sender: self)
    }
    
    @IBAction func buttonViewAll(_ sender: Any) {
        performSegue(withIdentifier: "tableSegue", sender: self)
    }
    
    @IBAction func buttonSaveYesterday(_ sender: Any) {
        performSave(today: false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor(red: 249.0/255, green: 193.0/255, blue: 93.0/255, alpha: 0.7)
    }

}

