//
//  IdeaListViewController.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/04/29.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import Toast
import ObjectMapper
import SlackTextViewController
import Bond

class IdeaListViewController: BaseViewController,
    UITableViewDelegate,
    UIActionSheetDelegate,
    IdeaTableViewCellDelegate {
    
    @IBOutlet weak var ideaTableView: UITableView!

    @IBOutlet weak var postTextView: SLKTextView!

    @IBOutlet weak var hideKeyboardTransparentButton: UIButton!

    @IBOutlet weak var postTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewContainerBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var postAvatarButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    let ideaCellIdentifier = "ideaCellIdentifier"

    var groupId :Int
    var topicId :Int
    var colorCodeId :Int = GroupColor.Red.rawValue
    var topicName :String = ""

    var list = DynamicArray<Idea>([])

    var tableViewDataSourceBond: UITableViewDataSourceBond<UITableViewCell>!

    // TODO: bad api!! grouping arguments??
    init(groupId :Int, topicId :Int, colorCodeId :Int, topicName :String) {
        self.groupId = groupId
        self.topicId = topicId
        self.colorCodeId = colorCodeId
        self.topicName = topicName

        super.init(nibName: "IdeaListViewController", bundle: nil)

        LikeHelper.sharedInstance.setBaseInfo(groupId, topicId: topicId)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    override func viewDidAppear(animated: Bool) {
        self.postTextView.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        ideaTableView.delegate = self
        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.ideaTableView)
        ideaTableView.removeSeparatorsWhenUsingDefaultCell()

        // TODO: 一定の文字数のときはフォントを小さくするとかも入れたい？？
        self.navigationItem.title = self.topicName
        
        var refresh:UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action:"onRefresh:", forControlEvents:.ValueChanged)
        self.ideaTableView.addSubview(refresh)
        
        self.setBackButton()

        postAvatarButton.layer.cornerRadius  = postAvatarButton.getWidth() / 2
        postAvatarButton.layer.masksToBounds = true

        postButton.tintColor = GroupColor(rawValue: self.colorCodeId)?.getColor()

        var sortButton = UIBarButtonItem().bk_initWithImage(UIImage(named: "icon_sort")!,
            style: UIBarButtonItemStyle.Plain,
            handler: { (t) -> Void in
                self.showSortActionSheet()
        }) as! UIBarButtonItem

        map(self.list.dynCount) { count in
            return self.list.count > 1
        } ->> sortButton.dynEnabled
        
        self.navigationItem.rightBarButtonItems = [sortButton]

        self.list.map { [unowned self] (idea:  Idea) -> IdeaTableViewCell in
            let cell = IdeaTableViewCell.getView("IdeaTableViewCell") as! IdeaTableViewCell
            cell.ideaTableViewCellDelegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            idea.identifier                     ->> cell.identifier
            idea.postUser.profile.displayName   ->> cell.posterLabel.dynText
            idea.likeCount                     <->> cell.likeCount

            map(idea.createdAt) { dateString in
                return DateHelper.getDateString(dateString)
            } ->> cell.dateLabel.dynText

            idea.content ->> cell.contentLabel!.dynText

            cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.getWidth() / 2
            cell.avatarImageView.layer.masksToBounds = true

            // bondにおけるcastの方法、これがベストプラクティスかよくわからない
            idea.likeCount.map { (count :Int) -> String in
                return String(count)
            } ->> cell.likeCountLabel.dynText

            // MEMO: BondでPRつくったところ
            map(idea.postUser.profile.iconUrl, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { str in
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

            // bindしたい？
            cell.likeAnimationColor = GroupColor(rawValue: self.colorCodeId)!.getColor()

            return cell
        } ->> self.tableViewDataSourceBond

        map(self.postTextView.dynText) { string in
            return (count(string) > 0 && count(string) < 140)
        } ->> postButton.dynEnabled

        self.postTextView.placeholder = "アイデアを投稿する"
//        self.postTextView.placeholderColor = ColorHelper.fanHeavyGrayColor
        self.postTextView.maxNumberOfLines = 3
        self.postTextView.textContainerInset = UIEdgeInsetsMake(8.0, 4.0, 8.0, 0.0);
//        self.postTextView.layer.cornerRadius = kFanCornerRadius
        self.postTextView.layer.borderWidth = 0.5
        self.postTextView.layer.borderColor = UIColor.clearColor().CGColor
        self.postTextView.text = ""


        self.setupPostAvatarButton()

        self.setupNotifications()
        
        self.requestIdeas(self.groupId, topicId: self.topicId, block: nil)
    }

    func setupPostAvatarButton() {
        if let iconUrl = AccountHelper.sharedInstance.getIconUrl() {
            var data = NSData(contentsOfURL: NSURL(string: iconUrl)!)
            var image = UIImage(data: data!)
            self.postAvatarButton.setImage(image, forState: UIControlState.Normal)
        }
    }

    func setupNotifications() {

        self.observer.addObserverForName(SLKTextViewContentSizeDidChangeNotification,
            object: nil, queue: nil) { (n :NSNotification!) -> Void in
                if n.object is SLKTextView {
                    var h = self.postTextView.contentSize.height
                    if h > 80 {
                        return //80 is magic number, which means about 3 lines height
                    }
                    self.postTextViewHeightConstraint.constant = h
                    self.textViewContainerHeightConstraint.constant = h + 14
                    self.view.layoutIfNeeded()
                }
        }

        self.observer.addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil) { (n :NSNotification!) -> Void in
            self.keyboardWillShow(n)
        }

        self.observer.addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil) { (n :NSNotification!) -> Void in
            self.keyboardWillHide(n)
        }
    }
    
    func showSortActionSheet() {
        var actionSheet = UIAlertController(title: "アイデアをソートする",
            message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        // TODO:needs refactor
        actionSheet.addAction(UIAlertAction(title: "人気順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                var list = self.list.value
                self.list.removeAll(false)
                list.sort({ (prev :Idea, next :Idea) -> Bool in
                    return prev.likeCount.value > next.likeCount.value
                })
                self.list.append(list)
        }))
        actionSheet.addAction(UIAlertAction(title: "新しい順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                var list = self.list.value
                self.list.removeAll(false)
                list.sort({ (prev :Idea, next :Idea) -> Bool in
                    return prev.identifier.value > next.identifier.value
                })
                self.list.append(list)
        }))
        actionSheet.addAction(UIAlertAction(title: "古い順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                var list = self.list.value
                self.list.removeAll(false)
                list.sort({ (prev :Idea, next :Idea) -> Bool in
                    return prev.identifier.value < next.identifier.value
                })
                self.list.append(list)
        }))
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel,
            handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    func onRefresh(sender:UIRefreshControl) {
        self.list.removeAll(false)
        self.requestIdeas(self.groupId, topicId: self.topicId) { () -> Void in
            sender.endRefreshing()
        }
    }
    
    func requestIdeas(groupId :Int, topicId :Int, block :(() -> Void)?) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.IdeaList(groupId: groupId, topicId: topicId)) { response in
            switch response {
            case .Success(let box):
                pri(box.value)
                self.list.append(box.value)
                hideLoading()
            case .Failure(let box):
                pri(box.value) // NSError
                hideLoading()
            }
            if let b = block {
                b()
            }
        }
    }

    // MARK: - keyboard from NSNotification

    func keyboardWillShow(notification:NSNotification) {
        let info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = info[UIKeyboardAnimationCurveUserInfoKey] as! Int

        keyboardFrame = self.view.convertRect(keyboardFrame, toView: nil)

        self.textViewContainerBottomConstraint.constant = keyboardFrame.size.height

        UIView.animateWithDuration(duration as Double,
            delay: 0,
            options: UIViewAnimationOptions(UInt(curve) << 16),
            animations: { () -> Void in
                self.view.layoutIfNeeded()
            }) { (flg) -> Void in
                self.hideKeyboardTransparentButton.hidden = false
        }
    }

    func keyboardWillHide(notification:NSNotification) {
        let info = notification.userInfo!
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = info[UIKeyboardAnimationCurveUserInfoKey] as! Int

        self.textViewContainerBottomConstraint.constant = 0

        UIView.animateWithDuration(duration as Double,
            delay: 0,
            options: UIViewAnimationOptions(UInt(curve) << 16),
            animations: { () -> Void in
                self.view.layoutIfNeeded()
            }) { (flg) -> Void in
                self.hideKeyboardTransparentButton.hidden = true
        }
    }

    // MARK: - IB action

    @IBAction func postAvatarTapped(sender: UIButton) {
        let message = sender.selected ? "ユーザ名を表示して投稿します" : "匿名で投稿します"
        ToastHelper.make(self.view, message: message, duration: 0.3)
        sender.selected = !sender.selected
    }


    @IBAction func postButtonTapped(sender: AnyObject) {
        if self.validate() == false {
            showError(message: "アイデアの投稿は1文字以上140文字以内です")
            return
        }

        self.postTextView.resignFirstResponder()

        showLoading()

        ApiHelper.sharedInstance.call(ApiHelper.CreateIdea(groupId: self.groupId, topicId: self.topicId, content: self.postTextView.text)) { response in
            switch response {
            case .Success(let box):
                pri(box.value) // Message
                var idea = box.value as Idea
                self.list.insert(idea, atIndex: 0)

                self.postTextView.text = ""

                // ソート順を保持したかったらなんらかの処理を・・・

                hideLoading()

            case .Failure(let box):
                pri(box.value) // NSError
                hideLoading()
            }
        }
    }

    @IBAction func hideKeyboardTransparentButtonTapped(sender: UIButton) {
        self.postTextView.resignFirstResponder()
    }


    func validate() -> Bool {
        var text = self.postTextView.text.trimSpaceCharacter()

        if count(text) == 0 {
            return false
        }
        if count(text) > 140 {
            return false
        }

        return true
    }

    // MARK: - UITableViewDelegate
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return IdeaTableViewCell.getCellHeight(list[indexPath.row],
            parentWidth: self.ideaTableView.getWidth())
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var targetIdeaId = self.list[indexPath.row].identifier.value
        var vc = LikeListViewController(groupId: self.groupId, topicId: self.topicId, ideaId: targetIdeaId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - AskIdeaViewDelegate
    
    func askIdeaViewTapped() {
        self.view.makeToast("hello, Ikyusan")
    }
    
    // MARK: - IdeaTableViewCellDelegate
    
    func ideaTableViewCellLikeButtonTapped(ideaId :Int) {
        LikeHelper.sharedInstance.doLike(ideaId)
    }

    func ideaTableViewCellLikeMaxCount() {
        ToastHelper.make(self.view, message: "スキは最大で100個までです")
    }

    func ideaTableViewCellLongPressed(ideaId: Int) {

        for (index, value) in enumerate(self.list.value) {
            var idea = value as Idea
            if idea.identifier.value == ideaId && idea.postUser.identifier.value != AccountHelper.sharedInstance.getUserId() {
                // 他人のアイデアはシェアできない・消せない
                return
            }
        }

        var action = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        action.addAction(UIAlertAction(title: "シェアする", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            var vc = TwitterShareViewController()
            var nav = UINavigationController(rootViewController: vc)
            self.presentViewController(nav, animated: true, completion: nil)
        }))

        action.addAction(UIAlertAction(title: "削除する", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
//            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                self.showDeleteModal(ideaId)
//            })
        }))
        action.addAction(UIAlertAction(title: "閉じる", style: UIAlertActionStyle.Cancel, handler: nil))

        self.presentViewController(action, animated: true, completion: nil)
    }

    func showDeleteModal(ideaId: Int) {
        var alert = UIAlertController(title: "本当に削除しますか？", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "いいえ", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "はい", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            showLoading()
            ApiHelper.sharedInstance.call(ApiHelper.DeleteIdea(groupId: self.groupId, topicId: self.topicId, ideaId: ideaId)) { response in
                switch response {
                case .Success(let box):

                    for (index, value) in enumerate(self.list.value) {
                        var idea = value as Idea
                        if idea.identifier.value == ideaId {
                            self.list.removeAtIndex(index)
                            break
                        }
                    }

                    hideLoading()

                case .Failure(let box):
                    pri(box.value) // NSError
                    hideLoading()
                }
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
