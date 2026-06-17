//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 07/05/2026.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: StatisticsPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navigationItem.title = NSLocalizedString("statistics_title", comment: "Заголовок экрана статистики")
        
        presenter?.viewDidLoad()
    }
}

// MARK: - StatisticsViewProtocol

extension StatisticsViewController: StatisticsViewProtocol {
}
