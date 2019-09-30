//
//  AVCustomCalendarController.swift
//  Anirudh Vyas
//
//  Created by Anirudh on 06/05/19.
//  Copyright © 2019 Anirudh Vyas. All rights reserved.
//

import UIKit

let AGE_LIMIT = 0

public struct CalendarComponentStyle {
    var backgroundColor: UIColor?
    var textColor: UIColor?
    var highlightColor: UIColor?
    
    public init(backgroundColor: UIColor?, textColor: UIColor?, highlightColor:UIColor?) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.highlightColor = highlightColor
    }
    
}

struct CalendarComponents {
    let years = (((Calendar.current.component(.year, from: Date()) - AGE_LIMIT)-100)...2099).map { String($0) }
    let months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec"]
    let days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    var dates:Dynamic<[String]>! = Dynamic<[String]>((1...31).map { String($0) })
    var masterDates:Dynamic<[String]>! = Dynamic<[String]>((1...31).map { String($0) })
}

public struct AVDate {
    public var day: String?
    public var month: String?
    public var year: String?
    public var doubleVal: Double?
}

internal struct _AVDate {
    public var day: String?
    public var month: String?
    public var year: String?
    public var doubleVal: Double? {
        mutating get {
            let dfmatter = DateFormatter()
            dfmatter.dateFormat="yyyy-MM-dd'T'HH:mm:ssZ"
            dfmatter.timeZone = .current
            if let _year = year, let _month = calendarComponents.months.firstIndex(of: month!), let day = day, let _day = calendarComponents.dates.value?.firstIndex(of: day) {
                let _date = dfmatter.date(from: "\(_year)-\(_month + 1)-\(_day + 1)T00:00:00+0000")
                if let dateStamp = _date?.timeIntervalSince1970 {
                    return dateStamp
                }
            }
            return nil
        }
    }
    
    var calendarComponents = CalendarComponents()

    init(day: String?, month: String?, year: String?) {
        self.day = day
        self.month = month
        self.year = year
    }
    
    func stringify() -> String {
        if let _day = day, let _month = month, let _year = year {
            return _day + " / " + _month + " / " + _year
        }
        return ""
    }
}

class AVCustomCalendarViewModel {

    var calendarComponents = CalendarComponents()
    let countOfMonthCells: Int = 12
    var date: _AVDate!
    var preSelectedDate: AVDate!
    
    init() {
        date = _AVDate(day: String(Calendar.current.component(.day, from: Date())), month: calendarComponents.months[Calendar.current.component(.month, from: Date()) - 1], year: String((Calendar.current.component(.year, from: Date()) - AGE_LIMIT)))
    }
    
    func getIndices(from date: AVDate) -> (day: Int, month: Int, year: Int) {
        var indices: (day: Int, month: Int, year: Int) = (0,0,0)
        indices.day = (Int(date.day ?? "1") ?? 1) - 1
        indices.month = calendarComponents.months.firstIndex(of: date.month ?? "Jan") ?? 0
        indices.year = calendarComponents.years.firstIndex(of: date.year ?? "Jan") ?? 0
        return indices
    }
    
    func getCurrentMonth() -> Int {
        let half = countOfMonthCells/2
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        let centerMonthIndex = half % calendarComponents.months.count
        let centerIndexToBeReturned = half - (centerMonthIndex - currentMonthIndex)
        return centerIndexToBeReturned
    }
    
    func getCurrentMonthIndex() -> Int {
        return (Calendar.current.component(.month, from: Date()) - 1)
    }
    
    func getCurrentDateIndex() -> Int {
        return (Calendar.current.component(.day, from: Date()) - 1)
    }
    
    func getCurrentYearIndex() -> Int {
        let years = calendarComponents.years
        let currentMonth = Calendar.current.component(.year, from: Date())
        let index = years.firstIndex(of: "\(currentMonth)")
        return index!
    }
    
    func updateDate(dayValue day: Int? = nil, monthValue month: Int? = nil, yearValue year: Int? = nil) {
        if let day = day {
            date.day = String(day + 1)
        }
        if let month = month {
            date.month = calendarComponents.months[month % calendarComponents.months.count]
        }
        if let year = year {
            date.year = calendarComponents.years[year]
        }
        if let month = date.month, let year = date.year {
            updateTheDays(month: calendarComponents.months.firstIndex(of: month)! + 1, year: Int(year)!)
        }
    }
    
