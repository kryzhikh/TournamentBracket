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
    let interactor = Interactor()
    let modalTransition = GroupDetailsTransition(duration: 0.5, isPresenting: false)
    let navigationTransition = GroupDetailsNavigationTransition(duration: 0.5, isPresenting: false)
    
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
            vc.transitioningDelegate = self
            vc.group = group
            vc.groupCardWidth = groupCardWidth
            present(vc, animated: true)
        }
    }
}


//MARK: - Custom navigation controller transition
extension GroupsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        navigationTransition.isPresenting = operation == .push
        return navigationTransition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return !navigationTransition.isPresenting && interactor.hasStarted ? interactor : nil
    }
}

//MARK: - Custom modal transition
extension GroupsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalTransition.isPresenting = false
        return modalTransition
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalTransition.isPresenting = true
        return modalTransition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
