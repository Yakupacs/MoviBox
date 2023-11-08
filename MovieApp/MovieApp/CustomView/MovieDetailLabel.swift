//
//  DetailLabel.swift
//  MovieApp
//
//  Created by Yakup on 7.11.2023.
//

import Foundation
import UIKit

class MovieDetailLabel: UILabel{
	init(frame: CGRect, feature: String) {
		super.init(frame: frame)
		setupView(feature: feature)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView(feature: String){
		translatesAutoresizingMaskIntoConstraints = false
		font = UIFont(name: "Avenir-Heavy", size: 14)
		textColor = UIColor(named: "descriptionColor")
		textAlignment = .left
		text = "\(feature): Unknown"
	}
}
