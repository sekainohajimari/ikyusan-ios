//
//  LikeListViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/02.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import Bond

class LikeListViewController: BaseViewController,
    UITableViewDelegate {

    @IBOutlet weak var likeTableView: UITableView!
    
    var list = DynamicArray<Like>([])

    var tableViewDataSourceBond: UITableViewDataSourceBond<UITableViewCell>!
    
    var groupId :Int
    var topicId :Int
    var ideaId  :Int
    
    init(groupId :Int, topicId :Int, ideaId :Int) {
        self.groupId = groupId
        self.topicId = topicId
        self.ideaId  = ideaId
        super.init(nibName: "LikeListViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        likeTableView.delegate = self
//        likeTableView.dataSource = self
        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.likeTableView)
        likeTableView.removeSeparatorsWhenUsingDefaultCell()
        
        self.navigationItem.title = kNavigationTitleLikeList
        
        self.setBackButton()

        self.list.map { [unowned self] (like: Like) -> MemberTableViewCell in
            let cell = MemberTableViewCell.getView("MemberTableViewCell") as! MemberTableViewCell

            map(like.likeUser.profile.iconUrl, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { str in
                var url = NSURL(string: str)
                if let existUrl = url {
                    var data = NSData(contentsOfURL: existUrl)
                    if let existData = data {
                        return UIImage(data: existData)!
                    } else {
                        return UIImage()
                    }
                } else {
                    return UIImage()
                }

                } ->> cell.avatarImageView.dynImage

            cell.avatarImageView?.layer.cornerRadius = cell.avatarImageView!.getWidth() / 2
            cell.avatarImageView?.layer.masksToBounds = true

            like.likeUser.profile.displayName ->> cell.nameLabel.dynText
            like.num.map { num in
                return String(num)
            } ->> cell.subLabel.dynText

            return cell

        } ->> self.tableViewDataSourceBond
        
        self.requestLikes(self.groupId, topicId:self.topicId, ideaId:self.ideaId)
    }
    
    func requestLikes(groupId :Int, topicId :Int, ideaId :Int) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.LikeList(groupId: groupId, topicId: topicId, ideaId: ideaId)) { response in
            switch response {
            case .Success(let box):
                println(box.value)

                for like in box.value {
                    self.list.append(like)
                }

                hideLoading()
            case .Failure(let box):
                println(box.value) // NSError
                hideLoading()
            }
        }
    }

    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }

}
