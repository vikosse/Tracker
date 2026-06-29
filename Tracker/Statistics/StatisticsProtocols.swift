//
//  StatisticsProtocols.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 10/05/2026.
//

import Foundation

// MARK: - Statistics Data Model

struct StatisticsData {
    let bestPeriod: Int
    let perfectDays: Int
    let trackersCompleted: Int
    let averageValue: Int
}

// MARK: - View Protocol

protocol StatisticsViewProtocol: AnyObject {
    func showStatistics(_ data: StatisticsData)
    func showEmptyState()
}

// MARK: - Presenter Protocol

protocol StatisticsPresenterProtocol: AnyObject {
    func viewWillAppear()
}
