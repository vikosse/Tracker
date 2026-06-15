//
//  OnboardingPageModel.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 15/06/2026.
//

import UIKit

struct OnboardingPageModel {
    let backgroundImage: UIImage
    let text: String
}

extension OnboardingPageModel {

    private enum Strings {
        static let firstPageTitle = "Отслеживайте только то, что хотите"
        static let secondPageTitle = "Даже если это\nне литры воды и йога"
    }

    static let pages: [OnboardingPageModel] = [
        OnboardingPageModel(
            backgroundImage: UIImage(resource: .onboardingBackground1),
            text: Strings.firstPageTitle
        ),
        OnboardingPageModel(
            backgroundImage: UIImage(resource: .onboardingBackground2),
            text: Strings.secondPageTitle
        ),
    ]
}
