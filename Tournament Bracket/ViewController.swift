//
//  ViewController.swift
//  TournamentTables
//
//  Created by Konstantin Ryzhikh on 05/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var groupCardWidth: CGFloat {
        return min(view.frame.width - 40, 320.0)
    }

    @IBOutlet weak var groupsCollectionView: UICollectionView!
    
    var groups: [Group]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = groupsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: groupCardWidth, height: 100)
        }
        groupsCollectionView.register(UINib(nibName: GroupCell.nibName, bundle: nil), forCellWithReuseIdentifier: GroupCell.reuseId)
        prepareData()
    }
    
    func prepareData() {
        let groupsDict = ["A": ["Vasili", "Petr", "Ivan", "Valera", "Goreslav"], "B": ["Mike", "John", "Tom", "Jerry"], "C": ["Jovanni", "Alejandro", "Marko", "Polo"]]
        
        let context = CoreData.shared.viewContext
        var groups = [Group]()
        
        for groupName in groupsDict.keys {
            groups.append(Group(name: groupName, competitorsNames: groupsDict[groupName] ?? [], context: context))
        }
        
        self.groups = groups
        groupsCollectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let layout = groupsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = size.width < size.height ? .vertical : .horizontal
        }
    }

}

extension ViewController: UICollectionViewDataSource {
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        let vc = GroupDetailsViewController()
        if let cell = collectionView.cellForItem(at: indexPath) {
            let img = cell.makeSnapshot()
            print(img)
        }
        vc.group = group
        present(vc, animated: true)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width - 40
//        let height = CGFloat(groups[indexPath.row].competitors?.count ?? 0) * GroupTableCell.cellHeight
//    }
}

