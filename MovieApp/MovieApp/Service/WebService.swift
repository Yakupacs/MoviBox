//
//  WebService.swift
//  MovieApp
//
//  Created by Yakup on 5.11.2023.
//

import Foundation

class WebService: WebServiceProtocol{
	func searchMovies(searchText: String, page: String?, filterType: FilterType?, completion: @escaping (Result<SearchMovie, ErrorType>) -> ()){
		var urlString = Contants.URLs.baseURL + Contants.Paths.searchPath + searchText
		if let page{
			urlString.append(Contants.Paths.pagePath + page)
		}
		if let filterType{
			var filter = String()
			switch filterType{
			case .Movie:
				filter = "movie"
			case .Serie:
				filter = "series"
			case .Episode:
				filter = "episode"
			case .Game:
				filter = "game"
			}
			urlString.append(Contants.Paths.typeResultPath + filter)
		}
		let url = URL(string: urlString)!

		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error{
				completion(.failure(.serverError))
			}else if let data{
				do {
					let searchMovie = try JSONDecoder().decode(SearchMovie.self, from: data)
					completion(.success(searchMovie))
				} catch{
					completion(.failure(.decodingError))
				}
			}
		}.resume()
	}
	
	func getDetailsMovie(imdbID: String, completion: @escaping (Result<MovieDetail, ErrorType>) -> ()){
		let url = URL(string: Contants.URLs.baseURL + Contants.Paths.imdbIDPath + imdbID)!

		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error{
				completion(.failure(.serverError))
			}else if let data{
				do {
					let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
					completion(.success(movieDetail))
				}catch{
					completion(.failure(.decodingError))
				}
			}
		}.resume()
	}
}
