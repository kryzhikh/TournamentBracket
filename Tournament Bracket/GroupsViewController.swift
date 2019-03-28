//
//  GroupsViewController.swift
//  TournamentTables
//
//  Created by Konstantin Ryzhikh on 05/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController {
    
    var groupCardWidth: CGFloat {
        return min(view.frame.width - 60, 340.0)
    }

    @IBOutlet weak var groupsCollectionView: UICollectionView!
    
    var transitionCollectionView: UICollectionView {
        return groupsCollectionView
    }
    
    var groups: [Group]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = groupsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: groupCardWidth, height: 100)
        }
        groupsCollectionView.register(UINib(nibName: GroupCell.nibName, bundle: nil), forCellWithReuseIdentifier: GroupCell.reuseId)
        prepareData()
        view.apply(.grayBackground)
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func prepareData() {
        let groupsDict = ["A": ["Vasili", "Petr", "Ivan", "Valera"],
                          "B": ["Mike", "John", "Tom", "Jerry"],
                          "C": ["Jovanni", "Alejandro", "Marko", "Polo"],
                          "D": ["Chan", "Chen", "Zhao", "Minzi"]]
        
        let context = CoreData.shared.viewContext
        var groups = [Group]()
        
        for groupName in groupsDict.keys {
            groups.append(Group(name: groupName, competitorsNames: groupsDict[groupName] ?? [], context: context))
        }
        
        self.groups = groups
        groupsCollectionView.reloadData()
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        if let layout = groupsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = size.width < size.height ? .vertical : .horizontal
//        }
//    }

}

extension GroupsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.reuseId, for: indexPath) as! GroupCell
        let group = groups[indexPath.row]
        cell.fill(with: group)
        return cell
    }

}

extension GroupsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        if let nc = self.navigationController {
            let vc = GroupNavigationDetailsViewController()
            vc.indexPath = indexPath
            vc.group = group
            
            nc.pushViewController(vc, animated: true)
        }
        else {
            let vc = GroupDetailsViewController()
            vc.indexPath = indexPath
            vc.group = group
            vc.groupCardWidth = groupCardWidth
            present(vc, animated: true)
        }
    }
}

extension GroupsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GroupDetailsNavigationTransition(duration: 0.5, isPresenting: operation == .push)
    }
}
