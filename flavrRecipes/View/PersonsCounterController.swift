//
//  PersonsCounterController.swift
//  flavrRecipes
//
//  Created by apple on 04.01.2023.
//

import UIKit

protocol PersonsCounterControllerDelegate: AnyObject{
    func getNumberPerson(number: String)
}

class PersonsCounterController: UITableViewController {
    weak var delegate: PersonsCounterControllerDelegate?
var numberPersons = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberPersons.count
    }
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let number = numberPersons[indexPath.row]
        cell.textLabel?.text = "\(number) People"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let number = numberPersons[indexPath.row]
        delegate?.getNumberPerson(number: number)
    }

}
