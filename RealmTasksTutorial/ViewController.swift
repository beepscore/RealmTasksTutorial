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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        title = "My Tasks"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

