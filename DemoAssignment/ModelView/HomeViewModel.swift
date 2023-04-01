//
//  HomeViewModel.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 01/04/23.
//

import UIKit

class HomeViewModel: NSObject {
    
    var categoryData = [CategoryMDL]()

    func fetchDataFromServer(completionHandler :@escaping ([CategoryMDL]?)->()){
        
        let urlString = "https://api.escuelajs.co/api/v1/products"
        
        if let url  = URL(string: urlString){
            
            URLSession.shared.dataTask(with: url) { resData, resResult, error in
                
                guard let rData = resData else{return}
                
                do {
                    
                    let jsonDecoder = JSONDecoder()
                    let mdlData = try jsonDecoder.decode([CategoryMDL].self, from: rData)

                    self.categoryData = mdlData.sorted { $0.id < $1.id }

                    completionHandler(self.categoryData)
                }
                catch let error {
                    
                    debugPrint(error.localizedDescription)
                }
            }
            .resume()
        }
    }
    
    // MARK: Pagination Mapped

    func moreDataFetch(indexValue: inout Int,completionHandler:([CategoryMDL])->()){
        guard self.categoryData.count > 0 else {return}
        
        let mdlData = self.categoryData
        
        if indexValue < mdlData.count - 1 {
            if (indexValue + 10) < mdlData.count - 1 {
                
                self.mappData(page: indexValue + 1, count: (indexValue + 9), mdlData: mdlData) { mappedCategoryData in
                    completionHandler(mappedCategoryData)
                }
            }
            else{
                
                self.mappData(page: indexValue + 1, count: mdlData.count - 1, mdlData: mdlData) { mappedCategoryData in
                    completionHandler(mappedCategoryData)
                }
                
            }
        }
    }
    
    func mappData(page:Int,count:Int, mdlData : [CategoryMDL],completionHandler:([CategoryMDL])->()){
        var tempData = [CategoryMDL]()
        for i in (page...count - 1){
            
            tempData.append(mdlData[i])
        }
        completionHandler(tempData)
    }
}
