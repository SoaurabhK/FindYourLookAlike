//
//  CenterPageLayout.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 26/12/17.
//  Copyright © 2017 Soaurabh Kakkar. All rights reserved.
//

import UIKit

class CenterPageLayout: UICollectionViewFlowLayout {
    
    var mostRecentOffset : CGPoint = CGPoint()
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if velocity.x == 0 {
            return mostRecentOffset
        }
        
        guard let collectionView = self.collectionView, let attributesForVisibleCells = self.layoutAttributesForElements(in: collectionView.bounds) else {
            mostRecentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
            return mostRecentOffset
        }
        
        let halfWidth = collectionView.bounds.size.width * 0.5;
        
        var candidateAttributes : UICollectionViewLayoutAttributes?
        for attributes in attributesForVisibleCells {
            
            // == Skip comparison with non-cell items (headers and footers) == //
            if attributes.representedElementCategory != UICollectionElementCategory.cell {
                continue
            }
            if (attributes.center.x == 0) || (attributes.center.x > (collectionView.contentOffset.x + halfWidth) && velocity.x < 0) {
                continue
            }
            candidateAttributes = attributes
        }
        
        // Beautification step , I don't know why it works!
        if(proposedContentOffset.x == -(collectionView.contentInset.left)) {
            return proposedContentOffset
        }
        
        guard let _ = candidateAttributes else {
            return mostRecentOffset
        }
        mostRecentOffset = CGPoint(x: floor(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
        return mostRecentOffset
        
    }
    
}
