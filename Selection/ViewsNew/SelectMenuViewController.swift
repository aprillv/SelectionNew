//
//  SelectMenuViewController.swift
//  Selection
//
//  Created by April on 7/5/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit

protocol SelectMenuDelegate {
    func goToNextPage(menuname: String)
}
class SelectMenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableHeight : NSLayoutConstraint!
    
    var delegate : SelectMenuDelegate?
    
    @IBOutlet var tableview: UITableView!{
        didSet{
            //            backView.backgroundColor = UIColor.whiteColor()
            tableview.layer.borderColor = CConstants.BorderColor.CGColor
            tableview.layer.borderWidth = 1.0
            //            backView.layer.cornerRadius = 8
            tableview.layer.shadowColor = UIColor.lightGrayColor().CGColor
            tableview.layer.shadowOpacity = 1
            tableview.layer.shadowRadius = 8.0
            tableview.layer.shadowOffset = CGSize(width: -0.5, height: 0.0)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.6)
        self.tableHeight.constant = CGFloat((self.menuList.count  + 1) * 50)
        view.updateConstraintsIfNeeded()
    }
    
    private struct Constants {
        static let headCellIdentifier = "headCell"
        static let contentCellIdentifier = "contentCell"
        
        
        
    }
    
    
    var menuListn : [String]? {
        didSet{
            if let _ = menuListn {
                for m in menuListn! {
                    switch m {
                    case "1.0200":
                        menuList.append(CConstants.menu102)
                    case "1.6200":
                        menuList.append(CConstants.menu162)
                    case "1.6400":
                        menuList.append(CConstants.menu164)
                    case "1.6500":
                        menuList.append(CConstants.menu165)
                    default:
                        break
                    }
                }
            }
        }
    }
    var menuList = [String]()
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.headCellIdentifier) {
            cell.textLabel?.text = "Select one menu"
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: 20)
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = CConstants.ApplicationColor
            cell.backgroundColor = CConstants.ApplicationColor
            return cell
        }
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.contentCellIdentifier)
            cell!.textLabel?.text = menuList[indexPath.row]
        cell!.textLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: 17.0)
        cell!.accessoryType = .DisclosureIndicator
            return cell!
        
//        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.dismissViewControllerAnimated(true) { 
            if let text = cell?.textLabel?.text, let del = self.delegate {
                del.goToNextPage(text)
            }
        }
        
    }
}
