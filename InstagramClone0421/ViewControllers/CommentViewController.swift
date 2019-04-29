//
//  CommentViewController.swift
//  InstagramClone0421
//
//  Created by mt on 2019/04/25.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var comments = [Comment]()
    var users = [UserModel]()
    
    var postId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadComment()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        handleTextField()
        sendBtnDefault()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        configureObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Keyboardが現れた時Viewをずらす。
    func keyboardWillShow(notification: Notification?) {
        if commentTextField.isFirstResponder {
            let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!, animations: { () in
                let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
                self.view.transform = transform
            })
        }
    }
    
    // Keyboardが消えたときViewを戻す
    func keyboardWillHide(notification: Notification?) {
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            self.view.transform = CGAffineTransform.identity
        })
    }

    
    func loadComment() {
        self.activityIndicator.startAnimating()
        Api.PostComment.REF_POST_COMMENT.child(self.postId).observe(.childAdded, with: { (DataSnapshot) in
            Api.Comment.observeComments(commentId: DataSnapshot.key, completed: { (newComment) in
                self.fetchUser(uid: newComment.uid!, completed: {
                    self.comments.append(newComment)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.tableView.reloadData()
                })
            })
        })
    }
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.User.observeUser(withId: uid, completion: { (user) in
            self.users.append(user)
            completed()
        })
    }
    
    func sendBtnDefault() {
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.isEnabled = false
    }
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    func textFieldDidChange() {
        guard let commentText = commentTextField.text, !commentText.isEmpty  else {
            sendBtnDefault()
            return
        }
        
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.isEnabled = true
    }
    
    
    @IBAction func sendBtn_TouchUpInside(_ sender: Any) {
        let commentsRef = Api.Comment.REF_COMMENTS
        let newCommentsId = commentsRef.childByAutoId().key
        let newCommentsRef = commentsRef.child(newCommentsId!)
        let uid = Api.User.CURRENT_USER?.uid
        newCommentsRef.setValue(["commentText": commentTextField.text!, "uid": uid!]) { (Error, DatabaseReference) in
            if Error != nil {
                ProgressHUD.showError(Error?.localizedDescription)
            }
        }
        
        let postCommentRef = Api.PostComment.REF_POST_COMMENT
        let newPostCommentRef = postCommentRef.child(self.postId).child(newCommentsId!)
        newPostCommentRef.setValue(true) { (Error, DatabaseReference) in
            if Error != nil {
                ProgressHUD.showError(Error?.localizedDescription)
            }
        }
        
        clean()
        sendBtnDefault()
    }
    
    func clean() {
        commentTextField.text = ""
    }
    
    
}
extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell
    }
    
    
}

