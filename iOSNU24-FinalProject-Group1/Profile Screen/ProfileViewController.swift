//
//  ProfileViewController.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Scott Carvalho on 11/26/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var profileScreen = ProfileScreen()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var auth = Auth.auth()
    var isEditMode = false
    var originalName: String = ""
    var originalBio: String = ""
    var originalLocation: String = ""
    var originalProfileImageUrl: String = ""
    
    override func loadView() {
        view = profileScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileScreen.editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        profileScreen.profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfileImageTapped))
        profileScreen.profileImageView.addGestureRecognizer(tapGesture)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Log out",
            style: .plain,
            target: self,
            action: #selector(onLogOutBarButtonTapped)
        )
        
        fetchUserProfile()
    }
    
    @objc private func editProfileTapped() {
        if isEditMode {
            // Save changes if in edit mode
            saveChanges()
        } else {
            // Store the original values before entering edit mode
            originalBio = profileScreen.bioLabel.text ?? ""
            originalLocation = profileScreen.locationLabel.text ?? ""
            
            // Enable edit mode
            isEditMode = true
            toggleEditMode()
        }
    }
    
    @objc func onLogOutBarButtonTapped() {
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let welcome = WelcomeViewController()
                self.navigationController?.pushViewController(welcome, animated: true)
            } catch {
                print("Error occurred!")
            }
        }))
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(logoutAlert, animated: true)
    }
    
    @objc private func cancelEditTapped() {
        // Revert changes and disable edit mode
        isEditMode = false
        toggleEditMode()
        
        // Restore original values
        profileScreen.bioTextField.text = originalBio
        profileScreen.locationTextField.text = originalLocation
        profileScreen.bioLabel.text = originalBio
        profileScreen.locationLabel.text = originalLocation
    }
    
    private func toggleEditMode() {
        profileScreen.bioLabel.isHidden = isEditMode
        profileScreen.locationLabel.isHidden = isEditMode
        profileScreen.bioTextField.isHidden = !isEditMode
        profileScreen.locationTextField.isHidden = !isEditMode
        profileScreen.editProfileButton.setTitle(isEditMode ? "Save" : "Edit Profile", for: .normal)
        
        if isEditMode {
            // Add cancel button dynamically
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelEditTapped))
            navigationItem.rightBarButtonItem = cancelButton
            
            // Populate text fields with current data
            profileScreen.bioTextField.text = profileScreen.bioLabel.text
            profileScreen.locationTextField.text = profileScreen.locationLabel.text
        } else {
            // Remove cancel button when not in edit mode
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func changeProfileImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            dismiss(animated: true)
            return
        }
        
        profileScreen.profileImageView.image = selectedImage
        dismiss(animated: true) {
            self.uploadProfileImage(selectedImage)
        }
    }
    
    private func uploadProfileImage(_ image: UIImage) {
        let email = "scott_profile_image" // Example user identifier
        let storageRef = storage.reference().child("profile_images/\(email).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        storageRef.putData(imageData, metadata: nil) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                
                guard let url = url else { return }
                self.saveProfileImageUrl(url.absoluteString)
            }
        }
    }
    
    private func saveProfileImageUrl(_ url: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "User UID not found.")
            return
        }
        
        let userDocRef = db.collection("user").document(uid)
        
        userDocRef.updateData([
            "profileImageUrl": url
        ]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Success", message: "Profile image updated successfully!")
                self.fetchUserProfile() // Refresh the UI
            }
        }
    }
    
    private func saveChanges() {
        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "User UID not found.")
            return
        }
        
        let userDocRef = db.collection("user").document(uid)
        let updatedBio = profileScreen.bioTextField.text ?? ""
        let updatedLocation = profileScreen.locationTextField.text ?? ""
        
        userDocRef.updateData([
            "bio": updatedBio,
            "location": updatedLocation
        ]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Success", message: "Profile updated successfully!")
                
                // Update labels and switch back to non-edit mode
                DispatchQueue.main.async {
                    self.profileScreen.bioLabel.text = updatedBio
                    self.profileScreen.locationLabel.text = updatedLocation
                    
                    // Switch to non-edit mode and hide the text fields
                    self.isEditMode = false
                    self.toggleEditMode()
                }
            }
        }
    }
    
    private func fetchUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "User UID not found.")
            return
        }
        
        // Fetch the user's collection using their UID
        let userDocRef = db.collection("user").document(uid)
        
        userDocRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.showAlert(title: "Error", message: "No profile data found.")
                return
            }
            
            DispatchQueue.main.async {
                self.profileScreen.nameLabel.text = data["name"] as? String ?? "No Name"
                self.profileScreen.bioLabel.text = data["bio"] as? String ?? "No Bio"
                self.profileScreen.locationLabel.text = data["location"] as? String ?? "No Location"
                
                if let profileImageUrl = data["profileImageUrl"] as? String,
                   let imageUrl = URL(string: profileImageUrl) {
                    self.loadProfileImage(from: imageUrl)
                }
            }
        }
    }
    
    private func loadProfileImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to load profile image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.profileScreen.profileImageView.image = image
            }
        }
        task.resume()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
