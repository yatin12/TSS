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
    
    var objHomeResposne: HomeResposne?
    var strCurrSectionNm: String = ""
    
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
        
        /*
        let layout1: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout1.itemSize = CGSize(width: UIScreen.main.bounds.width - 100.0, height: 225.0)
        
        // Configure layout properties
        layout1.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout1.minimumInteritemSpacing = 5
        layout1.minimumLineSpacing = 5
        layout1.scrollDirection = .horizontal
        objCollectionHome.collectionViewLayout = layout1
        */

        
        self.objCollectionHome.dataSource = self
        self.objCollectionHome.delegate = self
        self.objCollectionHome.reloadData()
        
        self.objCollectionMeetSister.register(UINib.init(nibName: "MeetSisterCTC", bundle: .main), forCellWithReuseIdentifier: "MeetSisterCTC")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let itemsPerRow: CGFloat = 3
        let padding: CGFloat = 5
        let totalPadding = padding * (itemsPerRow + 1)
        let itemWidth = (objCollectionMeetSister.frame.width - totalPadding) / itemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: 230.0)
        
        // Configure layout properties
        layout.sectionInset = UIEdgeInsets(top: 5, left: padding, bottom: 5, right: padding)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        
        // Initialize the collection view
        objCollectionMeetSister.collectionViewLayout = layout
        
        
        
        
        self.objCollectionMeetSister.dataSource = self
        self.objCollectionMeetSister.delegate = self
        self.objCollectionMeetSister.reloadData()
    }
    
    func configure(withResponse response: HomeResposne?, withIndex index: Int, strSectionNm: String) {
        objHomeResposne = response
     //   print(objHomeResposne)
       
        strCurrSectionNm = strSectionNm
        print("strCurrSectionNm -->\(strCurrSectionNm)")
        
        /*
        if strCurrSectionNm == ""
        {
            imgSectionZero.isHidden = false
            objCollectionHome.isHidden = true
            objCollectionMeetSister.isHidden = true
        }
        else if strCurrSectionNm == "Tops News"
        {
            imgSectionZero.isHidden = true
            objCollectionHome.isHidden = false
            objCollectionMeetSister.isHidden = true
        }
        else if strCurrSectionNm == "Season 1"
        {
            imgSectionZero.isHidden = true
            objCollectionHome.isHidden = false
            objCollectionMeetSister.isHidden = true
        }
        else if strCurrSectionNm == "Season 1 BTS (Behind the Scenes)"
        {
            imgSectionZero.isHidden = true
            objCollectionHome.isHidden = false
            objCollectionMeetSister.isHidden = true
        }
        else if strCurrSectionNm == "E.Videos"
        {
            imgSectionZero.isHidden = true
            objCollectionHome.isHidden = false
            objCollectionMeetSister.isHidden = true
        }
        else if strCurrSectionNm == "Recommended Episodes"
        {
            imgSectionZero.isHidden = true
            objCollectionHome.isHidden = false
            objCollectionMeetSister.isHidden = true
        }
        else if strCurrSectionNm == "Meet The Sisters"
        {
            imgSectionZero.isHidden = true
            objCollectionHome.isHidden = true
            objCollectionMeetSister.isHidden = false
        }
        */
    }
}
//MARK: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout Methods
extension HomeTBC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 4
        var rowCount: Int = 0
        if strCurrSectionNm == "Tops News"
        {
            rowCount = objHomeResposne?.data?.recentNews?.count ?? 0
        }
        else if strCurrSectionNm == "Season 1"
        {
            rowCount = objHomeResposne?.data?.season?.count ?? 0
        }
        else if strCurrSectionNm == "Season 1 BTS (Behind the Scenes)"
        {
            //rowCount = objHomeResposne?.data?.season1BTS?.count ?? 0
            rowCount = 2
        }
        else if strCurrSectionNm == "E.Videos"
        {
            rowCount = objHomeResposne?.data?.empowermentVideo?.count ?? 0
        }
        else if strCurrSectionNm == "Recommended Episodes"
        {
            rowCount = objHomeResposne?.data?.recommendedEpisodes?.count ?? 0
        }
        else if strCurrSectionNm == "Meet The Sisters"
        {
            rowCount = objHomeResposne?.data?.meetTheSisters?.count ?? 0
        }
        return rowCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == objCollectionMeetSister
        {
            let cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetSisterCTC",for: indexPath) as! MeetSisterCTC

            cellToReturn.lblSisterNm.text = "\(objHomeResposne?.data?.meetTheSisters?[indexPath.row].name ?? "")"
            
            let strBlogUrl = "\(objHomeResposne?.data?.meetTheSisters?[indexPath.row].thumbnail ?? "")"
            cellToReturn.imgSister.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
           
            cell = cellToReturn
        }
        else
        {
            let cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell",for: indexPath) as! HomeCollectionCell
            
            if strCurrSectionNm == "Tops News"
            {
                cellToReturn.vwRestHeader.isHidden = false
                cellToReturn.vwSeason1TBS.isHidden = true
                
                let strTitle = "\(objHomeResposne?.data?.recentNews?[indexPath.row].title ?? "")"
                let strDesc = "\(objHomeResposne?.data?.recentNews?[indexPath.row].description ?? "")"
                cellToReturn.lblTitle.text = strTitle.htmlToString()
                cellToReturn.lblDesc.text = strDesc.htmlToString()
                
                let strBlogUrl = "\(objHomeResposne?.data?.recentNews?[indexPath.row].thumbnail ?? "")"
                cellToReturn.imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)

            }
            else if strCurrSectionNm == "Season 1"
            {
                cellToReturn.vwRestHeader.isHidden = false
                cellToReturn.vwSeason1TBS.isHidden = true
                
                let strTitle = "\(objHomeResposne?.data?.season?[indexPath.row].title ?? "")"
                let strDesc = "\(objHomeResposne?.data?.season?[indexPath.row].description ?? "")"
                cellToReturn.lblTitle.text = strTitle
                cellToReturn.lblDesc.text = strDesc
                
                let strBlogUrl = "\(objHomeResposne?.data?.season?[indexPath.row].thumbnail ?? "")"
                cellToReturn.imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)

                
            }
            else if strCurrSectionNm == "Season 1 BTS (Behind the Scenes)"
            {
                cellToReturn.vwRestHeader.isHidden = true
                cellToReturn.vwSeason1TBS.isHidden = false
                
                Season1TBSURL = "\(objHomeResposne?.data?.season1BTS?[0].url ?? "")"
                
                cellToReturn.btnWatchNowOutlt.addTarget(self, action: #selector(btnWatchNowTapped(sender:)), for: .touchUpInside)

            }
            else if strCurrSectionNm == "E.Videos"
            {
                cellToReturn.vwRestHeader.isHidden = false
                cellToReturn.vwSeason1TBS.isHidden = true
                
                let strTitle = "\(objHomeResposne?.data?.empowermentVideo?[indexPath.row].title ?? "")"
                let strDesc = "\(objHomeResposne?.data?.empowermentVideo?[indexPath.row].description ?? "")"
                cellToReturn.lblTitle.text = strTitle
                cellToReturn.lblDesc.text = strDesc
                
                let strBlogUrl = "\(objHomeResposne?.data?.empowermentVideo?[indexPath.row].thumbnail ?? "")"
                cellToReturn.imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
                
            }
            else if strCurrSectionNm == "Recommended Episodes"
            {
                cellToReturn.vwRestHeader.isHidden = false
                cellToReturn.vwSeason1TBS.isHidden = true
                
                if let recommendedEpisodes = objHomeResposne?.data?.recommendedEpisodes {
                    if indexPath.row < recommendedEpisodes.count {
                        // Safe to access recommendedEpisodes[indexPath.row]
                        let strTitle = "\(recommendedEpisodes[indexPath.row].title ?? "")"
                        let strDesc = "\(recommendedEpisodes[indexPath.row].description ?? "")"
                        cellToReturn.lblTitle.text = strTitle
                        cellToReturn.lblDesc.text = strDesc
                        
                        let strBlogUrl = "\(objHomeResposne?.data?.recommendedEpisodes?[indexPath.row].thumbnail ?? "")"
                        cellToReturn.imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
                        
                    } else {
                        // Handle the case where indexPath.row is out of range
                        print("Index out of range: indexPath.row \(indexPath.row) beyond recommendedEpisodes count \(recommendedEpisodes.count)")
                    }
                } else {
                    // Handle the case where recommendedEpisodes or its parent objects are nil
                    print("Recommended episodes array or its parent objects are nil")
                }
            }

            cell = cellToReturn
        }
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width
        var height = 225.0
        if collectionView == objCollectionMeetSister
        {
            /*
            width = (UIScreen.main.bounds.width - 250.0)
            height = 230.0
            */
            
            let itemsPerRow: CGFloat = 3
            let padding: CGFloat = 5
            let totalPadding = padding * (itemsPerRow + 1)
            let itemWidth = (objCollectionMeetSister.frame.width - totalPadding) / itemsPerRow
            return CGSize(width: itemWidth, height: 230.0)
            
        }
        else
        {
             if strCurrSectionNm == "Season 1 BTS (Behind the Scenes)"
            {
                 width = (UIScreen.main.bounds.width)
                  height = 100.0
            }
            else
            {
                width = (UIScreen.main.bounds.width - 250.0)
                 height = 225.0
            }
          
        }
         
        return CGSize(width: width, height: height)
    }
    
    @objc func btnWatchNowTapped(sender: UIButton){
        NotificationCenter.default.post(name: Notification.Name("btnWatchNowTapped"), object: nil, userInfo: nil)

    }
//    func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
}
