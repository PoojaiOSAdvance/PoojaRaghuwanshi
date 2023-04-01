//
//  HomeCell.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 31/03/23.
//

import UIKit

class HomeCell: UITableViewCell {

    static let  identifier = "HomeCell"
    
    @IBOutlet private weak var lblTitle : UILabel!
    @IBOutlet private weak var lblDes : UILabel!
    @IBOutlet private weak var lblPrice : UILabel!
    @IBOutlet private weak var imgage : UIImageView!
    
    
    var categoryMdl : CategoryMDL? {
        
        didSet{
            
            guard let categoryData = categoryMdl else{return}
            
            self.lblTitle.text = categoryData.title
            self.lblPrice.text =  "$" +  String(describing: categoryData.price ?? 0)
            
            guard let category = categoryData.category else{return}
            self.lblDes.text = category.name
            
            guard let imgUrl = category.image else{return}
            guard let url = URL(string: imgUrl) else{return}
            
            if Reachability.isConnected() {
               
                ImageDownloader.shared.loadImage(url:url) { getImg in
                   
                    self.imgage.image =  getImg
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
