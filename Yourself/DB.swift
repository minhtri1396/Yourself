class DB {
    func GetName() -> String {
        let className = String(describing: self)
        let range: Range<String.Index> = className.range(of: ".")!
        return className.substring(from: range.upperBound)
    }
}
