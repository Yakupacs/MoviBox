//
//  filterRadioButton.swift
//  MovieApp
//
//  Created by Yakup on 7.11.2023.
//

import Foundation
import UIKit

class FilterRadioButton: UIButton{
	init(frame: CGRect, kind: String) {
		super.init(frame: frame)
		setupView(kind: kind)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView(kind: String){
		translatesAutoresizingMaskIntoConstraints = false
		setTitleColor(.white, for: .normal)
		setTitle(" \(kind)", for: .normal)
		titleLabel?.font = UIFont(name: "Avenir", size: 15)
		setImage(UIImage(systemName: "circle"), for: .normal)
		tintColor = .white
	}
}