    private func updateTheDays(month monthValue: Int, year yearValue: Int) {
        let dateComponents = DateComponents(year: yearValue, month: monthValue)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        calendarComponents.dates.value = (1...numDays).map { String($0) }
    }
}

class AVCustomCalendarController: UIViewController {

    internal var preSelectedDate: AVDate?
    
    private var _yearStyleComponents: CalendarComponentStyle?
    var yearStyleComponents: CalendarComponentStyle? {
        get {
            return _yearStyleComponents
        } set {
            _yearStyleComponents = newValue
        }
    }
    
    private var _monthStyleComponents: CalendarComponentStyle?
    var monthStyleComponents: CalendarComponentStyle? {
        get {
            return _monthStyleComponents
        } set {
            _monthStyleComponents = newValue
        }
    }
    
    private var _dateStyleComponents: CalendarComponentStyle?
    var dateStyleComponents: CalendarComponentStyle? {
        get {
            return _dateStyleComponents
        } set {
            _dateStyleComponents = newValue
        }
    }
    
    private lazy var dateHighlightImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: self.dateCollectionGrid.bounds.size.width*0.118, height: self.dateCollectionGrid.bounds.size.width*0.118))
        image.layer.cornerRadius = image.bounds.size.height/2
        image.backgroundColor = _dateStyleComponents?.highlightColor
        return image
    }()
    
    @IBOutlet var yearSideShades: [UIImageView]! {
        didSet {
            let bundle = Bundle(for: AVCustomCalendarController.self)
            for view in yearSideShades {
                if view.tag == 100, let _image = UIImage(named: "calendar_left_year_gradient", in: bundle, compatibleWith: nil) {
                    view.image = _image.withRenderingMode(.alwaysTemplate)
                } else if view.tag == 200, let _image = UIImage(named: "calendar_right_year_gradient", in: bundle, compatibleWith: nil) {
                    view.image = _image.withRenderingMode(.alwaysTemplate)
                }
                view.tintColor = _yearStyleComponents?.backgroundColor
            }
        }
    }
    
    @IBOutlet var monthSideShades: [UIImageView]! {
        didSet {
            let bundle = Bundle(for: AVCustomCalendarController.self)
            for view in monthSideShades {
                if view.tag == 100, let _image = UIImage(named: "calendar_left_month_gradient", in: bundle, compatibleWith: nil) {
                    view.image = _image.withRenderingMode(.alwaysTemplate)
                } else if view.tag == 200, let _image = UIImage(named: "calendar_right_month_gradient", in: bundle, compatibleWith: nil) {
                    view.image = _image.withRenderingMode(.alwaysTemplate)
                }
                view.tintColor = _monthStyleComponents?.backgroundColor
            }
        }
    }
    
    @IBOutlet var yearCollectionGrid: AVHorizontalScrollCollectionView! {
        didSet {
            yearCollectionGrid.backgroundColor = _yearStyleComponents?.backgroundColor
        }
    }
    
    @IBOutlet var monthCollectionGrid: AVHorizontalScrollCollectionView! {
        didSet {
            monthCollectionGrid.backgroundColor = _monthStyleComponents?.backgroundColor
        }
    }
    
    @IBOutlet var dateCollectionGrid: AVHorizontalScrollCollectionView! {
        didSet {
            dateCollectionGrid.backgroundColor = _dateStyleComponents?.backgroundColor
        }
    }
    
    private let viewModel: AVCustomCalendarViewModel = AVCustomCalendarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.preSelectedDate = preSelectedDate
        viewModel.calendarComponents.dates.bind = { [weak self] (arr) in
            guard let weakSelf = self else { return }
            if let day = weakSelf.viewModel.date.day {
                if Int(day)! > (arr?.count)! {
                    weakSelf.dateHighlightImage.isHidden = true
                    weakSelf.viewModel.date.day = nil
                }
            }
            weakSelf.dateCollectionGrid.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var indices: (day: Int, month: Int, year: Int) = (0,0,0)
        if let preSelectedDate = preSelectedDate {
            indices.day = self.viewModel.getIndices(from: preSelectedDate).day
            indices.month = self.viewModel.getIndices(from: preSelectedDate).month
            indices.year = self.viewModel.getIndices(from: preSelectedDate).year
        } else {
            indices.day = self.viewModel.getCurrentDateIndex()
            indices.month = viewModel.getCurrentMonth()
            indices.year = self.viewModel.getCurrentYearIndex()
        }
        yearCollectionGrid.scrollToItem(at: IndexPath(row: indices.year, section: 0), at: .centeredHorizontally, animated: false)
        monthCollectionGrid.scrollToItem(at: IndexPath(row: indices.month, section: 0), at: .centeredHorizontally, animated: false)
        viewModel.updateDate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.updateCellTransform(with: CGAffineTransform(scaleX: 1.3, y: 1.3), cell: self.yearCollectionGrid.cellForItem(at: IndexPath(row: indices.year, section: 0)) as! AVCustomCalendarYearCell, withHighlightColor: self._yearStyleComponents?.highlightColor)
            self.updateCellTransform(with: CGAffineTransform(scaleX: 1.3, y: 1.3), cell: self.monthCollectionGrid.cellForItem(at: IndexPath(row: indices.month, section: 0)) as! AVCustomCalendarYearCell, withHighlightColor: self._monthStyleComponents?.highlightColor)
            let centerForCell = self.dateCollectionGrid.layoutAttributesForItem(at: IndexPath(row: indices.day, section: 0))?.center
            self.dateHighlightImage.center = centerForCell!
            self.dateCollectionGrid.addSubview(self.dateHighlightImage)
            self.dateHighlightImage.isHidden = false
        }
    }
    
    private func updateCellTransform(with transform: CGAffineTransform = CGAffineTransform.identity, cell aCell: AVCustomCalendarYearCell, withHighlightColor highlightColor: UIColor? = .white) {
        UIView.animate(withDuration: 0.2) {
            aCell.transform = transform
            if transform != .identity {
                aCell.titleLabel.textColor = highlightColor
            }
        }
    }
    
    func getDate() -> AVDate? {
        if let _ = viewModel.date.doubleVal { //Calculate double value.
            var date = AVDate()
            date.day = viewModel.date.day
            date.month = viewModel.date.month
            date.year = viewModel.date.year
            date.doubleVal = viewModel.date.doubleVal
            return date
        }
        return nil
    }
}

