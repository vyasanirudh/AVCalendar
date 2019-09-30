//
//  AVCalendarViewController.swift
//  Anirudh Vyas
//
//  Created by Anirudh on 08/05/19.
//  Copyright © 2019 Anirudh Vyas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

open class AVCalendarViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            self.closeButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }
    }
    
    @IBOutlet weak var backgroundView: UIView! {
        didSet {

        }
    }
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }
    }
    
    public static var calendar: AVCalendarViewController = {
        let storyboard = UIStoryboard(name: "Calendar", bundle: Bundle(for: AVCalendarViewController.self))
        let subscriptionPlansVC = storyboard.instantiateViewController(withIdentifier: "AVCalendarViewController") as! AVCalendarViewController
        subscriptionPlansVC.modalPresentationStyle = .overCurrentContext
        return subscriptionPlansVC
    }()
    
    private var _yearStyleComponents: CalendarComponentStyle?
    public var yearStyleComponents: CalendarComponentStyle? {
        get {
            return _yearStyleComponents
        } set {
            _yearStyleComponents = newValue
            calendarVC?.yearStyleComponents = newValue
        }
    }
    
    private var _monthStyleComponents: CalendarComponentStyle?
    public var monthStyleComponents: CalendarComponentStyle? {
        get {
            return _monthStyleComponents
        } set {
            _monthStyleComponents = newValue
            calendarVC?.monthStyleComponents = newValue
        }
    }
    
    private var _dateStyleComponents: CalendarComponentStyle?
    public var dateStyleComponents: CalendarComponentStyle? {
        get {
            return _dateStyleComponents
        } set {
            _dateStyleComponents = newValue
            calendarVC?.dateStyleComponents = newValue
        }
    }
    
    public var subscriber: ((AVDate?)->())?
    public var preSelectedDate: AVDate? {
        didSet {
            calendarVC?.preSelectedDate = preSelectedDate
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showCalendar()
    }
    
    private func showCalendar() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.containerView.alpha = 1.0
            self.closeButton.alpha = 1.0
            self.backgroundView.alpha = 1.0
            self.backgroundView.transform = .identity
            self.containerView.transform = .identity
        }) { (done) in
             UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.closeButton.transform = .identity
             }) { (done) in
                
            }
        }
    }
    
    private func hideCalendar() {
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

    }

    private var calendarVC: AVCustomCalendarController? {
        didSet {
            calendarVC?.dateStyleComponents = _dateStyleComponents
            calendarVC?.monthStyleComponents = _monthStyleComponents
            calendarVC?.yearStyleComponents = _yearStyleComponents
        }
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? AVCustomCalendarController {
            calendarVC = vc
        }
    }
    
    @IBAction func closeButtonAction(sender: UIButton) {
        if let vc = self.calendarVC {
            if let dateSelected = vc.getDate() {
                if dateSelected.day == nil {
                    if let _subscriber = self.subscriber {
                        _subscriber(nil)
                    }
                    return
                } else {
                    if let _subscriber = self.subscriber {
                        _subscriber(dateSelected)
                    }
                }
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.containerView.alpha = 0.0
                    self.closeButton.alpha = 0.0
                    self.backgroundView.alpha = 0.0
                    self.containerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    self.closeButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }) { (done) in
                    self.dismiss(animated: false, completion: nil)
                }
            } else {
                sender.generateFeedback()
            }
        }
    }
    
    deinit {
        print("")
    }
}
