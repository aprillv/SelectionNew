//
//  FloorplanListViewController.swift
//  Selection
//
//  Created by April on 7/8/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class FloorplanListViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource, FloorplanMenuDelegate
{
    
    private struct constants {
        static let contentCellIndentifier = "contentCell"
        static let headCellIndentifier = "headCell"
        static let segueToViewAreaList = "showfloorplanarea"
        static let segueToMenuList = "showMenu"
        static let segueToFloorplanView = "showFloorplanView"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFloorplanListFromServer()
    }
    
    var ciaitem : CialistItemObj?
    
    
    
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
        self.getFloorplanListFromServer()
    }
    
    var floorplanList : [FloorplanItem]?{
        didSet{
            tableview.reloadData()
        }
    }
    var floorplanListOrigin : [FloorplanItem]? {
        didSet{
            
            
            self.textFieldDidChange(nil)
        }
    }
    
    
    
    private func getFloorplanListFromServer(){
        let userInfo = NSUserDefaults.standardUserDefaults()
        if let email = userInfo.objectForKey(CConstants.UserInfoEmail) as? String,
            let pwd = userInfo.objectForKey(CConstants.UserInfoPwd) as? String,
            let username = userInfo.objectForKey(CConstants.UserInfoUserName) as? String,
            let item = self.ciaitem{
            
            
            let a = ["email":email,"pwd":pwd,"username":username,"idcia":item.ciaid ?? " "]
            
            //            print(a)
            
            var hud : MBProgressHUD?
            if !(self.refreshControl!.refreshing){
                hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud?.labelText = CConstants.RequestMsg
            }
            
            
            Alamofire.request(.POST, CConstants.ServerURL + "baselection_masterfloorplanlist.json", parameters: a).responseJSON{ (response) -> Void in
                //                    self.clearNotice()
                hud?.hide(true)
                self.refreshControl?.endRefreshing()
                //                    self.progressBar?.dismissViewControllerAnimated(true){ () -> Void in
                //                        self.spinner?.stopAnimating()
                if response.result.isSuccess {
                    //                        print(response.result.value)
                    if let rtnValue = response.result.value as? [[String: AnyObject]]{
//                        print(rtnValue)
                        var tmp = [FloorplanItem]()
                        //                        if let list = rtnValue["pricebooktemplatelist"] as? [[String : String]] {
                        for o in rtnValue {
                            tmp.append(FloorplanItem(dicInfo: o))
                        }
                        //                        }
                        
                        self.floorplanListOrigin = tmp
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
        return self.floorplanList?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.contentCellIndentifier, forIndexPath: indexPath)
        if let cell1 = cell as? FloorplanItemCell {
            let item = self.floorplanList![indexPath.row]
            cell1.setContentDetail(item)
        }
        return cell
    }
    
    var selectedItem : FloorplanItem?
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.floorplanList![indexPath.row]
        selectedItem = item
        
        self.performSegueWithIdentifier(constants.segueToMenuList, sender: item)
    }
    
    @IBOutlet var viewheight: NSLayoutConstraint!{
        didSet{
            viewheight.constant = 1.0 / UIScreen.mainScreen().scale
            view.updateConstraintsIfNeeded()
        }
    }
    
   @IBAction func goLogout (){
        self.navigationController?.popToRootViewControllerAnimated(true)
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
                floorplanList = floorplanListOrigin
            }else{
                floorplanList = floorplanListOrigin?.filter(){
                    
                    return $0.idnumber!.lowercaseString.containsString(txt)
                        || $0.marketingname!.lowercaseString.containsString(txt)
                        || $0.floorplanname!.lowercaseString.containsString(txt)
                    
                    
                }
            }
        }else{
            floorplanList = floorplanListOrigin
        }
    }
    
    
    
    @IBAction func goback(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case constants.segueToMenuList:
                if let vc = segue.destinationViewController as? FloorplanMenuViewController {
                    vc.delegate = self
                    if let a = selectedItem {
                        vc.xtitle = "\(a.idnumber ?? "") - \(a.floorplanname ?? "")"
                    }
                }
            case constants.segueToViewAreaList:
                if let vc = segue.destinationViewController as? PricebookTemplateItemsViewController {
                    vc.floorplanTemplateItem = selectedItem
                    
                }
            case constants.segueToFloorplanView:
                if let vc = segue.destinationViewController as? FloorPlanViewController {
                    vc.floorplanInfo = selectedItem
                }
            default:
                break
            }
        }
    }
    
    func GoToMenu(menu: String) {
        switch menu {
        case CConstants.menuFloorplanView:
            self.performSegueWithIdentifier(constants.segueToFloorplanView, sender: nil)
        default:
            self.performSegueWithIdentifier(constants.segueToViewAreaList, sender: nil)
        }
    }
}