extension AVCustomCalendarController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dateCollectionGrid {
            let centerForCell = collectionView.layoutAttributesForItem(at: indexPath)?.center
            self.dateHighlightImage.isHidden = false
            dateHighlightImage.center = centerForCell!
            viewModel.updateDate(dayValue: indexPath.row)
        }
    }
}

extension AVCustomCalendarController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == yearCollectionGrid {
            return viewModel.calendarComponents.years.count
        } else if collectionView == monthCollectionGrid {
            return viewModel.countOfMonthCells
        } else if collectionView == dateCollectionGrid {
            return viewModel.calendarComponents.masterDates.value!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AVCustomCalendarYearCell
        if collectionView == yearCollectionGrid {
            cell.titleLabel.text = viewModel.calendarComponents.years[indexPath.row]
            cell.titleLabel.textColor = _yearStyleComponents?.textColor
        } else if collectionView == monthCollectionGrid {
            let itemToShow = viewModel.calendarComponents.months[indexPath.row % viewModel.calendarComponents.months.count]
            cell.titleLabel.text = itemToShow
            cell.titleLabel.textColor = _monthStyleComponents?.textColor
        } else if collectionView == dateCollectionGrid {
            cell.titleLabel.text = viewModel.calendarComponents.masterDates.value![indexPath.row]
            cell.titleLabel.textColor = _dateStyleComponents?.textColor
            if indexPath.row >= viewModel.calendarComponents.dates.value?.count ?? 0 {
                cell.titleLabel.textColor = cell.titleLabel.textColor.withAlphaComponent(0.5)
                cell.isUserInteractionEnabled = false
            } else {
                cell.isUserInteractionEnabled = true
            }
        }
        return cell
    }
}

