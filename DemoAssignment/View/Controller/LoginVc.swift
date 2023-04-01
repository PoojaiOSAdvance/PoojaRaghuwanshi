//
//  LoginVc.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 01/04/23.
//

import UIKit

class LoginVc: UIViewController {

    static let identifier = "LoginVc"
    //MARK: outelet
    
    @IBOutlet private weak var txtEmail : UITextField!
    @IBOutlet private weak var txtPassword : UITextField!
    @IBOutlet private weak var btnPassword : UIButton!
    
    var hidePassword = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
    }
    //MARK: Button Action
    
    @IBAction func signIn(sender:Any){
        let validity = self.loginValidation(Email: txtEmail.text!, password: txtPassword.text!)
                                            
        if validity  == ""{
            self.checkExistingDataToLogin(userEnterEmail: txtEmail.text!, userPassword: txtPassword.text!)
        }
        else{
            self.AlertShows(msg: validity)
        }
        
    }
    
    
    @IBAction func showHidePassWord(sender:Any){
       
        self.btnPassword.setImage(self.setImageForPassword(isHidden: hidePassword), for: .normal)
        hidePassword = !hidePassword
        self.txtPassword.isSecureTextEntry = hidePassword

    }
    //MARK: FUNCTIONS
    
    func setUi(){
        self.txtPassword.disableAutoFill()
        self.NavigationBarHiddenWithBackButton(barHidden: false,tintColor: .white)
        setKeyBoard()
    }
    
    func setKeyBoard(){
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

        self.keywordDoneButtonAdd(secondTxt: txtEmail, thirdTxt: txtPassword)
    }
    
    //MARK: Key board

    @objc func keyboardWillShow(notification:NSNotification) {
        
        if txtPassword.isEditing {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y =  -100
        }
        
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y = 0
    }
    
}
