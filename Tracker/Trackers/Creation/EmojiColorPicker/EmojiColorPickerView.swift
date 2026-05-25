//
//  EmojiColorPickerView.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 24/05/2026.
//

import UIKit

protocol EmojiColorPickerViewDelegate: AnyObject {
    func emojiColorPicker(_ view: EmojiColorPickerView, didSelectEmojiAt index: Int)
    func emojiColorPicker(_ view: EmojiColorPickerView, didSelectColorAt index: Int)
}

final class EmojiColorPickerView: UIView {
    
    // MARK: - Nested Types
    
    private enum Section: Int, CaseIterable {
        case emoji, color
        
        var title: String {
            switch self {
            case .emoji: return "Emoji"
            case .color: return "Цвет"
            }
        }
    }
    
    // MARK: - Properties
    
    weak var delegate: EmojiColorPickerViewDelegate?
    
    var selectedEmojiIndex: Int? {
        didSet { refreshSelection(in: .emoji, oldIndex: oldValue, newIndex: selectedEmojiIndex) }
    }
    
    var selectedColorIndex: Int? {
        didSet { refreshSelection(in: .color, oldIndex: oldValue, newIndex: selectedColorIndex) }
    }
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = CGSize(width: 0, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 24, right: 18)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = false
        view.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        view.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        view.register(
            PickerSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PickerSectionHeaderView.reuseIdentifier
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selection refresh
    
    private func refreshSelection(in section: Section, oldIndex: Int?, newIndex: Int?) {
        if let old = oldIndex, old != newIndex {
            configureCell(at: IndexPath(item: old, section: section.rawValue), isSelected: false)
        }
        if let new = newIndex {
            configureCell(at: IndexPath(item: new, section: section.rawValue), isSelected: true)
        }
    }
    
    private func configureCell(at indexPath: IndexPath, isSelected: Bool) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .emoji:
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else { return }
            cell.configure(
                emoji: TrackerConstants.availableEmojis[indexPath.item],
                isSelected: isSelected
            )
        case .color:
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else { return }
            cell.configure(
                color: TrackerConstants.availableColors[indexPath.item],
                isSelected: isSelected
            )
        }
    }
    
    // MARK: - Intrinsic Size
    
    override var intrinsicContentSize: CGSize {
        collectionView.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: collectionView.contentSize.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.height != collectionView.contentSize.height {
            invalidateIntrinsicContentSize()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension EmojiColorPickerView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .emoji: return TrackerConstants.availableEmojis.count
        case .color: return TrackerConstants.availableColors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch section {
        case .emoji:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCell.reuseIdentifier,
                for: indexPath
            ) as? EmojiCell else { return UICollectionViewCell() }
            cell.configure(
                emoji: TrackerConstants.availableEmojis[indexPath.item],
                isSelected: selectedEmojiIndex == indexPath.item
            )
            return cell
        case .color:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCell.reuseIdentifier,
                for: indexPath
            ) as? ColorCell else { return UICollectionViewCell() }
            cell.configure(
                color: TrackerConstants.availableColors[indexPath.item],
                isSelected: selectedColorIndex == indexPath.item
            )
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let section = Section(rawValue: indexPath.section),
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PickerSectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? PickerSectionHeaderView
        else { return UICollectionReusableView() }
        header.configure(title: section.title)
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension EmojiColorPickerView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .emoji:
            delegate?.emojiColorPicker(self, didSelectEmojiAt: indexPath.item)
        case .color:
            delegate?.emojiColorPicker(self, didSelectColorAt: indexPath.item)
        }
    }
}
