import UIKit
import SCLAlertView

enum ALERT_TYPE: Int {
    case ERROR = 0,
    SUCCEESS,
    INFO
}

class Alert {
    static func show (type: ALERT_TYPE, title: String, msg: String) {
        
        let appearance = SCLAlertView.SCLAppearance(
                        kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                        showCloseButton: true,
                        showCircularIcon: true
                    )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        if type == .ERROR { // th loi
            alertView.showError(title, subTitle: msg)
        } else if type == .SUCCEESS {
            alertView.showSuccess(title, subTitle: msg)
        } else {
            alertView.showInfo(title, subTitle: msg)
        }
    }
}
