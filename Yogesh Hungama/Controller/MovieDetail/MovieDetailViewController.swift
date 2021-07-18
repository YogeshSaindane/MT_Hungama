//
//  MovieDetailViewController.swift
//  Yogesh Hungama
//
//  Created by Encoding Solutions on 18/07/21.
//

import UIKit
import SDWebImage
import MBProgressHUD

class MovieDetailViewController: UIViewController {

    @IBOutlet var imageView_poster: UIImageView!
    @IBOutlet var lbl_movieTitle: UILabel!
    @IBOutlet var lbl_releaseDate: UILabel!
    @IBOutlet var lbl_description: UILabel!
    @IBOutlet var lbl_language: UILabel!
    @IBOutlet var lbl_genre: UILabel!
    
    @IBOutlet var lbl_CastSection: UILabel!
    @IBOutlet var lbl_CrewSection: UILabel!
    @IBOutlet var lbl_similarMovieSection: UILabel!
    
    
    var Indicator : MBProgressHUD!
    
    @IBOutlet var cast_collectionView: UICollectionView!
    @IBOutlet var crew_collectionView: UICollectionView!
    @IBOutlet var similarMovies_collectionView: UICollectionView!
    var currentMovie: Movie!
    var detailVM : MovieDetailVM?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = currentMovie.title
        registerCells()
        if let flowLayout1 = cast_collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout1.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
        
        if let flowLayout2 = crew_collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout2.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
        
        if let flowLayout3 = similarMovies_collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout3.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
        

        detailVM = MovieDetailVM(controller: self)
        Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.setData()
        self.setUI()
        
        if(currentMovie.id != nil){
           
           
            detailVM?.getMovieCredit(movieID: "\(currentMovie.id!)")
            
           
            detailVM?.getSimilarMovies(movieID: "\(currentMovie.id!)")
            
        }
         
    }
    
    func registerCells(){
        crew_collectionView.register(MovieCreditCollectionViewCell.getNib(), forCellWithReuseIdentifier: MovieCreditCollectionViewCell.identifier)
        cast_collectionView.register(MovieCreditCollectionViewCell.getNib(), forCellWithReuseIdentifier: MovieCreditCollectionViewCell.identifier)
        similarMovies_collectionView.register(MovieCreditCollectionViewCell.getNib(), forCellWithReuseIdentifier: MovieCreditCollectionViewCell.identifier)
        
    }
    
    func setData(){
        
        var imageStr = ConstantURL.baseImageURL
        if(currentMovie.posterPath != nil){
            imageStr += currentMovie.backdropPath!
        }
        let mngr = SDWebImageManager.shared
        mngr.loadImage(with: URL(string: imageStr), options: [], progress: { receivedSize, expectedSize, imgurl in
        }, completed: { [self] image,data, error, cacheType, finished, imageURL in
            if image != nil {
               imageView_poster.image = image
            }else{
                imageView_poster.image = nil
                
            }
        })
        
        
        lbl_movieTitle.text = currentMovie.title
        lbl_description.text = currentMovie.overview
        lbl_releaseDate.text = currentMovie.releaseDate
        lbl_language.text = getMovieLanguage(langCode: currentMovie.originalLanguage ?? "")
        lbl_genre.text = getMovieGenre(arr: currentMovie.genreIDS ?? [])
        
 
    }
    
    func getMovieGenre(arr:[Int]) -> String{
        var str = ""
        for id in arr {
            
            str += MovieGenre.shared.genre[id] ?? ""
            str += ", "
        }
        return str
    }
    
    
    func getMovieLanguage(langCode:String) -> String{
        
       
            
        let  str = MovieLanguage.shared.laguages[langCode] ?? langCode
        return str
    }
    
    
    func setUI(){
        lbl_movieTitle.set(fontName: FontName.HelveticaBold, fontSize: FontSize.size24, txtColor: UIColor.darkGray)
        lbl_releaseDate.set(fontName: FontName.Helvetica, fontSize: FontSize.size16, txtColor: UIColor.lightGray)
        lbl_description.set(fontName: FontName.Helvetica, fontSize: FontSize.size16, txtColor: UIColor.darkGray)
        lbl_language.set(fontName: FontName.Helvetica, fontSize: FontSize.size16, txtColor: UIColor.lightGray)
        lbl_genre.set(fontName: FontName.Helvetica, fontSize: FontSize.size16, txtColor: UIColor.lightGray)
        
        lbl_CastSection.set(fontName: FontName.HelveticaBold, fontSize: FontSize.size24, txtColor: UIColor.white)
        lbl_CrewSection.set(fontName: FontName.HelveticaBold, fontSize: FontSize.size24, txtColor: UIColor.white)
        lbl_similarMovieSection.set(fontName: FontName.HelveticaBold, fontSize: FontSize.size24, txtColor: UIColor.white)
        
        
        
    }
}

extension MovieDetailViewController : ProgressDelegate{
    func showLoadingIndicator() {
        self.showIndicator(with: Indicator, title: ConstantMessage.pleaseWait, and: "")
    }
    
    func hideLoadingIndicator() {
        self.hideIndicator(progress : Indicator)
    }
    
    func reloadTableview() {
        
        cast_collectionView.reloadData()
        crew_collectionView.reloadData()
        similarMovies_collectionView.reloadData()
        
        
    
    }
}


extension MovieDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == crew_collectionView){
            return detailVM?.movieCredit?.crew.count ?? 0
            
        }else if(collectionView == cast_collectionView){
            return detailVM?.movieCredit?.cast.count ?? 0
            
        }else if(collectionView == similarMovies_collectionView){
            return detailVM?.similarMovies?.count ?? 0
            
        }
        
        return 0
         
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCreditCollectionViewCell.identifier , for: indexPath) as! MovieCreditCollectionViewCell
        
        if(collectionView == crew_collectionView){
            let cellItem = (detailVM?.movieCredit?.crew[indexPath.item])!
           
            
            return loadMovieCreditCollectionView(cell: cell, cellItem: cellItem)
            
        }else if(collectionView == cast_collectionView){
            let cellItem = (detailVM?.movieCredit?.cast[indexPath.item])!
            
            
            return loadMovieCreditCollectionView(cell: cell, cellItem: cellItem)
            
        }else if(collectionView == similarMovies_collectionView){
            let cellItem = (detailVM?.similarMovies?[indexPath.item])!
            
            return loadsimilarMovieCollectionView(cell: cell, cellItem: cellItem)
            
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 360, height: 400)
    }
    
    
    
    
    func loadMovieCreditCollectionView (cell:MovieCreditCollectionViewCell, cellItem: Cast) -> UICollectionViewCell{
    
        cell.setCastData(itemCast: cellItem)
        return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == similarMovies_collectionView){
            let cellItem = (detailVM?.similarMovies?[indexPath.item])!
            let detailVC = MovieDetailViewController()
                detailVC.currentMovie = cellItem
            UserdefaultsClass.shared.storeMovieInRecentSearch(movie: cellItem)
            
                self.navigationController?.pushViewController(detailVC, animated: true)
            
        }
        
        
        
    }
    
    func loadsimilarMovieCollectionView (cell: MovieCreditCollectionViewCell, cellItem: Movie)-> UICollectionViewCell{
    
        cell.setMovieData(movie: cellItem)
        return cell
    }
    
    
    
}





