//
//  PricebookTemplateItemsViewController.swift
//  Selection
//
//  Created by April on 7/5/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class PricebookTemplateItemsViewController: BaseViewController
, UITableViewDelegate, UITableViewDataSource
{
    
    private struct constants {
        static let contentCellIndentifier = "contentCell"
        static let headCellIndentifier = "headCell"
        static let segueToViewCatalog = "showViewCatalog"
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = self.pricebookTemplateItem {
            self.title = (item.idnumber ?? "") + " - " + (item.tname ?? "")
        }
        self.getPriceBookTemplateItemListFromServer()
    }
    
    var pricebookTemplateItem : PricebookTemplateItem?
    
    var refreshControl: UIRefreshControl?
    
    @IBOutlet var tableview: UITableView!{
        didSet{
            tableview.separatorColor = UIColor.clearColor()
            tableview.separatorStyle = .None
            refreshControl = UIRefreshControl()
            refreshControl!.addTarget(self, action: #selector(PricebookTemplateItemsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
            tableview.addSubview(refreshControl!)
        }
    }
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        self.getPriceBookTemplateItemListFromServer()
    }
    
    var templateItemList : [PricebookTemplateItemListI]?{
        didSet{
            tableview.reloadData()
        }
    }
    var templateItemListOrigin : [PricebookTemplateItemListI]? {
        didSet{
            self.textFieldDidChange(nil)
        }
    }
    
    private func getPriceBookTemplateItemListFromServer(){
        let userInfo = NSUserDefaults.standardUserDefaults()
        if let email = userInfo.objectForKey(CConstants.UserInfoEmail) as? String,
            let pwd = userInfo.objectForKey(CConstants.UserInfoPwd) as? String,
            let username = userInfo.objectForKey(CConstants.UserInfoUserName) as? String,
            let item = self.pricebookTemplateItem{
            
            
            let a = ["email": email, "password" : pwd, "username": username,"idcia":"1","idpricebooktemplate":item.idnumber ?? "","templatename":item.tname ?? ""]
            
            print(a)
            
            var hud : MBProgressHUD?
            if !(self.refreshControl!.refreshing){
                hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud?.labelText = CConstants.RequestMsg
            }
            
            
            Alamofire.request(.POST, CConstants.ServerURL + "baselection_pricebookTemplateItemListRequest.json", parameters: a).responseJSON{ (response) -> Void in
                //                    self.clearNotice()
                hud?.hide(true)
                self.refreshControl?.endRefreshing()
                //                    self.progressBar?.dismissViewControllerAnimated(true){ () -> Void in
                //                        self.spinner?.stopAnimating()
                if response.result.isSuccess {
                    //                        print(response.result.value)
                    if let rtnValue = response.result.value as? [[String: AnyObject]]{
                        print(rtnValue)
                        var tmp = [PricebookTemplateItemListI]()
//                        if let list = rtnValue["pricebooktemplatelist"] as? [[String : String]] {
                            for o in rtnValue {
                                tmp.append(PricebookTemplateItemListI(dicInfo: o))
                            }
//                        }
                        
                        self.templateItemListOrigin = tmp
                    }else{
                        
                        self.PopServerError()
                    }
                }else{
                    
                    self.PopNetworkError()
                }
            }
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableview.dequeueReusableCellWithIdentifier(constants.headCellIndentifier)
        cell?.backgroundColor = CConstants.SearchBarBackColor
        cell?.contentView.backgroundColor = CConstants.SearchBarBackColor
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.templateItemList?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.contentCellIndentifier, forIndexPath: indexPath)
        if let cell1 = cell as? PricebookTemplateItemCell {
            let item = self.templateItemList![indexPath.row]
            cell1.setCellContentDetail(item)
//            if (item.areacode ?? "").containsString("-") {
//                cell1.contentView.backgroundColor = UIColor.whiteColor()
//                cell1.backgroundColor = UIColor.whiteColor()
//            }else{
//                cell1.contentView.backgroundColor = UIColor.lightGrayColor()
//                cell1.backgroundColor = UIColor.lightGrayColor()
//            }
        }
//        cell.backgroundColor = CConstants.SearchBarBackColor
//        cell.contentView.backgroundColor = CConstants.SearchBarBackColor
        
        return cell
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
                templateItemList = templateItemListOrigin
            }else{
                templateItemList = templateItemListOrigin?.filter(){
                    
                    return $0.areacode!.lowercaseString.containsString(txt)
                        || $0.areaname!.lowercaseString.containsString(txt)
                        || $0.xdescription!.lowercaseString.containsString(txt)
                    
                    
                }
            }
        }else{
            templateItemList = templateItemListOrigin
        }
    }

    @IBAction func goback(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case constants.segueToViewCatalog:
                if let vc = segue.destinationViewController as? ViewCatalog {
                    vc.idpricebooktemplate = self.pricebookTemplateItem?.idnumber
                    vc.pricebookTemplateItemList = self.templateItemListOrigin?.filter(){
                        return $0.fs == 1
                    }
                }
            default:
                break
            }
        }
    }
}
