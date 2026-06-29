//
//  MainScreenAnalytics.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 19/06/2026.
//

import AppMetricaCore

enum MainScreenAnalytics {

    // MARK: - Screen

    static func open() {
        report(event: "open", item: nil)
    }

    static func close() {
        report(event: "close", item: nil)
    }

    // MARK: - Taps

    static func tapAddTrack() {
        report(event: "click", item: "add_track")
    }

    static func tapTrack() {
        report(event: "click", item: "track")
    }

    static func tapFilter() {
        report(event: "click", item: "filter")
    }

    static func tapEdit() {
        report(event: "click", item: "edit")
    }

    static func tapDelete() {
        report(event: "click", item: "delete")
    }

    // MARK: - Private

    private static func report(event: String, item: String?) {
        var parameters: [String: String] = ["screen": "Main"]
        if let item {
            parameters["item"] = item
        }
        AppMetrica.reportEvent(
            name: event,
            parameters: parameters,
            onFailure: { error in
                print(
                    "[Analytics] Failed to report '\(event)': \(error.localizedDescription)"
                )
            }
        )
    }
}
