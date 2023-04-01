//
//  CategoryImageCell.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 01/04/23.
//

import UIKit

class CategoryImageCell: UICollectionViewCell {
    
    static let  identifier = "CategoryImageCell"
    @IBOutlet private weak var image : UIImageView!
    var currentImage : UIImage?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var cateImage : String? {
        
        didSet{
            
            guard let imgUrl = cateImage else{return}
            guard let url = URL(string: imgUrl) else{return}
            
            ImageDownloader.shared.loadCategoryImage(url:url) { [self] getImg in
                
                if let img = getImg{
                    self.image.image =  img

                }
                else{
                    DispatchQueue.main.async {
                        self.image.image =  self.currentImage ?? nil

                    }

                }
            }

        }
    }
    
}
