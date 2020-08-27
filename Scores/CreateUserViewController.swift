//
//  CreateUserViewController.swift
//  Scores
//
//  Created by Rastaar Haghi on 8/27/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit
import CoreData

class CreateUserViewController: UIViewController {

    var usernameTextField = UITextField(frame: CGRect(x: 50, y: 200, width: 200, height: 75))
    var currUser: NSManagedObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create a User Account!"
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
