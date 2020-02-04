//
//  Requests.swift
//  Course2FinalTask
//
//  Created by Игорь on 20/01/2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

func logIn(login: String, password: String, completionHandler: @escaping (Result<String>) ->Void) {
    let url = URL(string: "http://localhost:8080/signin/")
    var request = URLRequest(url: url!)
    
    let encoder = JSONEncoder()
    let account = Account(login: login, password: password)
    let accountJsonData = try? encoder.encode(account)
    
    request.allHTTPHeaderFields = ["Content-Type" : "application/json"]
    request.httpMethod = "POST"
    request.httpBody = accountJsonData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("krinjer2")
            print(String(describing: error))
            return
            }
        print(String(data: data, encoding: .utf8)!, "krinjer18+")
        
        if let error = error {
            print("krinjer ")
            print(error.localizedDescription)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("http status code: \(httpResponse.statusCode)")
        }
        
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let errorInResponse = json["error"] as? Bool {
                    if errorInResponse {
                        completionHandler(.success("Error"))
                    }
                }
                
                if let jsonToken = json["token"] as? String {
                    print("Figa cring")
                    completionHandler(.success(jsonToken))
                }
            }
        } catch {
            print ("JSON Serialization error!")
            completionHandler(.fail(error))
            return
        }
    }
    
    task.resume()
}

func getPostsForFeed(token: String, completionHandler: @escaping (Result<Posts>) ->Void) {
    
    let url = URL(string: "http://localhost:8080/posts/feed")
    var request = URLRequest(url: url!)
    request.addValue(token, forHTTPHeaderField: "token")
    request.httpMethod = "GET"


    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            completionHandler(.fail(error!))
            return
        }
        
        guard let responceData = data else {
            let error = BackendError.objectSerialization(reason: "No data in responce")
            completionHandler(.fail(error)!)
            return
        }
        print(String(data: responceData, encoding: .utf8)!)
        
            do {
                if let json = try JSONSerialization.jsonObject(with: responceData, options: []) as? [Dictionary<String, Any>],
                    let posts = Posts(json: json) {
                        completionHandler(.success(posts))
                    } else {
                        let error = BackendError.objectSerialization(reason: "Can't create object from JSON")
                        completionHandler(.fail(error)!)
                    }
                } catch {
                    completionHandler(.fail(error)!)
                    return
                }
    }
    task.resume()
}

func getUser(withId id: Int, token: String , completionHandler: @escaping (Result<User>) ->Void) {
    let url = URL(string: "http://localhost:8080/users/" + String(id))
    var request = URLRequest(url: url!)
    request.addValue(token, forHTTPHeaderField: "token")
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            completionHandler(.fail(error!))
            return
        }
        
        guard let responceData = data else {
            let error = BackendError.objectSerialization(reason: "No data in responce")
            completionHandler(.fail(error)!)
            return
        }
        print(String(data: responceData, encoding: .utf8)!)
        
            do {
                if let json = try JSONSerialization.jsonObject(with: responceData, options: []) as? Dictionary<String, Any>,
                    let user = User(jsonItem: json) {
                       print("Создает юзера",user)
                        completionHandler(.success(user))
                    } else {
                        let error = BackendError.objectSerialization(reason: "Can't create object from JSON")
                        completionHandler(.fail(error)!)
                    }
                } catch {
                    completionHandler(.fail(error)!)
                    return
                }
    }
    task.resume()
}

func getUserMe(token: String, completionHandler: @escaping (Result<User>) ->Void) {
    let url = URL(string: "http://localhost:8080/users/me")
    var request = URLRequest(url: url!)
    request.addValue(token, forHTTPHeaderField: "token")
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            completionHandler(.fail(error!))
            return
        }
        
        guard let responceData = data else {
            let error = BackendError.objectSerialization(reason: "No data in responce")
            completionHandler(.fail(error)!)
            return
        }
        print(String(data: responceData, encoding: .utf8)!)
        
            do {
                if let json = try JSONSerialization.jsonObject(with: responceData, options: []) as? Dictionary<String, Any>,
                    let user = User(jsonItem: json) {
                       print("Создает юзера",user)
                        completionHandler(.success(user))
                    } else {
                        let error = BackendError.objectSerialization(reason: "Can't create object from JSON")
                        completionHandler(.fail(error)!)
                    }
                } catch {
                    completionHandler(.fail(error)!)
                    return
                }
    }
    task.resume()
}

