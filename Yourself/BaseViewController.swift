import Foundation
import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    var iconsForCells = [String]()
    var titlesForCells = [String]()
    var indentifiers = [String]()
    
    private var menuVC: MenuViewController!
    private var callbacks = [String: () -> Void]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuVC = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.delegate = self
        
        // Hide slide menu (to can set animation when it is showed in the first time)
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        menuVC.close()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        if index != -1 {
            self.openViewControllerBasedOnIdentifier(indentifiers[(Int)(index)])
        }
    }
    
    func addCallback(forIdentifier: String, callback: @escaping () -> Void) {
        callbacks.updateValue(callback, forKey: forIdentifier)
    }
    
    // strIdentifier is similar Storyboard ID
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let callback = callbacks[strIdentifier]
        
        if callback != nil {
            callback!();
        }
        
        let view = storyBoard.instantiateViewController(withIdentifier: strIdentifier)
        self.present(view, animated: true, completion: nil)
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    func closeSlideMenu() {
        menuVC.close()
    }
    
    func onSlideMenuButtonPressed(_ sender : UIButton){
        if (menuVC.isShowing) {
            menuVC.close()
        } else {
            menuVC.arrayMenuOptions.removeAll()
            for i in 0..<titlesForCells.count {
                menuVC.arrayMenuOptions.append(["title":titlesForCells[i], "icon":iconsForCells[i]])
            }
        
//            menuVC.view.layoutIfNeeded()
            
            // menuVC and menuVC.view will be removed from self when we invoke menuVC.close()
            self.view.addSubview(menuVC.view)
            self.addChildViewController(menuVC)
            
            menuVC.show()
        }
    }
}
