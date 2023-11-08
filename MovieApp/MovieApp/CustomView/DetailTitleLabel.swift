//
//  DetailTitleLabel.swift
//  MovieApp
//
//  Created by Yakup on 7.11.2023.
//

import Foundation
import UIKit

class DetailTitleLabel: UILabel{
	init(frame: CGRect, title: String, size: CGFloat, textColor: UIColor) {
		super.init(frame: frame)
		setupView(title: title, size: size, textColor: textColor)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView(title: String, size: CGFloat, textColor: UIColor){
		translatesAutoresizingMaskIntoConstraints = false
		font = UIFont(name: "Avenir-Heavy", size: size)
		self.textColor = textColor
		text = title
	}
}
