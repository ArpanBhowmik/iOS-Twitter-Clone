//
//  TweetController.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 24/1/23.
//

import UIKit

class TweetController: UICollectionViewController {
    private var tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TweetHeader.reuseIdentifier)
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.reuseIdentifier)
    }
}

//MARK: UICollectionView DataSource

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweet
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TweetHeader.reuseIdentifier, for: indexPath) as! TweetHeader
        header.tweet = tweet
        return header
    }
}

//MARK: UICollectionViewFlowLayoutDelegate
extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 260)
    }
}
