//
//  EventDetailScreen.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Hanson Wu on 11/27/24.
//

import Foundation
import UIKit

protocol EventDetailScreenDelegate: AnyObject {
    func onShowMapTapped()
}

class EventDetailScreen: UIView {
    weak var delegate: EventDetailScreenDelegate?
    
    var buttonShowMap: UIButton!

    var eventDetailSection: UIView!
    var commentSection: UIView!
    var commentScrollView: UIScrollView!
    var commentContentView: UIView!

    var ImageEventImageView: UIImageView!

    var labelEventDetailName: UILabel!
    var labelEventDetailDateTime: UILabel!
    var labelEventDetailLocation: UILabel!
    var labelEventDetailAttendance: UILabel!
    var labelEventDetailTags: UILabel!

    var eventDetailStackView: UIStackView!

    var tableViewComments: UITableView!

    var labelCommentsHeader: UILabel!

    var imageName: String!

    var buttonAddComment: UIButton!
    var textViewReply: UITextView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupButtonShowMap()

        setupEventDetailSection()
        setupImageEvenImageView()

        setupLabelEventName()
        setupLabelEventDateTime()
        setupLabelEventLocation()
        setupLabelEventAttendance()
        setupLabelEventTags()

        setupEventDetailStackView()
        setupCommentContentView()

        setupLabelCommentsHeader()

        setupTableViewComments()
        setupButtonAddComment()
        setupReplyTextView()

