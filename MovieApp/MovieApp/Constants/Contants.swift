//
//  Contants.swift
//  MovieApp
//
//  Created by Yakup on 5.11.2023.
//

import Foundation

private let API_KEY = "6d052b04"

struct Contants{
	struct URLs{
		static let baseURL = "https://www.omdbapi.com/?apikey=\(API_KEY)"
	}
	struct Paths{
		// Movie title to search for "s"
		static let searchPath = "&s="
		
		// Page number to return "page"
		static let pagePath = "&page="
		
		// A valid IMDb ID (e.g tt1285016) "i"
		static let imdbIDPath = "&i="
		
		// Movie title to search for "t"
		static let movieTitlePath = "&t="
		
		// Year of release "y"
		static let yearReleasePath = "&y="
		
		// Type of result to return "type"
		static let typeResultPath = "&type="
	}
}
