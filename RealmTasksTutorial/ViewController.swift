//
//  ViewController.swift
//  RealmTasksTutorial
//
//  Created by Steve Baker on 11/25/17.
//  Copyright © 2017 Beepscore LLC. All rights reserved.
//

import UIKit

import RealmSwift

class ViewController: UITableViewController {

    var items = List<Task>()

    // TODO: consider store in keychain
    var username = ""
    var password = ""

    // notificationToken to observe changes from the Realm
    var notificationToken: NotificationToken?
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUsernameAndPasswordAndSetupRealm()
    }

    func setupUI() {
        title = "My Tasks"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.leftBarButtonItem = editButtonItem
    }

    func getUsernameAndPasswordAndSetupRealm() {
        let alertController = UIAlertController(title: "Login", message: "", preferredStyle: .alert)

        var usernameTextField: UITextField!
        var passwordTextField: UITextField!

        alertController.addTextField { textField in
            usernameTextField = textField
            textField.placeholder = "User Name"
        }

        alertController.addTextField { textField in
            passwordTextField = textField
            textField.placeholder = "Password"
        }

        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ _ in
            // nil coalescing operator
            self.username = usernameTextField.text ?? ""
            self.password = passwordTextField.text ?? ""

            self.setupRealm()
        }))

        present(alertController, animated: true, completion: nil)
    }

    func setupRealm() {
        // Log in existing user with username and password

        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false),
                       server: Constants.syncAuthURL) { user, error in
                        guard let user = user else {
                            fatalError(String(describing: error))
                        }

            DispatchQueue.main.async {
                // Open Realm
                let configuration = Realm.Configuration(
                    syncConfiguration: SyncConfiguration(user: user,
                        realmURL: Constants.syncServerURL!)
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

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! items.realm?.write {
            items.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                let item = items[indexPath.row]
                realm.delete(item)
            }
        }
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

