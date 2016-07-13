//
//  FloorplanAreaList.swift
//  Selection
//
//  Created by April on 7/12/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class FloorplanAreaList: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    var idcia : String?
    var idfloorplan : String?
    var code : String?
    var xnames: String?
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let point = touch.locationInView(view)
        return !CGRectContainsPoint(tableView.frame, point)
    }
    
    var listOrigin : [FloorplanAreaItem]?{
        didSet{
            tableView.reloadData()
            tableHeight.constant = min(CGFloat(44 * ((listOrigin?.count ?? 0) + 1)),
                min(view.frame.size.height, view.frame.size.width) - 100 )
            view.updateConstraintsIfNeeded()
        }
    }
    
    private struct constants {
    static let contentCell = "contentCell"
        static let headCell = "headCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        getAreaItemList()
    }
    private func getAreaItemList() {
        
        if let xidcia = idcia, let xidfloorplan = idfloorplan, let mcode = code {
            let request = ["idcia": xidcia,
                           "idfloorplan" : xidfloorplan,
                           "code": mcode,
                           ]
            Alamofire.request(.POST,
                CConstants.ServerURL + "baselection_floorplanItemList.json",
                parameters: request).responseJSON{ (response) -> Void in
                    if response.result.isSuccess {
//                        print(response.result.value)
                        if let rtnValue = response.result.value as? [[String: AnyObject]]{
                            var na = [FloorplanAreaItem]()
                            for rtn in rtnValue {
                                na.append(FloorplanAreaItem(dicInfo: rtn))
                            }
                            self.listOrigin = na
                        }else{
                            //                    self.doLogin()
                        }
                    }else{
                        //                self.doLogin()
                    }
            }
            
        }
        
        
    }
    
    @IBOutlet var tableView : UITableView!{
        didSet{
            tableView.layer.borderColor = CConstants.BorderColor.CGColor
            tableView.layer.borderWidth = 1.0
            tableView.separatorStyle = .None
            //            backView.layer.cornerRadius = 8
            tableView.layer.shadowColor = UIColor.lightGrayColor().CGColor
            tableView.layer.shadowOpacity = 1
            tableView.layer.shadowRadius = 8.0
            tableView.layer.shadowOffset = CGSize(width: -0.5, height: 0.0)
        }
    }
    @IBOutlet var tableHeight : NSLayoutConstraint!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOrigin?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.contentCell, forIndexPath: indexPath)
        if let cell1 = cell as? FloorplanAreaItemCell {
            let item = listOrigin![indexPath.row]
            cell1.setContentDetail(item)
        }
        return cell
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.headCell)
        cell?.contentView.backgroundColor = CConstants.ApplicationColor
        cell?.backgroundColor = CConstants.ApplicationColor
        if let cell1 = cell as? FloorplanAreaItemCell {
            cell1.xname.text = (code ?? "") + " - " + (xnames ?? "");
        }
        return cell
    }
    
    @IBAction func doclose(){
        self.dismissViewControllerAnimated(
        true){}
    }
    
    
}
