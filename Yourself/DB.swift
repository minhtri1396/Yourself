import Foundation

class DB {
    
    static func Sync(closure: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            GAccount.Instance.Verify() {
                (email, result) in
                
                if result {
                    DAOFJars.BUIDER.Sync()
                    DAOFIntent.BUIDER.Sync()
                    DAOFAlternatives.BUIDER.Sync()
                    DAOFTime.BUIDER.Sync()
                    DAOFCheerUp.BUIDER.Sync()
                    DAOFTimeStats.BUIDER.Sync()
                    
                    _ = DAOTrash.BUILDER.DeleteAll()
                }
                
                closure(result)
            }
        }
    }
    
    func GetName() -> String {
        let className = String(describing: self)
        let range: Range<String.Index> = className.range(of: ".")!
        return className.substring(from: range.upperBound)
    }
}
