//
//  UserProfileVC.swift
//  Community Calendar
//
//  Created by Michael on 5/8/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit
import Apollo

extension UserProfileViewController: UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func setupSubView() {
        
        //MARK: - Constraints
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            cameraButton.heightAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 0.4),
            cameraButton.widthAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 0.5),
            logoutButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor),
            saveEditButton.widthAnchor.constraint(equalTo: logoutButton.widthAnchor),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: view.bounds.width / 2),
            imageBackgroundView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            imageBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageBackgroundView.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 2)
        ])
        
        profileImageView.anchor(top: imageBackgroundView.topAnchor, leading: imageBackgroundView.leadingAnchor, trailing: imageBackgroundView.trailingAnchor, bottom: imageBackgroundView.bottomAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .zero)
        
        //MARK: - Delegates
        
        nameTextField.delegate = self
        
        
        imageBackgroundView.layer.cornerRadius = imageBackgroundView.bounds.height / 2
        imageBackgroundView.dropShadow()
        logoutButton.dropShadow()
        saveEditButton.dropShadow()
        loginButton.dropShadow()
        nameTextField.borderStyle = .none
        nameTextField.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        logoutButton.layer.cornerRadius = 12
        saveEditButton.layer.cornerRadius = 12
        loginButton.layer.cornerRadius = 12
        nameTextField.layer.cornerRadius = 12
        
        nameTextField.isEnabled = false
        cameraButton.isHidden = true    
        
        
        
        if let user = user {
            updateViewsLogin(user: user)
        } else {
            updateViewsLogout()
        }
    }

    func loginUser() {
        loginButton.isHidden = true
        guard let apolloController = apolloController else { return }
        authController?.signIn(viewController: self) { _ in
            if let accessToken = self.authController?.stateManager?.accessToken {
                print("Access Token: \(accessToken)")
                self.authController?.getUser { result in
                    guard let userInfo = try? result.get() else {
                        print("No Okta Auth User Info")
                        return
                    }
                    if let oktaID = userInfo.first, let username = userInfo.last {
                        self.emailLabel.text = username
                        self.apolloController?.apollo = apolloController.configureApolloClient(accessToken: accessToken)
                        self.apolloController?.fetchUserID(oktaID: oktaID) { result in
                            if let user = try? result.get() {
                                print("First Name: \(String(describing: user.firstName)), Last Name: \(String(describing: user.lastName)), profileImage: \(String(describing: user.profileImage))")
                                DispatchQueue.main.async {
                                    self.updateViewsLogin(user: user)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func logoutUser() {
        authController?.signOut(viewController: self, completion: {
            DispatchQueue.main.async {
                self.presentUserInfoAlert(title: "Success!", message: "You have been successfully logged out.")
            }
            self.updateViewsLogout()
        })
    }
    
    func updateViewsLogout() {
        self.loginButton.isHidden = false
        self.profileImageView.isHidden = true
        self.logoutButton.isHidden = true
        self.emailLabel.isHidden = true
        self.saveEditButton.isHidden = true
        self.nameTextField.isHidden = true
        self.eventsCreatedLabel.isHidden = true
        self.cameraButton.isHidden = true
        self.numberOfEventsCreatedLabel.isHidden = true
        self.imageBackgroundView.isHidden = true
    }
    
    func updateViewsLogin(user: FetchUserIdQuery.Data.User) {
        guard
            let urlString = user.profileImage,
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url),
            let firstName = user.firstName,
            let lastName = user.lastName,
            let createdEvents = user.createdEvents
            else { return }
        
        let createdCount = createdEvents.count
        self.currentUserName = "\(firstName) \(lastName)"
        DispatchQueue.main.async {
            self.profileImageView.image = UIImage(data: data)
            self.imageBackgroundView.isHidden = false
            self.nameTextField.isHidden = false
            self.nameTextField.text = self.currentUserName
            self.emailLabel.isHidden = false
            self.profileImageView.isHidden = false
            self.logoutButton.isHidden = false
            self.saveEditButton.isHidden = false
            self.saveEditButton.setTitle("Edit", for: .normal)
            self.loginButton.isHidden = true
            self.eventsCreatedLabel.isHidden = false
            self.numberOfEventsCreatedLabel.isHidden = false
            self.numberOfEventsCreatedLabel.text = "\(createdCount)"
        }
    }
    
    func editingUserProfile() {
        nameTextField.isEnabled = true
        saveEditButton.setTitle("Save", for: .normal)
        nameTextField.borderStyle = .roundedRect
        cameraButton.isHidden = false
    }
    
    func saveTapped() {
        let fullName = nameTextField.text
        let nameArray = fullName?.components(separatedBy: " ")
        
        if let imageData = profileImageView.image?.pngData(), let graphQLID = apolloController?.currentUserID, let accessToken = authController?.stateManager?.accessToken, let firstName = nameArray?.first, let lastName = nameArray?.last {
            apolloController?.hostImage(imageData: imageData, completion: { result in
                guard let urlString = try? result.get() else { return }
                print(urlString)
                self.apolloController?.updateUserInfo(urlString: urlString, firstName: firstName, lastName: lastName, graphQLID: graphQLID, accessToken: accessToken, completion: { result in
                    guard let response = try? result.get() else { return }
                    let updatedImageURL = response.profileImage
                    let newFirstName = response.firstName
                    let newLastName = response.lastName
                    print("New Profile Image String: \(String(describing: updatedImageURL)), New First Name: \(String(describing: newFirstName)), New Last Name: \(String(describing: newLastName))")
                })
            })
        }
        nameTextField.isEnabled = false
        nameTextField.resignFirstResponder()
        saveEditButton.setTitle("Edit", for: .normal)
        nameTextField.borderStyle = .none
        cameraButton.isHidden = true
    }
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func fetchCreatedEvents(completion: @escaping () -> Void) {
        guard let accessToken = authController?.stateManager?.accessToken else {
            print("No access Token for retrieving users created events")
            return
        }
        guard let graphQLID = Apollo.shared.currentUserID else {
            print("No current graphQLID")
            return
        }
        Apollo.shared.getUserCreatedEvents(graphQLID: graphQLID, accessToken: accessToken, completion: { _ in
            
        })
    }
}