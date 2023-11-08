//
//  ActorCollectionView.swift
//  MovieApp
//
//  Created by Yakup on 8.11.2023.
//

import Foundation
import UIKit

class ActorCollectionView: UICollectionView{

	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		setupViews()
	}
	
	func setupViews(){
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.minimumInteritemSpacing = 5
		layout.minimumLineSpacing = 5
		layout.itemSize = CGSize(width: 65, height: 75)
		collectionViewLayout = layout
		translatesAutoresizingMaskIntoConstraints = false
		register(ActorsCVC.self, forCellWithReuseIdentifier: "actorCell")
		backgroundColor = .clear
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
