//
//  ScheduleProtocols.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 17/05/2026.
//

import Foundation

// MARK: - Delegate


protocol ScheduleViewControllerDelegate: AnyObject {
    func scheduleDidConfirm(_ selectedDays: Set<Weekday>)
}

// MARK: - View Protocol

protocol ScheduleViewProtocol: AnyObject {
    func reloadDays()
}

// MARK: - Presenter Protocol

protocol SchedulePresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfDays() -> Int
    func day(at index: Int) -> Weekday
    func isDaySelected(_ day: Weekday) -> Bool
    func toggleDay(_ day: Weekday, isOn: Bool)
    func didTapDone()
}
