//
//  ActorsCVC.swift
//  MovieApp
//
//  Created by Yakup on 6.11.2023.
//

import UIKit

class ActorsCVC: UICollectionViewCell {
	
	private let actorImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = 15
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let actorNameLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.white
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "Avenir", size: 11)
		label.textAlignment = .center
		label.numberOfLines = 0
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addViews()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setup(indexPath: IndexPath, actors: [String.SubSequence]){
		actorImageView.sd_setImage(with: URL(string: "https://www.shutterstock.com/image-vector/default-avatar-profile-icon-man-250nw-681058294.jpg"))
		actorNameLabel.text = actors[indexPath.row].capitalized
	}
	
	func addViews(){
		backgroundColor = .clear
		
		addSubview(actorImageView)
		addSubview(actorNameLabel)
		
		actorImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		actorImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
		actorImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
		actorImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		
		actorNameLabel.topAnchor.constraint(equalTo: actorImageView.bottomAnchor).isActive = true
		actorNameLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		actorNameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		actorNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		actorNameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
	}
}
