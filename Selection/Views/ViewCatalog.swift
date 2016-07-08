//
//  ViewCatalog.swift
//  Selection
//
//  Created by April on 3/14/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit
import SDWebImage

class ViewCatalog: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPrintInteractionControllerDelegate {
var xfrom = 1
    
    @IBAction func DoPrint(sender: AnyObject) {
         let count = (xfrom == 1 ? self.selectionList!.count : self.pricebookTemplateItemList!.count)
        if count == 0 {
            return;
        }
//        UIView* testView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f)];
//        NSMutableData* pdfData = [NSMutableData data];
//        UIGraphicsBeginPDFContextToData(pdfData, CGRectMake(0.0f, 0.0f, 792.0f, 612.0f), nil);
//        UIGraphicsBeginPDFPage();
//        CGContextRef pdfContext = UIGraphicsGetCurrentContext();
//        CGContextScaleCTM(pdfContext, 0.773f, 0.773f);
//        [testView.layer renderInContext:pdfContext];
//        UIGraphicsEndPDFContext();
        // 1: from assembily 2 from pricebook template
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRectMake(0.0, 0.0, 612.0, 792.0), nil)
        
//        UIGraphicsBeginPDFPage()
//        var pdfContext = UIGraphicsGetCurrentContext()
//        CGContextScaleCTM(pdfContext, 0.773, 0.773)
        
//        let printView = UIView(frame: CGRect(x: 0, y: 0, width: 768.0, height: 1024.0))
//        
//        var upc = UILabel(frame: CGRect(x: 8, y: 10, width: 740, height: 21))
//        
//        let userInfo = NSUserDefaults.standardUserDefaults()
//        if let cianame = userInfo.valueForKey(CConstants.UserInfoCiaName) as? String  {
//                upc.text = cianame
//        }
//        printView.addSubview(upc)
//        upc = UILabel(frame: CGRect(x: 8, y: 32, width: 740, height: 21))
//        upc.text = "Part Picture List"
//        printView.addSubview(upc)
//        for i in 0...self.selectionList!.count-1 {
//            let item = self.selectionList![i]
//            let view = UIView(frame: CGRectMake(CGFloat((i%3)*255)+4, CGFloat((i/3)*250) + 60, CGFloat(254), CGFloat(240)))
//            view.layer.borderColor = CConstants.BorderColor.CGColor
//            view.layer.borderWidth = 1.0
//            let upc = UILabel(frame: CGRect(x: 8, y: 0, width: 246, height: 21))
//            let name = UILabel(frame: CGRect(x: 8, y: 21, width: 246, height: 21))
//            let image = UIImageView(frame: CGRect(x: 8, y: 42, width: 238, height: 196))
//            upc.text = item.upc!
//            name.text = item.selectionarea
//            let indexpath = NSIndexPath(forItem: i, inSection: 0)
//            if let cell = self.collectionListView.cellForItemAtIndexPath(indexpath) as? selectionImageCell {
//            image.image = cell.pic.image
//            }
//            
//            view.addSubview(upc)
//            view.addSubview(name)
//            view.addSubview(image)
//            printView.addSubview(view)
////
//            
//        }
        var printView :UIView?
        var pdfContext : CGContext?
       
        for i in 0...count-1 {
            if i % 12 == 0 {
                UIGraphicsBeginPDFPage()
                pdfContext = UIGraphicsGetCurrentContext()
                CGContextScaleCTM(pdfContext, 0.773, 0.773)
                
                printView = UIView(frame: CGRect(x: 0, y: 0, width: 768.0, height: 1024.0))
                var upc1 = UILabel(frame: CGRect(x: 8, y: 10, width: 740, height: 21))
                
                let userInfo = NSUserDefaults.standardUserDefaults()
                if let cianame = userInfo.valueForKey(CConstants.UserInfoCiaName) as? String  {
                    upc1.text = cianame
                }
                printView!.addSubview(upc1)
                upc1 = UILabel(frame: CGRect(x: 8, y: 32, width: 740, height: 21))
                upc1.text = "Part Picture List"
                printView!.addSubview(upc1)
            }
            
            var strupc : String?
            var xdescription : String?
            var url: String
            
            switch xfrom {
            case 1:
                let item = self.selectionList![i]
                strupc = item.upc!
                xdescription = item.selectionarea!
                url =  "https://contractssl.buildersaccess.com/baselection_image?idcia=\(item.idcia!)&idassembly1=\(item.idassembly1!)&upc=\(item.upc!)&isthumbnail=0"
                
            default:
                let item = self.pricebookTemplateItemList![i]
                strupc = item.part!
                xdescription = item.xdescription!
                url =  getImageUrl(item.part!)
                
                
            }
            
            let view = UIView(frame: CGRectMake(CGFloat((i%3)*255)+4, CGFloat(((i%12)/3)*250) + 60, CGFloat(254), CGFloat(240)))
            view.layer.borderColor = CConstants.BorderColor.CGColor
            view.layer.borderWidth = 1.0
            let upc = UILabel(frame: CGRect(x: 8, y: 0, width: 246, height: 21))
            let name = myUILabel(frame: CGRect(x: 8, y: 21, width: 246, height: 39))
            name.numberOfLines = 2
            name.verticalAlignment = VerticalAlignmentTop
            let image = UIImageView(frame: CGRect(x: 8, y: 42, width: 238, height: 196))
            upc.text = strupc
            name.text = xdescription
            
            if SDImageCache.sharedImageCache().diskImageExistsWithKey(url) {
                image.image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(url)
            }else{
                image.image = UIImage(data: NSData(contentsOfURL: NSURL(string: url)!)!)
                SDImageCache.sharedImageCache().storeImage(image.image, forKey: url)
            }
            
            view.addSubview(upc)
            view.addSubview(name)
            view.addSubview(image)
            
            print(view.frame)
            printView!.addSubview(view)
            if (i + 1) % 12 == 0 || i == count-1{
               printView!.layer.renderInContext(pdfContext!)
            }
            //
            
        }
        
//        printView.layer.renderInContext(<#T##ctx: CGContext##CGContext#>)
        UIGraphicsEndPDFContext()
        
