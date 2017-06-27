import Foundation
import Firebase
import GoogleSignIn
import UIKit

class BaseViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, SlideMenuDelegate {
    
    var iconsForCells = [String]()
    var titlesForCells = [String]()
    var indentifiers = [String]()
    var notIndentifiers = [String]()
    
    private var menuVC: MenuViewController!
    private var callbacks = [String: () -> Void]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuVC = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.delegate = self
        
        // Hide slide menu (to can set animation when it is showed in the first time)
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Initialize google sign-in
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        menuVC.close()
    }
    
    
    
    //////////////////////////////////////////////////////////////
    //******************** GOOGLE SIGN IN **********************//
    //////////////////////////////////////////////////////////////
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        GAccount.Instance.Sign(signIn, didSignInFor: user, withError: error)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    
    
    
    //////////////////////////////////////////////////////////////
    //*********** SLIDE MENU (MENU OF BURGER BUTTON) ***********//
    //////////////////////////////////////////////////////////////
    
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
        let callback = callbacks[strIdentifier]
        
        if callback != nil {
            callback!();
        }
        
        if !notIndentifiers.contains(strIdentifier) {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyBoard.instantiateViewController(withIdentifier: strIdentifier)
            self.present(view, animated: true, completion: nil)
        }
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
    
    func onSlideMenuButtonPressed(_ sender : UIButton){
        if (menuVC.isShowing) {
            menuVC.close()
        } else {
            menuVC.arrayMenuOptions.removeAll()
            for i in 0..<titlesForCells.count {
                menuVC.arrayMenuOptions.append(["title":titlesForCells[i], "icon":iconsForCells[i]])
            }
            
            // menuVC and menuVC.view will be removed from self when we invoke menuVC.close()
            self.view.addSubview(menuVC.view)
            self.addChildViewController(menuVC)
            
            menuVC.show()
        }
    }
}
