//
//  PasswordViewController.swift
//  TravellerStop
//
//  Created by HilalOruc on 14.09.2021.
//

import UIKit
import Firebase

class PasswordViewController: UIViewController {

    @IBOutlet weak var eskiSifre: UITextField!
    @IBOutlet weak var yeniSifre: UITextField!
    @IBOutlet weak var yeniSifreTekrar: UITextField!
    @IBAction func changeButonClicked(_ sender: Any) {
    
        if eskiSifre.text != nil && eskiSifre.text != "" {
            if yeniSifre.text != nil && yeniSifre.text != "" {
                if yeniSifreTekrar.text != nil && yeniSifreTekrar.text != "" {
                    if yeniSifre.text == yeniSifreTekrar.text {
                        let oldPassword = eskiSifre.text!
                        let user = Auth.auth().currentUser
                        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: oldPassword)
                        
                        user?.reauthenticate(with: credential) { error, arg   in
                          if let error = error {
                            self.uyariVer("Hata", "Eski şifre yanlış \(error)")
                          }
                          else {
                                Auth.auth().currentUser?.updatePassword(to: oldPassword) { error in
                                    if error != nil {
                                        self.uyariVer("Hata", error!.localizedDescription)
                                    }
                                    else{
                                        self.uyariVer("Başarılı", "Şifre başarıyla güncellendi!")
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    
                        
                        
                    }
                    else{
                        uyariVer("Hata", "Yeni şifre tekrar uyuşmuyor!")
                    }
                }
                else{
                    uyariVer("Hata", "'Yeni şifre tekrar' boş bırakılamaz!")
                }
                
            }
            else{
                uyariVer("Hata", "'Yeni şifre ' boş bırakılamaz!")
            }
        }
        else {
            uyariVer("Hata", "'Eski şifre' boş bırakılamaz!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    func uyariVer (_ title: String , _ message: String){
            
            let uyari = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           
            let okBtn = UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
            
            uyari.addAction(okBtn)
            self.present(uyari , animated: true, completion: nil)
        }
}