func getPosts(ofUserWithId id: Int, token: String, completionHandler: @escaping (Result<Posts>) ->Void) {
    let url = URL(string: "http://localhost:8080/users/" + String(id) + "/posts")
    var request = URLRequest(url: url!)
    request.addValue(token, forHTTPHeaderField: "token")
    request.httpMethod = "GET"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            completionHandler(.fail(error!))
            return
        }
               
        guard let responceData = data else {
            let error = BackendError.objectSerialization(reason: "No data in responce")
            completionHandler(.fail(error)!)
            return
        }
        print(String(data: responceData, encoding: .utf8)!)
               
        do {
            if let json = try JSONSerialization.jsonObject(with: responceData, options: []) as? [Dictionary<String, Any>],
            let posts = Posts(json: json) {
               print(json)
                completionHandler(.success(posts))
            } else {
                let error = BackendError.objectSerialization(reason: "Can't create object from JSON")
                completionHandler(.fail(error)!)
            }
        } catch {
            completionHandler(.fail(error)!)
            return
        }
    }
    task.resume()
}

func getUserLikedPost(withId id: Int, token: String, completionHandler: @escaping (Result<Users>) ->Void) {
    let url = URL(string: "http://localhost:8080/posts/" + String(id) + "/likes")
    var request = URLRequest(url: url!)
    request.addValue(token, forHTTPHeaderField: "token")
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            completionHandler(.fail(error!))
            return
        }
               
        guard let responceData = data else {
            let error = BackendError.objectSerialization(reason: "No data in responce")
            completionHandler(.fail(error)!)
            return
        }
        print(String(data: responceData, encoding: .utf8)!)
               
        do {
        if let json = try JSONSerialization.jsonObject(with: responceData, options: []) as? [Dictionary<String, Any>],
            let users = Users(json: json) {
                completionHandler(.success(users))
            } else {
                let error = BackendError.objectSerialization(reason: "Can't create object from JSON")
                completionHandler(.fail(error)!)
            }
        } catch {
            completionHandler(.fail(error)!)
            return
        }
    }
    task.resume()

}

struct postID: Codable {
    var postID: String
    init(id: Int) {
        self.postID = String(id)
    }
}

func likePost(withID id: Int, token: String, completionHandler: @escaping (Result<Posts.Post>) ->Void) {
    let url = URL(string: "http://localhost:8080/posts/like")
    var request = URLRequest(url: url!)
    
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(postID(id: id))
    
    request.allHTTPHeaderFields = ["Content-Type" : "application/json"]
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.addValue(token, forHTTPHeaderField: "token")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("krinjer2")
            print(String(describing: error))
            return
            }
        print(String(data: data, encoding: .utf8)!, "krinjer18+")
        
        if let error = error {
            print("krinjer ")
            print(error.localizedDescription)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("http status code: \(httpResponse.statusCode)")
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>,
            let post = Posts.Post(jsonItem: json) {
                    completionHandler(.success(post))
            } else {
                let error = BackendError.objectSerialization(reason: "Can't create object from JSON")
                completionHandler(.fail(error)!)
            }
        } catch {
            print ("JSON Serialization error!")
            completionHandler(.fail(error))
            return
        }
    }
    
    task.resume()
}

