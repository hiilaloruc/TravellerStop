//
//  ViewController.swift
//  TravellerStop
//
//  Created by HilalOruc on 20.08.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var sifreTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //dışarı tıklayınca klavyeyi kapat
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func closeKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func girisYapBtn(_ sender: Any) {
        if emailTF.text != "" && sifreTF.text != "" {
            
            Auth.auth().signIn(withEmail: emailTF.text!, password: sifreTF.text!) { (authResult, error) in
                if error != nil {
                    self.uyariVer("Hata", error?.localizedDescription ?? "İşlem gerçekleştirilemedi, Tekrar deneyin")
                }
                else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }
        else {
            uyariVer("Hata", "E-mail ve Şifre giriniz")
        }
      
    }
    
    
    @IBAction func kayitOlTBtn(_ sender: Any) {
        //performSegue(withIdentifier: "toFeedVC", sender: nil)
        if emailTF.text != "" && sifreTF.text != "" {
            //hesap oluşturulabilir
            Auth.auth().createUser(withEmail: emailTF.text!, password: sifreTF.text!) { authResult, error in
                if error != nil{
                    self.uyariVer("Hata", error?.localizedDescription ?? "İşlem gerçekleştirilemedi, Tekrar deneyin")
                }
                else{
                     //DB -> USER e atama işlemleri başlar
                        let fireStoreDatabase = Firestore.firestore()
                        let fireStoreUser = ["userEmail": self.emailTF.text! , "userId": Auth.auth().currentUser?.uid] as [String : Any]
                        
                        fireStoreDatabase.collection("User").addDocument(data: fireStoreUser){
                            (error) in
                            if error != nil{
                                self.uyariVer("Hata", error?.localizedDescription ?? "DB USER' e aktarım yapılamadı")
                            }
                            else {
                                //başarılı şekilde aktarıldı -> feed'e git
                                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                                
                                
                            }
                        } //DB'ye atama işlemleri biter
                        
                   
                }
            }
            
            
        }
        else{
            uyariVer("Hata", "E-mail ve Şifre giriniz")
        }
    }
    
    
    
    
    func uyariVer (_ title: String , _ message: String){
            
            let uyari = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           
            let okBtn = UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
            
            uyari.addAction(okBtn)
            self.present(uyari , animated: true, completion: nil)
        }
}

