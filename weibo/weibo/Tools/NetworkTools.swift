//
//  NetworkTools.swift
//  wangluotool
//
//  Created by better on 2019/7/26.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {
    //枚举类型
    enum RequestType {
        case GET
        case POST
    }
//    enum RequestType : Int {
//        case GET = 0
//        case POST = 1
//    }
//    enum RequestType : String {
//        case GET = "GET"
//        case POST = "POST"
//    }
    
    
    
    //let:线程是安全的
    //单例
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
        //这个是服务器返回的类型中没有text/html,我们将它添加到解析类型中就可以了
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tools
    }()
}
//MARK:- 封装请求方法
extension NetworkTools {
    func request(methodType:RequestType, urlString:String,parameters:[String:AnyObject],finished:@escaping (_ result:AnyObject?,_ error:Error?)->()) {
        //定义成功回调
        let successCallBack = { (task:URLSessionDataTask, result:Any?) in
            //task:任务,result:返回的结果
//            print("发送请求成功\(String(describing: result))")
            finished(result as AnyObject,nil)
        }
        //定义失败回调
        let failureCallBack = { (task:URLSessionDataTask?, error:Error) in
                print("发送请求失败\(error)")
                finished(nil,error)
        }
        
        
        
        if(methodType == RequestType.GET ){
        //参数1:url,参数2:请求参数,参数3:监听进度,参数4:成功回调,参数5:失败回调
         get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
        else{
        //参数1:url,参数2:请求参数,参数3:监听进度,参数4:成功回调,参数5:失败回调
        post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
    }
    }
}


//MARK: - 请求AccessToken
extension NetworkTools {
    func loadAccessToken(code:String,finished:@escaping (_ result:[String:AnyObject]?,_ error:Error?)->()) {
        //获取url
        let  urlString = "https://api.weibo.com/oauth2/access_token"
        
        //获取请求参数
        let parameters = ["client_id":app_key,"client_secret":app_secret,"grant_type":"authorization_code","code":code,"redirect_uri":redirect_uri]
        
        //发送网络请求
        request(methodType: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result:AnyObject?, error:Error?) in
            finished(result as? [String:AnyObject],error)
        }
        
    }
}
//MARK: - 请求用户信息
extension NetworkTools {
    func loadUserInfo(accessToken:String,uid:String,finished:@escaping (_ result:[String:AnyObject]?,_ error:Error?)->()) {
        //获取url
        let urlString = "https://api.weibo.com/2/users/show.json"
        //设置参数
        let parameters = ["access_token":accessToken,"uid":uid]
        
        //发送网络请求
        request(methodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result:AnyObject?, error:Error?) in
            finished(result as? [String : AnyObject],error)
        }
    }
    
}
//MARK: - 请求用户信息
extension NetworkTools {
    func loadStatuses(since_id: Int, max_id: Int, finished:@escaping (_ result:[[String:AnyObject]]?,_ error:Error?)->()) {
        //获取请求路径
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        //获取请求参数
        let parameters = ["access_token":(UserAccountViewModel.shareInstance.account?.access_token)!,"since_id":"\(since_id)","max_id":"\(max_id)"]
        //发送网络请求
        request(methodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result:AnyObject?, error:Error?) in
            //1获取字典数据
            guard let resultDict = result as? [String: AnyObject] else {
                finished(nil,error)
                return
            }
            //2将数组数据回调给外界
            finished((resultDict["statuses"] as? [[String : AnyObject]]),error)
        }
        
    }
}
//MARK: - 发送微博
extension NetworkTools {
    func sendStatus(statusText:String,isSuccess:@escaping (_ isSuccess:Bool)->()) {
        //1.获取请求的url
        let url = "https://api.weibo.com/2/statuses/update.json"
        //2.设置请求参数
        let parameters = ["access_token":(UserAccountViewModel.shareInstance.account?.access_token)!,"status":statusText]
        //3.发送网络请求
        request(methodType: .POST, urlString: url, parameters: parameters as [String : AnyObject]) { (result:AnyObject?, error:Error?) in
            if result != nil {
                isSuccess(true)
            } else {
                isSuccess(false)
            }
        }
    }
}

//MARK: - 发送微博携带图片
extension NetworkTools {
    func sendStatusAndPicture(statusText: String,image: UIImage,isSuccess: @escaping (_ isSuccess:Bool)->()) {
        //1.获取请求的url
        let url = "https://api.weibo.com/2/statuses/upload.json"
        //2.设置请求参数
        let parameters = ["access_token":(UserAccountViewModel.shareInstance.account?.access_token)!,"status":statusText]
        //4.发送网络请求(往服务器上传数据)
        post(url, parameters: parameters, constructingBodyWith: { (formDate:AFMultipartFormData) in
            //1.数据形式为二进制形式
            if let imageData = image.jpegData(compressionQuality:0.5) {
                formDate.appendPart(withFileData: imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
        }, progress: nil, success: { (_, _) in
            isSuccess(true)
        }) { (_, error:Error) in
            isSuccess(false)
            print(error)
        }
    }
    
}
