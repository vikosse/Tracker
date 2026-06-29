//
//  TrackersViewControllerSnapshotTests.swift
//  TrackerTests
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewControllerSnapshotTests: XCTestCase {

    func testEmptyStateSnapshot() {
        let sut = makeTrackersViewController()
        assertSnapshot(matching: sut, as: .image)
    }

    // MARK: - Factory

    private func makeTrackersViewController() -> UIViewController {
        let trackerStore = TrackerStore()
        let recordStore = TrackerRecordStore()
        let presenter = TrackersPresenter(
            trackerStore: trackerStore,
            recordStore: recordStore
        )
        let vc = TrackersViewController()
        vc.presenter = presenter
        presenter.view = vc
        let nav = UINavigationController(rootViewController: vc)
        nav.overrideUserInterfaceStyle = .light
        return nav
    }
}
