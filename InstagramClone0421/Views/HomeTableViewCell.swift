//
//  HomeTableViewCell.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/24.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
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
        
        Api.Post.REF_POSTS.child(post!.postId!).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: DataSnapshot.key)
                self.updateLike(post: post)
            }
        })
        
        Api.Post.REF_POSTS.child((post?.postId)!).observe(.childChanged, with: { (DataSnapshot) in
            if let value = DataSnapshot.value as? Int {
                self.likeCountBtn.setTitle("\(value) likes", for: .normal)
            }
        })
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
        let postRef = Api.Post.REF_POSTS.child(post!.postId!)
        incrementsLikes(forRef: postRef)
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
    
    
    func incrementsLikes(forRef ref: DatabaseReference) {
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                
                var likeCount = post["likeCount"] as? Int ?? 0
                
                if let _ = likes[uid] {
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
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
