//
//  ChangeDateViewController.swift
//  WeatherMDB
//
//  Created by Rini Vasan on 3/11/20.
//  Copyright © 2020 Rini Vasan. All rights reserved.
//

import UIKit

class ChangeDateViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        datesButton.backgroundColor = UIColor.init(red: 216/255, green: 199/255, blue: 181/255, alpha: 1)
        dateLabel.backgroundColor = UIColor.init(red: 216/255, green: 199/255, blue: 181/255, alpha: 1)
        doneButton.backgroundColor = UIColor.init(red: 216/255, green: 199/255, blue: 181/255, alpha: 1)
        
        dateLabel.layer.cornerRadius = 15.0
        dateLabel.clipsToBounds = true
        
        
        datesButton.layer.cornerRadius = 15.0
        datesButton.clipsToBounds = true
        
        doneButton.layer.cornerRadius = 15.0
        doneButton.clipsToBounds = true
       
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datesButton: UIDatePicker!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func donePressed(_ sender: Any) {
        date = self.datesButton.date.convertedDate
        self.navigationController?.popViewController(animated: true)

    }
    
}


extension Date {

    var convertedDate:Date {

     let dateFormatter = DateFormatter();

      let dateFormat = "dd MMM yyyy";
      dateFormatter.dateFormat = dateFormat;
    let formattedDate = dateFormatter.string(from: self);

     dateFormatter.locale = NSLocale.current;
     dateFormatter.timeZone = TimeZone(abbreviation: "PST+0:00");

     dateFormatter.dateFormat = dateFormat as String;
     let sourceDate = dateFormatter.date(from: formattedDate as String);

     return sourceDate!;
 }
}
