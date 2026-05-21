//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 07/05/2026.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Nested Types
    
    private enum Tab {
        case trackers
        case statistics
        
        var title: String {
            switch self {
            case .trackers:
                return "Трекеры"
            case .statistics:
                return "Статистика"
            }
        }
        
        var iconName: String {
            switch self {
            case .trackers:
                return "record.circle.fill"
            case .statistics:
                return "hare.fill"
            }
        }
        
        var tabBarItem: UITabBarItem {
            UITabBarItem(
                title: title,
                image: UIImage(systemName: iconName),
                selectedImage: nil
            )
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    // MARK: - Setup
    
    private func setupTabs() {
        let trackersTab = makeTrackersTab()
        let statisticsTab = makeStatisticsTab()
        viewControllers = [trackersTab, statisticsTab]
    }
    
    private func makeTrackersTab() -> UINavigationController {
        
        let viewController = TrackersViewController()
        let presenter = TrackersPresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem = Tab.trackers.tabBarItem
        
        return navController
    }
    
    private func makeStatisticsTab() -> UINavigationController {
        let viewController = StatisticsViewController()
        let presenter = StatisticsPresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem = Tab.statistics.tabBarItem
        
        return navController
    }
}
