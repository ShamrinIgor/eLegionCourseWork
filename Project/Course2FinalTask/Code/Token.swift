import Foundation

struct Token {
    var token: String
    
    init(str: String) {
        self.token = str
    }
    
    init() {
        self.token = ""
    }
}
