//
//  CreateMatchViewController.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 26/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class CreateTournamentViewController: UIViewController, StoryboardInstantiatable {

    static let storyboardId = "CreateTournamentViewController"
    static let storyboardName = "CreateTournament"
    
    @IBOutlet weak var createTournamentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createTournament(_ sender: Any) {
        let vc = AddPlayersViewController.instantiateFromStoryboard()
        let tnmnt = Tournament.makeBracketTournament(name: "Test Tournament", competitorsNames: [], context: CoreData.shared.viewContext)
        vc.tournament = tnmnt
        present(vc, animated: true)
    }
    
}
