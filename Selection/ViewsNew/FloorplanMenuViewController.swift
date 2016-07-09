//
//  FloorplanMenuViewController.swift
//  Selection
//
//  Created by April on 7/9/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit

protocol FloorplanMenuDelegate {
    
    func GoToMenu(menu : String)
}

class FloorplanMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func doClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true){}
    }
    var delegate : FloorplanMenuDelegate?
    
    var xtitle : String?
    
    private struct constants{
        static let CellIdentifier = "contentCell"
        static let headCellIdentifier = "headCell"
    }
    
    
    let meunList = [CConstants.menuFloorplanView, CConstants.menuListView]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.6)
    }
    
    @IBOutlet var tableview : UITableView! {
        didSet{
//            tableview.separatorStyle = .None
            tableview.layer.borderColor = CConstants.BorderColor.CGColor
            tableview.layer.borderWidth = 1.0
            //            backView.layer.cornerRadius = 8
            tableview.layer.shadowColor = UIColor.lightGrayColor().CGColor
            tableview.layer.shadowOpacity = 1
            tableview.layer.shadowRadius = 8.0
            tableview.layer.shadowOffset = CGSize(width: -0.5, height: 0.0)
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCellWithIdentifier(constants.headCellIdentifier) {
//            cell.textLabel?.text = xtitle ?? "Select one menu"
//            cell.textLabel?.textAlignment = .Center
//            cell.textLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: 20)
//            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = CConstants.ApplicationColor
            cell.backgroundColor = CConstants.ApplicationColor
            return cell
        }
        return nil
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meunList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell;
        cell = tableView.dequeueReusableCellWithIdentifier(constants.CellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: 18)
            cell.textLabel?.text = meunList[indexPath.row]
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true) { 
            if let del = self.delegate {
                del.GoToMenu(self.meunList[indexPath.row])
            }
        }
        
        
    }

}
