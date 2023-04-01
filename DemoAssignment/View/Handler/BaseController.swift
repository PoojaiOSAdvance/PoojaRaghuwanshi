//
//  BaseController.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 31/03/23.
//

import UIKit

extension  UIViewController {
    
    // MARK: ACTION
    @objc func onTapMore(){
        
        self.moreShow()
    }
    
    
    // MARK: Keyboard
    
    func keywordDoneButtonAdd(firstTxt:UITextField? = nil,secondTxt:UITextField?,thirdTxt:UITextField?,fourthTxt:UITextField? = nil){
        firstTxt?.addDoneToolbar()
        secondTxt?.addDoneToolbar()
        thirdTxt?.addDoneToolbar()
        fourthTxt?.addDoneToolbar()
    }
    
    // MARK: Navigation bar
    
    func NavigationBarHiddenWithBackButton(barHidden:Bool,tintColor:UIColor,title:String = ""){
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.setNavigationBarHidden(barHidden, animated: false)
        self.navigationController?.navigationBar.tintColor = tintColor
        self.title = title
        
    }
    func navigationBarForHomePage(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onTapMore))
        navigationItem.rightBarButtonItem?.image =  UIImage(systemName: "line.horizontal.3")
        navigationItem.rightBarButtonItem?.tintColor = .link
        navigationItem.leftBarButtonItem?.tintColor = .clear
        self.title = "Home"
        self.navigationItem.setHidesBackButton(true , animated: false)
        
    }
    
    
    // MARK: ImageSet
    
    func setImageForPassword(isHidden:Bool)->UIImage? {
        
        guard isHidden == true else {
            
            return UIImage(named:Images.hidePass.rawValue) ?? nil
        }
        
        return UIImage(named:Images.showPass.rawValue) ?? nil
    }
    
    // MARK: Validation
    
    func Validation(userName:String,Email:String,password:String,confirmPassword:String)->String{
        
        guard !userName.isEmpty else{  return ErrorHandling.UserName.rawValue}
        guard !Email.isEmpty else{  return ErrorHandling.Email.rawValue}
        guard isValidEmail(email:Email) else{  return ErrorHandling.ValidEmail.rawValue}
        guard !password.isEmpty else{  return ErrorHandling.password.rawValue}
        guard !confirmPassword.isEmpty else{  return ErrorHandling.confirmPassword.rawValue}
        guard  confirmPassword == password else{  return ErrorHandling.bothPasswordMatch.rawValue}
        guard self.isValidPassword(password: password) else{return ErrorHandling.validPassword.rawValue}
        
        return ""
        
    }
    
    func loginValidation(Email:String,password:String)->String{
        
        guard !Email.isEmpty else{  return ErrorHandling.Email.rawValue}
        guard isValidEmail(email:Email) else{  return ErrorHandling.ValidEmail.rawValue}
        guard !password.isEmpty else{  return ErrorHandling.password.rawValue}
        guard self.isValidPassword(password: password) else{return ErrorHandling.validPassword.rawValue}
        
        return ""
        
    }
    
    private func isValidEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: email)
    }
    
    public func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // MARK: Alter
    
    func AlertShows(msg:String){
        
        let alert = UIAlertController(title: "Alert ‼️", message: msg, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK 👍", style: UIAlertAction.Style.default, handler: { [self] _ in
            dismiss(animated: true)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func moreShow(){
        
        let alert = UIAlertController(title: "🌸🌸🌸", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Logout 🔒", style: UIAlertAction.Style.destructive, handler: { [self] _ in
            
            let storyboard = UIStoryboard(name: StroyboardName.main.rawValue, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: WelcomeScreenVc.identifier) as? WelcomeScreenVc {
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel 🙂", style: UIAlertAction.Style.cancel, handler: { [self] _ in
            dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Navigate to home
    
    func navigateToHome(){
        let storyboard = UIStoryboard(name: StroyboardName.main.rawValue, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: HomeVc.identifier) as? HomeVc {
          
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: Fetch CoreData
    
    func fetchEmployee()->[Person]?
    {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        debugPrint(path[0])
        
        do {
            guard let result = try PersistentStorage.shared.context.fetch(Person.fetchRequest()) as? [Person] else {return nil}
            
            result.forEach({debugPrint($0.userName)})
            return result
            
        } catch let error
        {
            debugPrint(error)
        }
        return nil
    }
    
    func toCheckValidationForLoginByCoreData(person: [Person],userEnterEmail:String) -> Person? {
        
        return person.filter { $0.email == userEnterEmail}.first ?? nil
    }

    func checkExistingDataToLogin(userEnterEmail :String ,userPassword:String) {
        
        let personArr = self.fetchEmployee()
        
        if let personArrObj = personArr , let person  = self.toCheckValidationForLoginByCoreData(person: personArrObj, userEnterEmail: userEnterEmail)
        {
            if person.password == userPassword
            {
                self.navigateToHome()
            }
            else{
                self.AlertShows(msg: ErrorHandling.coreDataValidationFailded.rawValue)
            }
        }
        else{
            self.AlertShows(msg: ErrorHandling.userNotExist.rawValue)
        }
    }

    
    func checkExistingDataAvailToSignUp(userEnterEmail :String)->Bool {
        
        let personArr = self.fetchEmployee()
        
        if let personArrObj = personArr , self.toCheckValidationForLoginByCoreData(person: personArrObj, userEnterEmail: userEnterEmail) != nil
        {
            self.AlertShows(msg: ErrorHandling.userAlreadyExist.rawValue)
            return true
        }
        else{
            
            return false
        }
    }
    
}

extension UITextField{
    
    func addDoneToolbar() {
        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onToolBarDone))
        
        toolbar.items = [space, doneBtn]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func onToolBarDone() {
        self.resignFirstResponder()
    }
}


enum StroyboardName : String{
    case main = "Main"
}


enum Images : String {
     
    case showPass = "showPassword"
    case hidePass = "hiddenPassword"
}

enum ErrorHandling : String {
     
    case UserName = "Please Enter User Name"
    case Email = "Please Enter Email"
    case ValidEmail = "Please Enter Valid Email"
    case password = "Please Enter password"
    case confirmPassword = "Please Enter confirm password"
    case bothPasswordMatch = "Confirm password and Password should match"
    case validPassword = "Please Enter valid password , which contain at least one capital, numeric or special character"
    case InterNetConnection = "Please check your internet connection"
    case coreDataValidationFailded = "Email and password wrong , please Enter valid data"
    case userNotExist = "Email not exist in our database please check your register email"
    case userAlreadyExist = "Email already exist in our database please enter diffrent credential for registration"
}


extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}