        initConstraints()
    }

    func setupButtonAddComment() {
        buttonAddComment = UIButton(type: .system)
        buttonAddComment.titleLabel?.font = .boldSystemFont(ofSize: 200)
        buttonAddComment.setImage(
            UIImage(systemName: "plus.circle.fill"), for: .normal)
        buttonAddComment.frame.size = CGSize(width: 200.0, height: 300.0)
        buttonAddComment.contentHorizontalAlignment = .fill
        buttonAddComment.contentVerticalAlignment = .fill
        buttonAddComment.imageView?.contentMode = .scaleAspectFit
        buttonAddComment.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(buttonAddComment)
    }
    
    func setupButtonShowMap() {
        
        buttonShowMap = UIButton(type: .system)
        buttonShowMap.setTitle("Show Map", for: .normal)
        buttonShowMap.setTitleColor(.white, for: .normal)
        buttonShowMap.backgroundColor = .systemBlue
        buttonShowMap.layer.cornerRadius = 10
        buttonShowMap.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        buttonShowMap.translatesAutoresizingMaskIntoConstraints = false
        
        
        buttonShowMap.addTarget(self, action: #selector(showMapTapped), for: .touchUpInside)

        self.addSubview(buttonShowMap)
    }
    
    @objc private func showMapTapped() {
        delegate?.onShowMapTapped()
    }

    func setupEventDetailSection() {
        eventDetailSection = UIView()
//        eventDetailSection.backgroundColor = .blue
//        eventDetailSection.layer.borderWidth = 1
//        eventDetailSection.layer.borderColor = UIColor.gray.cgColor
//        eventDetailSection.layer.cornerRadius = 5
        eventDetailSection.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(eventDetailSection)
    }

    func setupImageEvenImageView() {
        ImageEventImageView = UIImageView()
        ImageEventImageView.contentMode = .scaleAspectFit
        ImageEventImageView.clipsToBounds = true
        ImageEventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventDetailSection.addSubview(ImageEventImageView)
    }

    func setEventImage(imageName: String) {
        guard let uwImage = UIImage(named: imageName) else {
            print("error setting event image")
            return
        }
        ImageEventImageView.image = uwImage
    }

    func setupLabelEventName() {
        labelEventDetailName = UILabel()
        labelEventDetailName.text = "Event Name: "
        labelEventDetailName.translatesAutoresizingMaskIntoConstraints = false
        eventDetailSection.addSubview(labelEventDetailName)
    }

    func setupLabelEventDateTime() {
        labelEventDetailDateTime = UILabel()
        labelEventDetailDateTime.text = "Time: "
        labelEventDetailDateTime.translatesAutoresizingMaskIntoConstraints =
            false
        eventDetailSection.addSubview(labelEventDetailDateTime)
    }

    func setupLabelEventLocation() {
        labelEventDetailLocation = UILabel()
        labelEventDetailLocation.text = "Location: "
        labelEventDetailLocation.translatesAutoresizingMaskIntoConstraints =
            false
        eventDetailSection.addSubview(labelEventDetailLocation)
    }

    func setupLabelEventAttendance() {
        labelEventDetailAttendance = UILabel()
        labelEventDetailAttendance.text = "Attendance: "
        labelEventDetailAttendance.translatesAutoresizingMaskIntoConstraints =
            false
        eventDetailSection.addSubview(labelEventDetailAttendance)
    }

    func setupLabelEventTags() {
        labelEventDetailTags = UILabel()
        labelEventDetailTags.text = "Tag(s): "
        labelEventDetailTags.translatesAutoresizingMaskIntoConstraints = false
        eventDetailSection.addSubview(labelEventDetailTags)
    }

    func setupEventDetailStackView() {
        eventDetailStackView = UIStackView(arrangedSubviews: [
            labelEventDetailName, labelEventDetailDateTime,
            labelEventDetailLocation, labelEventDetailAttendance,
            labelEventDetailTags,
        ])
        eventDetailStackView.axis = .vertical
        eventDetailStackView.spacing = 4
        eventDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        eventDetailSection.addSubview(eventDetailStackView)
    }

    func setupLabelCommentsHeader() {
        labelCommentsHeader = UILabel()
        labelCommentsHeader.text = "COMMENTS:"
        labelCommentsHeader.font = .boldSystemFont(ofSize: 17)
        labelCommentsHeader.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelCommentsHeader)
    }

    func setupCommentContentView() {
        commentContentView = UIView()
//        commentContentView.backgroundColor = .cyan
//        commentContentView.layer.borderWidth = 1
//        commentContentView.layer.borderColor = UIColor.gray.cgColor
//        commentContentView.layer.cornerRadius = 5
        commentContentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(commentContentView)
    }

    func setupTableViewComments() {
        tableViewComments = UITableView()
//        tableViewComments.backgroundColor = .red
        tableViewComments.layer.borderWidth = 1
        tableViewComments.layer.borderColor = UIColor.gray.cgColor
        tableViewComments.layer.cornerRadius = 5
        tableViewComments.register(
            TableViewCommentCell.self, forCellReuseIdentifier: "comments")
        tableViewComments.translatesAutoresizingMaskIntoConstraints = false
        commentContentView.addSubview(tableViewComments)
    }

    func setupReplyTextView() {

        textViewReply = UITextView()
        textViewReply?.frame = CGRect(
            x: 20, y: 200, width: self.frame.width - 40, height: 200)
        textViewReply?.layer.borderWidth = 1
        textViewReply?.layer.borderColor = UIColor.gray.cgColor
        textViewReply?.layer.cornerRadius = 5
        textViewReply.translatesAutoresizingMaskIntoConstraints = false
        commentContentView.addSubview(textViewReply)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            // Event Image
            ImageEventImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            ImageEventImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            ImageEventImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            ImageEventImageView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),

            // Event Details Stack View
            eventDetailStackView.topAnchor.constraint(equalTo: ImageEventImageView.bottomAnchor, constant: 16),
            eventDetailStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            eventDetailStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            // Show Map Button
            buttonShowMap.topAnchor.constraint(equalTo: eventDetailStackView.bottomAnchor, constant: 16),
            buttonShowMap.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonShowMap.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonShowMap.heightAnchor.constraint(equalToConstant: 44),

            // Comments Header
            labelCommentsHeader.topAnchor.constraint(equalTo: buttonShowMap.bottomAnchor, constant: 16),
            labelCommentsHeader.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            // Comments Content View
            commentContentView.topAnchor.constraint(equalTo: labelCommentsHeader.bottomAnchor, constant: 8),
            commentContentView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            commentContentView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            commentContentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            // Table View Comments
            tableViewComments.topAnchor.constraint(equalTo: commentContentView.topAnchor, constant: 8),
            tableViewComments.leadingAnchor.constraint(equalTo: commentContentView.leadingAnchor, constant: 8),
            tableViewComments.trailingAnchor.constraint(equalTo: commentContentView.trailingAnchor, constant: -8),
            tableViewComments.bottomAnchor.constraint(equalTo: textViewReply.topAnchor, constant: -8),

            // Add Comment Button
            buttonAddComment.widthAnchor.constraint(equalToConstant: 48),
            buttonAddComment.heightAnchor.constraint(equalToConstant: 48),
            buttonAddComment.bottomAnchor.constraint(equalTo: commentContentView.bottomAnchor, constant: -16),
            buttonAddComment.trailingAnchor.constraint(equalTo: commentContentView.trailingAnchor, constant: -16),

            // Reply Text View
            textViewReply.heightAnchor.constraint(equalToConstant: 50),
            textViewReply.leadingAnchor.constraint(equalTo: commentContentView.leadingAnchor, constant: 8),
            textViewReply.trailingAnchor.constraint(equalTo: buttonAddComment.leadingAnchor, constant: -8),
            textViewReply.bottomAnchor.constraint(equalTo: commentContentView.bottomAnchor, constant: -16),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
