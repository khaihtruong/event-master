//
//  EventTableViewManager.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Khai Truong on 11/26/24.
//

import Foundation
import UIKit

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return eventList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: Configs.tableViewContactsID, for: indexPath)
            as! EventTableViewCell
        cell.labelName.text = eventList[indexPath.row].name
        cell.labelLocation.text = eventList[indexPath.row].location
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        cell.labelTime.text = dateFormatter.string(
            from: eventList[indexPath.row].dateTime.dateValue())

        cell.labelImage.image = UIImage(named: "happy")
        let tag = eventList[indexPath.row].tag
        cell.labelTag.text = tag[0]
        if tag[0] == "academic" {
            cell.labelImage.image = UIImage(named: "academic")
        } else if eventList[indexPath.row].tag[0] == "sports" {
            cell.labelImage.image = UIImage(named: "sports")
        } else {
            cell.labelImage.image = UIImage(named: "concert")
        }
        return cell
    }

    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        let eventDetailVC = EventDetailScreenVC()
        let name = eventList[indexPath.row].name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateTime = dateFormatter.string(
            from: eventList[indexPath.row].dateTime.dateValue())

        let location = eventList[indexPath.row].location

        eventDetailVC.eventKey = name + dateTime + location

        navigationController?.pushViewController(eventDetailVC, animated: true)
    }
}
