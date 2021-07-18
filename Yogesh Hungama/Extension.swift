//
//  Extension.swift
//  Yogesh Hungama
//
//  Created by Encoding Solutions on 18/07/21.
//

import Foundation
import UIKit
import MBProgressHUD


extension UIViewController {
    
    @objc func showIndicator(with progress : MBProgressHUD, title: String, and Description:String?) {
        //      let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        progress.label.text = title
        progress.isUserInteractionEnabled = false
        progress.detailsLabel.text = Description
        progress.show(animated: true)
    }
    
    @objc func hideIndicator(progress : MBProgressHUD) {
        DispatchQueue.main.async {
            progress.hide(animated: true)
        }
        
    }
}



extension UILabel{
    func set(fontName: String, fontSize: Float, txtColor: UIColor){
        
        self.font = UIFont(name: fontName, size: CGFloat(fontSize))
        self.textColor = txtColor
    }
}
extension String {
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
              let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
              !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
}
