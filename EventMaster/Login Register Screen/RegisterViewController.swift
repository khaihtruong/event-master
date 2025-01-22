//
//  RegisterViewController.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Kevin Chen on 12/2/24.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import UIKit

class RegisterViewController: UIViewController {

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "EventMaster"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter your account information:"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registerButton)

        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Subtitle
            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Name TextField
            nameTextField.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -20),

            // Email TextField
            emailTextField.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -20),

            // Password TextField
            passwordTextField.topAnchor.constraint(
                equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -20),

            // Confirm Password TextField
            confirmPasswordTextField.topAnchor.constraint(
                equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -20),

            // Register Button
            registerButton.topAnchor.constraint(
                equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            registerButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 150),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    // MARK: - Actions
    @objc private func registerButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
            let email = emailTextField.text, isValidEmail(email),
            let password = passwordTextField.text, !password.isEmpty,
            let confirmPassword = confirmPasswordTextField.text,
            password == confirmPassword
        else {
            if !isValidEmail(emailTextField.text ?? "") {
                showAlert(message: "Invalid email.")
            } else if passwordTextField.text != confirmPasswordTextField.text {
                showAlert(message: "Passwords do not match.")
            } else {
                showAlert(
                    message:
                        "Please fill out all fields with valid information.")
            }
            return
        }

        registerUser(name: name, email: email, password: password)
    }

    // MARK: - Firebase Registration and Firestore Integration
    private func registerUser(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(
                    message:
                        "Registration failed: \(error.localizedDescription)")
                return
            }

            guard let uid = authResult?.user.uid else {
                self.showAlert(
                    message: "Unexpected error. Could not retrieve user ID.")
                return
            }

            // Save user information in Firestore
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "bio": "",
                "email": email,
                "location": "",
                "name": name,
                "profileImageUrl": "",
            ]

            db.collection("user").document(uid).setData(userData) { error in
                if let error = error {
                    self.showAlert(
                        message:
                            "Failed to save user data: \(error.localizedDescription)"
                    )
                } else {
                    // Registration and data saving successful
                    self.setNameOfTheUserInFirebaseAuth(name: name)
                    self.navigateToHomeScreen()
                }
            }
        }
    }

    // MARK: - Helper Functions
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    private func navigateToHomeScreen() {
        let homePageViewController = HomePageViewController()  // Update with your home screen controller
        self.navigationController?.pushViewController(
            homePageViewController, animated: true)
    }

    func setNameOfTheUserInFirebaseAuth(name: String) {
        let changeRequest = Auth.auth().currentUser?
            .createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: { (error) in
            if error == nil {
//                self.navigationController?.popViewController(animated: true)
                return
            } else {
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
        })
    }
}
