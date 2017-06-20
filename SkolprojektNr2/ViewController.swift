//
//  ViewController.swift
//  SkolprojektNr2
//
//  Created by Richard Smith on 2017-06-19.
//  Copyright © 2017 Richard Smith. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseMessaging
import FirebaseAuth


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTf: UITextField!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var threatBtn: UIButton!
    @IBOutlet weak var accidentBtn: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    let refreshControl = UIRefreshControl()
    var ref: DatabaseReference?
    
    var handler: DatabaseHandle?
    var threatHandler: DatabaseHandle?
    var accidentHandler: DatabaseHandle?
    
    var helpMessage: [String] = []
    var threatMessage: [String] = []
    var accidentMessage: [String] = ["Hu"]
    
    var sectionMessages: [Int: [String]] = [:]
    
    let sectionTitle = ["Help:", "Threat:", "Accident"]
    let sectionImages: [UIImage] = [#imageLiteral(resourceName: "information"), #imageLiteral(resourceName: "danger"), #imageLiteral(resourceName: "car-first-aid-kit")]
    
    let test: [String] = ["Hallå", "Christina"]
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.hideKeyBoardWhenTappedOutside()
        
        ref = Database.database().reference()
        
        helpBtn.layer.cornerRadius = 20
        threatBtn.layer.cornerRadius = 20
        accidentBtn.layer.cornerRadius = 20
        
//        handler = ref?.child("help").observe(.childAdded, with: { (snapshot) in
//            if let item = snapshot.value as? String {
//                self.helpMessage.append(item)
//                self.tableView.reloadData()
//            }
//        })
//        threatHandler = ref?.child("threat").observe(.childAdded, with: { (snapshot) in
//            if let item = snapshot.value as? String {
//                self.threatMessage.append(item)
//                self.tableView.reloadData()
//            }
//        })
//        accidentHandler = ref?.child("accident").observe(.childAdded, with: { (snapshot) in
//            if let item = snapshot.value as? String {
//                self.accidentMessage.append(item)
//                self.tableView.reloadData()
//            }
//        })
        
        

        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(ViewController.observeHelpMessages), for: .valueChanged)
        refreshControl.addTarget(self, action: #selector(ViewController.observeThreatMessage), for: .valueChanged)
        refreshControl.addTarget(self, action: #selector(ViewController.observeAccidentMessage), for: .valueChanged)
        observeHelpMessages()
        observeThreatMessage()
        observeAccidentMessage()
        
        sectionMessages = [0: helpMessage, 1: threatMessage, 2: accidentMessage]
        
//         Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.signInBtn.isHidden = true
                self.signOutBtn.isHidden = false
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func helpBtn(_ sender: Any) {
        if messageTf.text != "" {
            ref?.child("help").childByAutoId().setValue(messageTf.text!)
            setMessageTf()
        } else {
            print("User retarded")
        }
    }
    @IBAction func threat(_ sender: Any) {
        if messageTf.text != "" {
            ref?.child("threat").childByAutoId().setValue(messageTf.text!)
            setMessageTf()
        } else {
            print("User retarded")
        }
    }
    func setMessageTf() {
        messageTf.text = ""
    }

    @IBAction func accident(_ sender: Any) {
        if messageTf.text != "" {
            ref?.child("accident").childByAutoId().setValue(messageTf.text!)
            setMessageTf()
            tableView.reloadData()
        } else {
            print("User retarded")
        }
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        let token: [String: AnyObject] = [Messaging.messaging().fcmToken!: Messaging.messaging().fcmToken as AnyObject]
        
        Auth.auth().signInAnonymously { (user, error) in
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
            } else {
                self.postToken(token: token)
                self.signInBtn.isHidden = true
                self.signOutBtn.isHidden = false
            }
        }
    }
    @IBAction func signOut(_ sender: Any) {
        self.signOutBtn.isHidden = true
        self.signInBtn.isHidden = false
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            self.signInBtn.isHidden = true
            self.signOutBtn.isHidden = false
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func postToken(token: [String:AnyObject]) {
        print("FCMToken: \(token)")
        let dbRef = Database.database().reference()
        dbRef.child("fcmToken").child(Messaging.messaging().fcmToken!).setValue(token)
    }
    func observeHelpMessages() {
        self.helpMessage.removeAll()
        
        handler = ref?.child("help").observe(.childAdded, with: { (snapshot) in
            
            if let item = snapshot.value as? String {
                
                self.helpMessage.append(item)
                
                
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                })
            }
            
        }, withCancel: nil)
    }
    func observeThreatMessage() {
        self.threatMessage.removeAll()
        
        threatHandler = ref?.child("threat").observe(.childAdded, with: { (snapshot) in
            
            if let item = snapshot.value as? String {
                
                self.threatMessage.append(item)
                
                
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                })
            }
            
        }, withCancel: nil)
    }
    func observeAccidentMessage() {
      //  self.accidentMessage.removeAll()
        
        accidentHandler = ref?.child("accident").observe(.childAdded, with: { (snapshot) in
            
            if let item = snapshot.value as? String {
                
                self.accidentMessage.append(item)
                print(self.accidentMessage)
                
                
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                })
            }
            
        }, withCancel: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return (sectionMessages[section]?.count)!
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        
        let image = UIImageView(image: sectionImages[section])
        image.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(image)
        
        let label = UILabel()
        label.text = sectionTitle[section]
        label.frame = CGRect(x: 45, y: 5, width: 100, height: 35)
        view.addSubview(label)
        
        return view
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell!.textLabel?.text = sectionMessages[indexPath.section]![indexPath.row]
        
        
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//        cell.textLabel?.text = accidentMessage[indexPath.row]
    
        
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//     if editingStyle == .delete {
//        let message = myMessages[indexPath.row]
//        let dbRef = Database.database().reference()
//        dbRef.child("help").child(dbRef.key).removeValue()
//        }
//     }
}

