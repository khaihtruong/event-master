//
//  ViewController.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Scott Carvalho on 11/18/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class WelcomeViewController: UIViewController {
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var currentUser: FirebaseAuth.User?
    
    let database = Firestore.firestore()

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "EventMaster"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome.\nPlease sign in or sign up below:"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal) // Changed text color to black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()

    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal) // Changed text color to black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.currentUser = nil
            } else {
                self.currentUser = user
                let homeScreen = HomePageViewController()
                self.navigationController?.pushViewController(homeScreen, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(welcomeLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)

        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Welcome Label Constraints
            welcomeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Sign In Button Constraints
            signInButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            signInButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            signInButton.widthAnchor.constraint(equalToConstant: 120),
            signInButton.heightAnchor.constraint(equalToConstant: 50),

            // Sign Up Button Constraints
            signUpButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            signUpButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            signUpButton.widthAnchor.constraint(equalToConstant: 120),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Button Actions
    @objc private func signInButtonTapped() {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }

    @objc private func signUpButtonTapped() {
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
}

