//
//  UploadViewController.swift
//  TravellerStop
//
//  Created by HilalOruc on 20.08.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var addImageIV: UIImageView!
    @IBOutlet weak var aciklamaTextView: UITextView!
    
    var resimOnay = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        aciklamaTextView.delegate = self
        aciklamaTextView.autocapitalizationType = .sentences
        
        aciklamaTextView.text = "Açıklama yaz.."
        aciklamaTextView.textColor = UIColor.lightGray


        //RESME TIKLANDIĞINDA GÖRSEL SEÇTİR -- BAŞLAR
        addImageIV.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(gorselSec))
        addImageIV.addGestureRecognizer(imageGestureRecognizer)
        //RESME TIKLANDIĞINDA GÖRSEL SEÇTİR -- BİTER
        
        //dışarı tıklayınca klavyeyi kapat
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Açıklama yaz.."
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func closeKeyboard(){
        view.endEditing(true)
    }
    
    //Resmi al
    @objc func gorselSec(){
        let picker = UIImagePickerController()
        picker.delegate = self //bu noktada 2 adet class inherit etmen lazım: //UIImagePickerControllerDelegate, UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    //Resmi imageview'de göster -> didfinish
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         resimOnay = 1
        addImageIV.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)//seçme alanını kapat çünkü seçildi artık
       
    }
    
    @IBAction func paylasBtn(_ sender: Any) {
        if  resimOnay == 0 {
            
            //UYARI BAŞLAR
            let uyari = UIAlertController.init(title: "Warning", message: "Choose an image!", preferredStyle: UIAlertController.Style.alert)
           
            let okBtn = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            
            uyari.addAction(okBtn)
            self.present(uyari , animated: true, completion: nil)
            //UYARI BİTER
        }
        else if  resimOnay == 1 {
           
            let storage = Storage.storage()
            let storageReferance = storage.reference()//konum
            
            let mediaFolder = storageReferance.child("Media")
            if let data = addImageIV.image?.jpegData(compressionQuality: 0.5){
                //görsel adı oluştur -> unique
                let uuid = UUID().uuidString
                let imgReferance = mediaFolder.child("\(uuid).jpg")
                imgReferance.putData(data, metadata: nil) { StorageMetadata, error in
                    if error != nil {
                        self.uyariVer("Hata", error?.localizedDescription ?? "Resim yüklenemedi")
                        
                    }
                    else{
                        imgReferance.downloadURL { url, error in
                            if error == nil{
                                let imgUrl = url?.absoluteString
                                if let imgUrl = imgUrl{
                                 //DB'ye atama işlemleri başlar
                                    let fireStoreDatabase = Firestore.firestore()
                                    let fireStorePost = ["gorselUrl":imgUrl , "aciklama":self.aciklamaTextView.text!, "email":Auth.auth().currentUser?.email, "tarih":FieldValue.serverTimestamp()] as [String : Any]
                                
                                    
                                    fireStoreDatabase.collection("Post").addDocument(data: fireStorePost){
                                        (error) in
                                        if error != nil{
                                            self.uyariVer("Hata", error?.localizedDescription ?? "DB'ye aktarım yapılamadı")
                                        }
                                        else {
                                            //başarılı şekilde aktarıldı -> sayfa içeriğini sıfırla
                                            self.aciklamaTextView.text = ""
                                            self.addImageIV.image = UIImage.init(named: "imgadd")
                                            self.tabBarController?.selectedIndex = 0
                                            
                                            
                                        }
                                    }
                                    
                                }//DB'ye atama işlemleri biter
                                
                            }
                        }
                    }
                }
            }
            
            
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FlowerAdded"), object: nil)
          //  self.navigationController?.popViewController(animated: true)
        }

    }
    
    func uyariVer (_ title: String , _ message: String){
            
            let uyari = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           
            let okBtn = UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
            
            uyari.addAction(okBtn)
            self.present(uyari , animated: true, completion: nil)
        }
    

    
}
