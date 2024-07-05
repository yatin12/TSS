//
//  HomeTBC.swift
//  TSS
//
//  Created by apple on 30/06/24.
//

import UIKit

class HomeTBC: UITableViewCell 
{
    @IBOutlet weak var objCollectionMeetSister: UICollectionView!
    @IBOutlet weak var imgSectionZero: UIImageView!
    @IBOutlet weak var objCollectionHome: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCollectionview()
    {
        self.objCollectionHome.register(UINib.init(nibName: "HomeCollectionCell", bundle: .main), forCellWithReuseIdentifier: "HomeCollectionCell")
        self.objCollectionHome.dataSource = self
        self.objCollectionHome.delegate = self
        self.objCollectionHome.reloadData()
        
        self.objCollectionMeetSister.register(UINib.init(nibName: "MeetSisterCTC", bundle: .main), forCellWithReuseIdentifier: "MeetSisterCTC")
        self.objCollectionMeetSister.dataSource = self
        self.objCollectionMeetSister.delegate = self
        self.objCollectionMeetSister.reloadData()
    }
    
    
}
//MARK: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout Methods
extension HomeTBC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == objCollectionMeetSister
        {
            let cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetSisterCTC",for: indexPath) as! MeetSisterCTC

            cell = cellToReturn
        }
        else
        {
            let cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell",for: indexPath) as! HomeCollectionCell

            cell = cellToReturn
        }
       return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width
        var height = 225.0
        if collectionView == objCollectionMeetSister
        {
            width = (UIScreen.main.bounds.width - 250.0)
            height = 230.0
        }
        else
        {
            width = (UIScreen.main.bounds.width - 250.0)
            height = 225.0
        }
         
        return CGSize(width: width, height: height)
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
}
