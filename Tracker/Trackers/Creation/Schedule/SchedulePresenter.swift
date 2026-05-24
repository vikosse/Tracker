//
//  SchedulePresenter.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 17/05/2026.
//

import Foundation

final class SchedulePresenter: SchedulePresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: ScheduleViewProtocol?
    weak var delegate: ScheduleViewControllerDelegate?
    private var selectedDays: Set<Weekday>
    private let allDays: [Weekday] = Weekday.allCases
    
    // MARK: - Init
    
    init(initialSelection: Set<Weekday>) {
        self.selectedDays = initialSelection
    }
    
    // MARK: - SchedulePresenterProtocol
    
    func viewDidLoad() {
        view?.reloadDays()
    }
    
    func numberOfDays() -> Int {
        allDays.count
    }
    
    func day(at index: Int) -> Weekday {
        allDays[index]
    }
    
    func isDaySelected(_ day: Weekday) -> Bool {
        selectedDays.contains(day)
    }
    
    func toggleDay(_ day: Weekday, isOn: Bool) {
        if isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
    
    func didTapDone() {
        delegate?.scheduleDidConfirm(selectedDays)
    }
}
