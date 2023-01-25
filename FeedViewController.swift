//
//  FeedViewController.swift
//  TravellerStop
//
//  Created by HilalOruc on 20.08.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
   /* var userEmails = [String]()
    var aciklamalar = [String]()
    var imgUrls = [String]()*/
    var PostDizisi = [Post]()
    let fireStoreDatabaseCollection = Firestore.firestore().collection("User")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        FirebaseVerileriAl()
    }
  /*  func tareuseIdentifierbleView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostDizisi.count
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FeedCell
        cell.explanationLbl.numberOfLines = 0
        //cell.emailLbl.text = userEmails[indexPath.row]
        cell.emailLbl.text = PostDizisi[indexPath.row].email
        //cell.explanationLbl.text = aciklamalar[indexPath.row]
        cell.explanationLbl.text = PostDizisi[indexPath.row].aciklama
        //cell.imgIV.image = UIImage.init(named: "logo-travellerStop")
        //cell.imgIV.sd_setImage(with: URL(string: "\(self.imgUrls[indexPath.row])"), placeholderImage: UIImage(named: "giphy"))
        cell.imgIV.sd_setImage(with: URL(string: "\(self.PostDizisi[indexPath.row].imgUrl)"), placeholderImage: UIImage(named: "giphy"))
        cell.userIcon.sd_setImage(with: URL(string: "\(self.PostDizisi[indexPath.row].userIconURL)"), placeholderImage: UIImage(named: "giphy"))
        cell.nameLbl.text = PostDizisi[indexPath.row].name
        return cell
    }
    
    func FirebaseVerileriAl(){
        let firestoreDatabase = Firestore.firestore()
        //websitedeki koleksiyon adım: Post
        firestoreDatabase.collection("Post").order(by: "tarih", descending: true)
            .addSnapshotListener { snapshot, error in
            if error != nil {
                print(error.debugDescription)
            }
            else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.PostDizisi.removeAll(keepingCapacity: false)
                   
                    for document in snapshot!.documents{ //tüm posların dizisi
                        if let url = document.get("gorselUrl")  as? String {
                            if let aciklama = document.get("aciklama") as? String{
                                if let email = document.get("email")  as? String{
                                    
                                    var userLogo = "https://cdn2.iconfinder.com/data/icons/instagram-ui/48/jee-75-512.png"
                                    var userFullName = ""
                                    
                                    self.fireStoreDatabaseCollection.whereField("userEmail", isEqualTo: email)
                                       .getDocuments() { (querySnapshot, err) in
                                           if let err = err {
                                            print(err.localizedDescription)
                                           } else {
                                          
                                               for documentx in querySnapshot!.documents {
                                               
                                                 //user id referance (User->documentID)= document.documentID
                                                   if documentx.get("userImg") != nil {
                                                       userLogo = documentx.get("userImg") as! String
                                                       print("gelen url atama işlemi yapıldı : \(userLogo)")
                                                   }
                                                   if documentx.get("userFullName") != nil {
                                                       userFullName = documentx.get("userFullName") as! String
                                                   }
                                                    
                                                    self.PostDizisi.append(Post.init(email: email, aciklama: aciklama, imgUrl: url, userIconURL: userLogo, name:userFullName))
                                                    self.tableView.reloadData()
                                               
                                               }
                                            
                                           }
                                        
                                       }
                                    
                                }
                            }
                        }
                   }
                    self.tableView.reloadData()
                }
            }
        }
        
    }

}
