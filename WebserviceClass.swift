//
//  WebserviceClass.swift
//  SearchBarAssignment
//
//  Created by Taniya on 22/07/19.
//  Copyright 2019 viktaan.com. All rights reserved.
//


import UIKit
@objc protocol webServiceDelegate
{
    @objc optional  func movieListResponse(dictionary:NSDictionary)
}

private let sharedKraken = WebserviceClass()

var baseUrl:String! = "https://api.themoviedb.org/3/"

class WebserviceClass: NSObject {
    
    var window: UIWindow!
    let screenSize: CGRect = UIScreen.main.bounds
    
    var delegates : webServiceDelegate?
    
    class var sharedInstance: WebserviceClass {
        return sharedKraken
    }
    
    // MARK: - getMovieList Call
    func getMovieList()
    {
        var anyObj = NSDictionary()
        do {
            let url = "movie/now_playing?api_key=6be464dbe3f3ad7c603e4b8735334c4b&language=en-US&page=1"
            let finalURL = baseUrl + "" + url
            let url2 = URL(string:finalURL as String)
            var request = URLRequest(url: url2!)
            request.httpMethod = "GET"
            
            do {
                NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { (response, data, error) -> Void in
                    
                    let string = NSString(data: data!, encoding: String.Encoding.isoLatin1.rawValue)
                    let data = string!.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
                    
                    do {
                        anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        self.delegates?.movieListResponse!(dictionary: anyObj)
                    } catch {
                        print("json error: \(error)")
                    }
                }
            }
        }
    }
}
