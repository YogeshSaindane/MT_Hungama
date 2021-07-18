//
//  MovieListTableViewCell.swift
//  Yogesh Hungama
//
//  Created by Encoding Solutions on 18/07/21.
//

import UIKit
import SDWebImage
class MovieListTableViewCell: UITableViewCell {
   
    static let identifier = "MovieListTableViewCell"
    static func getNib()-> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }

    @IBOutlet var imageView_poster: UIImageView!
    @IBOutlet var lbl_movieTitle: UILabel!
    @IBOutlet var lbl_releaseDate: UILabel!
    @IBOutlet var lbl_description: UILabel!
    @IBOutlet var btn_play: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.setCellUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCellData(movie: Movie){
        
        var imageStr = ConstantURL.baseImageURL
        if(movie.posterPath != nil){
            imageStr += movie.posterPath!
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
        
        
        lbl_movieTitle.text = movie.title
        lbl_description.text = movie.overview
        lbl_releaseDate.text = movie.releaseDate
        
        
 
    }
    
    func setCellUI(){
        lbl_movieTitle.set(fontName: FontName.Helvetica, fontSize: FontSize.size16, txtColor: UIColor.darkGray)
        lbl_releaseDate.set(fontName: FontName.Helvetica, fontSize: FontSize.size14, txtColor: UIColor.lightGray)
        lbl_description.set(fontName: FontName.Helvetica, fontSize: FontSize.size12, txtColor: UIColor.lightGray)
        
        
    }
    
    
}
