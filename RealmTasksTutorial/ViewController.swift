//
//  ViewController.swift
//  RealmTasksTutorial
//
//  Created by Steve Baker on 11/25/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import UIKit

import RealmSwift

// TODO: consider extract model classes to a separate file

// MARK: Model

final class TaskList: Object {
    @objc dynamic var text = ""
    @objc dynamic var id = ""
    let items = List<Task>()

    override static func primaryKey() -> String? {
        return "id"
    }
}

final class Task: Object {
    @objc dynamic var text = ""
    @objc dynamic var completed = false
}

class ViewController: UITableViewController {

    var items = List<Task>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // add sample data
        items.append(Task(value: ["text": "My First Task"]))

    }

    func setupUI() {
        title = "My Tasks"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: UITableView

    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.text
        cell.textLabel?.alpha = item.completed ? 0.5 : 1
        return cell
    }
}

