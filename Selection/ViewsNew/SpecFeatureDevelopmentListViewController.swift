//
//  SpecFeatureDevelopmentListViewController.swift
//  Selection
//
//  Created by April on 7/7/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class SpecFeatureDevelopmentListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var idcia : String?
    
    private struct constants {
        static let contentCellIndentifier = "contentCell"
        static let headCellIndentifier = "headCell"
        static let segueToItemList = "showPricebookList"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSpecFeatureDevelopmentListFromServer()
    }
    @IBAction func goLogout(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func goback(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var refreshControl: UIRefreshControl?
    
    @IBOutlet var tableview: UITableView!{
        didSet{
            tableview.separatorColor = UIColor.clearColor()
            tableview.separatorStyle = .None
            refreshControl = UIRefreshControl()
            refreshControl!.addTarget(self, action: #selector(PricebookTemplateViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
            tableview.addSubview(refreshControl!)
        }
    }
    func refresh(refreshControl: UIRefreshControl) {
        self.getSpecFeatureDevelopmentListFromServer()
    }
    
    var SepcDevelopmentItemLists : [SepcDevelopmentItem]?{
        didSet {
            tableview.reloadData()
        }
    }
    var SepcDevelopmentItemListsOrigin : [SepcDevelopmentItem]? {
        didSet{
            self.textFieldDidChange(nil)
        }
    }
    
    private func getSpecFeatureDevelopmentListFromServer(){
        let userInfo = NSUserDefaults.standardUserDefaults()
        if let email = userInfo.objectForKey(CConstants.UserInfoEmail) as? String,
            let pwd = userInfo.objectForKey(CConstants.UserInfoPwd) as? String, let idciaa = idcia{
            
            
            let a = ["email": email, "pwd" : pwd, "idcia" : idciaa, "username": (userInfo.objectForKey(CConstants.UserInfoUserName) as? String ?? "")]
            
            var hud : MBProgressHUD?
            if !(self.refreshControl!.refreshing){
                hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud?.labelText = CConstants.RequestMsg
            }
            
            
            Alamofire.request(.POST, CConstants.ServerURL + "baselection_SpecFeatureDevelopmentList.json", parameters: a).responseJSON{ (response) -> Void in
                //                    self.clearNotice()
                hud?.hide(true)
                self.refreshControl?.endRefreshing()
                //                    self.progressBar?.dismissViewControllerAnimated(true){ () -> Void in
                //                        self.spinner?.stopAnimating()
                if response.result.isSuccess {
                    //                        print(response.result.value)
                    if let rtnValue = response.result.value as? [[String: String]]{
//                        print(rtnValue["pricebooktemplatelist"])
                        var tmp = [SepcDevelopmentItem]()
                        for o in rtnValue {
                            tmp.append(SepcDevelopmentItem(dicInfo: o))
                        }
                        
                        self.SepcDevelopmentItemListsOrigin = tmp
                    }else{
                        
                        self.PopServerError()
                    }
                }else{
                    
                    self.PopNetworkError()
                }
            }
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableview.dequeueReusableCellWithIdentifier(constants.headCellIndentifier)
        cell?.backgroundColor = CConstants.SearchBarBackColor
        cell?.contentView.backgroundColor = CConstants.SearchBarBackColor
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SepcDevelopmentItemLists?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.contentCellIndentifier) as! SpecDevelopmentCell
        cell.setContentDetail(self.SepcDevelopmentItemLists![indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.SepcDevelopmentItemLists![indexPath.row]
        ///showTemplateItems
        self.performSegueWithIdentifier(constants.segueToItemList, sender: item)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case constants.segueToItemList:
                if let controller = segue.destinationViewController as? PricebookTemplateItemsViewController {
                    controller.developmentTemplateItem = sender as? SepcDevelopmentItem
                }
            default:
                break
            }
        }
    }
    
    
    @IBOutlet var viewheight: NSLayoutConstraint!{
        didSet{
            viewheight.constant = 1.0 / UIScreen.mainScreen().scale
            view.updateConstraintsIfNeeded()
        }
    }
    @IBOutlet var txtField: UITextField!{
        didSet{
            
            txtField.layer.cornerRadius = 5.0
            txtField.placeholder = "Search"
            txtField.clearButtonMode = .WhileEditing
            txtField.leftViewMode = .Always
            txtField.leftView = UIImageView(image: UIImage(named: "search"))
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PricebookTemplateViewController.textFieldDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: txtField)
        }
        
    }
    
    func textFieldDidChange(notifications : NSNotification?){
        if let txt = txtField.text?.lowercaseString{
            if txt.isEmpty{
                SepcDevelopmentItemLists = SepcDevelopmentItemListsOrigin
            }else{
                SepcDevelopmentItemLists = SepcDevelopmentItemListsOrigin?.filter(){
                    
                    return $0.idproject!.lowercaseString.containsString(txt)
                        || $0.name!.lowercaseString.containsString(txt)
                    || $0.pricelevel!.lowercaseString.containsString(txt)
                    
                    
                }
            }
        }else{
            SepcDevelopmentItemLists = SepcDevelopmentItemListsOrigin
        }
    }
}
