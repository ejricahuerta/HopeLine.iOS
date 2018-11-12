//
//  DataFetcher.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-05.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

enum JSonResult<Value> {
    case success(Value)
    case failure(Error)
    
}

class DataFetcher {

    func GetData(forAction: String, handler: ((JSonResult<Any>)->Void)?) {
        let strUrl = "\(APIConstants.url)\(forAction)"
        let url = URL(string: strUrl)
        let task  = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let resperr = error {
                handler?(.failure(resperr))
            }
            else {
                do {
                    let  jsondata = try JSONSerialization.jsonObject(with: data!) as! [NSDictionary]
                    print(jsondata)
                    handler?(.success(jsondata))
                }
                catch {
                    handler?(.failure(error))
                }
            }
        }
        task.resume()
    }

}
