//
//  NewsVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import KVSpinnerView

class NewsVC: UIViewController {
    //  - Variables - 
    var userId: String = ""
    var selectedIndex: Int = 0
    var categoryId: String = ""
    var objBlogCategoryResponse: blogCategoryResponse?
    var objBlogByCategoryResponse: blogByCategoryResponse?
    
    private let objblogCategoryViewModel = blogCategoryViewModel()
    private let objblogByCategoryViewModel = blogByCategoryViewModel()
    
    //  - Outlets - 
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var tblNews: UITableView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var objCollectionCategory: UICollectionView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLifeCycle Methods
extension NewsVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()
        self.setUpBackButtonView()
        self.setUpHeaderView()
        self.registerNib()
        self.setupCollectionview()
        self.apiCallGetBlogCategoryList()
        self.setNotificationObserverMethod()
    }
    
}
//MARK: General Methods
extension NewsVC
{
    func setNotificationObserverMethod()
    {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apicallNewsTab(notification:)), name: Notification.Name("APICall_News"), object: nil)
    }
    @objc func apicallNewsTab(notification: Notification)
    {
        self.apiCallGetBlogCategoryList()
    }
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
    }
    func setUpBackButtonView()
    {
        if isFromViewAll == true
        {
            vwBack.isHidden = false
            imgLogo.isHidden = true
        }
        else
        {
            vwBack.isHidden = true
            imgLogo.isHidden = false
        }
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["NewsTBC"], withNibNames: ["NewsTBC"], tbl: tblNews)
        //        tblNotification.estimatedRowHeight = UITableView.automaticDimension
        //        tblNotification.rowHeight = 90.0
        
    }
    func setupCollectionview()
    {
        self.objCollectionCategory.register(UINib.init(nibName: "NewsCTC", bundle: .main), forCellWithReuseIdentifier: "NewsCTC")
        
    }
}
//MARK: IBAction
extension NewsVC
{
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
        
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension NewsVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objBlogByCategoryResponse?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTBC", for: indexPath) as! NewsTBC
        cell.configure(withResponse: objBlogByCategoryResponse, withIndex: indexPath.row)
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 470
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postId: String = "\(objBlogByCategoryResponse?.data?[indexPath.row].postID ?? 0)"
        NavigationHelper.pushWithPassData(storyboardKey.InnerScreen, viewControllerIdentifier: "NewsDeatilsVC", from: navigationController!, data: postId)

    }
}
//MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension NewsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objBlogCategoryResponse?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCTC",for: indexPath) as! NewsCTC
        
        let htmlString = "\(objBlogCategoryResponse?.data?[indexPath.item].categoryName ?? "")"
        cell.lblCategory.text = htmlString.htmlToString()
        
        if indexPath.item == selectedIndex
        {
            cell.vwMain.backgroundColor = UIColor(named: "ThemePinkColor")
            cell.vwMain.borderColor = .clear
            cell.vwMain.borderWidth = 0
            if indexPath.item == 0
            {
                categoryId = "\(objBlogCategoryResponse?.data?[0].categoryID ?? 0)"
                strSelectedBlog = "\(objBlogCategoryResponse?.data?[0].categoryName ?? "")"
                objCollectionCategory.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

                self.apiCallGetBlogByCategoryList()
            }
        }
        else
        {
            cell.vwMain.backgroundColor = .clear
            cell.vwMain.borderColor = UIColor.white
            cell.vwMain.borderWidth = 1
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = "\(objBlogCategoryResponse?.data?[indexPath.item].categoryName ?? "")"
        let size = text.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: AppFontName.Poppins_Medium.rawValue, size: 14)!])
        return CGSize(width: size.width + 30, height: 40) // 16 is for padding
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        categoryId = "\(objBlogCategoryResponse?.data?[indexPath.item].categoryID ?? 0)"
        strSelectedBlog = "\(objBlogCategoryResponse?.data?[indexPath.item].categoryName ?? "")"
        self.apiCallGetBlogByCategoryList()
        
        objCollectionCategory.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        objCollectionCategory.reloadData()
    }
    
}
extension NewsVC
{
    func setUpUIAfterGettingResponse(response: blogCategoryResponse?)
    {
        if response?.data?.count ?? 0 > 0
        {
            self.objBlogCategoryResponse = response
            self.objCollectionCategory.dataSource = self
            self.objCollectionCategory.delegate = self
            self.objCollectionCategory.reloadData()
        }
    }
    
    func apiCallGetBlogCategoryList()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objblogCategoryViewModel.blogCategoryList(userId: userId, categortType: "\(blogCategories.News)") { result in
                switch result {
                case .success(let response):
                    print(response)
                    KVSpinnerView.dismiss()
                    if response.settings?.success == true
                    {
                        self.setUpUIAfterGettingResponse(response: response)

                    }
                    else
                    {
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(response.settings?.message ?? "")")

                    }
                    
                case .failure(let error):
                    // Handle failure
                    KVSpinnerView.dismiss()
                    
                    if let apiError = error as? APIError {
                        ErrorHandlingUtility.handleAPIError(apiError, in: self)
                    } else {
                        // Handle other types of errors
                        //print("Unexpected error: \(error)")
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(error.localizedDescription)")
                        
                    }
                }
            }
        }
        else
        {
            KVSpinnerView.dismiss()
             AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.NoInternetAlertMsg)")
        }
    }
    func apiCallGetBlogByCategoryList()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objblogByCategoryViewModel.blogByCategoryList(category_id: categoryId, userId: userId) { result in
                switch result {
                case .success(let response):
                    KVSpinnerView.dismiss()
                    print(response)

                    if response.settings?.success == true
                    {
                        if response.data?.count ?? 0 > 0
                        {
                            self.tblNews.isHidden = false
                            self.lblNoDataFound.isHidden = true
                            
                            self.objBlogByCategoryResponse = response
                            self.tblNews.dataSource = self
                            self.tblNews.delegate = self
                            self.tblNews.reloadData()
                        }
                        else
                        {
                            self.tblNews.isHidden = true
                            self.lblNoDataFound.isHidden = false
                        }
                    }
                    else
                    {
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(response.settings?.message ?? "")")

                    }
                    
                    
                    
                case .failure(let error):
                    // Handle failure
                    KVSpinnerView.dismiss()
                    
                    if let apiError = error as? APIError {
                        ErrorHandlingUtility.handleAPIError(apiError, in: self)
                    } else {
                        // Handle other types of errors
                        //print("Unexpected error: \(error)")
                        AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(error.localizedDescription)")
                        
                    }
                }
            }
        }
        else
        {
            KVSpinnerView.dismiss()
             AlertUtility.presentSimpleAlert(in: self, title: "", message: "\(AlertMessages.NoInternetAlertMsg)")
        }
        
    }
}
