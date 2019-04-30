//
//  AddPlayersViewController.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 26/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class AddPlayersViewController: UIViewController, StoryboardInstantiatable {
    
    static let storyboardId = "AddPlayersViewController"
    static let storyboardName = "CreateTournament"
    
    private let playerCellId = "playerCellId"
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    var keyboardObserver: NSObjectProtocol?
    
    var tournament: Tournament!
    var players = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameTextField.delegate = self
        addDismissKeyboardInTapGesture()
        tableView.keyboardDismissMode = .interactive
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: playerCellId)
        
        keyboardObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: OperationQueue.main, using: { [weak self] notification in
            self?.keyboardWillChangeFrameNotification(notification)
        })
    }
    
    func addPlayers(_ string: String) {
        let names = string
            .components(separatedBy: CharacterSet.punctuationCharacters)
            .map { $0.trimmingCharacters(in: .whitespaces) }
        print(names)
        let newPlayers = names.map { Player(name: $0, context: CoreData.shared.viewContext) }
        players.append(contentsOf: newPlayers)
    }
    
    
    //MARK: - Utility
    private func checkIfBracketValid() -> Bool {
        return players.count > 2 && players.count.isPowerOfTwo()
    }
    
    private func addDismissKeyboardInTapGesture() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gr)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(false)
    }
    
    private func keyboardWillChangeFrameNotification(_ n: Notification) {
        guard
            let beginFrame = (n.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let endFrame = (n.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (n.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            endFrame != beginFrame
            else { return }
        let keyboardInitialY = beginFrame.minY
        let keyboardFinalY = endFrame.minY
        let showingKeyboard = keyboardFinalY < keyboardInitialY
        buttonBottomConstraint.constant = view.frame.height - keyboardFinalY - (showingKeyboard ? view.safeAreaInsets.bottom : 0)
        print("KB FRAME: ", beginFrame, endFrame)
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension AddPlayersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let string = textField.text, !string.isEmpty else { return true }
//        let player = Player(name: name, context: CoreData.shared.viewContext)
//        players.append(player)
        addPlayers(string)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: players.count - 1, section: 0), at: .none, animated: true)
        textField.text = ""
        print("IS MAIN: ", Thread.isMainThread)
        return true
    }
}

extension AddPlayersViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: playerCellId, for: indexPath)
        let player = players[indexPath.row]
        cell.textLabel?.text = player.name
        return cell
    }
}
