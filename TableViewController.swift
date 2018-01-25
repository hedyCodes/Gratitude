//
//  TableViewController.swift
//  Gratitude
//
//  Created by Heather Martin on 12/11/17.
//  Copyright © 2017 Heather Martin. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var monthSelectionControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var back: UIButton!
    
    let dataManager = DataManager()
    lazy var gratitudes:[gratitude] = []
    var tableRowHeight:CGFloat = 80.0
    let dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "tulipsbackgd.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        gratitudes = dataManager.getGratsByMonth(monthSelection: 0)
        //check for grats older than 3 moths ago and give user option to export existing and delete old ones 
        tableView.reloadData()

        self.back.cornerRadius = 10
        self.tableView.cornerRadius = 10
    }
    
    func calcRowHeight(){
        //let baseString:NSAttributedString = "Art"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gratitudes = dataManager.getGratsByMonth(monthSelection: 0)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gratitudes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! gratCellTableViewCell
        let datestamp:Date = gratitudes[indexPath.row].datestamp!

        dateFormatter.dateFormat  = "EEEE, MM/dd/YYYY"
        let weekDay = dateFormatter.string(from: datestamp as Date)
        cell.dateLabel.text = weekDay
        
        cell.noteLabel.text = gratitudes[indexPath.row].note!
        cell.gratId = Int16(gratitudes[indexPath.row].id!)
        return cell as UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableRowHeight
    }
    
    @IBAction func exportButton(_ sender: Any) {
        exportLogData()
    }
    
    func exportLogData() {
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("logs.csv")
        var csvText = "Date,Note\n"
        for grat in gratitudes {
            let date:String = grat.datestamp!.toString(dateFormat: "MM/dd/YYY HH:mm")
            let note:String = grat.note!
            let newLine = "\(date),\(note)\n"
            csvText.append(newLine)
        }
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])   
            vc.excludedActivityTypes = [
                UIActivityType.assignToContact,
                UIActivityType.saveToCameraRoll,
                UIActivityType.postToFlickr,
                UIActivityType.postToVimeo,
                UIActivityType.postToTencentWeibo,
                UIActivityType.postToTwitter,
                UIActivityType.postToFacebook,
                UIActivityType.openInIBooks
            ]
            present(vc, animated: true, completion: nil)
            
        } catch {
            
            print("Failed to create file")
            print("\(error)")
        }
    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func monthSelection(_ sender: Any) {
        let monthSelection:Int = monthSelectionControl.selectedSegmentIndex
        gratitudes = dataManager.getGratsByMonth(monthSelection: monthSelection)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
