//
//  EventTableViewCell.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Khai Truong on 11/26/24.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    var wrapperCellView: UIView!
    var labelName: UILabel!
    var labelTime: UILabel!
    var labelLocation: UILabel!
    var labelImage: UIImageView!
    var labelTag: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        setupLabelTime()
        setupLabelLocation()
        setupLabelImage()
        setupLabelTag()
        
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 20)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
    
    func setupLabelTime(){
        labelTime = UILabel()
        labelTime.text = "10:00 AM"
        labelTime.textColor = .gray
        labelTime.font = UIFont.systemFont(ofSize: 14)
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTime)
    }
    
    func setupLabelLocation(){
        labelLocation = UILabel()
        labelLocation.font = UIFont.boldSystemFont(ofSize: 14)
        labelLocation.textColor = .systemGray
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelLocation)
    }
    
    func setupLabelTag(){
        labelTag = UILabel()
        labelTag.font = UIFont.boldSystemFont(ofSize: 14)
        labelTag.textColor = .systemBlue
        labelTag.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTag)
    }
    
    func setupLabelImage() {
        labelImage = UIImageView()
        labelImage.image = UIImage(systemName: "photo")
        labelImage.contentMode = .scaleToFill
        labelImage.clipsToBounds = true
        labelImage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelImage)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            labelImage.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            labelImage.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            labelImage.heightAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -8),
            labelImage.widthAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: 20),
            
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: labelImage.trailingAnchor, constant: 8),
            labelName.heightAnchor.constraint(equalToConstant: 20),
            labelName.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelTime.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelTime.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),
            labelTime.heightAnchor.constraint(equalToConstant: 20),
            labelTime.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelTag.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 2),
            labelTag.leadingAnchor.constraint(equalTo: labelImage.trailingAnchor, constant: 8),
            labelTag.heightAnchor.constraint(equalToConstant: 16),
            labelTag.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelLocation.topAnchor.constraint(equalTo: labelTag.bottomAnchor, constant: 6),
            labelLocation.leadingAnchor.constraint(equalTo: labelImage.trailingAnchor, constant: 8),
            labelLocation.heightAnchor.constraint(equalToConstant: 12),
            labelLocation.widthAnchor.constraint(lessThanOrEqualTo: labelName.widthAnchor),
            
            
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
