//
//  CreateUserViewController.swift
//  Scores
//
//  Created by Rastaar Haghi on 8/27/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

class CreateUserViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    
    var usernameLabel: UILabel!
    var favTeamLabel: UILabel!
    
    var usernameTextField: TextFieldWithPadding!
    var favTeamTextField: TextFieldWithPadding!
    
    let favTeamPicker = UIPickerView()
    
    var submitButton: UIButton!
    var selectedTeam = "Select your Favorite Team"
    var currUser: NSManagedObject?
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create a User Account"
        view.backgroundColor = UIColor(white: 247.0/255.0, alpha: 1)
        configureLabels()
        configureTextFields()
        submitButtonInit()
        createPickerView()
        dismissPickerView()
        createUser()
    }
    
    func configureTextFields() {
        self.usernameTextField = customizedTextFieldWithPadding(yPos: 150)
        self.favTeamTextField = customizedTextFieldWithPadding(yPos: 275)
        self.favTeamTextField.textAlignment = .natural
        self.view.addSubview(usernameTextField)
        self.view.addSubview(favTeamTextField)
    }
    
    func configureLabels() {
        self.usernameLabel = customizedLabel(text: "Select a username", size: 24, yPos: 100)
        self.favTeamLabel = customizedLabel(text: "What is your favorite team?", size: 24, yPos: 225)
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
        print("Started createUser()")
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown Device ID"
        print(deviceID)
        print("Ended createUser()")
    }
    

}

extension CreateUserViewController {
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
        
    }
    
}

extension CreateUserViewController {
    
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
    
    func submitButtonInit() {
        self.submitButton = UIButton()
        self.submitButton.setTitle("Create User", for: .normal)
        self.submitButton.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.85)
        self.submitButton.titleLabel!.font = UIFont.regularFont(size: 18)
        self.submitButton.layer.cornerRadius = 15
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.frame = CGRect(x: UIScreen.main.bounds.midX - 100, y: 400, width: 200, height: 50)
        self.submitButton.titleLabel!.font = UIFont.regularFont(size: 24)
        self.submitButton.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.9)
        self.submitButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        view.addSubview(submitButton)
        print("Created User")
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
    
    func dismissPickerView() {
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//
//        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
//        toolBar.setItems([button], animated: true)
//        toolBar.isUserInteractionEnabled = true
//        favTeamTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
       view.endEditing(true)
        if(self.selectedTeam != "Select your Favorite Team") {
            print(self.selectedTeam)
        }
    }
}
