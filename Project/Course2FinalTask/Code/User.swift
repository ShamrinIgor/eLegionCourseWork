import Foundation
import UIKit
//import DataProvider
struct User {
    /// Идентификатор пользователя
    public var id: Int?

    /// Имя аккаунта пользователя
    public var username: String?

    /// Полное имя пользователя пользователя
    public var fullName: String?

    /// Аватар пользователя
    public var avatar: URL?

    /// Свойство, отображающее подписан ли текущий пользователь на этого пользователя
    public var currentUserFollowsThisUser: Bool?

    /// Свойство, отображающее подписан ли этот пользователь на текущего пользователя
    public var currentUserIsFollowedByThisUser: Bool?

    /// Количество подписок этого пользователя
    public var followsCount: Int?

    /// Количество подписчиков этого пользователя
    public var followedByCount: Int?
    
    init?(jsonItem: Dictionary<String, Any>) {
        
        guard let id = jsonItem["id"] as? String else {
            print("Ошибка в инициализаторе User 1")
            return
        }
        self.id = Int(id)
        
        guard let username = jsonItem["username"] as? String else {
            print("Ошибка в инициализаторе User 2")
            return
        }
        self.username = username
        
        guard let fullName = jsonItem["fullName"] as? String else {
            print("Ошибка в инициализаторе User 3")
            return
        }
        self.fullName = fullName
        
        guard let avatar = jsonItem["avatar"] as? String else {
            print("Ошибка в инициализаторе User 4")
            return
        }
        self.avatar = URL(string: avatar)
        
        guard let currentUserFollowsThisUser = jsonItem["currentUserFollowsThisUser"] as? Bool else {
            print("Ошибка в инициализаторе User 5")
            return
        }
        self.currentUserFollowsThisUser = currentUserFollowsThisUser
        
        guard let currentUserIsFollowedByThisUser = jsonItem["currentUserIsFollowedByThisUser"] as? Bool else {
            print("Ошибка в инициализаторе User 6")
            return
        }
        self.currentUserIsFollowedByThisUser = currentUserIsFollowedByThisUser
        
        guard let followsCount = jsonItem["followsCount"] as? Int else {
            print("Ошибка в инициализаторе User 7")
            return
        }
        self.followsCount = followsCount
        
        guard let followedByCount = jsonItem["followedByCount"] as? Int else {
            print("Ошибка в инициализаторе User 8")
            return
        }
        self.followedByCount = followedByCount
    }
}

struct Users {
    var users: [User] = []
    
    init?(json: [Dictionary<String, Any>]) {
        for user in json {
            guard let itemForArray = User(jsonItem: user) else {
                return
            }
            self.users.append(itemForArray)
        }
    }
}
