//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 12/06/2026.
//

import Foundation

final class CategoryViewModel {

    // MARK: - Bindings

    var onUpdate: (() -> Void)?
    var onCategorySelected: ((String) -> Void)?

    // MARK: - State

    private(set) var selectedTitle: String?

    // MARK: - Private

    private let store: TrackerCategoryStore

    // MARK: - Computed

    var numberOfCategories: Int { store.categories.count }

    // MARK: - Init

    init(
        selectedTitle: String? = nil,
        store: TrackerCategoryStore = TrackerCategoryStore()
    ) {
        self.selectedTitle = selectedTitle
        self.store = store
        store.delegate = self
        ensureDefaultCategoryExists()
    }

    // MARK: - Data

    func categoryTitle(at index: Int) -> String {
        store.categories[index].title ?? ""
    }

    func isSelected(at index: Int) -> Bool {
        categoryTitle(at: index) == selectedTitle
    }

    func hasTrackers(at index: Int) -> Bool {
        store.hasTrackers(at: index)
    }

    // MARK: - User Actions

    func selectCategory(at index: Int) {
        let title = categoryTitle(at: index)
        selectedTitle = title
        onCategorySelected?(title)
    }

    func addCategory(titled title: String) {
        try? store.findOrCreate(titled: title)
    }

    func renameCategory(at index: Int, to newTitle: String) {
        try? store.rename(at: index, to: newTitle)
    }

    func deleteCategory(at index: Int) {
        try? store.delete(at: index)
    }

    // MARK: - Private

    private func ensureDefaultCategoryExists() {
        try? store.findOrCreate(titled: TrackerConstants.defaultCategoryTitle)
    }
}

// MARK: - TrackerCategoryStoreDelegate

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func trackerCategoryStore(
        _ store: TrackerCategoryStore,
        didUpdate update: StoreUpdate
    ) {
        onUpdate?()
    }
}
