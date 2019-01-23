//
//  LoginViewController.swift
//  PlayersInfo
//
//  Created by Mohit Gorakhiya on 1/22/19.
//  Copyright © 2019 Mohit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var appDel: AppDelegate!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.appDel = UIApplication.shared.delegate as? AppDelegate
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.cornerView.layer.masksToBounds = true
        self.cornerView.layer.cornerRadius = 5.0
        self.cornerView.layer.borderColor = Constant.navigationColor.cgColor
        self.cornerView.layer.borderWidth = 1.0
        
        self.emailField.text = "maheshwari@techcetra.com"
        self.passwordField.text = "qwerty123"
    }
    
    @IBAction func loginClicked(_ sender: UIButton)
    {
        if !Connectivity.isConnectedToInternet()
        {
            self.showAlert(title: "Alert", msg: Constant.noInternetMessage, completion: nil)
            return
        }
        let emailStr: String = self.emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordStr: String = self.passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if emailStr.isEmpty
        {
            self.showAlert(title: "Alert", msg: "Please enter email id.", completion: nil)
            return
        }
        if passwordStr.isEmpty
        {
            self.showAlert(title: "Alert", msg: "Please enter password.", completion: nil)
            return
        }
        
        if !self.validateEmail(enteredEmail: emailStr)
        {
            self.showAlert(title: "Alert", msg: "Please enter valid email id.", completion: nil)
            return
        }
        
        let params: Parameters = [
            "email": emailStr,
            "password": passwordStr
        ]
        
        let requestURL: String = Constant.BASEURL + Constant.LOGINAPI
        
        self.showLoading()
        
        Alamofire.request(requestURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                self.hideLoading()
                switch response.result
                {
                case .success(_):
                    if let data = response.result.value
                    {
                        let responseJSON = JSON(data)
                        if responseJSON["success"].boolValue {
                            
                            UserDefaults.standard.set(true, forKey: Constant.isUserLogin)
                            
                            if responseJSON["data"]["token"].string != nil {
                                
                                UserDefaults.standard.set(responseJSON["data"]["token"].stringValue, forKey: Constant.kTokenValue)
                                
                                UserDefaults.standard.synchronize()
                                
                                DispatchQueue.main.async {
                                    self.showAlert(title: "Alert", msg: responseJSON["msg"].string ?? "Logged in successfully", completion: {
                                        
                                        self.appDel.setCurrentViewController()
                                        
                                    })
                                }
                            }
                            else {
                                
                                self.showAlert(title: "Alert", msg: "Token not found.", completion: nil)
                            }
                            
                            
                        }
                        else {
                            self.showAlert(title: "Error", msg: responseJSON["msg"].string ?? "", completion: nil)
                        }
                    }
                    else
                    {
                    
                    }
                    break
                    
                case .failure(_):
                    
                    self.showAlert(title: "Alert", msg: "Error occurred, please try after some time.", completion: nil)
                    
                    break
                    
                }
        }
    }
}
