//
//  Tracker.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 18/05/2026.
//

import UIKit

struct Tracker: Equatable, Hashable {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<Weekday>
}
