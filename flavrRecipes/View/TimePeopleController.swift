//
//  TilePeopleController.swift
//  flavrRecipes
//
//  Created by apple on 04.01.2023.
//

import UIKit

protocol TimePeopleControllerDelegate: AnyObject {
    func didSelectTime(with time: String)
}

class TimePeopleController: UITableViewController {
    weak var delegate: TimePeopleControllerDelegate?
    var timeArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timeArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let time = timeArray[indexPath.row]
        cell.textLabel?.text = "\(time) Minutes"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let time = timeArray[indexPath.row]
        delegate?.didSelectTime(with: time)
    }
    


}
