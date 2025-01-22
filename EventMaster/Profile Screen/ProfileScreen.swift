//
//  MainScreen.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Scott Carvalho on 11/26/24.
//

import UIKit

class ProfileScreen: UIView {

    // Profile Image
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    // Name Label
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "User Name" // Placeholder
        return label
    }()
    
    // Name TextField
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Edit Name"
        textField.isHidden = true // Initially hidden
        return textField
    }()
    
    // Location Label
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Location TextField
    let locationTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Edit location"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true // Initially hidden
        return textField
    }()
    
    // Bio Label
    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Bio TextField
    let bioTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Edit bio"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true // Initially hidden
        return textField
    }()
    
    // Edit Profile Button
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    // Stack views for bio and location
    let bioStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(bioStackView) // Add the bio stack view
        addSubview(locationStackView) // Add the location stack view
        addSubview(editProfileButton)
        
        // Configure bioStackView
        let bioTitleLabel = UILabel()
        bioTitleLabel.text = "Bio:"
        bioTitleLabel.font = UIFont.systemFont(ofSize: 16)
        bioStackView.addArrangedSubview(bioTitleLabel)
        bioStackView.addArrangedSubview(bioLabel)
        bioStackView.addArrangedSubview(bioTextField)
        
        // Configure locationStackView
        let locationTitleLabel = UILabel()
        locationTitleLabel.text = "Location:"
        locationTitleLabel.font = UIFont.systemFont(ofSize: 16)
        locationStackView.addArrangedSubview(locationTitleLabel)
        locationStackView.addArrangedSubview(locationLabel)
        locationStackView.addArrangedSubview(locationTextField)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            
            // Bio stack view
            bioStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            bioStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bioStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Location stack view
            locationStackView.topAnchor.constraint(equalTo: bioStackView.bottomAnchor, constant: 20),
            locationStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            locationStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Ensure all text fields are the same width
            bioTextField.widthAnchor.constraint(equalTo: locationTextField.widthAnchor),
            locationTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
            
            editProfileButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            editProfileButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            editProfileButton.widthAnchor.constraint(equalToConstant: 150),
            editProfileButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
