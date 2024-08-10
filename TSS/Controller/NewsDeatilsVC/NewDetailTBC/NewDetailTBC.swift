//
//  NewDetailTBC.swift
//  TSS
//
//  Created by apple on 06/07/24.
//

import UIKit

protocol NewDetailTBCDelegate: AnyObject {
    func cell(_ cell: NewDetailTBC, faceBookUrl: String, sender: Any)
    func cell(_ cell: NewDetailTBC, instagramUrl: String)
    func cell(_ cell: NewDetailTBC, tikTokUrl: String)
    func cell(_ cell: NewDetailTBC, nextPostId: String)
    func cell(_ cell: NewDetailTBC, previousPostId: String)


   //func cell(_ cell: InverterTBC, isViewZoomClicked: Bool)
}
class NewDetailTBC: UITableViewCell {
    var delegate: NewDetailTBCDelegate?
   // var index: Int = 0
    var objBlogDetailsResponse: blogDetailsResponse?

    
   
    @IBOutlet weak var objCollectionRelatedBlog: UICollectionView!
    @IBOutlet weak var btnNextPostOutlt: UIButton!
    @IBOutlet weak var btnPreviousPostOutlt: UIButton!
    @IBOutlet weak var btnTiktokOutlt: UIButton!
    @IBOutlet weak var btnInstOutlt: UIButton!
    @IBOutlet weak var btnFaceBookOutlt: UIButton!
    @IBOutlet weak var objCollectionTags: UICollectionView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBlogCategory: UILabel!
    @IBOutlet weak var imgBlog: UIImageView!
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
        self.objCollectionRelatedBlog.register(UINib.init(nibName: "HomeCollectionCell", bundle: .main), forCellWithReuseIdentifier: "HomeCollectionCell")
        
        self.objCollectionTags.register(UINib.init(nibName: "NewsCTC", bundle: .main), forCellWithReuseIdentifier: "NewsCTC")
    }
    func configure(withResponse response: blogDetailsResponse?, withIndex index: Int) {
        objBlogDetailsResponse = response
        
        lblTitle.text = "\(response?.data?.title ?? "")"
        lblBlogCategory.text = strSelectedBlog.htmlToString()
//        let htmlString = "\(response?.data?.description ?? "")"
//        lblDesc.text = htmlString.htmlToString()

        let strDesc = "\(response?.data?.description ?? "")"
        lblDesc.text = strDesc.htmlToString()
       
        
        let strBlogUrl = "\(response?.data?.thumbnail ?? "")"
        imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
        
        self.objCollectionRelatedBlog.dataSource = self
        self.objCollectionRelatedBlog.delegate = self
        self.objCollectionRelatedBlog.reloadData()
        
        self.objCollectionTags.dataSource = self
        self.objCollectionTags.delegate = self
        self.objCollectionTags.reloadData()
        
    }
    @IBAction func btnTikTokTapped(_ sender: UIButton) {
        let tiktokUrl: String = "\(objBlogDetailsResponse?.data?.linkedin_url ?? "")"
        delegate?.cell(self, tikTokUrl: tiktokUrl)
    }
    @IBAction func btnInstaTapped(_ sender: UIButton) {
        let instaURL: String = "\(objBlogDetailsResponse?.data?.twitter_url ?? "")"
        delegate?.cell(self, instagramUrl: instaURL)
    }
    
    @IBAction func btnFacebookTapped(_ sender: UIButton) {
        let faceBookURL: String = "\(objBlogDetailsResponse?.data?.facebookURL ?? "")"
        delegate?.cell(self, faceBookUrl: faceBookURL, sender: sender)
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        let nextPostId: String = "\(objBlogDetailsResponse?.data?.nextPostID ?? "")"
        delegate?.cell(self, nextPostId: nextPostId)
    }
    @IBAction func btnPreviousTapped(_ sender: Any) {
        let previousPostId: String = "\(objBlogDetailsResponse?.data?.previusPostID ?? "")"
        delegate?.cell(self, previousPostId: previousPostId)
    }
    
    
}
//MARK: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout Methods
extension NewDetailTBC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var noOfItems: Int = 0
        if collectionView == objCollectionTags {
            noOfItems = objBlogDetailsResponse?.data?.tag?.count ?? 0
        }
        else
        {
            noOfItems = objBlogDetailsResponse?.data?.relatedBlogs?.count ?? 0
           // noOfItems = 5

        }
        return noOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == objCollectionTags
        {
            let cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCTC",for: indexPath) as! NewsCTC

            cellToReturn.lblCategory.text = "\(objBlogDetailsResponse?.data?.tag?[indexPath.item] ?? "")"
            
            cellToReturn.vwMain.backgroundColor = UIColor(named: "ThemeTextfiledFillColor")
            cellToReturn.vwMain.borderColor = .clear
            cellToReturn.vwMain.borderWidth = 0
            cellToReturn.vwMain.cornerRadius = 3
            
            
            cell = cellToReturn
        }
        else
        {
            let cellToReturn = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell",for: indexPath) as! HomeCollectionCell

            
            let strTitle = "\(objBlogDetailsResponse?.data?.relatedBlogs?[indexPath.item].title ?? "")"
            cellToReturn.lblTitle.text  = strTitle.htmlToString()
            let strDesc = "\(objBlogDetailsResponse?.data?.relatedBlogs?[indexPath.item].description ?? "")"
            cellToReturn.lblDesc.text = strDesc.htmlToString()

         //   cellToReturn.lblTitle.text = "\(objBlogDetailsResponse?.data?.relatedBlogs?[indexPath.item].title ?? "")"
            cellToReturn.imgBlog.contentMode = .scaleAspectFit
            let strBlogUrl = "\(objBlogDetailsResponse?.data?.relatedBlogs?[indexPath.item].thumbnail ?? "")"
            cellToReturn.imgBlog.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
            
           
            
            cell = cellToReturn
        }
       return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width
        var height = 225.0
        if collectionView == objCollectionTags
        {
           // let text = "\(objBlogCategoryResponse?.data?[indexPath.item].categoryName ?? "")"
            let text = "\(objBlogDetailsResponse?.data?.tag?[indexPath.item] ?? "")"
            let size = text.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: AppFontName.Poppins_Medium.rawValue, size: 14)!])
            width = size.width + 30
            height = 40
        }
        else
        {
            width = (UIScreen.main.bounds.width - 250.0)
            height = 225.0
        }
       
        return CGSize(width: width, height: height)
    }
}
