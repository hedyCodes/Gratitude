//
//  gratCellTableViewCell.swift
//  Gratitude
//
//  Created by Heather Martin on 12/11/17.
//  Copyright © 2017 Heather Martin. All rights reserved.
//

import UIKit

class gratCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    var gratId:Int16 = 0
    
    var deleteIndexPath:Int? = 0

    let datamanager = DataManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    @IBAction func deleteButton(_ sender: Any) {
//        print("deleting ", gratId)
//        datamanager.deleteGrat(inGratId: gratId)
//        self.removeFromSuperview()
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
