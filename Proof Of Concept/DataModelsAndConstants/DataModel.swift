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
                
                // fetch data in the background
                DispatchQueue.global(qos: .background).async {
                    guard let url = URL(string: Constants.baseURL) else {
                        return
                    }
                    
                    do{
                        guard let data = try? Data(contentsOf: url) else{
                            return
                        }
                        
                        let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
                        guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                            print("could not convert data to UTF-8 format")
                            return
                        }
                        do {
                            // take data under "row" key which is the array for the table
                            let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format) as! NSDictionary
                            dataArray = responseJSONDict[Constants.rowsKey] as! NSArray
                            
                            // this is the entire response dict including "title"
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