        if UIPrintInteractionController.canPrintData(pdfData) {
            
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = "Part Picture List"
            printInfo.outputType = .Photo
            
            let printController = UIPrintInteractionController.sharedPrintController()
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = false
            
            printController.printingItem = pdfData
            
            printController.presentAnimated(true, completionHandler: nil)
            printController.delegate = self
        }
    }
    
    private func getImageUrl(ids : String) -> String{
        if let _ = idpricebooktemplate {
            return "https://contractssl.buildersaccess.com/baselection_pricebookTemplateItemPicture?idcia=1&idpricebooktemplate=\(idpricebooktemplate!)&upc=\(ids)&isthumbnail=1"
        }else if let _ = iddevelopmenttemplate {
            return "https://contractssl.buildersaccess.com/baselection_specFeatureDevelopmentItemImage?idcia=1&iddevelopmenttemplate1=\(iddevelopmenttemplate!)&upc=\(ids)&isthumbnail=1"
        }else {
             return "https://contractssl.buildersaccess.com/baselection_floorplanItemImage?idcia=1&idfloorplan=\(idfloorplantemplate!)&upc=\(ids)&isthumbnail=1"
        
        }
        
    }
    func printInteractionControllerParentViewController(printInteractionController: UIPrintInteractionController) -> UIViewController {
        return self.navigationController!
    }
    func printInteractionControllerWillPresentPrinterOptions(printInteractionController: UIPrintInteractionController) {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0, green: 164/255.0, blue: 236/255.0, alpha: 1)
        self.navigationController?.topViewController?.navigationController?.navigationBar.tintColor = UIColor(red: 0, green: 164/255.0, blue: 236/255.0, alpha: 1)
    }
    @IBOutlet var collectionListView: UICollectionView!{
        didSet{
//            if let _ = selectionList {
//                collectionListView.reloadData()
//            }
            if let _ = pricebookTemplateItemList {
                collectionListView.reloadData()
            }
        }
    }
    
    var selectionList: [AssemblySelectionAreaObj]?{
        didSet{
            self.xfrom = 1
            if collectionListView != nil {
                collectionListView.reloadData()
            }
        }
    }
    
    var pricebookTemplateItemList: [PricebookTemplateItemListI]?{
        didSet{
            self.xfrom = 2
            if collectionListView != nil {
                collectionListView.reloadData()
            }
        }
    }
    
    private struct constants{
    static let cellIdentifier = "selectionImageCell"
    }
    
    var idpricebooktemplate : String?

    var iddevelopmenttemplate : String?
    var idfloorplantemplate : String?
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(constants.cellIdentifier, forIndexPath: indexPath)
        if let cell1 = cell as? selectionImageCell {
            switch  xfrom {
            case 1:
                let item = selectionList![indexPath.row]
                cell1.upc.text = item.upc!
                cell1.name.text = item.selectionarea!
                //            cell1.pic.sd_setImageWithURL(NSURL(string: "https://contractssl.buildersaccess.com/baselection_image?idcia=\(item.idcia!)&idassembly1=\(item.idassembly1!)&upc=\(item.upc!)&isthumbnail=0"))
                cell1.spinner.startAnimating()
                let urlstr = "https://contractssl.buildersaccess.com/baselection_image?idcia=\(item.idcia!)&idassembly1=\(item.idassembly1!)&upc=\(item.upc!)&isthumbnail=0"
                cell1.pic.sd_setImageWithURL(NSURL(string: urlstr), completed: { (_, _, _, _) -> Void in
                    cell1.spinner.stopAnimating()
                     SDImageCache.sharedImageCache().storeImage(cell1.pic.image, forKey: urlstr)
                })
            default:
                let item = pricebookTemplateItemList![indexPath.row]
                cell1.upc.text = item.part!
                cell1.name.text = item.xdescription!
                //            cell1.name.sizeToFit()
                print(cell1.name.numberOfLines)
                cell1.spinner.startAnimating()
                let urlstr =  getImageUrl(item.part!)
                cell1.pic.sd_setImageWithURL(NSURL(string: urlstr), completed: { (_, _, _, _) -> Void in
                    SDImageCache.sharedImageCache().storeImage(cell1.pic.image, forKey: urlstr)
                    
                    cell1.spinner.stopAnimating()
                })
            }
           
//            print("https://contractssl.buildersaccess.com/baselection_pricebookTemplateItemPicture?idcia=1&idpricebooktemplate=\(idpricebooktemplate!)&upc=\(item.part!)&isthumbnail=1")
            
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
        if xfrom == 1 {
            return selectionList?.count ?? 0
        }else{
            return pricebookTemplateItemList?.count ?? 0
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userInfo = NSUserDefaults.standardUserDefaults()
        if let _ = userInfo.valueForKey(CConstants.UserInfoCiaId),
            let cianame = userInfo.valueForKey(CConstants.UserInfoCiaName)  {
            switch xfrom {
            case 1:
//                self.title = "\(xtitle )"
                break
            default:
                self.title = "\(1 ) - \(cianame )"
            }
        }
        
    }
    
}
