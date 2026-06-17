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
        static var firstPageTitle: String { NSLocalizedString("onboarding_page1_title", comment: "Текст первой страницы онбординга") }
        static var secondPageTitle: String { NSLocalizedString("onboarding_page2_title", comment: "Текст второй страницы онбординга") }
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
