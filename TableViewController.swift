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
    var deleteDate:Date = Date()

    func showConfirmationAlert(title: String!, message: String!,success: (() -> Void)? , cancel: (() -> Void)?) {
        let alertController = UIAlertController(title:title,
                                                message: message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel",
                                                        style: .cancel) {
                                                            action -> Void in cancel?()
        }
        let successAction: UIAlertAction = UIAlertAction(title: "Delete and Save old data",
                                                         style: .default) {
                                                            action -> Void in success?()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(successAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "tulipsbackgd.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
     
        gratitudes = dataManager.getGratsByMonth(monthSelection: 0)
        tableView.reloadData()

        self.back.cornerRadius = 10
        self.tableView.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //check for grats older than 3 moths ago and give user option to export existing and delete old ones
        deleteDate = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        if (dataManager.tooManyGrats(deletedate: deleteDate)) {
            showConfirmationAlert(title: "Save your Gratitudes older than \(deleteDate)", message: "The app can only store 3 months of gratitudes.  Everything older than 3 months will be deleted. You will also have the option to save them to your phone", success: { () -> Void in
                print("success")
                //delete from today - one month
                let deletedGrats:[gratitude] = self.dataManager.deleteGratsLaterThan(date: self.deleteDate)
                if (deletedGrats.count > 0) {
                    self.exportData(grats: deletedGrats)
                    self.tableView.reloadData()
                }
            }) { () -> Void in
                self.dismiss(animated: true, completion: nil)
            }
        }

        
    }
    
    //calucate row height to set table rows dynamically based on char count 
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
        exportData(grats: gratitudes)
    }
    
    func exportData(grats: [gratitude]) {
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("logs.csv")
        var csvText = "Date,Note\n"
        for grat in grats {
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
