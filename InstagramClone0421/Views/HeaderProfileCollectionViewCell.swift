//
//  HeaderProfileCollectionViewCell.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/26.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class HeaderProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    
    var user: UserModel? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
    }
    
    func updateView() {
        self.nameLabel.text = user!.username
        if let profilePhotoUrlString = user!.profileImageURL {
            let profilePhotoUrl = URL(string: profilePhotoUrlString)
            self.profileImageView.sd_setImage(with: profilePhotoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    

    
}
