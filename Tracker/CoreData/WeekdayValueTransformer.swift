//
//  WeekdayValueTransformer.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 24/05/2026.
//

import Foundation

@objc
final class WeekdayValueTransformer: ValueTransformer {

    override class func transformedValueClass() -> AnyClass { NSData.self }

    override class func allowsReverseTransformation() -> Bool { true }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [Weekday] else { return nil }
        return try? JSONEncoder().encode(days)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([Weekday].self, from: data as Data)
    }

    static func register() {
        ValueTransformer.setValueTransformer(
            WeekdayValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: WeekdayValueTransformer.self))
        )
    }
}
