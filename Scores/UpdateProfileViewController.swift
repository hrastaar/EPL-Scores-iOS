//
//  UpdateProfileViewController.swift
//  Scores
//
//  Created by Rastaar Haghi on 8/27/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

class UpdateProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    var usernameLabel: UILabel!
    var favTeamLabel: UILabel!
    
    var usernameTextField: TextFieldWithPadding!
    var favTeamTextField: TextFieldWithPadding!
    
    let favTeamPicker = UIPickerView()
    
    var submitButton: UIButton!
    var selectedTeam = "Select your Favorite Team"
    var currUser: NSManagedObject?
    
    var ref = Database.database().reference()

    struct User {
        var username: String
        var favoriteTeam: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update Profile"
        view.backgroundColor = UIColor(white: 247.0/255.0, alpha: 1)
        configureLabels()
        configureTextFields()
        self.submitButton = configureSubmitButton()
        view.addSubview(self.submitButton)
        createPickerView()
    }
    
    func configureTextFields() {
        self.usernameTextField = customizedTextFieldWithPadding(yPos: 200)
        self.favTeamTextField = customizedTextFieldWithPadding(yPos: 325)
        self.favTeamTextField.textAlignment = .natural
        self.view.addSubview(usernameTextField)
        self.view.addSubview(favTeamTextField)
    }
    
    func configureLabels() {
        self.usernameLabel = customizedLabel(text: "Pick a username", size: 24, yPos: 150)
        self.favTeamLabel = customizedLabel(text: "Select your favorite team", size: 24, yPos: 275)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(favTeamLabel)
    }
    
    func configurePicker() {
        self.favTeamPicker.dataSource = self
        self.favTeamPicker.delegate = self
        //self.favTeamPicker.backgroundColor = .black
    }
    
    @objc
    func createUser() {
        let username = self.usernameTextField.text!, favTeam = self.selectedTeam
        if username.count < 5 {
            let alertController = UIAlertController(title: "Error!", message: "Please make sure that your username is greater than 5 characters long.", preferredStyle: .actionSheet)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil)
        } else if favTeam == "Select your Favorite Team" {
            let alertController = UIAlertController(title: "Error!", message: "Please make sure that you select a Premier League team to follow!", preferredStyle: .actionSheet)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil)
        } else {
            print("Creating a user with username \(username) and favorite team \(favTeam)")
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else {
                return
            }
            let user = NSManagedObject(entity: entity, insertInto: managedContext)
            user.setValue(username, forKeyPath: "username")
            user.setValue(favTeam, forKeyPath: "favoriteTeam")
            
            do {
                try managedContext.save()
                print("Updating Profile: username is now \(username), and favorite team is now \(favTeam)")
                let alertController = UIAlertController(title: "Saved Profile!", message: "Your username has been updated to \(username), and your favorite team is now \(favTeam)", preferredStyle: .actionSheet)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alertController.addAction(dismissAction)
                present(alertController, animated: true, completion: nil)
            } catch let error as NSError {
                print("Could not save.\(error), \(error.userInfo)")
            }
            
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }
    }


}

// UIPickerView Extension
extension UpdateProfileViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teamNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teamNames[row]
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTeam = teamNames[row]
        favTeamTextField.text = selectedTeam
        if let hexCode = teamColors[selectedTeam] {
            DispatchQueue.main.async {
                self.view.backgroundColor = UIColor(hex: hexCode[0])
                if hexCode.count > 1 {
                    self.submitButton.backgroundColor = UIColor(hex: hexCode[1])
                    if let isDarkButton = self.submitButton.backgroundColor?.isDarkColor {
                        if isDarkButton {
                            self.submitButton.setTitleColor(.white, for: .normal)
                        } else {
                            self.submitButton.setTitleColor(.black, for: .normal)
                        }
                    }
                }
                // update the label colors to properly contrasting color
                if let isDark = self.view.backgroundColor?.isDarkColor {
                    if isDark {
                        self.usernameLabel.textColor = .white
                        self.favTeamLabel.textColor = .white
                    } else {
                        self.usernameLabel.textColor = .black
                        self.favTeamLabel.textColor = .black
                    }
                }
            }
        }
        self.view.endEditing(true)
    }
    
}

// UI Element initializers
extension UpdateProfileViewController {
    
    func customizedTextFieldWithPadding(yPos: CGFloat) -> TextFieldWithPadding {
        let textField = TextFieldWithPadding(frame: CGRect(x: 30, y: yPos, width: view.bounds.maxX - 60, height: 50))
        textField.font = UIFont.regularFont(size: 18)
        textField.textColor = .white
        textField.textAlignment = .left
        textField.layer.cornerRadius = 7.5
        textField.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.9)
        return textField
    }
    
    func customizedLabel(text: String, size: CGFloat, yPos: CGFloat) -> UILabel {
        let textLabel = UILabel(frame: CGRect(x: 30, y: yPos, width: view.bounds.maxX - 60, height: 50))
        textLabel.text = text
        textLabel.textAlignment = .left
        textLabel.font = UIFont.regularFont(size: size)
        textLabel.numberOfLines = 0
        return textLabel
    }
    
    func configureSubmitButton() -> UIButton {
        let submitButton = UIButton()
        submitButton.setTitle("Update Information", for: .normal)
        submitButton.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.85)
        submitButton.titleLabel!.font = UIFont.regularFont(size: 18)
        submitButton.layer.cornerRadius = 15
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.frame = CGRect(x: UIScreen.main.bounds.midX - 100, y: 400, width: 200, height: 50)
        submitButton.titleLabel!.font = UIFont.regularFont(size: 24)
        submitButton.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.9)
        submitButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        return submitButton
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.usernameTextField.resignFirstResponder()
        return true
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        favTeamTextField.inputView = pickerView
    }
}