extension AVCustomCalendarController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dateCollectionGrid {
            return CGSize(width: (collectionView.bounds.width*0.136), height: (collectionView.bounds.height*0.086))
        } else if collectionView == monthCollectionGrid {
            return CGSize(width: 63.0, height: 30.0)
        } else if collectionView == yearCollectionGrid {
            return CGSize(width: 63.0, height: 30.0)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == dateCollectionGrid {
            return collectionView.bounds.size.width * 0.08
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == dateCollectionGrid {
            return UIEdgeInsets(top: collectionView.bounds.size.width * 0.04, left: collectionView.bounds.size.width * 0.012, bottom: collectionView.bounds.size.width * 0.04, right: collectionView.bounds.size.width * 0.012)
        } else if collectionView == yearCollectionGrid {
            return UIEdgeInsets(top: (collectionView.bounds.size.height - (collectionView.bounds.height*0.086))/2, left: 15, bottom: (collectionView.bounds.size.height - (collectionView.bounds.height*0.086))/2, right: (collectionView.bounds.size.width - (collectionView.bounds.width*0.136))/2)
        } else if collectionView == monthCollectionGrid {
            return UIEdgeInsets(top: 0, left: (collectionView.bounds.size.width - (collectionView.bounds.width*0.136))/2, bottom: 0, right: (collectionView.bounds.size.width - (collectionView.bounds.width*0.136))/2)
        }
        return .zero
    }
}

extension AVCustomCalendarController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == 101 {
            resetCellApperence(for: yearCollectionGrid)
        } else if scrollView.tag == 102 {
            resetCellApperence(for: monthCollectionGrid)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 101 {
            scrollToNearestCenterIndex(for: yearCollectionGrid)
        } else if scrollView.tag == 102 {
            scrollToNearestCenterIndex(for: monthCollectionGrid)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if scrollView.tag == 101 {
                scrollToNearestCenterIndex(for: yearCollectionGrid)
            } else if scrollView.tag == 102 {
                scrollToNearestCenterIndex(for: monthCollectionGrid)
            }
        }
    }
    
    func resetCellApperence(for collectionView: AVHorizontalScrollCollectionView) {
        for cell: AVCustomCalendarYearCell in collectionView.visibleCells as! [AVCustomCalendarYearCell] {
            updateCellTransform(cell: cell)
            if collectionView == yearCollectionGrid {
                cell.titleLabel.textColor = _yearStyleComponents?.textColor
            } else if collectionView == monthCollectionGrid {
                cell.titleLabel.textColor = _monthStyleComponents?.textColor
            }
        }
    }
    
    func scrollToNearestCenterIndex(for collectionView: AVHorizontalScrollCollectionView) {

        var closestCell : UICollectionViewCell = collectionView.visibleCells[0];
        for cell in collectionView.visibleCells as! [AVCustomCalendarYearCell] {
            updateCellTransform(cell: cell)
            let closestCellDelta = abs(closestCell.center.x - collectionView.bounds.size.width/2.0 - collectionView.contentOffset.x)
            let cellDelta = abs(cell.center.x - collectionView.bounds.size.width/2.0 - collectionView.contentOffset.x)
            if (cellDelta < closestCellDelta){
                closestCell = cell
            }
        }
        if collectionView == yearCollectionGrid {
            updateCellTransform(with: CGAffineTransform(scaleX: 1.3, y: 1.3), cell: closestCell as! AVCustomCalendarYearCell, withHighlightColor: _yearStyleComponents?.highlightColor)
        } else if collectionView == monthCollectionGrid {
            updateCellTransform(with: CGAffineTransform(scaleX: 1.3, y: 1.3), cell: closestCell as! AVCustomCalendarYearCell, withHighlightColor: _monthStyleComponents?.highlightColor)
        }
        let indexPath = collectionView.indexPath(for: closestCell)
        collectionView.scrollToItem(at: indexPath!, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        if let indexPath = indexPath {
            if collectionView == yearCollectionGrid {
                viewModel.updateDate(yearValue: indexPath.row)
            } else if collectionView == monthCollectionGrid {
                viewModel.updateDate(monthValue: indexPath.row)
            }
        }
    }
}
