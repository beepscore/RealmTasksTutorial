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

    // notificationToken to observe changes from the Realm
    var notificationToken: NotificationToken?
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRealm()
    }

    func setupUI() {
        title = "My Tasks"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
    }

    func setupRealm() {
        // Log in existing user with username and password

        // TODO: update credentials to match registered credentials

        let username = "test"  // <--- Update this
        let password = "test"  // <--- Update this

        // realm object server running on local network e.g. macos
        let realmServerUrlString = "http://127.0.0.1:9080"
        let realmServerUrl = URL(string: realmServerUrlString)!

        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false),
                       server: realmServerUrl) { user, error in
                        guard let user = user else {
                            fatalError(String(describing: error))
                        }

            DispatchQueue.main.async {
                // Open Realm
                let configuration = Realm.Configuration(
                    syncConfiguration: SyncConfiguration(user: user,
                        realmURL: URL(string: "realm://127.0.0.1:9080/~/realmtasks")!)
                    )
                self.realm = try! Realm(configuration: configuration)

                // Show initial tasks
                func updateList() {
                    if self.items.realm == nil, let list = self.realm.objects(TaskList.self).first {
                        self.items = list.items
                    }
                    self.tableView.reloadData()
                }
                updateList()

                // Notify us when Realm changes
                self.notificationToken = self.realm.observe { _,_ in
                    updateList()
                }
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
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

    // MARK: Functions

    @objc func add() {
        let alertController = UIAlertController(title: "New Task", message: "Enter Task Name", preferredStyle: .alert)

        var alertTextField: UITextField!

        alertController.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "Task Name"
        }

        alertController.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard let text = alertTextField.text , !text.isEmpty else { return }

            let items = self.items
            // write items to the Realm
            try! items.realm?.write {
                items.insert(Task(value: ["text": text]), at: items.filter("completed = false").count)
            }
        })
        
        present(alertController, animated: true, completion: nil)
    }

}