func unlikePost(withID id: Int, token: String, completionHandler: @escaping (Result<Posts.Post>) ->Void) {
    let url = URL(string: "http://localhost:8080/posts/unlike")
    var request = URLRequest(url: url!)
    
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(postID(id: id))
    
    request.allHTTPHeaderFields = ["Content-Type" : "application/json"]
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.addValue(token, forHTTPHeaderField: "token")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("krinjer2")
            print(String(describing: error))
            return
            }
        print(String(data: data, encoding: .utf8)!, "krinjer18+")
        
        if let error = error {
            print("krinjer ")
            print(error.localizedDescription)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("http status code: \(httpResponse.statusCode)")
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>,
            let post = Posts.Post(jsonItem: json) {
                    completionHandler(.success(post))
            } else {
                let error = BackendError.objectSerialization(reason: "Can't create object from JSON")
                completionHandler(.fail(error)!)
            }
        } catch {
            print ("JSON Serialization error!")
            completionHandler(.fail(error))
            return
        }
    }
    
    task.resume()
}



struct userForFollow: Codable {
    var userID: String
    init(id: Int) {
        self.userID = String(id)
    }
}


func followUser(withID id: Int, token: String, completionHandler: @escaping (Result<User>) ->Void) {
    let url = URL(string: "http://localhost:8080/users/follow")
    var request = URLRequest(url: url!)
    
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(userForFollow(id: id))
    
    request.allHTTPHeaderFields = ["Content-Type" : "application/json"]
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.addValue(token, forHTTPHeaderField: "token")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("krinjer2")
            print(String(describing: error))
            return
            }
        print(String(data: data, encoding: .utf8)!, "krinjer18+")
        
        if let error = error {
            print("krinjer ")
            print(error.localizedDescription)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("http status code: \(httpResponse.statusCode)")
            if httpResponse.statusCode == 406 {
                completionHandler(.badResponse(406))
                return
            }
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>,
            let user = User(jsonItem: json) {
                    completionHandler(.success(user))
            } else {
                let error = BackendError.objectSerialization(reason: "Can't create object from JSON")
                completionHandler(.fail(error)!)
            }
        } catch {
            print ("JSON Serialization error!")
            completionHandler(.fail(error))
            return
        }
    }
    
    task.resume()
}

func unfollowUser(withID id: Int, token: String, completionHandler: @escaping (Result<User>) ->Void) {
    let url = URL(string: "http://localhost:8080/users/unfollow")
    var request = URLRequest(url: url!)
    
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(userForFollow(id: id))
    
    request.allHTTPHeaderFields = ["Content-Type" : "application/json"]
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.addValue(token, forHTTPHeaderField: "token")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("krinjer2")
            print(String(describing: error))
            return
            }
        print(String(data: data, encoding: .utf8)!, "krinjer18+")
        
        if let error = error {
            print("krinjer ")
            print(error.localizedDescription)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("http status code: \(httpResponse.statusCode)")
            if httpResponse.statusCode == 406 {
                completionHandler(.badResponse(406))
                return
            }
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>,
            let user = User(jsonItem: json) {
                    completionHandler(.success(user))
            } else {
                let error = BackendError.objectSerialization(reason: "Can't create object from JSON")
                completionHandler(.fail(error)!)
            }
        } catch {
            print ("JSON Serialization error!")
            completionHandler(.fail(error))
            return
        }
    }
    
    task.resume()
}

func createPost(token: String, image: UIImage, description: String, completionHandler: @escaping (Result<Posts.Post>) ->Void) {
    let url = URL(string: "http://localhost:8080/signin/")
    var request = URLRequest(url: url!)
    
    let imageData = image.pngData()!
    let strBase64Data = imageData.base64EncodedData()
    
    request.allHTTPHeaderFields = ["Content-Type" : "application/json"]
    request.httpMethod = "POST"
    request.httpBody = strBase64Data

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("krinjer2")
            print(String(describing: error))
            return
            }
        print(String(data: data, encoding: .utf8)!, "krinjer18+")
        
        if let error = error {
            print("krinjer ")
            print(error.localizedDescription)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("http status code: \(httpResponse.statusCode)")
        }
        
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>,
            let post = Posts.Post(jsonItem: json) {
                    completionHandler(.success(post))
            } else {
                let error = BackendError.objectSerialization(reason: "Can't create object from JSON")
                completionHandler(.fail(error)!)
            }
        } catch {
            print ("JSON Serialization error!")
            completionHandler(.fail(error))
            return
        }
    }
    
    task.resume()
}
