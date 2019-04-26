//
//  PhoneContactFavouriteApi.swift
//  ContactSync
//
//  Created by Vedran on 25/03/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Contacts


class ApiEndpoints {
    
    class func fetchMatches(forDeviceContacts contacts:[CNContact],
                            syncUrl:URL) -> Observable<[[String : Any]]?> {
        Logging.URLRequests = { _ in false }
        
        let bodyString = ["phoneNumbers" : contacts.getPhoneNumbers().reducePhoneNumbersToString()]
        let jsonBody = try! JSONSerialization.data(withJSONObject: bodyString, options: .prettyPrinted)
        
        return URLSession.shared.rx.response(request: makeRequest(fromData: jsonBody, endpointUrl: syncUrl))
            .asObservable()
            .map { (arg) -> [[String : Any]]? in
            let (response, data) = arg
            guard response.statusCode == 200,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let jsonDictionary = json as? [String : Any],
                let userData = jsonDictionary["data"] as? [String : Any],
                let users = userData["users"] as? [[String : Any]] else {
                    return nil
            }
            print("\n- - API CONTACTS FETCHED - -\n")
            return users
        }
    }
    
    private static func makeRequest(fromData: Data, endpointUrl: URL) -> URLRequest {
        var request = URLRequest(url: endpointUrl)
        request.httpBody = fromData
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        return request
    }
    
}

