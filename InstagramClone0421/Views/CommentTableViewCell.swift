//
//  CommentTableViewCell.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/25.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            updateView()
        }
    }
    
    var user: UserModel? {
        didSet {
            setUserInfo()
        }
    }
    
    
    func updateView() {
        commentLabel.text = comment?.commentText
    }
    
    func setUserInfo() {
        self.nameLabel.text = user?.username
        if let profilePhotoUrlString = user?.profileImageURL {
            let profilePhotoUrl = URL(string: profilePhotoUrlString)
            profileImageView.sd_setImage(with: profilePhotoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 18
        
        commentLabel.numberOfLines = 0
        commentLabel.text = ""
        nameLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("111111")
        profileImageView.image = UIImage(named: "placeholderImg")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
