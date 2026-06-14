//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 14/06/2026.
//

import UIKit

final class OnboardingViewController: UIPageViewController {

    // MARK: - Constants

    static let onboardingCompletedKey = "isOnboardingCompleted"

    private enum Layout {
        static let buttonBottomPadding: CGFloat = 50
        static let buttonHeight: CGFloat = 60
        static let labelButtonSpacing: CGFloat = 160
        static var labelBottomOffset: CGFloat { buttonBottomPadding + buttonHeight + labelButtonSpacing }
    }

    // MARK: - Pages

    private var pages: [UIViewController] = []

    // MARK: - UI

    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    private lazy var actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Вот это технологии!", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 16
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupOverlay()
        setupPages()
    }

    private func setupPages() {
        pages = OnboardingPageModel.pages.map {
            OnboardingPageViewController(model: $0, labelBottomOffset: Layout.labelBottomOffset)
        }
        pageControl.numberOfPages = pages.count
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: false)
        }
    }

    // MARK: - Layout

    private func setupOverlay() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(pageControl)
        view.addSubview(actionButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.buttonBottomPadding),
            actionButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -24),
        ])
    }

    // MARK: - Actions

    @objc private func actionButtonTapped() {
        UserDefaults.standard.set(true, forKey: OnboardingViewController.onboardingCompletedKey)

        guard let windowScene = view.window?.windowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }

        let tabBar = MainTabBarController()
        sceneDelegate.window?.rootViewController = tabBar
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let current = pageViewController.viewControllers?.first,
              let index = pages.firstIndex(of: current) else { return }
        pageControl.currentPage = index
    }
}
