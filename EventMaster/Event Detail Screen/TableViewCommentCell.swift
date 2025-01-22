//
//  TableViewCommentCell.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Hanson Wu on 11/27/24.
//

import Foundation
import UIKit

class TableViewCommentCell: UITableViewCell {
    private var wrapperCellView: UIView!
    var labelUserName: UILabel!
    var labelDateTime: UILabel!
    var labelCommentText: UILabel!
    var stackView: UIStackView!
    var buttonLike: UIButton!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapperCellView()
        setupLabelUserName()
        setupLabelDateTime()
        setupLabelCommentText()
        setupLikeButton()
        setupStackView()

        initConstraints()
    }

    private func setupWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 12
        wrapperCellView.layer.masksToBounds = true
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(wrapperCellView)
    }

    private func setupLabelUserName() {
        labelUserName = UILabel()
        labelUserName.textColor = .systemGray
        labelUserName.font = UIFont.boldSystemFont(ofSize: 16)
        labelUserName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelUserName)
    }

    private func setupLabelDateTime() {
        labelDateTime = UILabel()
        labelDateTime.textColor = .systemGray
        labelDateTime.font = UIFont.boldSystemFont(ofSize: 10)
        labelDateTime.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelDateTime)
    }

    private func setupLabelCommentText() {
        labelCommentText = UILabel()
        labelCommentText.font = UIFont.boldSystemFont(ofSize: 16)
        labelCommentText.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelCommentText)
    }
    
    @objc func onButtonTapped(){
        print("button tapped")
    }

    private func setupLikeButton() {
        buttonLike = UIButton(type: .system)
        let imageHeart = UIImage(systemName: "heart")
        buttonLike.setImage(imageHeart, for: .normal)
//        buttonLike.backgroundColor = .lightGray
        buttonLike.setTitle("0", for: .normal)
        buttonLike.setTitleColor(.systemBlue, for: .normal)
        buttonLike.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(buttonLike)
//        buttonLike.addTarget(self, action:#selector(onButtonTapped), for: .touchUpInside)
    }

    private func setupStackView() {
        let topStackView = UIStackView(arrangedSubviews: [
            labelCommentText, labelDateTime,
        ])
        topStackView.axis = .horizontal
        topStackView.spacing = 8
        topStackView.alignment = .leading
        topStackView.translatesAutoresizingMaskIntoConstraints = false

        let bottomStackView = UIStackView(arrangedSubviews: [
            labelUserName, buttonLike,
        ])
        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 16
        bottomStackView.alignment = .leading
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false

        stackView = UIStackView(arrangedSubviews: [
            topStackView, bottomStackView,
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(stackView)
    }

    private func initConstraints() {

        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 4),
            wrapperCellView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor, constant: -4),

            stackView.topAnchor.constraint(
                equalTo: wrapperCellView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(
                equalTo: wrapperCellView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(
                equalTo: wrapperCellView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(
                equalTo: wrapperCellView.bottomAnchor, constant: -8),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
