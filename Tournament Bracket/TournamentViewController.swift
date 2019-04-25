//
//  TournamentViewController.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 11/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class TournamentViewController: UICollectionViewController {
    
    var groupCardWidth: CGFloat = 0
    
//    @IBOutlet weak var collectionView: UICollectionView!
    
    convenience init() {
        self.init(collectionViewLayout: GroupsCollectionLayout())
    }
    
    var tournament: Tournament?
    var groups: [Group] {
        return tournament?.groups?.array as? [Group] ?? []
    }
    
    let interactor = Interactor()
    let modalTransition = GroupDetailsTransition(duration: 0.5, isPresenting: false)
    let navigationTransition = GroupDetailsNavigationTransition(duration: 0.5, isPresenting: false)
    let transitionService = TransitionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.isNavigationBarHidden = false
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: groupCardWidth, height: 220)
        }
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
//        collectionView.register(UINib(nibName: GroupCell.nibName, bundle: nil), forCellWithReuseIdentifier: GroupCell.reuseId)
//        let layout = GroupsCollectionLayout()
//        layout.estimatedItemSize = CGSize(width: groupCardWidth, height: 220)
//        collectionView.collectionViewLayout = layout
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }


}

extension TournamentViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.reuseId, for: indexPath) as! GroupCell
        let group = groups[indexPath.row]
        cell.fill(with: group)
        return cell
    }
}

extension TournamentViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        if let nc = self.navigationController {
            let vc = GroupNavigationDetailsViewController()
            vc.interactor = interactor
            vc.transition = navigationTransition
            vc.indexPath = indexPath
            vc.group = group
            
            nc.pushViewController(vc, animated: true)
        }
        else {
            let vc = GroupDetailsViewController()
            vc.indexPath = indexPath
            vc.transition = modalTransition
            vc.interactor = interactor
            vc.transitioningDelegate = transitionService
            vc.group = group
            vc.groupCardWidth = groupCardWidth
            present(vc, animated: true)
        }
    }
    
}
