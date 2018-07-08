//
//  Constants.swift
//  Proof Of Concept
//
//  Created by Trupti Gavhane on 08/07/18.
//  Copyright © 2018 Telstra. All rights reserved.
//

import Foundation
import SystemConfiguration

class Constants {

static let sharedInstance = Constants()

    static let baseURL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    static let labelTitle = "title"
    static let labelDescription = "description"
    static let rowsKey = "rows"
    static let titleKey = "title"
    static let imageKey = "imageHref"
    static let thumbnailWidth = 60
    static let thumbnailHeight = 60
    
    // This function checks the network conditions, returns a boolean
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }

}


