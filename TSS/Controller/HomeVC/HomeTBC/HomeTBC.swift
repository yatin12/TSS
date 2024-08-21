//
//  HomeTBC.swift
//  TSS
//
//  Created by apple on 30/06/24.
//

import UIKit
import AVFoundation

class HomeTBC: UITableViewCell
{
    
   // var currentVideoIndexPath: IndexPath?
//    var currentPlayingIndexPath: IndexPath?
//    let arrVideosLocal = ["trailer-1-final-promo", "trailer-2-final-promo"]
//    
    
  //  @IBOutlet weak var objPgControl: UIPageControl!
    //@IBOutlet weak var vwSection1: UIView!
    @IBOutlet weak var objCollectionMeetSister: UICollectionView!
   // @IBOutlet weak var imgSectionZero: UIImageView!
    @IBOutlet weak var objCollectionHome: UICollectionView!
    
  //  @IBOutlet weak var objCollectionSection1: UICollectionView!
    @IBOutlet weak var objCollection1TBS: UICollectionView!
    var objHomeResposne: HomeResposne?
    var strCurrSectionNm: String = ""
    // hasVideoPlayed = false
    
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
        /*
        self.objCollectionSection1.register(UINib.init(nibName: "Seaction1CTC", bundle: .main), forCellWithReuseIdentifier: "Seaction1CTC")
      //  objCollectionSection1.isPagingEnabled = true
        
        let layout12: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let itemWidth12 = UIScreen.main.bounds.width
        layout12.itemSize = CGSize(width: itemWidth12, height: 225.0)
        
        // Configure layout properties
        layout12.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout12.minimumInteritemSpacing = 5
        layout12.minimumLineSpacing = 5
        layout12.scrollDirection = .horizontal
        
        // Initialize the collection view
        objCollectionSection1.collectionViewLayout = layout12
        
        
        self.objCollectionSection1.dataSource = self
        self.objCollectionSection1.delegate = self
        self.objCollectionSection1.reloadData()
        
        */
        
        self.objCollectionHome.register(UINib.init(nibName: "HomeCollectionCell", bundle: .main), forCellWithReuseIdentifier: "HomeCollectionCell")
        
        self.objCollectionHome.dataSource = self
        self.objCollectionHome.delegate = self
        self.objCollectionHome.reloadData()
       
        
        self.objCollection1TBS.register(UINib.init(nibName: "Season1TBSCTC", bundle: .main), forCellWithReuseIdentifier: "Season1TBSCTC")
        let layout1: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let itemWidth1 = UIScreen.main.bounds.width - 48.0
        layout1.itemSize = CGSize(width: itemWidth1, height: 80.0)
        
        // Configure layout properties
        layout1.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout1.minimumInteritemSpacing = 5
        layout1.minimumLineSpacing = 5
        layout1.scrollDirection = .horizontal
        
        // Initialize the collection view
        objCollection1TBS.collectionViewLayout = layout1
        
        self.objCollection1TBS.dataSource = self
        self.objCollection1TBS.delegate = self
        self.objCollection1TBS.reloadData()
        
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
        
        
        
        strCurrSectionNm = strSectionNm
        print("strCurrSectionNm -->\(strCurrSectionNm)")
        
       
        objCollectionHome.reloadData()
        objCollectionMeetSister.reloadData()
        self.objCollection1TBS.reloadData()
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
            rowCount = objHomeResposne?.data?.season1BTS?.count ?? 0
            print("rowCount-->\(rowCount)")
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell = UICollectionViewCell()
        if collectionView == objCollectionMeetSister
        {
            let cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetSisterCTC",for: indexPath) as! MeetSisterCTC
            
            cellToReturn.lblSisterNm.text = "\(objHomeResposne?.data?.meetTheSisters?[indexPath.row].name ?? "")"
            
            let strBlogUrl = "\(objHomeResposne?.data?.meetTheSisters?[indexPath.row].thumbnail ?? "")"
            cellToReturn.imgSister.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
            
            
            cell = cellToReturn
        }
        else if collectionView == objCollection1TBS
        {
            let cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: "Season1TBSCTC",for: indexPath) as! Season1TBSCTC
            
            
            Season1TBSURL = "\(objHomeResposne?.data?.season1BTS?[0].url ?? "")"
            
            cellToReturn.btnWatchNowOutlt.addTarget(self, action: #selector(btnWatchNowTapped(sender:)), for: .touchUpInside)
            
            cell = cellToReturn
        }
        else
        {
            let cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell",for: indexPath) as! HomeCollectionCell
            
            if strCurrSectionNm == "Tops News"
            {
                
                let strTitle = "\(objHomeResposne?.data?.recentNews?[indexPath.row].title ?? "")"
                let strDesc = "\(objHomeResposne?.data?.recentNews?[indexPath.row].description ?? "")"
                cellToReturn.lblTitle.text = strTitle.htmlToString()
                cellToReturn.lblDesc.text = strDesc.htmlToString()
                
                let strBlogUrl = "\(objHomeResposne?.data?.recentNews?[indexPath.row].thumbnail ?? "")"
                cellToReturn.imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
                
            }
            else if strCurrSectionNm == "Season 1"
            {
                
                let strTitle = "\(objHomeResposne?.data?.season?[indexPath.row].title ?? "")"
                let strDesc = "\(objHomeResposne?.data?.season?[indexPath.row].description ?? "")"
                cellToReturn.lblTitle.text = strTitle
                cellToReturn.lblDesc.text = strDesc
                
                let strBlogUrl = "\(objHomeResposne?.data?.season?[indexPath.row].thumbnail ?? "")"
                cellToReturn.imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
                
                
            }
            
            else if strCurrSectionNm == "E.Videos"
            {
                
                
                let strTitle = "\(objHomeResposne?.data?.empowermentVideo?[indexPath.row].title ?? "")"
                let strDesc = "\(objHomeResposne?.data?.empowermentVideo?[indexPath.row].description ?? "")"
                cellToReturn.lblTitle.text = strTitle
                cellToReturn.lblDesc.text = strDesc
                
                let strBlogUrl = "\(objHomeResposne?.data?.empowermentVideo?[indexPath.row].thumbnail ?? "")"
                cellToReturn.imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
                
            }
            else if strCurrSectionNm == "Recommended Episodes"
            {
                
                
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
            let itemsPerRow: CGFloat = 3
            let padding: CGFloat = 5
            let totalPadding = padding * (itemsPerRow + 1)
            let itemWidth = (objCollectionMeetSister.frame.width - totalPadding) / itemsPerRow
            return CGSize(width: itemWidth, height: 230.0)
            
        }
        else if collectionView == objCollection1TBS
        {
            width = (UIScreen.main.bounds.width - 48.0)
            return CGSize(width: width, height: 80.0)
            
        }
        else
        {
            width = (UIScreen.main.bounds.width - 250.0)
            height = 225.0
        }
        
        return CGSize(width: width, height: height)
    }
    
    @objc func btnWatchNowTapped(sender: UIButton){
        NotificationCenter.default.post(name: Notification.Name("btnWatchNowTapped"), object: nil, userInfo: nil)
        
    }
}


