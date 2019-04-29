//
//  PhotoCollectionViewCell.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/26.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myPostImageView: UIImageView!
    
    var myPost: Post? {
        didSet {
            updateMyPost()
        }
    }
    
    func updateMyPost() {
        if let myPostImageUrlString = myPost?.photoURL {
            let myPostImageUrl = URL(string: myPostImageUrlString)
            myPostImageView.sd_setImage(with: myPostImageUrl, placeholderImage: UIImage(named: "Placeholder-image"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myPostImageView.contentMode = .scaleAspectFill
        myPostImageView.clipsToBounds = true
    }
    
}
