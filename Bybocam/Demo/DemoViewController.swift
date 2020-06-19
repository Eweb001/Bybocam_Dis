//
//  DemoViewController.swift
//  Bybocam
//
//  Created by APPLE on 15/11/19.
//  Copyright © 2019 eWeb. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController
{
   
    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    /*
     
    public weak var delegate: OuterCellProtocol?
    var positionForCell: [Int: Int] = [:]
    
    // Mark 1
    let innerCollectionView : UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame :.zero , collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .orange
        layout.estimatedItemSize =  CGSize(width: cv.frame.width, height: 1)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        
        return cv
        
    }()
 */
    /*
    // Mark 2
    
    var post: Post?
    {
        didSet
        {
            if let numLikes = post?.numLikes
            {
                //likesLabel.text = "\(numLikes) Likes"
            }
            
            if  let numComments = post?.numComments
            {
               // commentsLabel.text = "\(numComments) Comments"
            }
            innerCollectionView.reloadData()
            self.loadViewIfNeeded()
        }
    }
    protocol OuterCellProtocol: class
    {
        func changed(toPosition position: Int, cell: OutterCell)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if let index = self.innerCollectionView.indexPathForItem(at: CGPoint(x: self.innerCollectionView.contentOffset.x + 1, y: self.innerCollectionView.contentOffset.y + 1)) {
            self.delegate?.changed(toPosition: index.row, cell: self)
        }
    }
    func changed(toPosition position: Int, cell: OutterCell)
    {
        
        if let index = self.collectionView?.indexPath(for: cell)
        {
            self.positionForCell[index.row] = position
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        retun 2
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoColectionOne", for: indexPath) as! DemoColectionOne
        cell.post = post[indexPath.row]
        
        cell.delegate = self
        
        let cellPosition = self.positionForCell[indexPath.row] ?? 0
        cell.innerCollectionView.scrollToItem(at: IndexPath(row: cellPosition, section: 0), at: .left, animated: false)
        print (cellPosition)
        
        return cell
     }
     */
  
    
}
