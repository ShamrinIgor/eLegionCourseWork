import Foundation

class Account: Codable {
    var login: String
    var password: String
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}
