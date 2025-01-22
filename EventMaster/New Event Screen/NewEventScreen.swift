//
//  NewEventScreenView.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Hanson Wu on 11/27/24.
//

import Foundation
import UIKit

class NewEventScreen: UIView {

    var scrollView: UIScrollView!
    var contentView: UIView!

    var labelSubHeader: UILabel!

    var labelName: UILabel!
    var labelDateTime: UILabel!
    var labelLocation: UILabel!
    var labelTagHeader: UILabel!
    var labelTagSelected: UILabel!
    var labelCapacity: UILabel!

    var textFieldName: UITextField!
    var textFieldDateTime: UITextField!
    var textFieldLocation: UITextField!

    var eventDate: Date!

    var dateTimePicker: UIDatePicker!
    var tagPicker: UIPickerView!
    var capacityPicker: UIPickerView!
    var selectedCapacity: Int!
    var buttonSelectTag: UIButton!
    var buttonClearTag: UIButton!
    var defaultEventTag = Configs.eventTagList[0]

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        setupScrollView()
        setupContentView()

        setupLabelSubHeader()

        setupLabelName()
        setupTextFieldName()

        setupLabelDateTime()
        setupDateTimePicker()

        setupLabelLocation()
        setupTextFieldLocation()

        setupLabelTagHeader()
        setupLabelTagSelected()

        setupTagButton()
        setupClearTagButton()

        setupLabelCapacity()
        setupCapacityPicker()

