//
//  MovieDetailVM.swift
//  Yogesh Hungama
//
//  Created by Encoding Solutions on 18/07/21.
//

import Foundation
class MovieDetailVM : NSObject {
    override init() {
        super.init()
    }
    var movieCredit : MovieCreditClass?
    var similarMovies : [Movie]?
    init(controller:ProgressDelegate){
        super.init()
        self.delegate = controller
    }
    
    var delegate : ProgressDelegate?
    
    func getMovieCredit(movieID:String){
        
        
        NetworkServices.shared.getMovieCast(movieID: movieID) { [self] (result) in
            
            
            DispatchQueue.main.async { [self] in
                delegate?.hideLoadingIndicator()
                delegate?.reloadTableview()
            }
            
            switch result{
            case .success(let data):
                movieCredit = data
                
            case .failure( _):
                movieCredit = nil
                break
            }
            
            
            
            
            
            
        }
    }
    
    
    func getSimilarMovies(movieID:String){
        NetworkServices.shared.getSimilarMovies(movieID: movieID) { [self] (result) in
            DispatchQueue.main.async { [self] in
                delegate?.hideLoadingIndicator()
                delegate?.reloadTableview()
            }
            
            switch result{
            case .success(let data):
                similarMovies = data.results
                
            case .failure( _):
                similarMovies = nil
                break
            }
        }
    }
}
