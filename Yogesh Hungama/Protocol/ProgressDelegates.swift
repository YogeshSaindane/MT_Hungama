//
//  ProgressDelegates.swift
//  Yogesh Hungama
//
//  Created by Encoding Solutions on 18/07/21.
//

import UIKit
import Foundation


@objc protocol ProgressDelegate{
   
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func reloadTableview()
    
}
