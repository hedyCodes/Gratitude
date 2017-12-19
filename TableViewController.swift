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
    var gratitudes:[gratitude] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "tulipsbackgd.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        gratitudes = dataManager.getGratsByMonth(monthSelection: 0)
        self.back.cornerRadius = 10
        self.tableView.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gratitudes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! gratCellTableViewCell
        let datestamp:Date = gratitudes[indexPath.row].datestamp!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"
        let weekDay = dateFormatter.string(from: datestamp as Date)
        cell.dateLabel.text = weekDay + ", " +  datestamp.toString(dateFormat: "MM/dd/YY")
        cell.noteLabel.text = gratitudes[indexPath.row].note!
        cell.gratId = Int16(gratitudes[indexPath.row].id!)
        return cell as UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
