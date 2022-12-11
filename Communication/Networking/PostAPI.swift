//
//  PostAPI.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 02/03/1444 AH.
//

import Foundation
import Alamofire
import SwiftyJSON


class PostAPI:API{

    //MARK: GET ALL POST
    static func getAllPosts(page:Int,tag:String?,completionHandler : @escaping ([Post],Int)->()){
        
        var URLPost = baseURL+"/post"
        
        if var myTag = tag{
            // to remove space
            myTag = myTag.trimmingCharacters(in: .whitespaces)
            URLPost = "\(baseURL)/tag/\(myTag)/post"
        }
        let params = [
            "page":"\(page)",
            "limit" : "5"
        ]
        AF.request(URLPost,parameters:params,encoder: URLEncodedFormParameterEncoder.default,headers: headers).responseJSON { response in
            
            let jsonData = JSON(response.value)
            let data = jsonData["data"]
            let total = jsonData["total"].intValue
            let decoder =  JSONDecoder()
            do {
                let posts = try decoder.decode([Post].self,from:data.rawData())
                completionHandler(posts,total)
            }catch let error{
                print(error)
            }
        }
    }
    
    // MARK: CREATE POST
    static func createPost(image:String,text:String , userId:String ,completionHandler : @escaping(Post?)->()){
        let URLComment = "\(baseURL)/post/create"
        
        let params = [
            "image": image,
            "owner" : userId,
            "text" : text
        ]
        
        AF.request(URLComment,method: .post,parameters: params,encoder: JSONParameterEncoder.default,headers: headers).validate().responseJSON { response in
            
            switch response.result{
            case .success :
                let jsonData = JSON(response.value)
                let decoder =  JSONDecoder()
                do {
                    let post = try decoder.decode(Post.self,from:jsonData.rawData())
                    completionHandler(post)
                }catch let error{
                    print(error)
                }
            
            case .failure(let error):
                print (error)
            }
        }
    }
    
    //MARK: GET ALL COMMENT
    static func getAllComments(id:String,completionHandler : @escaping([Comment])->()){
        
        let URLComment = baseURL+"/post/\(id)/comment"
        
        AF.request(URLComment,headers: headers).responseJSON { response in

            let jsonData = JSON(response.value)
            let data = jsonData["data"]
            let decoder =  JSONDecoder()
            do {
                let comment = try decoder.decode([Comment].self,from:data.rawData())
                completionHandler(comment)
            }catch let error{
                print(error)
            }
        }

    }
    
    // MARK: GET ALL TAG
    static func getAllTag (completionHandler : @escaping ([String?])->()){
        
        let URLTag = "\(baseURL)/tag"
        
        AF.request(URLTag,headers: headers).responseJSON { response in
            
            let jsonData = JSON(response.value)
            let data = jsonData["data"]
            let decoder =  JSONDecoder()
            do {
                let tags = try decoder.decode([String?].self,from:data.rawData())
                completionHandler(tags)
            }catch let error{
                print(error)
            }
        }
    }
    
    // MARK: CREATE COMMENT
    static func createComment(postId:String , userId:String , message:String,completionHandler : @escaping()->()){
        let URLComment = "\(baseURL)/comment/create"
        
        let params = [
            "message" : message,
            "owner" : userId,
            "post" : postId
        ]
        
        AF.request(URLComment,method: .post,parameters: params,encoder: JSONParameterEncoder.default,headers: headers).validate().responseJSON { response in
            
            switch response.result{
            case .success :
                completionHandler()
            
            case .failure(let error):
                print (error)
            }
        }
    }
    
    //MARK: DELETE SPASIFIC POST
    static func deletePost(postId:String ,completionHandler : @escaping()->()){
        let URLComment = "\(baseURL)/post/\(postId)"
        

        AF.request(URLComment,method: .delete,headers: headers).validate().responseJSON { response in
            
            switch response.result{
            case .success :
                let jsonData = JSON(response.value)
                let decoder =  JSONDecoder()
                do {
                    completionHandler()
                }catch let error{
                    print(error)
                }
            
            case .failure(let error):
                print (error)
            }
        }
    }
    
    //MARK: GET SPASIFICE POST
    static func getSpasificPosts(page:Int,id:String,completionHandler : @escaping ([Post],Int)->()){
        
        var URLPost = "\(baseURL)/user/\(id)/post"
        
        let params = [
            "page":"\(page)",
            "limit" : "12"
        ]
        
        AF.request(URLPost,parameters: params,encoder: URLEncodedFormParameterEncoder.default,headers: headers).responseJSON { response in
            
            let jsonData = JSON(response.value)
            let data = jsonData["data"]
            let total = jsonData["total"].intValue
            let decoder =  JSONDecoder()
            do {
                let posts = try decoder.decode([Post].self,from:data.rawData())
                completionHandler(posts,total)
            }catch let error{
                print(error)
            }
        }
    }
}
