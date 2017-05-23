class DTOUser {
    let uid: String // user id
    let fid: String // firebase id
    let email: String
    let verified: Bool
    
    init(uid: String, fid: String, email: String, verified: Bool) {
        self.uid = uid
        self.fid = fid
        self.email = email
        self.verified = verified
    }
}
