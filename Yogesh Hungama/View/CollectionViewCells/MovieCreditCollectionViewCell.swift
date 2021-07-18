//
//  MovieCreditCollectionViewCell.swift
//  Yogesh Hungama
//
//  Created by Encoding Solutions on 18/07/21.
//

import UIKit
import SDWebImage

class MovieCreditCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var view_Container: UIView!
    static let identifier = "MovieCreditCollectionViewCell"
    
    static func getNib()-> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet var imageView_poster: UIImageView!
    @IBOutlet var lbl_Title: UILabel!
    @IBOutlet var lbl_DetailsTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setUI()
        self.setCellUI()
        
    }

    func setUI(){
        
        view_Container.layer.cornerRadius = 10
        imageView_poster.layer.cornerRadius = 10
        
        
    }
    
    func setMovieData(movie: Movie){
        
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
        
        lbl_Title.text = movie.title
        lbl_DetailsTitle.text = nil
    
    }
    var isHeightCalculated: Bool = false

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        //Exhibit A - We need to cache our calculation to prevent a crash.
        if !isHeightCalculated {
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
    }
    
    func setCastData(itemCast: Cast){
        
        var imageStr = ConstantURL.baseImageURL
        if(itemCast.profilePath != nil){
            imageStr += itemCast.profilePath!
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
        
        lbl_Title.text = itemCast.originalName
        lbl_DetailsTitle.text = itemCast.character
    
    }
    
    
    
    
    func setCellUI(){
        lbl_Title.set(fontName: FontName.Helvetica, fontSize: FontSize.size16, txtColor: UIColor.darkGray)
        lbl_DetailsTitle.set(fontName: FontName.Helvetica, fontSize: FontSize.size14, txtColor: UIColor.lightGray)
       
    }
     
}
