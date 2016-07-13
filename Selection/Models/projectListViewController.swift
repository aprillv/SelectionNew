//
//  projectListViewController.swift
//  Selection
//
//  Created by April on 6/8/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class projectListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
   
    // MARK: - Outlets
    
    var refreshControl : UIRefreshControl?
    
    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            refreshControl = UIRefreshControl()
            refreshControl!.addTarget(self, action: #selector(projectListViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
            tableView.addSubview(refreshControl!)
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
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CiaListViewController.textFieldDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: txtField)
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
    
    
    
    // MARK: paramater from last page
    var ciaid: String?
    var username : String?
    var iddeptos : Int?
    
    // MARK: TextField delegate
    func textFieldDidChange(notifications : NSNotification){
        if let txt = txtField.text?.lowercaseString{
            if txt.isEmpty{
                ProjectList = ProjectListOrigin
            }else{
                ProjectList = ProjectListOrigin?.filter(){
                    
                    return $0.nproject!.lowercaseString.containsString(txt)
                        || $0.pm1!.lowercaseString.containsString(txt)
                    || $0.pm2!.lowercaseString.containsString(txt)
                    
                    
                }
            }
        }else{
            ProjectList = ProjectListOrigin
        }
    }
    
    
  
    var ProjectListOrigin : [ProjectItemObj]?{
        didSet{
            ProjectList = ProjectListOrigin
        }
    }
    
    var ProjectList : [ProjectItemObj]?{
        didSet{
            self.tableView.reloadData()
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
        static let Title : String = "Select A Project"
        static let CellIdentifier : String = "Project Cell Identifier"
        static let headcellIdentifier = "project list head cell"
        
    }
    
//    var tableView: UITableView!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProjectListFromServer(nil)
        
        self.tableView.tag = 2
        self.navigationItem.hidesBackButton = true
        self.title = constants.Title
        
        self.tableView.reloadData()
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.headcellIdentifier)
        cell?.backgroundColor = CConstants.BackColor
        return cell
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProjectList?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell;
        cell = tableView.dequeueReusableCellWithIdentifier(constants.CellIdentifier, forIndexPath: indexPath)
        if let cell1 = cell as? ProjectCell {
            let item  = ProjectList![indexPath.row]
            cell1.setDetail(item)
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.txtField.resignFirstResponder()
        
        
        self.performSegueWithIdentifier(CConstants.SegueToFloorplanFromProjectList, sender: self.ProjectList![indexPath.row])
        
    }
    @IBAction func goLogout(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case CConstants.SegueToFloorplanFromProjectList:
                if let a = segue.destinationViewController as? FloorPlanViewController {
                    if let item = sender as? ProjectItemObj {
//                        a.fl = item
                    }
                }
            default:
                break;
            }
        }
    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if let identifier = segue.identifier {
    //            switch identifier {
    //            case CConstants.SegueToPrintModel:
    //
    //                if let controller = segue.destinationViewController as? PrintModelTableViewController {
    //                   controller.delegate = self
    //                }
    //                break
    //
    //            case CConstants.SegueToPrintPdf:
    //                if let controller = segue.destinationViewController as? PDFPrintViewController {
    //                    if let indexPath = tableView.indexPathForSelectedRow {
    //                        let ddd = self.CiaNmArray?[self.CiaNm?[indexPath.section] ?? ""]
    //                        let item: ContractsItem = ddd![indexPath.row]
    //
    //                        if let info = sender as? ContractAddendumC {
    //                            controller.pdfInfo0 = info
    //                            controller.addendumCpdfInfo = info
    //                            controller.AddressList = self.AddressListOrigin
    //                            controller.filesArray = self.filesNms!
    //                            controller.contractInfo = item
    //                            var itemList = [[String]]()
    //                            var i = 0
    //                            if let list = info.itemlist {
    //                                for items in list {
    //
    //                                    var itemList1 = [String]()
    //                                    let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 657.941, height: 13.2353))
    //                                    textView.scrollEnabled = false
    //                                    textView.font = UIFont(name: "Verdana", size: 11.0)
    //                                    textView.text = items.xdescription!
    //                                    textView.sizeToFit()
    //                                    textView.layoutManager.enumerateLineFragmentsForGlyphRange(NSMakeRange(0, items.xdescription!.characters.count), usingBlock: { (rect, usedRect, textContainer, glyphRange, _) -> Void in
    //                                        if  let a : NSString = items.xdescription! as NSString {
    //
    //                                            i++
    //                                            itemList1.append(a.substringWithRange(glyphRange))
    //                                        }
    //                                    })
    //                                    //                            itemList1.append("april test")
    //                                    itemList.append(itemList1)
    //                                }
    //                            }
    //                            controller.addendumCpdfInfo!.itemlistStr = itemList
    //
    //                            //                        let pass = i > 19 ? CConstants.PdfFileNameAddendumC2 : CConstants.PdfFileNameAddendumC
    //
    //                            controller.page2 = i > 19
    //                            //                        controller.initWithResource(pass)
    //
    //                        }else{
    //
    //
    //                            let info = ContractPDFBaseModel(dicInfo: nil)
    //                            info.code = item.code
    //                            info.idcia = item.idcia
    //                            info.idproject = item.idproject
    //                            info.idnumber = item.idnumber
    //                            info.idcity = item.idcity
    //                            info.nproject = item.nproject
    //                            controller.contractInfo = item
    //                            controller.pdfInfo0 = info
    //                            controller.AddressList = self.AddressListOrigin
    //                            controller.filesArray = self.filesNms
    //                            controller.page2 = false
    //                        }
    //                        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    //                    }
    //
    //                }
    //
    //            default:
    //                break;
    //            }
    //        }
    //    }
    
    @IBAction func refreshCiaList(sender: UIRefreshControl) {
        
        self.getProjectListFromServer(sender)
    }
    
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        self.getProjectListFromServer(refreshControl)
    }

    
    private func getProjectListFromServer(sender: UIRefreshControl?){
        let userInfo = NSUserDefaults.standardUserDefaults()
        let email = userInfo.valueForKey(CConstants.UserInfoEmail) as? String
        let password = userInfo.valueForKey(CConstants.UserInfoPwd) as? String
        
        
        let loginUserInfo = ProjectListRequired(email: email!, password: password!, idcia: self.ciaid ?? "", username: self.username ?? "", iddeptos: "\(self.iddeptos ?? 0)")
        
        let a = loginUserInfo.toDictionary()
        var hud : MBProgressHUD?
        if sender == nil {
            hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud?.labelText = CConstants.RequestMsg
        }
        
//        print(a)
        Alamofire.request(.POST, CConstants.ServerURL + CConstants.ProjectListServiceURL, parameters: a).responseJSON{ (response) -> Void in
            if response.result.isSuccess {
//                print(response.result.value)
                if let rtnValue = response.result.value as? [[String: AnyObject]]{
                    var ah = [ProjectItemObj]()
                    for a in rtnValue {
                        ah.append(ProjectItemObj(dicInfo: a))
                    }
                    
                    self.ProjectListOrigin = ah
                    
//                    let rtn = LoginedUserObj(dicInfo: rtnValue)
//                    
//                    if rtn.found == "1"{
//                        self.ProjectListOrigin = rtn.cialist
//                    }
                }
            }
            hud?.hide(true)
            sender?.endRefreshing()
        }
        
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.txtField.resignFirstResponder()
    }
}
