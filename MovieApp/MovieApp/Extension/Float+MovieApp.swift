//
//  Float+MovieApp.swift
//  MovieApp
//
//  Created by Yakup on 8.11.2023.
//

import Foundation
import UIKit

extension Float{
	func getStarCount() -> Int{
		if self >= 8.0 && self <= 10.0 {
			return 5
		}else if self >= 6.0 && self < 8.0{
			return 4
		}else if self >= 4.0 && self < 6.0{
			return 3
		}else if self >= 2.0 && self < 4.0{
			return 2
		}else if self >= 0.0 && self < 2.0{
			return 1
		}else{
			return 0
		}
	}
}
