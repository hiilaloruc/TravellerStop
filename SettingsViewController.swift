//
//  SettingsViewController.swift
//  TravellerStop
//
//  Created by HilalOruc on 20.08.2021.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var adiLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var bioTextField: UITextView!
    
    var resimSecildi = 0
    let fireStoreDatabaseCollection = Firestore.firestore().collection("User")
    
    @IBAction func toChangePass(_ sender: Any) {
        performSegue(withIdentifier: "toChangePass", sender: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if  resimSecildi == 1 {
            if  adiLbl.text != nil && adiLbl.text != "" {
                if emailLbl.text != nil && emailLbl.text != ""{
                    
               
                         let storage = Storage.storage()
                         let storageReferance = storage.reference()//konum
                         
                         let mediaFolder = storageReferance.child("Media")
                         if let data = userImage.image?.jpegData(compressionQuality: 0.5){
                             //görsel adı oluştur -> unique
                             let uuid = UUID().uuidString
                             let imgReferance = mediaFolder.child("\(uuid).jpg")
                             imgReferance.putData(data, metadata: nil) { StorageMetadata, error in
                                 if error != nil {
                                    print(error?.localizedDescription)
                                     
                                 }
                                 else{
                                     imgReferance.downloadURL { url, error in
                                         if error == nil{
                                             let imgUrl = url?.absoluteString
                                             if let imgUrl = imgUrl{
                                                
                                                
                    //atama işlemleri başlar
                   
                     self.fireStoreDatabaseCollection.whereField("userId", isEqualTo: Auth.auth().currentUser?.uid)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                self.uyariVer("Error getting document", "\(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                  //user id referance (User->documentID)= document.documentID
                                    
                                    let user = self.fireStoreDatabaseCollection.document("\(document.documentID)")

                                    // Set
                                    user.updateData([
                                        "userEmail": self.emailLbl.text,
                                        "userFullName": self.adiLbl.text,
                                        "userImg": imgUrl,
                                        "userBio": self.bioTextField.text ?? ""
                                        
                                    ]) { err in
                                        if let err = err {
                                            
                                            self.uyariVer("Error updating document:", "\(err)")
                                        } else {
                                            self.uyariVer("Başarılı", "Bilgileriniz güncellendi!")
                                            
                                        }
                                    }
                                    
                                    
                                }
                            } }
                                             }
                                            
                                         }
                                     }
                                    
                                 }
                    }
                    

                    
                
                
                    }
        }
                else {
                    uyariVer("Hata", "email seçilmedi")
                    
                }
            }
            else {
                uyariVer("Hata", "ad seçilmedi")
                
            }
        }
        else {
            uyariVer("Hata", "resim seçilmedi")
            
        }
    }
    
    @IBAction func changeImageBtn(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self //bu noktada 2 adet class inherit etmen lazım: //UIImagePickerControllerDelegate, UINavigationControllerDelegate
        //picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        /*Alt menü açılır*/
        let photodestination = UIAlertController.init(title: "Profil Fotoğrafını Değiştir", message: nil, preferredStyle: .actionSheet)
        
        let chooseCamera = UIAlertAction.init(title: "Kamera", style: .default) { UIAlertAction in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        
        let fromLibrary = UIAlertAction.init(title: "Galeri", style: .default) { UIAlertAction in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction.init(title: "İptal", style: .cancel)
        photodestination.addAction(chooseCamera)
        photodestination.addAction(fromLibrary)
        photodestination.addAction(cancel)
        
        self.present(photodestination, animated: true, completion: nil)

    }
    
    //Resmi imageview'de göster -> didfinish
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImage.image = info[.editedImage] as? UIImage
        resimSecildi = 1
        self.dismiss(animated: true, completion: nil)//seçme alanını kapat çünkü seçildi artık
       
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        resimSecildi = 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resimSecildi = 0
       // userImage.layer.cornerRadius = userImage.image?.size.height ?? userImage.frame.height / 2
        emailLbl.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: emailLbl.frame.height))
        emailLbl.leftViewMode = .always
        adiLbl.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: adiLbl.frame.height))
        adiLbl.leftViewMode = .always
        emailLbl.isUserInteractionEnabled = false
        emailLbl.isEnabled = false
        adiLbl.autocapitalizationType = .words
        
       
        bioTextField.delegate = self
        bioTextField.autocapitalizationType = .sentences
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    override func viewWillAppear(_ animated: Bool) {
        /*Text field doldurma yapılıyor*/
        let email = Auth.auth().currentUser?.email
        emailLbl.text = email

        self.fireStoreDatabaseCollection.whereField("userId", isEqualTo: Auth.auth().currentUser?.uid)
           .getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting document: \(err)")
               } else {
                   for document in querySnapshot!.documents {
                     //user id referance (User->documentID)= document.documentID
                    //document.get("userBio")
                    //document.get("userFullName")
                    //document.get("userImg")
                    
                    
                    if let name = document.get("userFullName"){
                        self.adiLbl.text =  name as! String
                    }
                    if let bio =  document.get("userBio") {
                        self.bioTextField.text = bio as! String
                    }
                     if let img = document.get("userImg"){
                        self.userImage.sd_setImage(with: URL(string: "\(img as! String)"), placeholderImage: UIImage(named: "foto"))
                        self.resimSecildi = 1
                    }
                   }
               }
            
           }
    }
    @objc func closeKeyboard(){
        view.endEditing(true)
    }
    
    
    

    @IBAction func cikisYapBtn(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
            
        }catch{
            print("Çıkış yaparken hata yakalandı: " + error.localizedDescription)
        }
        
        
    }
    func uyariVer (_ title: String , _ message: String){
            
            let uyari = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           
            let okBtn = UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
            
            uyari.addAction(okBtn)
            self.present(uyari , animated: true, completion: nil)
        }
    
}

