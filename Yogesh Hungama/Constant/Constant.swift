//
//  Constant.swift
//  Yogesh Hungama
//
//  Created by Encoding Solutions on 18/07/21.
//

import Foundation

struct ConstantURL {
    static let baseURL = "https://api.themoviedb.org/3"
    static let baseImageURL = "https://image.tmdb.org/t/p/w500"
    static let apiKey = "b3a24ad4e2689e87771d837cb5f235d2"
    static let nowPlayingUrl = "\(baseURL)/movie/now_playing?api_key=\(apiKey)&page="
    static let genreURL = "\(baseURL)/genre/movie/list?api_key=\(apiKey)&language=en-US"
    static let languageURL = "\(baseURL)/configuration/languages?api_key=\(apiKey)"
    static let castURL = "\(baseURL)/movie/MOVIEID/credits?api_key=\(apiKey)&language=en-US"
    static let similarMoviesURL = "\(baseURL)/movie/MOVIEID/similar?api_key=\(apiKey)&language=en-US&page=1"
}

struct ConstantMessage {
    static let pleaseWait = "Please Wait..."
    static let movieID = "MOVIEID"
    static let recentSearch = "recentSearch"
    static let recentlySearched = "Recently Searched"
    static let searchMovies = "Search Movies"

}

struct FontName{
    static let HelveticaBold = "Helvetica-Bold"
    static let Helvetica = "Helvetica"
    static let HelveticaLight = "Helvetica"
}


struct FontSize {
    static let size26 :Float = 26.0
    static let size24 :Float = 24.0
    static let size22 :Float = 22.0
    static let size20 :Float = 20.0
    static let size18 :Float = 18.0
    static let size16 :Float = 16.0
    static let size14 :Float = 14.0
    static let size12 :Float = 12.0
    static let size10 :Float = 10.0
    
    
}

