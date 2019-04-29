//
//  HomeTableViewCell.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/24.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var homeVC: HomeViewController?
    
    var post: Post? {
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
        captionLabel.text = post?.caption
        if let photoUrlString = post?.photoURL {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        
        self.updateLike(post: self.post!)
        
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
        
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        
        captionLabel.numberOfLines = 0
        captionLabel.text = ""
        nameLabel.text = ""
        
        let commentTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_TouchUpInside))
        commentImageView.addGestureRecognizer(commentTapGesture)
        commentImageView.isUserInteractionEnabled = true
        
        let likeTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
        likeImageView.addGestureRecognizer(likeTapGesture)
        likeImageView.isUserInteractionEnabled = true
    }
    
    func commentImageView_TouchUpInside() {
        if let id = post?.postId {
            homeVC?.performSegue(withIdentifier: "HomeToCommentSegue", sender: id)
        }
    }
    
    func likeImageView_TouchUpInside() {
        Api.Post.incrementsLikes(postId: post!.postId!, onSuccess: { (post) in
            self.updateLike(post: post)
            self.post?.likes = post.likes
            self.post?.likeCount = post.likeCount
            self.post?.isLiked = post.isLiked
        }) { (error) in
            ProgressHUD.showError(error)
        }
    }
    
    func updateLike(post: Post) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            likeCountBtn.setTitle("\(count) likes", for: .normal)
        } else {
            likeCountBtn.setTitle("最初のLikeを押してね", for: .normal)
        }
        
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
