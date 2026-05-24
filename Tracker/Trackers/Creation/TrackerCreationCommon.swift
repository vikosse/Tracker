//
//  TrackerCreationCommon.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 21/05/2026.
//

import Foundation

// MARK: - Delegate

protocol TrackerCreationDelegate: AnyObject {
    func trackerCreationDidCreate(_ tracker: Tracker, inCategory categoryTitle: String)
    func trackerCreationDidCancel()
}

// MARK: - Common View Protocol

protocol TrackerCreationViewProtocol: AnyObject {
    func reloadOptions()
    func setCreateButtonEnabled(_ isEnabled: Bool)
    func setNameError(_ message: String?)
}

// MARK: - Base Presenter

class BaseTrackerCreationPresenter {
    
    // MARK: - Properties
    
    weak var view: TrackerCreationViewProtocol?
    weak var delegate: TrackerCreationDelegate?
    
    var name: String = ""
    
    var categoryTitle: String = TrackerConstants.defaultCategoryTitle
    
    // MARK: - Lifecycle
    
    func viewDidLoad() {
        view?.reloadOptions()
        view?.setCreateButtonEnabled(isCreateAllowed)
    }
    
    // MARK: - User Input
    
    func didChangeName(_ text: String) {
        name = text
        view?.setCreateButtonEnabled(isCreateAllowed)
    }
    
    func didTapCategoryRow() {}
    
    func didTapCancel() {
        delegate?.trackerCreationDidCancel()
    }
    
    func didTapCreate() {
        guard isCreateAllowed else { return }
        delegate?.trackerCreationDidCreate(makeTracker(), inCategory: categoryTitle)
    }
    
    // MARK: - Overridable
    
    var isCreateAllowed: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func makeTracker() -> Tracker {
        Tracker(
            id: UUID(),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            color: TrackerConstants.randomColor(),
            emoji: TrackerConstants.randomEmoji(),
            schedule: []
        )
    }
    
    // MARK: - Table Data
    
    func numberOfOptionRows() -> Int { 1 }
    
    func titleForOptionRow(at index: Int) -> String {
        TrackerConstants.categoryTitle
    }
    
    func subtitleForOptionRow(at index: Int) -> String? {
        categoryTitle
    }
}
