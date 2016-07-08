//
//  SpecFeatureCiaListViewController.swift
//  Selection
//
//  Created by April on 7/7/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//
import UIKit
import Alamofire
import MBProgressHUD

class SpecFeatureCiaListViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var menunumber : String?
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
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CiaListViewController.textFieldDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: txtField)
        }
        
    }
    
    func textFieldDidChange(notifications : NSNotification){
        if let txt = txtField.text?.lowercaseString{
            if txt.isEmpty{
                CiaList = CiaListOrigin
            }else{
                CiaList = CiaListOrigin?.filter(){
                    
                    return $0.ciaid!.lowercaseString.containsString(txt)
                        || $0.cianame!.lowercaseString.containsString(txt)
                    
                    
                }
            }
        }else{
            CiaList = CiaListOrigin
        }
    }
    
    
    //    var lastSelectedIndexPath : NSIndexPath?
    
    @IBOutlet var backItem: UIBarButtonItem!
    //    @IBOutlet var switchItem: UIBarButtonItem!
    //    @IBOutlet var searchBar: UISearchBar!
    @IBAction func doLogout(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //    var head : CiaListViewHeadView?
    var CiaListOrigin : [CialistItemObj]?{
        didSet{
            CiaList = CiaListOrigin
        }
    }
    
    var CiaList : [CialistItemObj]?{
        didSet{
            self.tableview.reloadData()
        }
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
        self.getSpecCiaListFromServer()
    }
    
    private func getSpecCiaListFromServer(){
        let userInfo = NSUserDefaults.standardUserDefaults()
        if let email = userInfo.objectForKey(CConstants.UserInfoEmail) as? String,
            let pwd = userInfo.objectForKey(CConstants.UserInfoPwd) as? String{
            
            
            let a = ["email": email, "pwd" : pwd]
            
            var hud : MBProgressHUD?
            if !(self.refreshControl!.refreshing){
                hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud?.labelText = CConstants.RequestMsg
            }
            
            
            Alamofire.request(.POST, CConstants.ServerURL + "baselection_SpecFeatureCiaList.json", parameters: a).responseJSON{ (response) -> Void in
                //                    self.clearNotice()
                hud?.hide(true)
                self.refreshControl?.endRefreshing()
                //                    self.progressBar?.dismissViewControllerAnimated(true){ () -> Void in
                //                        self.spinner?.stopAnimating()
                if response.result.isSuccess {
                    //                        print(response.result.value)
                    if let rtnValue = response.result.value as? [[String: String]]{
//                        print(rtnValue["pricebooktemplatelist"])
                        var tmp = [CialistItemObj]()
                        for o in rtnValue {
                            tmp.append(CialistItemObj(dicInfo: o))
                        }
                        
                        self.CiaListOrigin = tmp
                    }else{
                        
                        self.PopServerError()
                    }
                }else{
                    
                    self.PopNetworkError()
                }
            }
        }
    }
    
    
    
    
    
    @IBOutlet weak var LoginUserName: UIBarButtonItem!{
        didSet{
            let userInfo = NSUserDefaults.standardUserDefaults()
            LoginUserName.title = userInfo.objectForKey(CConstants.LoggedUserNameKey) as? String
        }
    }
    // MARK: - Constanse
    private struct constants{
        static let segueToDevelopment = "showDevelopmentList"
        static let segueToFloorplan = "showplanlist"
        
        static let Title : String = "Select A Company"
        static let CellIdentifier : String = "Cia Cell Identifier"
        
    }
    
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.getSpecCiaListFromServer()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CiaList?.count ?? 0
    }
    //
    //    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return tableView.tag == 2 ? 66 : 30
    //    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell;
        cell = tableView.dequeueReusableCellWithIdentifier(constants.CellIdentifier, forIndexPath: indexPath)
        //        cell.separatorInset = UIEdgeInsetsZero
        //        cell.layoutMargins = UIEdgeInsetsZero
        //        cell.preservesSuperviewLayoutMargins = false
        if let cell1 = cell as? CiaCell {
            let item  = CiaList![indexPath.row]
            cell1.lbl.text = "\(item.ciaid!) ~ \(item.cianame!)"
        }
        
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.txtField.resignFirstResponder()
        
        
        //        self.performSegueWithIdentifier(CConstants.SegueToAssemblies, sender: self.CiaList![indexPath.row])
        switch menunumber ?? "" {
        case CConstants.menu102:
            self.performSegueWithIdentifier(constants.segueToFloorplan, sender: self.CiaList![indexPath.row])
        default:
            self.performSegueWithIdentifier(constants.segueToDevelopment, sender: self.CiaList![indexPath.row])
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                
            case constants.segueToDevelopment:
                if let a = segue.destinationViewController as? SpecFeatureDevelopmentListViewController {
                    if let item = sender as? CialistItemObj {
                        a.idcia = item.ciaid
                    }
                }
            case constants.segueToFloorplan:
                if let a = segue.destinationViewController as? FloorplanListViewController {
                    if let item = sender as? CialistItemObj {
                        a.ciaitem = item
                    }
                }
            case CConstants.SegueToAssemblies:
                if let a = segue.destinationViewController as? AssembliesViewController {
                    if let item = sender as? CialistItemObj {
                        a.ciaid = item.ciaid
                        a.title = item.cianame!
                        
                        let userInfo = NSUserDefaults.standardUserDefaults()
                        userInfo.setValue(item.ciaid!, forKey: CConstants.UserInfoCiaId)
                        userInfo.setValue(item.cianame!, forKey: CConstants.UserInfoCiaName)
                    }
                }
            case CConstants.SegueToProjectList:
                if let a = segue.destinationViewController as? projectListViewController {
                    if let item = sender as? CialistItemObj {
                        a.ciaid = item.ciaid
                        let userInfo = NSUserDefaults.standardUserDefaults()
                        a.username = userInfo.stringForKey(CConstants.UserInfoEmail)
                        a.iddeptos = userInfo.integerForKey(CConstants.UserInfoIddeptos)
                        
                        a.title = item.cianame!
                        
                        userInfo.setValue(item.ciaid!, forKey: CConstants.UserInfoCiaId)
                        userInfo.setValue(item.cianame!, forKey: CConstants.UserInfoCiaName)
                    }
                }
            default:
                break;
            }
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.txtField.resignFirstResponder()
    }
    
    @IBAction func goback(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
}

