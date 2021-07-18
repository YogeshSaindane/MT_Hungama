//
//  MovieListVM.swift
//  Yogesh Hungama
//
//  Created by Encoding Solutions on 18/07/21.
//

import Foundation


class MovieListVM: NSObject {
    override init() {
        super.init()
    }
    
    var movieList : [Movie]?
    var originalSearch : [Movie]?
    var recentMovie : [Movie]?
    init(controller:ProgressDelegate){
        super.init()
        self.delegate = controller
        recentMovie = UserdefaultsClass.shared.getRecentMovies()
    }
    
    var delegate : ProgressDelegate?
    
    func fetchMovies(pageNo:Int){
        delegate?.showLoadingIndicator()
        NetworkServices.shared.getMovieList(pageNo: pageNo) { [self] (result) in
            DispatchQueue.main.async {
                delegate?.hideLoadingIndicator()
                delegate?.reloadTableview()
            }
            
            switch result{
            case .success(let data):
                if(movieList == nil){
                    movieList = data.results
                }else{
                movieList?.append(contentsOf: data.results!)
                }
                
                originalSearch = movieList
            case .failure( _):
                movieList = nil
                break
            }
            
            
            
        }
        
    }
    
    
}

