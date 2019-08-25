//
//  ViewController.swift
//  SampleCalendarView
//
//  Created by Anirudh on 21/07/19.
//  Copyright © 2019 Anirudh Vyas. All rights reserved.
//

import UIKit
import AVCalendarFramework

class ViewController: UIViewController {

    @IBOutlet weak var selectDateButton: UIButton!
    var calendar: AVCalendarViewController = AVCalendarViewController.calendar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func showTheCalendar() {
        calendar.dateStyleComponents = CalendarComponentStyle(backgroundColor: UIColor(red: 89/255, green: 65/255, blue: 102/255, alpha: 1.0),
                                                              textColor: .white,
                                                              highlightColor: UIColor(red: 126/255, green: 192/255, blue: 196/255, alpha: 1.0).withAlphaComponent(0.5))
        calendar.yearStyleComponents = CalendarComponentStyle(backgroundColor: UIColor(red: 126/255, green: 192/255, blue: 196/255, alpha: 1.0),
                                                              textColor: .black, highlightColor: .white)
        calendar.monthStyleComponents = CalendarComponentStyle(backgroundColor: UIColor(red: 47/255, green: 60/255, blue: 95/255, alpha: 1.0),
                                                               textColor: UIColor(red: 126/255, green: 192/255, blue: 196/255, alpha: 1.0),
                                                               highlightColor: UIColor.white)
        calendar.subscriber = { (date) in
            if date != nil {
                let _ = Date(timeIntervalSince1970: TimeInterval(date?.doubleVal ?? 0))
                if let day = date?.day, let month = date?.month, let year = date?.year {
                    let dateString = day + " " + month + " " + year
                    self.selectDateButton.setTitle(dateString, for: .normal)
                }
            } else {
                
            }
        }
        self.present(calendar, animated: false, completion: nil)
    }


    @IBAction func buttonAction(_ sender: UIButton) {
        showTheCalendar()
    }
}

