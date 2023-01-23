//
//  ProfileFilterView.swift
//  Twitter Clone
//
//  Created by Arpan Bhowmik on 22/1/23.
//

import UIKit

protocol ProfileFilterViewDelegate: AnyObject {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath)
}

class ProfileFilterView: UIView {
    weak var delegate: ProfileFilterViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: ProfileFilterCell.reuseIdentifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        
        let selectedIndex = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: .left)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

//MARK: - UICollectionView Delegate and DataSource

extension ProfileFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileFilterCell.reuseIdentifier, for: indexPath) as! ProfileFilterCell
        cell.option = ProfileFilterOptions(rawValue: indexPath.row) ?? .tweets
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self, didSelect: indexPath)
    }
}

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(ProfileFilterOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
