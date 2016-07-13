//
//  citylistViewController.swift
//  Selection
//
//  Created by April on 7/7/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class citylistViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    private struct constants {
        static let contentCellIndentifier = "contentCell"
        static let headCellIndentifier = "headCell"
        static let segueToAssembliesList = "showAssemblies"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCityListFromServer()
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
        self.getCityListFromServer()
    }
    
    var cityLists : [cityItem]?{
        didSet {
            tableview.reloadData()
        }
    }
    var cityListsOrigin : [cityItem]? {
        didSet{
            self.textFieldDidChange(nil)
        }
    }
    
    private func getCityListFromServer(){
        let userInfo = NSUserDefaults.standardUserDefaults()
        if let email = userInfo.objectForKey(CConstants.UserInfoEmail) as? String,
            let pwd = userInfo.objectForKey(CConstants.UserInfoPwd) as? String{
            
            
            let a = ["email": email, "pwd" : pwd]
            
            var hud : MBProgressHUD?
            if !(self.refreshControl!.refreshing){
                hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud?.labelText = CConstants.RequestMsg
            }
            
            
            Alamofire.request(.POST, CConstants.ServerURL + "baselection_cityList.json", parameters: a).responseJSON{ (response) -> Void in
                //                    self.clearNotice()
                hud?.hide(true)
                self.refreshControl?.endRefreshing()
                //                    self.progressBar?.dismissViewControllerAnimated(true){ () -> Void in
                //                        self.spinner?.stopAnimating()
                if response.result.isSuccess {
                    //                        print(response.result.value)
                    if let rtnValue = response.result.value as? [[String: String]]{
//                        print(rtnValue["pricebooktemplatelist"])
                        var tmp = [cityItem]()
                        for o in rtnValue {
                            tmp.append(cityItem(dicInfo: o))
                        }
                        
                        self.cityListsOrigin = tmp
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
        return self.cityLists?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.contentCellIndentifier) as! cityCell
        cell.setContentDetail(self.cityLists![indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.cityLists![indexPath.row]
        ///showTemplateItems
        self.performSegueWithIdentifier(constants.segueToAssembliesList, sender: item)
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let identifier = segue.identifier {
//            switch identifier {
//            case constants.segueToAssembliesList:
//                if let controller = segue.destinationViewController as? AssembliesViewController {
//                    controller.pricebookTemplateItem = sender as? PricebookTemplateItem
//                }
//            default:
//                break
//            }
//        }
//    }
    
    @IBAction func goLogout(){
        self.navigationController?.popToRootViewControllerAnimated(true)
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
                cityLists = cityListsOrigin
            }else{
                cityLists = cityListsOrigin?.filter(){
                    
                    return $0.cityname!.lowercaseString.containsString(txt)
                        || $0.state!.lowercaseString.containsString(txt)
                    
                    
                }
            }
        }else{
            cityLists = cityListsOrigin
        }
    }
    
}