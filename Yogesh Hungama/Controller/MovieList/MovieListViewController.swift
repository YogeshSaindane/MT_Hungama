//
//  MovieListViewController.swift
//  Yogesh Hungama
//
//  Created by Encoding Solutions on 18/07/21.
//

import UIKit
import MBProgressHUD
import SDWebImage
class MovieListViewController: UIViewController {

    @IBOutlet var movieSearchBar: UISearchBar!
    
    @IBOutlet var movieListTableView: UITableView!
    var Indicator : MBProgressHUD!
    private var pageNo = 0
    var listVM : MovieListVM?
    @IBOutlet var recentTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ConstantMessage.searchMovies
        Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        listVM = MovieListVM(controller: self)
        pageNo += 1
        listVM?.fetchMovies(pageNo: pageNo)
        registerCell()
    
        
    }
    
    func registerCell(){
        movieListTableView.register(MovieListTableViewCell.getNib(), forCellReuseIdentifier: MovieListTableViewCell.identifier)
        
        recentTableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension MovieListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == movieListTableView){
            return listVM?.movieList?.count ?? 0
        }else{
            return listVM?.recentMovie?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        
        
        if(tableView == movieListTableView){
            let currentMovie = (listVM?.movieList![indexPath.row])!
            let cell = movieListTableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as! MovieListTableViewCell
            cell.setCellData(movie: currentMovie)
            return cell
        }else{
            let currentMovie = (listVM?.recentMovie![indexPath.row])!
            let cell = recentTableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = currentMovie.title
            var imageStr = ConstantURL.baseImageURL
            if(currentMovie.posterPath != nil){
                imageStr += currentMovie.posterPath!
            }
            let mngr = SDWebImageManager.shared
            mngr.loadImage(with: URL(string: imageStr), options: [], progress: { receivedSize, expectedSize, imgurl in
            }, completed: { image,data, error, cacheType, finished, imageURL in
                if image != nil {
                    cell.imageView!.image = image
                }else{
                    cell.imageView!.image = nil
                    
                }
            })
            
            return cell
        }
        
        
        
        
    }
   
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView == recentTableview){
            return ConstantMessage.recentlySearched
            
        }else{
            return nil
        }
    }
}


extension MovieListViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        var currentMovie : Movie!
        if(tableView == movieListTableView){
             currentMovie = (listVM?.movieList![indexPath.row])!
        }else{
            currentMovie = (listVM?.recentMovie![indexPath.row])!
        }
        movieSearchBar.endEditing(true)
        UserdefaultsClass.shared.storeMovieInRecentSearch(movie: currentMovie)
//        listVM?.recentMovie = UserdefaultsClass.shared.getRecentMovies()
        let detailVC = MovieDetailViewController()
        detailVC.currentMovie = currentMovie
        self.navigationController?.pushViewController(detailVC, animated: true)
          
    }
    
}
extension MovieListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if  maximumOffset - currentOffset <= 10.0{
//            self.showIndicator(Title: ConstantMessage.pleaseWait, and: "")
            self.showIndicator(with: Indicator, title: ConstantMessage.pleaseWait, and: "")
            pageNo += 1
            listVM?.fetchMovies(pageNo: pageNo)
        } else {
            self.hideIndicator(progress : Indicator)
        }
         
    }
}
extension MovieListViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
       
        if(listVM?.originalSearch != nil){
            let filteredArray = listVM?.originalSearch!.filter {
                
                
                let indicies = $0.title!.lowercased().indicesOf(string: searchText.lowercased())
                if(indicies.count > 0){
                    return true
                }else{
                    return false
                }
            }
            
            
            listVM?.movieList = filteredArray
            if(searchText == ""){
                listVM?.movieList = listVM?.originalSearch
            }
            
            self.movieListTableView.reloadData()
            
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        searchBar.text = ""
        resignFirstResponder()
        self.view.endEditing(true)
        
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        recentTableview.isHidden = false
        listVM?.recentMovie = UserdefaultsClass.shared.getRecentMovies()
        if(listVM?.recentMovie?.count == 0){
            recentTableview.isHidden = true
        }
        
        recentTableview.reloadData()
        
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        recentTableview.isHidden = true
        return true
    }
    
}


extension MovieListViewController : ProgressDelegate{
    func showLoadingIndicator() {
        self.showIndicator(with: Indicator, title: ConstantMessage.pleaseWait, and: "")
    }
    
    func hideLoadingIndicator() {
        self.hideIndicator(progress : Indicator)
    }
    
    func reloadTableview() {
        movieListTableView.reloadData()
    
    }
    
    
}

