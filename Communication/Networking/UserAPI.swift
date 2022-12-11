//
//  ProfileUserAPI.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 04/03/1444 AH.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserAPI : API {
   
    //MARK: GET SPACIFISE USER
    static func getSpacifiseUser(id:String , completionHandler : @escaping(User)->()){
       
        let URLUser = "\(baseURL)/user/\(id)"
        
        AF.request(URLUser,headers: headers).responseJSON { response in
            
            let jsonData = JSON(response.value)
            let decoder =  JSONDecoder()
            do {
                let user = try decoder.decode(User.self,from: jsonData.rawData())
                completionHandler(user)
            }catch let error{
                print(error)
            }
        }
    }
    
    //MARK: GET ALL USER
    static func getAllUser(page:Int,completionHandler : @escaping([User],Int)->()){
       
        let URLUser = "\(baseURL)/user"
        
        let params = [
            "page":"\(page)",
            "limit" : "20"
        ]
        
        AF.request(URLUser,parameters: params,encoder: URLEncodedFormParameterEncoder.default,headers: headers).responseJSON { response in
            
            let jsonData = JSON(response.value)
            let data = jsonData["data"]
            let total = jsonData["total"].intValue
            let decoder =  JSONDecoder()
            do {
                let user = try decoder.decode([User].self,from: data.rawData())
                completionHandler(user,total)
            }catch let error{
                print(error)
            }
        }
    }
    
    //MARK: CREATE USER
    static func createUser(firstName:String,lastName:String,email:String,title:String,gender:String,phoneNumber:String,completionHandler : @escaping(User?,String?)->()){
       
        let URLUser = "\(baseURL)/user/create"
        let params = [
            "firstName" : firstName,
            "lastName" : lastName,
            "email" : email,
            "title" : title,
            "gender":gender,
            "phone" : phoneNumber
        ]

        AF.request(URLUser,method: .post,parameters: params,encoder: JSONParameterEncoder.default,headers: headers).validate().responseJSON { response in
            
            switch response.result{
            case .success :
                let jsonData = JSON(response.value)
                let decoder =  JSONDecoder()
                do {
                    let user = try decoder.decode(User.self,from: jsonData.rawData())
                    completionHandler(user,nil)
                }catch let error{
                    print(error)
                }
            
            case .failure(let error):
                
                let JSONData = JSON(response.data)
                let data = JSONData["data"]
                
                //MARK: MESSAGE ERRORS
                
                let emailError = data["email"].stringValue
                let firstNameError = data["firstName"].stringValue
                let lastNameError = data["lastName"].stringValue
                let titleError = data["title"].stringValue
                let genderError = data["gender"].stringValue
                let phoneNumberError = data["phone"].stringValue
                
                let messageError = emailError + " " + firstNameError + " " + lastNameError + " " + titleError + " " + genderError + " " + phoneNumberError

                completionHandler(nil,messageError)
            }
            
        }
    }
    
    //MARK: SIGN IN
    static func signIn(firstName:String,lastName:String,completionHandler : @escaping(User?,String?)->()){
       
        let URLUser = "\(baseURL)/user"
        let params = [
            "created" : 1
        ]

        AF.request(URLUser,method: .get,parameters: params,encoder: URLEncodedFormParameterEncoder.default,headers: headers).validate().responseJSON { response in
            
            switch response.result{
            case .success :
                let jsonData = JSON(response.value)
                let data = jsonData["data"]
                let decoder =  JSONDecoder()
                do {
                    let users = try decoder.decode([User].self,from: data.rawData())
                    
                    var foundUser : User?
                    for user in users{
                        if user.firstName == firstName && user.lastName == lastName{
                            foundUser = user
                            break
                        }
                    }
                    
                    if let user = foundUser{
                        completionHandler(user,nil)
                    }else{
                        completionHandler(nil,"The first name of last name don't match any user")
                    }
                    print(users)
                  
                }catch let error{
                    print(error)
                }
            
            case .failure(let error):
                
                let JSONData = JSON(response.data)
                let data = JSONData["data"]
                
                //MARK: MESSAGE ERRORS
                
                let emailError = data["email"].stringValue
                let firstNameError = data["firstName"].stringValue
                let lastNameError = data["lastName"].stringValue
                let titleError = data["title"].stringValue
                let genderError = data["gender"].stringValue
                let phoneNumberError = data["phone"].stringValue
                
                let messageError = emailError + " " + firstNameError + " " + lastNameError + " " + titleError + " " + genderError + " " + phoneNumberError

                completionHandler(nil,messageError)
            }
            
        }
    }
    
    //MARK: UPDATE PROFILE
    static func updateMyProfile(id:String ,image:String,completionHandler : @escaping(User?,String?)->()){
       
        let URLUser = "\(baseURL)/user/\(id)"
        
       let params = [
            "picture":image
       ]
        
        AF.request(URLUser,method: .put,parameters: params,encoder: JSONParameterEncoder.default,headers: headers).validate().responseJSON { response in
            
            switch response.result{
            case .success :
                let jsonData = JSON(response.value)
                let decoder =  JSONDecoder()
                do {
                    let user = try decoder.decode(User.self,from: jsonData.rawData())
                    completionHandler(user,nil)
                  
                }catch let error{
                    print(error)
                }
            
            case .failure(let error):
                
                let JSONData = JSON(response.data)
                let data = JSONData["data"]
                
                //MARK: MESSAGE ERRORS
                
                let emailError = data["email"].stringValue
                let firstNameError = data["firstName"].stringValue
                let lastNameError = data["lastName"].stringValue
                let titleError = data["title"].stringValue
                let genderError = data["gender"].stringValue
                let phoneNumberError = data["phone"].stringValue
                
                let messageError = emailError + " " + firstNameError + " " + lastNameError + " " + titleError + " " + genderError + " " + phoneNumberError

                completionHandler(nil,messageError)
            }
        }
    }
    
    //MARK: DELETE SPECIFIC USER
    static func deleteSpecificUser(id:String,completionHandler : @escaping()->()){
       
        let URLUser = "\(baseURL)/user/\(id)"

        
        AF.request(URLUser,method: .delete,headers: headers).responseJSON { response in
            
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


}
