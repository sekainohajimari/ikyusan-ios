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
    AskIdeaViewDelegate,
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

    var list = DynamicArray<Idea>([])

    var tableViewDataSourceBond: UITableViewDataSourceBond<UITableViewCell>!
    
    init(groupId :Int, topicId :Int) {
        self.groupId = groupId
        self.topicId = topicId
        
        super.init(nibName: "IdeaListViewController", bundle: nil)
        
        LikeHelper.sharedInstance.setBaseInfo(groupId, topicId: topicId)
    }

    init(groupId :Int, topicId :Int, colorCodeId :Int) {
        self.groupId = groupId
        self.topicId = topicId
        self.colorCodeId = colorCodeId

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
//        ideaTableView.dataSource = self
        self.tableViewDataSourceBond = UITableViewDataSourceBond(tableView: self.ideaTableView)
        ideaTableView.removeSeparatorsWhenUsingDefaultCell()
//        ideaTableView.rowHeight = UITableViewAutomaticDimension

        self.navigationItem.title = kNavigationTitleIdeaList
        
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
            idea.content                        ->> cell.contentLabel!.dynText

            map(idea.createdAt) { dateString in
                return DateHelper.getDateString(dateString)
            } ->> cell.dateLabel.dynText

            cell.contentLabel!.sizeToFit()

            cell.avatarImageView.layer.cornerRadius = 20 // temp
            cell.avatarImageView.layer.masksToBounds = true // temp

            // bondにおけるcastの方法、これがベストプラクティスかよくわからない
            idea.likeCount.map { (count :Int) -> String in
                return String(count)
            } ->> cell.likeCountLabel.dynText

            // TODO: refactor
            idea.postUser.profile.iconUrl.map { (str :String) -> UIImage in
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

            return cell
        } ->> self.tableViewDataSourceBond



        self.postTextView.placeholder = "アイデアを投稿する"
//        self.postTextView.placeholderColor = ColorHelper.fanHeavyGrayColor
        self.postTextView.maxNumberOfLines = 3
        self.postTextView.textContainerInset = UIEdgeInsetsMake(8.0, 4.0, 8.0, 0.0);
//        self.postTextView.layer.cornerRadius = kFanCornerRadius
        self.postTextView.layer.borderWidth = 0.5
        self.postTextView.layer.borderColor = UIColor.clearColor().CGColor



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

        var dafaultImage = UIImage(named: "ask_ikyusan.png")
        self.postAvatarButton.setImage(dafaultImage, forState: UIControlState.Selected)
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
    
    func getRightButtons() -> NSMutableArray {
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "delete")
        return buttons
    }
    
    func showSortActionSheet() {
        var actionSheet = UIAlertController(title: "アイデアをソートする",
            message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        // TODO:needs refactor
        actionSheet.addAction(UIAlertAction(title: "人気順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                self.list.value.sort({ (prev :Idea, next :Idea) -> Bool in
                    return prev.likeCount.value > next.likeCount.value
                })
                self.ideaTableView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "新しい順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                self.list.value.sort({ (prev :Idea, next :Idea) -> Bool in
//                    return (prev.createdAt!.getDate().compare(next.createdAt!.getDate()) == NSComparisonResult.OrderedDescending)
                    return prev.identifier.value > next.identifier.value
                })
                self.ideaTableView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "古い順", style: UIAlertActionStyle.Default,
            handler: { (action :UIAlertAction!) -> Void in
                self.list.value.sort({ (prev :Idea, next :Idea) -> Bool in
//                    return (prev.createdAt!.getDate().compare(next.createdAt!.getDate()) == NSComparisonResult.OrderedAscending)
                    return prev.identifier.value < next.identifier.value                })
                self.ideaTableView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel,
            handler: nil))
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    func onRefresh(sender:UIRefreshControl) {
        self.list = DynamicArray<Idea>([])
        self.requestIdeas(self.groupId, topicId: self.topicId) { () -> Void in
            sender.endRefreshing()
            //            self.groupTableView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    func requestIdeas(groupId :Int, topicId :Int, block :(() -> Void)?) {
        showLoading()
        ApiHelper.sharedInstance.call(ApiHelper.IdeaList(groupId: groupId, topicId: topicId)) { response in
            switch response {
            case .Success(let box):
                println(box.value)
                self.list.append(box.value)
//                self.ideaTableView.reloadData() // memo: reloadData要らない ただし上でself.list.valueに対してデータをいじっても反映されないので注意
                hideLoading()
            case .Failure(let box):
                println(box.value) // NSError
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
                println(box.value) // Message
                var idea = box.value as Idea
                self.list.insert(idea, atIndex: 0)

                self.postTextView.text = ""

                // ソート順を保持したかったらなんらかの処理を・・・

                hideLoading()

            case .Failure(let box):
                println(box.value) // NSError
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


    // MARK: - UITableViewDataSource

//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return list.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier(ideaCellIdentifier,
//            forIndexPath: indexPath) as! IdeaTableViewCell
//        cell.delegate = self
//        cell.ideaTableViewCellDelegate = self
//        cell.rightUtilityButtons = self.getRightButtons() as [AnyObject]
//        cell.setData(list[indexPath.row])
//        
//        return cell
//    }

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
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 88
//    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        var footer = AskIdeaView.loadFromNib() as? AskIdeaView
//        footer?.delegate = self
//        return footer
//    }
    
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

}
