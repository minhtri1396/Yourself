import UIKit

class Alert:NSObject {
    static func show (title: String, msg: String, vc:UIViewController) {
        let alertCT = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okac = UIAlertAction(title: "OK", style: .default) {
            (alert:UIAlertAction)->Void in
            alertCT.dismiss(animated: true, completion: nil)
        }
        
        alertCT.addAction(okac)
        vc.present(alertCT, animated: true, completion: nil)
    }
}
