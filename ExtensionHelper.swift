//
//  ExtensionHelper.swift
//  Gratitude
//
//  Created by Heather Martin on 12/12/17.
//  Copyright © 2017 Heather Martin. All rights reserved.
//

import Foundation
import UIKit

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

protocol Traceable {
    var cornerRadius: CGFloat { get set }
}
extension UIView: Traceable {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
}
    
extension UIViewController {
    
    func alertConfirmation (title:String, message:String, completion:@escaping (_ result:Bool) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            completion(false)
        }))
    }
}



