//
//  UIColorValueTransformer.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 25/05/2026.
//

import UIKit

@objc(UIColorValueTransformer)
final class UIColorValueTransformer: NSSecureUnarchiveFromDataTransformer {
    
    override static var allowedTopLevelClasses: [AnyClass] {
        [UIColor.self]
    }
    
    static func register() {
        let transformer = UIColorValueTransformer()
        ValueTransformer.setValueTransformer(
            transformer,
            forName: NSValueTransformerName(rawValue: String(describing: UIColorValueTransformer.self))
        )
    }
}
