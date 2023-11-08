//
//  ActivityIndicator.swift
//  MovieApp
//
//  Created by Yakup on 8.11.2023.
//

import Foundation
import UIKit

class ActivityIndicator: UIActivityIndicatorView{
	init(frame: CGRect, color: UIColor) {
		super.init(frame: frame)
		setupView(color: color)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView(color: UIColor){
		hidesWhenStopped = true
		style = .large
		translatesAutoresizingMaskIntoConstraints = false
		startAnimating()
		self.color = color
	}
}
