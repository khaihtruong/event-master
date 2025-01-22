//
//  NewEventScreenVC.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Hanson Wu on 11/27/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import UIKit

class NewEventScreenVC: UIViewController {
    let newEventScreen = NewEventScreen()
    let database = Firestore.firestore()

    var datePicker: UIDatePicker!
    var boolDatePickerChanged: Bool = false

    var selectedTags = [String]()
    var selectedTagsJoinedStr = ""
    var selectedCapacity = "50"

    var defaultEventTag = Configs.eventTagList[0]

    override func loadView() {
        view = newEventScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self,
            action: #selector(onButtonSaveTapped))

        newEventScreen.capacityPicker.dataSource = self
        newEventScreen.capacityPicker.delegate = self

        newEventScreen.dateTimePicker.addTarget(
            self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        newEventScreen.buttonClearTag.addTarget(
            self, action: #selector(onClearTagsButtonTapped),
            for: .touchUpInside)

        newEventScreen.buttonSelectTag.menu = getMenuTags()

        //MARK: recognizing the taps on the app screen, not the keyboard...
        let tapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    //MARK: Hide Keyboard...
    @objc func hideKeyboardOnTap() {
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }

    func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        newEventScreen.textFieldDateTime.inputView = datePicker
    }

    @objc func datePickerChanged(_ datePicker: UIDatePicker) {
        boolDatePickerChanged = true && datePicker.date > Date()

    }

    func getMenuTags() -> UIMenu {
        var menuItems = [UIAction]()

        for tag in Configs.eventTagList {
            let menuItem = UIAction(
                title: tag,
                handler: { (_) in
                    self.defaultEventTag = tag
                    self.newEventScreen.buttonSelectTag.setTitle(
                        self.defaultEventTag, for: .normal)
                    self.updateSelectedTagLabel(newTag: tag)
                })
            menuItems.append(menuItem)
        }

        return UIMenu(title: "Select Event Tag", children: menuItems)
    }

    @objc func onClearTagsButtonTapped() {
        newEventScreen.labelTagSelected.text = "Select Event Tag(s)"
        selectedTags.removeAll()
    }

    func updateSelectedTagLabel(newTag: String) {
        if selectedTags.contains(newTag) {
            print("tag already selected")
            return
        }
        selectedTags.append(newTag)

        selectedTagsJoinedStr = selectedTags.joined(separator: ", ")

        newEventScreen.labelTagSelected.text = selectedTagsJoinedStr
    }

    func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(
            title: "Error", message: errorMessage, preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alert, animated: true)
    }

    @objc func onButtonSaveTapped() {
        print("save button tapped")

        guard let uwEventName = newEventScreen.textFieldName.text,
            !uwEventName.isEmpty
        else {
            showErrorAlert(errorMessage: "Event name cannot be empty.")
            print("event name is nil or empty")
            return
        }

        if boolDatePickerChanged == false {
            showErrorAlert(errorMessage: "Event time must be in the future.")
            print("event date time must be in the future")
            return
        }
        let uwEventDateTime = newEventScreen.dateTimePicker.date
        // adjust datetime from UTC to user's timezone
        let currTimeZone = TimeZone.current
        let currCalendar = Calendar.current
        let adjustedDate = currCalendar.date(
            byAdding: .second,
            value: currTimeZone.secondsFromGMT(for: uwEventDateTime),
            to: uwEventDateTime)!

        guard let uwEventLocation = newEventScreen.textFieldLocation.text,
            !uwEventLocation.isEmpty
        else {
            showErrorAlert(errorMessage: "Event location cannot be empty.")
            print("event location is nil or empty")
            return
        }

        if selectedTags.isEmpty {
            showErrorAlert(errorMessage: "Please select at least 1 event tag.")
            print("event tag is empty")
            return
        }

        let newEvent = Event(
            dateTime: Timestamp(date: adjustedDate), name: uwEventName,
            location: uwEventLocation, capacity: selectedCapacity,
            tag: selectedTags)

        createEventInDB(event: newEvent)
        self.navigationController?.popViewController(animated: true)

    }
    func createEventInDB(event: Event) {
        print(
            "creating event \(event.name) \(event.dateTime) \(event.location)")

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let currUserName = Auth.auth().currentUser?.displayName else {
            print(
                "NewEventScreenVC, createEventInDB: error unwrapping currUserName"
            )
            return
        }
        let formattedDateTime = event.dateTime.dateValue()
        let formattedDateTimeStr = formatter.string(from: formattedDateTime)
        let hashedEventKey = event.name + formattedDateTimeStr + event.location
        print("hashedEventKey |\(hashedEventKey)|")

        database.collection("events").document(hashedEventKey).setData([
            "name": event.name,
            "dateTime": event.dateTime,
            "location": event.location,
            "capacity": event.capacity,
            "tags": event.tag,
        ])
    }
}

extension NewEventScreenVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //MARK: we are using only one section...
        return 1
    }

    func pickerView(
        _ pickerView: UIPickerView, numberOfRowsInComponent component: Int
    ) -> Int {
        //MARK: we are displaying the options from Utilities.types...
        return Configs.maxCapacityList.count
    }

    func pickerView(
        _ pickerView: UIPickerView, titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        selectedCapacity = Configs.maxCapacityList[row]
        return Configs.maxCapacityList[row]
    }
}
