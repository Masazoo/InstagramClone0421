//
//  PeopleTableViewCell.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/29.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import SDWebImage

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var user: UserModel? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        nameLabel.text = user?.username
        if let profileImageUrlString = user?.profileImageURL {
            let profileImageUrl = URL(string: profileImageUrlString)
            profileImageView.sd_setImage(with: profileImageUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 18
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    
    @IBAction func followBtn_TouchUpInside(_ sender: Any) {
        
    }
    
}
