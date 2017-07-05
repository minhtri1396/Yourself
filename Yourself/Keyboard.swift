// Class Keyboard: solve events which type is keyboard such as creating done button, catch event for done button,
//                 check textfields to find any textfield is empty

import Foundation
import UIKit

class Keyboard {
    
    //MARK **** Property
    
    var arrTextField = [UITextField]()
    
    //MARK ***** Contructors ./.
    
    init(arrTextField: [UITextField]) {
        self.arrTextField = arrTextField
    }
    
    convenience init() {
        self.init(arrTextField: [UITextField]())
    }
    
    // MARK **** Methods
    
    func createDoneButton() {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.DONE), style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneButtonAction))
        toolbar.items = [done]
        
        for i in 0..<self.arrTextField.count {
            self.arrTextField[i].inputAccessoryView = toolbar
        }
    }
    
    func catchEventOfKeyboard(isScroll: Bool, notification: Notification)->CGPoint? {
        let infor = notification.userInfo
        let keyboard = (infor? [UIKeyboardFrameBeginUserInfoKey] as! NSValue ).cgRectValue.size
        
        if isScroll == true {
            return CGPoint(x: 0, y: keyboard.height)
        }
        else {
            return CGPoint(x: 0, y: 0)
        }
    }
    
    @objc private func doneButtonAction() {
        for i in 0..<self.arrTextField.count {
            self.arrTextField[i].resignFirstResponder()
        }
    }
    
    func checkHavingAnyTextFieldEmpty()->Bool {
        for i in 0..<self.arrTextField.count {
            if self.arrTextField[i].text! == "" {
                return true
            }
        }
        return false
    }
}
