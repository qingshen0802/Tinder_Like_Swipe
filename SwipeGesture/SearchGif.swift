//
//  SearchGif.swift
//  SwipeGesture
//
//  Created by Master on 9/7/21.
//

import Foundation
import Alamofire

class SearchGif : ObservableObject{
    @Published var searchResult = [GifModel]()
    
    init(key: String) {
        getGifs(key: key)
    }
    
    func getGifs(key: String) {
        AF.request("https://api.giphy.com/v1/gifs/search?api_key=\(GIPHY_API_KEY)&q=\(key)")
            .responseJSON { (response) in
                if response.error == nil {
                    do {
                        let value = try response.result.get()
                        let res = value as! [String: AnyObject]
                        let array = res["data"] as! [[String: AnyObject]]
                        var gif = GifModel()
                        var index = 0
                        for item in array {
                            gif.id = index
                            let images = item["images"]
                            let origin = images!["original_still"] as AnyObject
                            gif.imageUrl = origin["url"] as! String
                            self.searchResult.append(gif)
                            index = index + 1
                        }
                     } catch {
                         print("Error retrieving the value:")
                     }
                } else {
                    print(response.error!)
                }
            }
    }
}
