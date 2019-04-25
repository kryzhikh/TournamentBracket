//
//  GroupsCollectionLayout.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 09/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupsCollectionLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = super.layoutAttributesForElements(in: rect) ?? []
//        for attr in attrs {
//            attr.zIndex = attr.indexPath.row
//        }
//        print("Attributes bounds: ", attrs.first?.frame)
        return attrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.layoutAttributesForItem(at: indexPath)
        attr?.zIndex = indexPath.row
        return attr
    }

}
