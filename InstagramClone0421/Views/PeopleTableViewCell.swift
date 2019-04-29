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
        
        if user!.isFollowing! {
            followBtn.setTitle("フォロー中", for: .normal)
            followBtn.addTarget(self, action: #selector(self.unFollowAction), for: .touchUpInside)
        }else{
            followBtn.setTitle("フォローする", for: .normal)
            followBtn.addTarget(self, action: #selector(self.followAction), for: .touchUpInside)
        }
        
    }
    
    func followAction() {
        if !user!.isFollowing! {
            Api.follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(user!.uid!).setValue(true)
            Api.follow.REF_FOLLOWERS.child(user!.uid!).child(Api.User.CURRENT_USER!.uid).setValue(true)
            followBtn.addTarget(self, action: #selector(self.unFollowAction), for: .touchUpInside)
            followBtn.setTitle("フォロー中", for: .normal)
            user!.isFollowing! = true
        }
    }
    
    func unFollowAction() {
        if user!.isFollowing! {
            Api.follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(user!.uid!).setValue(NSNull())
            Api.follow.REF_FOLLOWERS.child(user!.uid!).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
            followBtn.addTarget(self, action: #selector(self.followAction), for: .touchUpInside)
            followBtn.setTitle("フォローする", for: .normal)
            user!.isFollowing! = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    
    
}
