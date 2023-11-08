//
//  Movie.swift
//  MovieApp
//
//  Created by Yakup on 5.11.2023.
//

import Foundation

struct SearchMovie: Codable {
	let search: [Movie]
	let totalResults, response: String

	enum CodingKeys: String, CodingKey {
		case search = "Search"
		case totalResults
		case response = "Response"
	}
}

struct Movie: Codable {
	let title, year, imdbID, type: String
	let poster: String

	enum CodingKeys: String, CodingKey {
		case title = "Title"
		case year = "Year"
		case imdbID
		case type = "Type"
		case poster = "Poster"
	}
}