        initContraints()

    }

    func setupScrollView() {
        scrollView = UIScrollView()
//        scrollView.backgroundColor = .green
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
    }

    func setupContentView() {
        contentView = UIView()
//        contentView.backgroundColor = .red
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }

    func setupLabelSubHeader() {
        labelSubHeader = UILabel()
        labelSubHeader.text = "Create Your Event"
        labelSubHeader.font = .boldSystemFont(ofSize: 14)

        labelSubHeader.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelSubHeader)
    }

    func setupLabelName() {
        labelName = UILabel()
        labelName.text = "Name:"
        labelName.font = .boldSystemFont(ofSize: 14)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelName)
    }

    func setupTextFieldName() {
        textFieldName = UITextField()
        textFieldName.placeholder = "Enter Event Name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.backgroundColor = .systemFill
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldName)
    }

    func setupLabelDateTime() {
        labelDateTime = UILabel()
        labelDateTime.text = "Date/Time:"
        labelDateTime.font = .boldSystemFont(ofSize: 14)

        labelDateTime.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelDateTime)
    }

    func setupLabelLocation() {
        labelLocation = UILabel()
        labelLocation.text = "Location:"
        labelLocation.font = .boldSystemFont(ofSize: 14)
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelLocation)
    }

    func setupTextFieldLocation() {
        textFieldLocation = UITextField()
        textFieldLocation.placeholder = "Enter Event Location"
        textFieldLocation.backgroundColor = .systemFill
        textFieldLocation.borderStyle = .roundedRect
        textFieldLocation.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldLocation)
    }

    func setupDateTimePicker() {
        dateTimePicker = UIDatePicker()
        dateTimePicker.datePickerMode = .dateAndTime
        //        dateTimePicker.timeZone = TimeZone.current
        dateTimePicker.translatesAutoresizingMaskIntoConstraints = false

        dateTimePicker.date = Date()
        contentView.addSubview(dateTimePicker)
    }

    func setupLabelTagHeader() {
        labelTagHeader = UILabel()
        labelTagHeader.text = "Tag(s)"
        labelTagHeader.font = .boldSystemFont(ofSize: 14)
        labelTagHeader.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelTagHeader)
    }

    func setupLabelTagSelected() {
        labelTagSelected = UILabel()
        labelTagSelected.text = "Select Event Tags"
        labelTagSelected.backgroundColor = .systemFill
        labelTagSelected.font = UIFont.italicSystemFont(ofSize: 17)
        
        //        labelTagSelected.font = .boldSystemFont(ofSize: 14)
        labelTagSelected.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelTagSelected)
    }

    func setupTagPicker() {
        tagPicker = UIPickerView()
        tagPicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tagPicker)
    }

    func setupTagButton() {
        buttonSelectTag = UIButton(type: .system)
        buttonSelectTag.setTitle(defaultEventTag, for: .normal)
        buttonSelectTag.showsMenuAsPrimaryAction = true
        buttonSelectTag.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonSelectTag)
    }

    func setupClearTagButton() {
        buttonClearTag = UIButton(type: .system)
        buttonClearTag.setTitle("Clear Tags", for: .normal)
        buttonClearTag.setTitleColor(.red, for: .normal)
        buttonClearTag.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonClearTag)
    }

    func setupLabelCapacity() {
        labelCapacity = UILabel()
        labelCapacity.text = "Capacity"
        labelCapacity.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelCapacity)
    }

    func setupCapacityPicker() {
        capacityPicker = UIPickerView()
        capacityPicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(capacityPicker)
    }

    func initContraints() {
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scrollView.widthAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.widthAnchor),

            contentView.topAnchor.constraint(
                equalTo: scrollView.topAnchor, constant: 32),
            contentView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor, constant: -32),
            contentView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor, constant: 32),
            contentView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor, constant: -32),
            contentView.centerXAnchor.constraint(
                equalTo: scrollView.centerXAnchor),

            labelSubHeader.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 32),
            labelSubHeader.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor),

            labelName.topAnchor.constraint(
                equalTo: labelSubHeader.bottomAnchor, constant: 16),
            labelName.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),

            textFieldName.topAnchor.constraint(
                equalTo: labelName.bottomAnchor, constant: 16),
            textFieldName.leadingAnchor.constraint(
                equalTo: labelName.leadingAnchor),
            textFieldName.widthAnchor.constraint(
                equalTo: contentView.widthAnchor),

            labelDateTime.topAnchor.constraint(
                equalTo: textFieldName.bottomAnchor, constant: 16),
            labelDateTime.leadingAnchor.constraint(
                equalTo: labelName.leadingAnchor),

            dateTimePicker.topAnchor.constraint(
                equalTo: labelDateTime.bottomAnchor, constant: 16),
            dateTimePicker.leadingAnchor.constraint(
                equalTo: labelName.leadingAnchor),

            labelLocation.topAnchor.constraint(
                equalTo: dateTimePicker.bottomAnchor, constant: 16),
            labelLocation.leadingAnchor.constraint(
                equalTo: labelName.leadingAnchor),

            textFieldLocation.topAnchor.constraint(
                equalTo: labelLocation.bottomAnchor, constant: 16),
            textFieldLocation.leadingAnchor.constraint(
                equalTo: labelName.leadingAnchor),
            textFieldLocation.widthAnchor.constraint(
                equalTo: contentView.widthAnchor),

            labelTagHeader.topAnchor.constraint(
                equalTo: textFieldLocation.bottomAnchor, constant: 16),
            labelTagHeader.leadingAnchor.constraint(
                equalTo: labelName.leadingAnchor),

            buttonSelectTag.topAnchor.constraint(
                equalTo: textFieldLocation.bottomAnchor, constant: 16),
            buttonSelectTag.bottomAnchor.constraint(
                equalTo: labelTagHeader.bottomAnchor),
            buttonSelectTag.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -32),

            labelTagSelected.topAnchor.constraint(
                equalTo: buttonSelectTag.bottomAnchor, constant: 16),
            labelTagSelected.leadingAnchor.constraint(
                equalTo: labelName.leadingAnchor),

            buttonClearTag.topAnchor.constraint(
                equalTo: labelTagSelected.bottomAnchor, constant: 16),
            buttonClearTag.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor),

            labelCapacity.topAnchor.constraint(
                equalTo: buttonClearTag.bottomAnchor, constant: 16),
            labelCapacity.leadingAnchor.constraint(
                equalTo: labelName.leadingAnchor),

            capacityPicker.topAnchor.constraint(
                equalTo: labelCapacity.bottomAnchor, constant: 16),
            capacityPicker.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor),
            capacityPicker.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
