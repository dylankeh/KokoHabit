//
//  CalendarViewController.swift
//  KokoHabit
//
//  This view controller shows a month calendar with the days colored in where they met their minimum point requirement
//  Users are able to swipe back and forth to see other months
//
//  Created by Khoa Tran on 2019-04-03.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    let dao = DAO()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    // setting some color styling
    let outsideMonthColor = UIColor.gray // the color for label of the day number that are outside of the current month
    let monthColor = UIColor.black // the color for label of the day number that are inside of the current month
    let selectedMonthColor = UIColor.white // the color for label of the day number that are selected
    let currentDateSelectedViewColor = UIColor.red // the color for label of the day number of the current date
    
    var formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calendarView.scrollToDate(Date.init(),animateScroll: false) // scroll to the current date when the calendar page appears
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
        // select the days where users passed their minimum point requirement for the day, this will style the cell
        calendarView.selectDates(dao.getDaysWhereUserPassedMinPoints(), triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)

    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else {return}
        
        // show a color if the cell is selected
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            
            if cellState.dateBelongsTo == .thisMonth {
                // set the color of the day number label if the day is inside the current month
                validCell.dateLabel.textColor = monthColor
            } else {
                 // set the color of the day number label if the day is outside the current month
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else {return}
        if cellState.isSelected {
            // show the color background if a cell is selected
            validCell.selectedBackgroundView?.isHidden = false
        } else {
            // otherwise the background will just be white
            validCell.selectedBackgroundView?.isHidden = true
        }
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        // headers for the calendar
        // this is the current year which will show ontop of the month calendar
        // this will update as user scrolls
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        // this is the current month which will show ontop of the month calendar
        // this will update as user scrolls
        formatter.dateFormat = "MMM"
        month.text = formatter.string(from: date)
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        // some calendar date configurations
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        // the range of the calendar
        let startDate = formatter.date(from: "2018-01-01")!
        let endDate = formatter.date(from: "2030-12-31")!
        
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
        formatter.dateFormat = "yyyy-MM-dd"
        if formatter.string(from: date) == formatter.string(from: dao.getLatestWeek()){
            cell.viewWithTag(1000)?.isHidden = false
        }
        
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
