//
//  CategoryDetailVc.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 01/04/23.
//

import UIKit

class CategoryDetailVc: UIViewController {

    static let  identifier = "CategoryDetailVc"
   
    @IBOutlet private weak var lblName : UILabel!
    @IBOutlet private weak var lblPrice : UILabel!
    @IBOutlet private weak var lblDes : UILabel!
    @IBOutlet private weak var img : UIImageView!
    @IBOutlet private weak var collectionView : UICollectionView!
    @IBOutlet private weak var pageController : UIPageControl!
    @IBOutlet private weak var loaderView :UIActivityIndicatorView!

    var CategoryData : CategoryMDL?
    var catTitle = ""
    var firstIndexImage : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        
        self.NavigationBarHiddenWithBackButton(barHidden: false, tintColor: .link,title: catTitle)
      
        loaderView.isHidden = false
        loaderView.startAnimating()
        self.pageController.isHidden = true
        
        guard let cateData = CategoryData else {return}
        self.lblDes.text = cateData.description
        self.lblPrice.text =  "$" +  String(describing: cateData.price ?? 0)
      
        guard let category = cateData.category else {return}
        self.lblName.text = category.name

        guard let imgUrl = category.image else{return}
        guard let url = URL(string: imgUrl) else{return}
        
        if Reachability.isConnected() {
           
            ImageDownloader.shared.loadSingleImageWithOutCache(url:url) { getImg in
                
                self.img.image =  getImg
            }
            guard let images = cateData.images else{return}
            
            guard let cUrl = images.first else{return}

            guard let cImgUrl = URL(string: cUrl) else{return}

           
            ImageDownloader.shared.loadFirstImageWithOutCache(url:cImgUrl) { getImg in
                
                self.firstIndexImage =  getImg
            }

            self.pageController.numberOfPages = images.count
            self.pageController.currentPage = 0
        }
        else{
            
            self.AlertShows(msg: ErrorHandling.InterNetConnection.rawValue)
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.pageController.isHidden = false

            self.collectionView.reloadData()
            self.loaderView.isHidden = true
            self.loaderView.stopAnimating()
        }

    }
    
    func registerCell(){
        
        collectionView.register(UINib(nibName: CategoryImageCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryImageCell.identifier)
    }
}

extension CategoryDetailVc : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageController.currentPage = Int(pageNumber)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let catDta = CategoryData,let img = catDta.images else {return 0}
        return img.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let catDta = CategoryData,let img = catDta.images ,let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryImageCell.identifier, for: indexPath) as? CategoryImageCell
        else{
            return UICollectionViewCell()
        }
        
        if let img = self.firstIndexImage{
            
            cell.currentImage = img
        }

        cell.cateImage = img[indexPath.item]
      
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
