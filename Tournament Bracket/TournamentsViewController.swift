//
//  TournamentsViewController.swift
//  TournamentTables
//
//  Created by Konstantin Ryzhikh on 05/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class TournamentsViewController: UIViewController {
    
    var groupCardWidth: CGFloat {
        return min(view.frame.width - 60, 340.0)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var expandedLayout: UICollectionViewFlowLayout!
    var collapesedLayout: UICollectionViewFlowLayout!
    var expanded = false
    var expandedSection = -1

    var groupsCollectionView: UICollectionView {
        return collectionView
    }
    
    var transitionCollectionView: UICollectionView {
        return groupsCollectionView
    }
    
    var groups: [Group]!
    var tournaments: [Tournament]!
    
    let transitionService = TransitionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: groupCardWidth, height: 220)
//            layout.minimumLineSpacing = 10
            layout.sectionInset.bottom = 30
            collapesedLayout = layout
            
            expandedLayout = GroupsCollectionLayout()
            expandedLayout.sectionInset.bottom = 30
            expandedLayout.scrollDirection = .vertical
            expandedLayout.estimatedItemSize = layout.estimatedItemSize
        }
        
        collectionView.register(UINib(nibName: GroupCell.nibName, bundle: nil), forCellWithReuseIdentifier: GroupCell.reuseId)
        prepareData()
        view.apply(.grayBackground)
        navigationController?.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
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
        var groups1 = [Group]()
        var groups2 = [Group]()
        
        for groupName in groupsDict.keys.sorted() {
            groups1.append(Group(name: groupName, competitorsNames: groupsDict[groupName] ?? [], context: context))
        }
        
        for groupName in groupsDict.keys.sorted() {
            groups2.append(Group(name: groupName, competitorsNames: groupsDict[groupName] ?? [], context: context))
        }
        
        let tnmt1 = Tournament(name: "Tournament A", groups: groups1, context: context)
        let tnmt2 = Tournament(name: "Tournament B", groups: groups2, context: context)
        
        try? context.save()
        
        self.groups = groups1
        self.tournaments = [tnmt1, tnmt2]
        collectionView.reloadData()
    }
    
}

extension TournamentsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tournaments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tournaments[section].groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.reuseId, for: indexPath) as! GroupCell
        let group = tournaments[indexPath.section].groups![indexPath.row] as! Group
        print(indexPath, group.name!, group.competitors!.count)
        cell.fill(with: group)
        return cell
    }
}

extension TournamentsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        if let nc = self.navigationController {
            let vc = GroupNavigationDetailsViewController()
            vc.interactor = transitionService.interactor
            vc.transition = transitionService.navigationTransition
            vc.indexPath = indexPath
            vc.group = group
            nc.pushViewController(vc, animated: true)
        }
        else {
            let cell = collectionView.cellForItem(at: indexPath)!
            
            if expandedSection == indexPath.section {
//                expandedSection = -1
                let vc = GroupDetailsViewController()
                vc.indexPath = indexPath
                vc.transition = transitionService.modalTransition
                vc.interactor = transitionService.interactor
                vc.transitioningDelegate = transitionService
                vc.group = group
                vc.groupCardWidth = groupCardWidth
                present(vc, animated: true)

            }
            else {
                let layout = expanded ? collapesedLayout : expandedLayout
                expanded = !expanded
                expandedSection = indexPath.section
                UIView.animate(withDuration: 0.3) {
                    collectionView.setCollectionViewLayout(layout!, animated: true)
                    collectionView.contentOffset.y = -collectionView.adjustedContentInset.top
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section != expandedSection && navigationController == nil ? -200 : 10
    }
    
}

extension TournamentsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionService.navigationControllerTransitioning(for: operation)
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transitionService.navigationControllerInteractiveTransitioning()
    }
}
