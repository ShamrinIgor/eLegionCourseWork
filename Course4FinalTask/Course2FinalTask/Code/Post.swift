import Foundation
import Kingfisher
import UIKit
//import DataProvider

struct Posts {
    
    public var posts: [Post] = []
    
    struct Post {
            /// Идентификатор автора публикации
            public var authorId: Int?
            /// Идентификатор публикации
            public var id: Int?

            /// Описание публикации
            public var description: String?

            /// Дата создания публикации
            public var createdTime: Date?

            /// Свойство, отображающее ставил ли текущий пользователь лайк на эту публикацию
            public var currentUserLikesThisPost: Bool?

            /// Количество лайков на этой публикации
            public var likedByCount: Int?

            /// Имя аккаунта автора публикации
            public var authorUsername: String?

            /// Аватар автора публикации
            public var authorAvatar: URL?
            
            public var image: URL?
                        
            init?(jsonItem: Dictionary<String, Any>) {
                guard let id = jsonItem["id"] as? String else {
                    print("1")
                    return nil
                }
                self.id = Int(id)
                
                guard let avatarStr = jsonItem["authorAvatar"] as? String else {
                    print("2")
                    return nil
                }
                if let url = URL(string: avatarStr) {
                    self.authorAvatar = url
                }
                
                guard let count = jsonItem["likedByCount"] as? Int else {
                    print("3")
                    return nil
                }
                self.likedByCount = count
                
                guard let imageUrlString = jsonItem["image"] as? String else {
                    print("4")
                    return nil
                }
                if let url = URL(string: imageUrlString) {
                           self.image = url
                       }
                
                guard let isoDate = jsonItem["createdTime"] as? String else {
                    print("5")
                    return nil
                }

                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                self.createdTime = dateFormatter.date(from:isoDate)!
                
                guard let name = jsonItem["authorUsername"] as? String else {
                    print("6")
                    return nil
                }
                self.authorUsername = name
                
                guard let des = jsonItem["description"] as? String else {
                    print("7")
                    return nil
                }
                self.description = des
                
                guard let liked = jsonItem["currentUserLikesThisPost"] as? Bool else {
                    print("8")
                    return nil
                }
                self.currentUserLikesThisPost = liked
            
                guard let author = jsonItem["author"] as? String else {
                    print("9")
                    return nil
                }
                self.authorId = Int(author)
            }
    }
            
            init?(json: [Dictionary<String, Any>] ) {
                
                for post in json {
                    guard let itemForArray = Post(jsonItem: post) else {
                        return
                    }
                    self.posts.append(itemForArray)
                }
            }

        }

    
