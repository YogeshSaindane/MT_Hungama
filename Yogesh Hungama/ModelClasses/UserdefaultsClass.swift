//
//  UserdefaultsClass.swift
//  Yogesh Hungama
//
//  Created by Encoding Solutions on 19/07/21.
//

import Foundation

class UserdefaultsClass {
    
    private static var current : UserdefaultsClass?
    
    static var shared : UserdefaultsClass {
        if current == nil {
            current = UserdefaultsClass()
        }
        return current!
    }
    
    static func deleteInstance(){
        current = nil
    }
    
    func getRecentMovies() ->[Movie] {
        var searchList = [Movie]()
        if let storedMovies = UserDefaults.standard.value(forKey: ConstantMessage.recentSearch) as? Data {
    
            do{
                let decoder = JSONDecoder()
                searchList = try decoder.decode([Movie].self, from: storedMovies)
                
            }catch {
                print(error.localizedDescription)
            }
            
        }
        return searchList
        
    }
    func storeMovieInRecentSearch(movie: Movie){
        
        var searchList = [Movie]()
        
        if let storedMovies = UserDefaults.standard.value(forKey: ConstantMessage.recentSearch) as? Data {
    
            do{
                let decoder = JSONDecoder()
                searchList = try decoder.decode([Movie].self, from: storedMovies)
               
                
            }catch {
                print(error.localizedDescription)
            }
          
            
            
           
            if (searchList.count > 4){
                searchList.removeLast()
                
            }else{
                
                let index = searchList.firstIndex { (temp) -> Bool in
                    if(temp.id == movie.id){
                        return true
                    }else{
                        return false
                    }
                }
            
                if(index != nil){
                    searchList.remove(at: index!)
                }
                
                searchList.insert(movie, at: 0)
            }
            
        }else{
            searchList.append(movie)
        }
     
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(searchList) {
                UserDefaults.standard.set(encoded, forKey: ConstantMessage.recentSearch)
                UserDefaults.standard.synchronize()
            }else{
                print("error")
            }
            
        
      
        
        
    }
    
    
    
}
