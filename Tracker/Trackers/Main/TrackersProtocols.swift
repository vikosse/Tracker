//
//  TrackersProtocols.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 10/05/2026.
//

import Foundation

// MARK: - View Protocol

protocol TrackersViewProtocol: AnyObject {
    func showPlaceholder()
    func hidePlaceholder()
    func reloadTrackers()
    func presentTrackerCreation()
}

// MARK: - Presenter Protocol

protocol TrackersPresenterProtocol: AnyObject {
    
    // MARK: - Lifecycle
    
    func viewDidLoad()
    
    // MARK: - User Actions
    
    func didTapAddButton()
    func didChangeDate(_ date: Date)
    func didChangeSearchText(_ text: String)
    func didTapTrackerAction(at indexPath: IndexPath)
    
    // MARK: - Collection View Data Source
    
    func numberOfSections() -> Int
    func numberOfTrackers(in section: Int) -> Int
    func tracker(at indexPath: IndexPath) -> Tracker
    func categoryTitle(forSection section: Int) -> String
    func isTrackerCompleted(at indexPath: IndexPath) -> Bool
    func completedCount(for trackerId: UUID) -> Int
    func isActionButtonEnabled() -> Bool
    
    // MARK: - Adding New Trackers
    
    func addTracker(_ tracker: Tracker, toCategoryTitled categoryTitle: String)
}
