import UIKit

class ExpenseNoteCell: UITableViewCell {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bodyView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ownedJarLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var altJarLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
}
