//
//  DataModel.swift
//  Proof Of Concept
//
//  Created by Trupti Gavhane on 07/07/18.
//  Copyright © 2018 Telstra. All rights reserved.
//

import UIKit

protocol DatModelProtocol {
    func didFetchData(data: NSDictionary)
}

class DataModel: NSObject {
    
    var datModelProtocol: DatModelProtocol?
    private static var dataModelSharedInstance: DataModel = {
        let dataModelSharedInstance = DataModel()
        // Configuration
        // ...
        return dataModelSharedInstance
    }()
    
    // MARK: - Accessors
    class func sharedInstance() -> DataModel {
        return dataModelSharedInstance
    }
    
    // MARK: - data model methods
    func fetchData() -> NSArray {
        var dataArray: NSArray = []
        var dataDictionary: NSDictionary = NSDictionary()
        
        DispatchQueue.global(qos: .background).async {
            //let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            let url = URL(string: Constants.baseURL)
            
            do{
                let data = try? Data(contentsOf: url!)
                
                let responseStrInISOLatin = String(data: data!, encoding: String.Encoding.isoLatin1)
                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                    print("could not convert data to UTF-8 format")
                    return
                }
                do {
                    //https://stackoverflow.com/questions/14321033/ios-nsjsonserialization-unable-to-convert-data-to-string-around-character/35338296
                    let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format) as! NSDictionary
                    dataArray = responseJSONDict["rows"] as! NSArray
                    dataDictionary = responseJSONDict
                } catch {
                    print(error)
                }
                
            // Background Thread
            DispatchQueue.main.async {
                // Run UI Updates
                self.datModelProtocol?.didFetchData(data: dataDictionary)
            }
        }
    }
        return dataArray

}

}
