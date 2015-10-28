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

    var list = ObservableArray<Idea>([])

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
        ideaTableView.removeSeparatorsWhenUsingDefaultCell()

        // TODO: 一定の文字数のときはフォントを小さくするとかも入れたい？？
        self.navigationItem.title = self.topicName
        
        let refresh:UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action:"onRefresh:", forControlEvents:.ValueChanged)
        self.ideaTableView.addSubview(refresh)
        
        self.setBackButton()

        postAvatarButton.layer.cornerRadius  = postAvatarButton.getWidth() / 2
        postAvatarButton.layer.masksToBounds = true

        postButton.tintColor = GroupColor(rawValue: self.colorCodeId)?.getColor()

        let sortButton = UIBarButtonItem().bk_initWithImage(UIImage(named: "icon_sort")!,
            style: UIBarButtonItemStyle.Plain,
            handler: { (t) -> Void in
                self.showSortActionSheet()
        }) as! UIBarButtonItem

//        self.list.lift().map { (list) -> Bool in
//            return list.count > 1
//        }.bindTo(sortButton.bnd_enabled)

        self.navigationItem.rightBarButtonItems = [sortButton]

        self.list.lift().bindTo(self.ideaTableView) { (indexPath, array, tableView) -> UITableViewCell in
            let cell = NotificationTableViewCell.getView("IdeaTableViewCell") as! IdeaTableViewCell
            cell.ideaTableViewCellDelegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let idea = array[0][indexPath.row]
            idea.identifier.bindTo(cell.identifier)
            idea.postUser.profile.displayName.bindTo(cell.posterLabel.bnd_text)
            idea.likeCount.bindTo(cell.likeCount)

            idea.createdAt.map { dateString in
                return DateHelper.getDateString(dateString)
            }.bindTo(cell.dateLabel.bnd_text)

            idea.content.bindTo(cell.contentLabel!.bnd_text)

            // bondにおけるcastの方法、これがベストプラクティスかよくわからない
            idea.likeCount.map { (count :Int) -> String in
                return String(count)
            }.bindTo(cell.likeCountLabel.bnd_text)

            idea.postUser.profile.iconUrl.deliverOn(Queue.Background).map { (urlString) -> UIImage in
                let url = NSURL(string: urlString)
                let data = NSData(contentsOfURL: url!)
                if let existData = data {
                    return UIImage(data: existData)!
                } else {
                    return UIImage()
                }
                }.deliverOn(Queue.Main).bindTo(cell.avatarImageView.bnd_image)

            // bindしたい？
            cell.likeAnimationColor = GroupColor(rawValue: self.colorCodeId)!.getColor()

            return cell
        }

        self.postTextView.bnd_text.map { string in
            let count = string?.characters.count
            return (count > 0 && count < 140)
        }.bindTo(postButton.bnd_enabled)

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
            let data = NSData(contentsOfURL: NSURL(string: iconUrl)!)
            let image = UIImage(data: data!)
            self.postAvatarButton.setImage(image, forState: UIControlState.Normal)
        }
    }

    func setupNotifications() {

        self.observer.addObserverForName(SLKTextViewContentSizeDidChangeNotification,
            object: nil, queue: nil) { (n :NSNotification!) -> Void in
                if n.object is SLKTextView {
                    let h = self.postTextView.contentSize.height
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
        let actionSheet = UIAlertController(title: "アイデアをソートする",
            message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        // TODO:needs refactor
        actionSheet.addAction(UIAlertAction(title: "人気順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                var list = self.list.array
                self.list.removeAll()
                list.sortInPlace({ (prev :Idea, next :Idea) -> Bool in
                    return prev.likeCount.value > next.likeCount.value
                })
                self.list.extend(list)
        }))
        actionSheet.addAction(UIAlertAction(title: "新しい順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                var list = self.list.array
                self.list.removeAll()
                list.sortInPlace({ (prev :Idea, next :Idea) -> Bool in
                    return prev.identifier.value > next.identifier.value
                })
                self.list.extend(list)
        }))
        actionSheet.addAction(UIAlertAction(title: "古い順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                var list = self.list.array
                self.list.removeAll()
                list.sortInPlace({ (prev :Idea, next :Idea) -> Bool in
                    return prev.identifier.value < next.identifier.value
                })
                self.list.extend(list)
        }))
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel,
            handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    func onRefresh(sender:UIRefreshControl) {
        self.list.removeAll()
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
                self.list.extend(box.value)
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
            options: UIViewAnimationOptions(rawValue: UInt(curve) << 16),
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
            options: UIViewAnimationOptions(rawValue: UInt(curve) << 16),
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
            showError("アイデアの投稿は1文字以上140文字以内です")
            return
        }

        self.postTextView.resignFirstResponder()

        showLoading()

        ApiHelper.sharedInstance.call(ApiHelper.CreateIdea(groupId: self.groupId, topicId: self.topicId, content: self.postTextView.text)) { response in
            switch response {
            case .Success(let box):
                pri(box.value) // Message
                let idea = box.value as Idea
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

        let count = text.characters.count
        if count == 0 {
            return false
        }
        if count > 140 {
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
        let targetIdeaId = self.list[indexPath.row].identifier.value
        let vc = LikeListViewController(groupId: self.groupId, topicId: self.topicId, ideaId: targetIdeaId)
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

        /*
        for (index, value) in enumerate(self.list.array) {
            let idea = value as Idea
            if idea.identifier.value == ideaId && idea.postUser.identifier.value != AccountHelper.sharedInstance.getUserId() {
                // 他人のアイデアは消せない
                return
            }
        }


        let alert = UIAlertController(title: "削除しますか？", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "いいえ", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "はい", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            showLoading()
            ApiHelper.sharedInstance.call(ApiHelper.DeleteIdea(groupId: self.groupId, topicId: self.topicId, ideaId: ideaId)) { response in
                switch response {
                case .Success(let box):

                    for (index, value) in enumerate(self.list.array) {
                        let idea = value as Idea
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
*/
    }

}
