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
    
    var list = ObservableArray<Like>([])
    
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
        likeTableView.removeSeparatorsWhenUsingDefaultCell()
        
        self.navigationItem.title = kNavigationTitleLikeList
        
        self.setBackButton()

        self.list.lift().bindTo(self.likeTableView) { (indexPath, array, tableView) -> UITableViewCell in
            let cell = MemberTableViewCell.getView("MemberTableViewCell") as! MemberTableViewCell
            let data = array[0][indexPath.row]

            data.likeUser.profile.iconUrl.deliverOn(Queue.Background).map { (urlString) -> UIImage in
                let url = NSURL(string: urlString)
                let data = NSData(contentsOfURL: url!)
                if let existData = data {
                    return UIImage(data: existData)!
                } else {
                    return UIImage()
                }
                }.deliverOn(Queue.Main).bindTo(cell.avatarImageView.bnd_image)

            data.likeUser.profile.displayName.bindTo(cell.nameLabel.bnd_text)

            data.num.map { (count) -> String in
                return String(count)
            }.bindTo(cell.subLabel.bnd_text)

            return cell
        }
        
        self.requestLikes(self.groupId, topicId:self.topicId, ideaId:self.ideaId)
    }
    
    func requestLikes(groupId :Int, topicId :Int, ideaId :Int) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.LikeList(groupId: groupId, topicId: topicId, ideaId: ideaId)) { response in
            switch response {
            case .Success(let box):
                pri(box.value)

                for like in box.value {
                    self.list.append(like)
                }

                hideLoading()
            case .Failure(let box):
                pri(box.value) // NSError
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
