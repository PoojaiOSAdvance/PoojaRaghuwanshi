//
//  RegistrationFromVc.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 31/03/23.
//

import UIKit

class RegistrationFromVc: UIViewController {
  
    static let identifier = "RegistrationFromVc"
    //MARK: outelet
    
    @IBOutlet private weak var txtUserName : UITextField!
    @IBOutlet private weak var txtEmail : UITextField!
    @IBOutlet private weak var txtPassword : UITextField!
    @IBOutlet private weak var txtConfirmPassword : UITextField!
    @IBOutlet private weak var btnConfirmPassword : UIButton!
    @IBOutlet private weak var btnPassword : UIButton!
    @IBOutlet private weak var loaderView :UIActivityIndicatorView!

    var hidePassword = true
    var hideCurrentPassword = true


    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
    }
    
    //MARK: Button Action
    
    @IBAction func signUp(sender:Any){
        
        loaderView.isHidden = false
        loaderView.startAnimating()
        
        
        let validity = self.Validation(userName: self.txtUserName.text!, Email: self.txtEmail.text!, password: self.txtPassword.text!, confirmPassword: self.txtConfirmPassword.text!)
        
        if validity  == ""{
            

            if !self.checkExistingDataAvailToSignUp(userEnterEmail: self.txtEmail.text!) {
              
                let newPerson  = Person(context: PersistentStorage.shared.context)
                
                newPerson.userName = self.txtUserName.text!
                newPerson.email = self.txtEmail.text!
                newPerson.password = self.txtPassword.text!
                newPerson.confrimPassword = self.txtConfirmPassword.text!
               
                PersistentStorage.shared.saveContext {
                    self.navigateToHome()
                }
            }
        }
        else{
            
            self.AlertShows(msg: validity)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.loaderView.stopAnimating()
        }

    }
    @IBAction func showHidePassWord(sender:Any){
       
        self.btnPassword.setImage(self.setImageForPassword(isHidden: hidePassword), for: .normal)
        hidePassword = !hidePassword
        self.txtPassword.isSecureTextEntry = hidePassword

    }
    @IBAction func showHideConfirmPassWord(sender:Any){
        
        self.btnConfirmPassword.setImage(self.setImageForPassword(isHidden: hideCurrentPassword), for: .normal)
        hideCurrentPassword = !hideCurrentPassword
        self.txtConfirmPassword.isSecureTextEntry = hideCurrentPassword

    }
    
    //MARK: FUNCTIONS
    
    func setUi(){
        self.txtPassword.disableAutoFill()
        self.txtConfirmPassword.disableAutoFill()
        self.NavigationBarHiddenWithBackButton(barHidden: false,tintColor: .white)
        setKeyBoard()
    }
    
    func setKeyBoard(){
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

        self.keywordDoneButtonAdd(firstTxt: txtUserName, secondTxt: txtEmail, thirdTxt: txtPassword, fourthTxt: txtConfirmPassword)
    }
    
    //MARK: Key board

    @objc func keyboardWillShow(notification:NSNotification) {
        
        if txtConfirmPassword.isEditing || txtPassword.isEditing  {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y =  -200
        }
        
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y = 0
    }
    
}
