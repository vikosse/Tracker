//
//  TrackerCreationCommon.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 21/05/2026.
//

import UIKit

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
    func presentCategoryScreen(selectedCategory: String?)
}

// MARK: - Base Presenter

class BaseTrackerCreationPresenter {

    // MARK: - Properties

    weak var view: TrackerCreationViewProtocol?
    weak var delegate: TrackerCreationDelegate?

    var name: String = ""

    var categoryTitle: String? = nil

    private(set) var selectedEmojiIndex: Int?
    private(set) var selectedColorIndex: Int?

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

    func didTapCategoryRow() {
        view?.presentCategoryScreen(selectedCategory: categoryTitle)
    }

    func didConfirmCategory(_ title: String) {
        categoryTitle = title
        view?.reloadOptions()
        view?.setCreateButtonEnabled(isCreateAllowed)
    }

    func didTapCancel() {
        delegate?.trackerCreationDidCancel()
    }

    func didTapCreate() {
        guard isCreateAllowed else { return }
        delegate?.trackerCreationDidCreate(
            makeTracker(),
            inCategory: categoryTitle ?? TrackerConstants.defaultCategoryTitle
        )
    }

    func didSelectEmoji(at index: Int) {
        selectedEmojiIndex = (selectedEmojiIndex == index) ? nil : index
    }

    func didSelectColor(at index: Int) {
        selectedColorIndex = (selectedColorIndex == index) ? nil : index
    }

    // MARK: - Overridable

    var isCreateAllowed: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func makeTracker() -> Tracker {
        Tracker(
            id: UUID(),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            color: chosenColor(),
            emoji: chosenEmoji(),
            schedule: []
        )
    }

    // MARK: - Helpers for makeTracker

    func chosenEmoji() -> String {
        guard let index = selectedEmojiIndex,
              TrackerConstants.availableEmojis.indices.contains(index)
        else { return TrackerConstants.randomEmoji() }
        return TrackerConstants.availableEmojis[index]
    }

    func chosenColor() -> UIColor {
        guard let index = selectedColorIndex,
              TrackerConstants.availableColors.indices.contains(index)
        else { return TrackerConstants.randomColor() }
        return TrackerConstants.availableColors[index]
    }

    // MARK: - Table Data

    func numberOfOptionRows() -> Int { 1 }

    func titleForOptionRow(at index: Int) -> String {
        TrackerConstants.categoryTitle
    }

    func subtitleForOptionRow(at index: Int) -> String? {
        return categoryTitle
    }
}
