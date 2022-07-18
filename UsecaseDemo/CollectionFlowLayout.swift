//
//  CollectionFlowLayout.swift
//  UsecaseDemo
//
//  Created by Ramel Rana on 17/07/22.
//

import UIKit

class CollectionFlowLayout: UICollectionViewFlowLayout {
    
        var currentCellPath: NSIndexPath?
        var currentCellCenter: CGPoint?
        var currentCellScale: CGFloat?
    
    
    func setCurrentCellScale(scale: CGFloat)
    {
        currentCellScale = scale
        self.invalidateLayout()
    }

    func setCurrentCellCenter(origin: CGPoint)
    {
        currentCellCenter = origin
        self.invalidateLayout()
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) ->
                          UICollectionViewLayoutAttributes? {
        let attributes =
            super.layoutAttributesForItem(at: indexPath)
        
        if let attributes = attributes {
            self.modifyLayoutAttributes(layoutattributes: attributes)
        }
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) ->
            [UICollectionViewLayoutAttributes]? {
        
        let allAttributesInRect =
            super.layoutAttributesForElements(in: rect)
        
        if let allAttributesInRect = allAttributesInRect {
            for cellAttributes in allAttributesInRect {
                self.modifyLayoutAttributes(layoutattributes: cellAttributes )
            }
        }
        return allAttributesInRect
    }
    
    func modifyLayoutAttributes(layoutattributes:
        UICollectionViewLayoutAttributes) {
        
        if let currentCellPath = currentCellPath,
            let currentCellScale = currentCellScale,
            let currentCellCenter = currentCellCenter {
            if layoutattributes.indexPath == currentCellPath as IndexPath {
                layoutattributes.transform3D =
                    CATransform3DMakeScale(currentCellScale,
                                           currentCellScale, 1.0)
                layoutattributes.center = currentCellCenter
                layoutattributes.zIndex = 1
            }
        }
    }
}


