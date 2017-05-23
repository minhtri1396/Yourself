import UIKit

class TimeNotesList: UIViewController {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    
    // MARK: *** UI events
    @IBAction func StatsButton_Tapped(_ sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let timeStatistics = storyBoard.instantiateViewController(withIdentifier: "TimeStatistics")
        self.present(timeStatistics, animated: true, completion: nil)
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}
