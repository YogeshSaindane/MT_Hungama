//
//  NetworkServices.swift
//  Yogesh Hungama
//
//  Created by Encoding Solutions on 18/07/21.
//

import Foundation


class NetworkServices {
    
    private static var current : NetworkServices?
    
    static var shared : NetworkServices {
        if current == nil {
            current = NetworkServices()
        }
        return current!
    }
    
    static func deleteInstance(){
        current = nil
    }
    private init(){
        getGenre()
        getLanguages()
        
    }
    
    private func getData(with urlString:String, onCompletion : @escaping(Result<Data,Error>)->Void){
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if(error == nil && data != nil){
                onCompletion(.success(data!))
            }else{
                onCompletion(.failure(error!))
            }
        }
        dataTask.resume()
    }
    
    
    
    func getMovieList(pageNo: Int = 1, onCompletion: @escaping(Result<MovieDetails,Error>)->Void){
        // Create url
        let urlString = ConstantURL.nowPlayingUrl  + "\(pageNo)"
        
        
        getData(with: urlString) { (result) in
            switch result{
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieDetails.self, from: data)
                    onCompletion(.success(result))
                }catch let err{
                    print(err.localizedDescription)
                }
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
        
    }
    
    func getGenre(){
        getData(with: ConstantURL.genreURL) { result in
            switch result{
            case .success(let data):
                do{
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)as! NSDictionary
                    let genres = jsonDict.object(forKey: "genres") as! [[String:Any]]
                    var allGenre = [Int:String]()
                   _ = genres.map{
                    if( ($0 as [String:Any])["id"] != nil && ($0 as [String:Any])["name"] != nil){
                        allGenre[($0 as [String:Any])["id"] as! Int] = ($0 as [String:Any])["name"] as? String
                        }
                    }
                    MovieGenre.shared.genre = allGenre
                    print(MovieGenre.shared.genre)
                
                }catch let err{
                    print(err.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                break
                
            }
            
            
        }
    }
    
    
    func getLanguages(){
        getData(with: ConstantURL.languageURL) { result in
            switch result{
            case .success(let data):
                do{
                    let langArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)as! [[String:Any]]
//                    let genres = jsonDict.object(forKey: "genres") as! [[String:Any]]
                    var allGenre = [String:String]()
                   _ = langArray.map{
                    if( ($0 as [String:Any])["iso_639_1"] != nil && ($0 as [String:Any])["english_name"] != nil){
                        allGenre[($0 as [String:Any])["iso_639_1"] as! String] = ($0 as [String:Any])["english_name"] as? String
                        }
                    }
                    MovieLanguage.shared.laguages = allGenre
                    print(MovieGenre.shared.genre)
                
                }catch let err{
                    print(err.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                break
                
            }
            
            
        }
    }
    
    
    func getMovieCast(movieID : String, onCompletion: @escaping(Result<MovieCreditClass,Error>)->Void){
        let castURL = ConstantURL.castURL.replacingOccurrences(of: ConstantMessage.movieID, with: movieID)
        
        getData(with: castURL) { result in
            switch result{
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieCreditClass.self, from: data)
                    onCompletion(.success(result))
                }catch let err{
                    print(err.localizedDescription)
                }
            case .failure(let error):
                onCompletion(.failure(error))
            }
            
            
        }
    }
    
    func getSimilarMovies(movieID : String, onCompletion: @escaping(Result<MovieDetails,Error>)->Void){
        let castURL = ConstantURL.similarMoviesURL.replacingOccurrences(of: ConstantMessage.movieID, with: movieID)
        
        getData(with: castURL) { result in
            switch result{
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MovieDetails.self, from: data)
                    onCompletion(.success(result))
                }catch let err{
                    print(err.localizedDescription)
                }
            case .failure(let error):
                onCompletion(.failure(error))
            }
            
            
        }
    }
    
    
    
}
