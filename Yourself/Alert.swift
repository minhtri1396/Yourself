import UIKit
import SCLAlertView

class Alert {
    static func show (type: Int, title: String, msg: String, selector:Selector, vc:UIViewController) {
        
        let appearance = SCLAlertView.SCLAppearance(
                        kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                        showCloseButton: false,
                        showCircularIcon: true
                    )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton(Language.BUILDER.get(group: Group.BUTTON, view: ButtonViews.DONE) , target: vc, selector: selector)
        
        if type == 0 { // th loi
            alertView.showError(title, subTitle: msg)
        } else {
            alertView.showSuccess(title, subTitle: msg)
        }
    }
}
