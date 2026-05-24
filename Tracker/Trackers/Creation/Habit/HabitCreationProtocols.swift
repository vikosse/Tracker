//
//  HabitCreationProtocols.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 14/05/2026.
//

import Foundation

protocol HabitCreationViewProtocol: TrackerCreationViewProtocol {
    func presentScheduleScreen(initialSchedule: Set<Weekday>)
}
