//
//  CalendarViewController.swift
//  KokoHabit
//
//  Created by Arthur Tran on 2019-04-03.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    let dao = DAO()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    let outsideMonthColor = UIColor.gray //UIColor(colorWithHexCalue: 0x)
    let monthColor = UIColor.black
    let selectedMonthColor = UIColor.white
    let currentDateSelectedViewColor = UIColor.red
    
    var formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
        // calendarView.scrollToDate(Date.init(),animateScroll: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calendarView.scrollToDate(Date.init(),animateScroll: false)
    }
    
    func setupCalendarView() {
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        calendarView.allowsMultipleSelection = true
        calendarView.selectDates(dao.getDaysWhereUserPassedMinPoints(), triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)

        
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else {return}
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else {return}
        if cellState.isSelected {
            validCell.selectedBackgroundView?.isHidden = false
        } else {
            validCell.selectedBackgroundView?.isHidden = true
        }
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMM"
        month.text = formatter.string(from: date)
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2019-01-01")!
        let endDate = formatter.date(from: "2019-12-31")!
        
        let parameters = ConfigurationParameters.init(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    // Display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    //    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
    //        return false
    //    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return false
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

