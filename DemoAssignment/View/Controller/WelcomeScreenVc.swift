//
//  WelcomeScreenVc.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 31/03/23.
//

import UIKit

class WelcomeScreenVc: UIViewController {
    
    static let  identifier = "WelcomeScreenVc"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true , animated: false)
    }
    
    //MARK: Button Action
    
    @IBAction func regiser(sender:UIButton){
        
        let storyboard = UIStoryboard(name: StroyboardName.main.rawValue, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: RegistrationFromVc.identifier) as? RegistrationFromVc {
          
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
  
    @IBAction func signIn(sender:UIButton){
        
        let storyboard = UIStoryboard(name: StroyboardName.main.rawValue, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: LoginVc.identifier) as? LoginVc {
          
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
