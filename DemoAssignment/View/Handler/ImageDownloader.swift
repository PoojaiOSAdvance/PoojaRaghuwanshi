//
//  ImageDownloader.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 01/04/23.
//

import UIKit

class ImageDownloader   {
   
    static let shared = ImageDownloader()
    
    private init(){}
    
    // MARK: Home page  images
    var task : URLSessionDataTask!
    var imageCache = NSCache<AnyObject, AnyObject>()
    var image : UIImage?
    
    // MARK: mutliple cat images
    var catImage : UIImage?
    var catImageCache = NSCache<AnyObject, AnyObject>()
    var taskCat : URLSessionDataTask!

    // MARK: single cat images
    var sImage : UIImage?
    var sImageCache = NSCache<AnyObject, AnyObject>()
    var sTask : URLSessionDataTask!

    // MARK: firstIndex cat images
    var fImage : UIImage?
    var fImageCache = NSCache<AnyObject, AnyObject>()
    var fTask : URLSessionDataTask!


    // MARK: Home page  images

    func loadImage(url:URL,completionHandler:@escaping(UIImage)->()){
             
        self.image = nil
        if let task = task{
            
            task.cancel()
        }
        if let imgFromCache = self.imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage{
            DispatchQueue.main.async {
                self.image = imgFromCache
                completionHandler(self.image!)
                
            }
        }
        else{
            task = URLSession.shared.dataTask(with: url) { data, response,error in
                
                guard let getData = data , let newImage = UIImage(data: getData) else{
                    
                    print("Could't load image from url: \(url)")
                    return
                }
                
                self.imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.image = newImage
                    completionHandler(self.image!)
                }
            }
            
            task.resume()
        }
    }
   
    // MARK: mutliple cat images

    func loadCategoryImage(url:URL,completionHandler:@escaping(UIImage?)->()){

        self.catImage = nil
      
        if let task = taskCat{
            
            task.cancel()
        }
        if let imgFromCache = self.catImageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage{
            DispatchQueue.main.async {
                self.catImage = imgFromCache
                completionHandler(self.catImage!)
                
            }
        }
        else{
            taskCat = URLSession.shared.dataTask(with: url) { data, response,error in
                
                guard let getData = data , let newImage = UIImage(data: getData) else{
                    
                    completionHandler(nil)

                    print("Could't load image from url: \(url)")
                    return
                }
                
                self.catImageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.catImage = newImage
                    completionHandler(self.catImage!)
                }
            }
            
            taskCat.resume()
        }
    }

    // MARK: single cat images

    func loadSingleImageWithOutCache(url:URL,completionHandler:@escaping(UIImage)->()){
        self.sImage = nil

        if let task = sTask{
            
            task.cancel()
        }
        if let imgFromCache = self.sImageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage{
            DispatchQueue.main.async {
                self.sImage = imgFromCache
                completionHandler(self.sImage!)
                
            }
        }
        else{
            sTask = URLSession.shared.dataTask(with: url) { data, response,error in
                
                guard let getData = data , let newImage = UIImage(data: getData) else{
                    
                    print("Could't load image from url: \(url)")
                    return
                }
                
                self.sImageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.sImage = newImage
                    completionHandler(self.sImage!)
                }
            }
            
            sTask.resume()
        }
    }

    // MARK: first cat images

    func loadFirstImageWithOutCache(url:URL,completionHandler:@escaping(UIImage)->()){
        self.fImage = nil

        if let task = fTask{
            
            task.cancel()
        }
        if let imgFromCache = self.fImageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage{
            DispatchQueue.main.async {
                self.fImage = imgFromCache
                completionHandler(self.fImage!)
                
            }
        }
        else{
            fTask = URLSession.shared.dataTask(with: url) { data, response,error in
                
                guard let getData = data , let newImage = UIImage(data: getData) else{
                    
                    print("Could't load image from url: \(url)")
                    return
                }
                
                self.fImageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.fImage = newImage
                    completionHandler(self.fImage!)
                }
            }
            
            fTask.resume()
        }
    }

}
