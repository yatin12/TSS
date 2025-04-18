//
//  TalkShowVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import KVSpinnerView
import WebKit
import GoogleMobileAds

class TalkShowVC: UIViewController {
    //  - Variables - 
    var objBlogCategoryResponse: blogCategoryResponse?
    var objTalkShowListResponse: talkShowListResponse?
    
    @IBOutlet weak var objWebViewSeason1BTS: WKWebView!
    private let objblogCategoryViewModel = blogCategoryViewModel()
    private let objTalkShowViewModel = talkShowViewModel()
    
    @IBOutlet weak var bannerView: GADBannerView!
    var userId: String = ""
    var userRole: String = ""
    var selectedIndex: Int = 0
    var categoryId: String = ""
    var videoId: String = "11480"
    var isSubscribedUser: String = ""
    var pageNo: Int = 1
    var isLoadingList : Bool = false
    var isValFromUserClick:Bool = false
    
    let inputFormatter = DateFormatter()
    let outputFormatter = DateFormatter()
    
    
    @IBOutlet weak var constHeightBannervw: NSLayoutConstraint!
    //  - Outlets - 
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var objCollectionViewCategory: UICollectionView!
    @IBOutlet weak var tblTalkShow: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLifeCycle Methods
extension TalkShowVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserId()

        self.loadBannerView()
        self.setUpBackButtonView()
        self.setUpHeaderView()
        
        self.registerNib()
        self.setupCollectionview()
        self.setNotificationObserverMethod()
        // self.checkSubscribeUserOrnot()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isSubscribedUser = AppUserDefaults.object(forKey: "SubscribedUserType") as? String ?? "\(SubscibeUserType.free)"
        if isSubscribedUser == "\(SubscibeUserType.premium)" || isSubscribedUser == "\(SubscibeUserType.basic)"
        {
            objWebViewSeason1BTS.isHidden = false
            tblTalkShow.isHidden = true
            lblNoData.isHidden = true
            
            // self.loadSeason1BTSURL(strURL: season1BTSUrl)
            
        }
        else
        {
            selectedIndex = 0
            pageNo = 1
            tblTalkShow.isHidden = false
            lblNoData.isHidden = true
            objWebViewSeason1BTS.isHidden = true
        }
        self.checkSubscribeUserOrnot()
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

//MARK: General Methods
extension TalkShowVC
{
    func loadBannerView()
    {
        if userRole == USERROLE.SignInUser
        {
            let isSubscribedUser = AppUserDefaults.object(forKey: "SubscribedUserType") as? String ?? "\(SubscibeUserType.free)"
            if isSubscribedUser == "\(SubscibeUserType.premium)" || isSubscribedUser == "\(SubscibeUserType.basic)"
            {
                constHeightBannervw.constant = 0
            }
            else
            {
             constHeightBannervw.constant = 50
                if currentEnvironment == .production
                {
                    bannerView.adUnitID = LiveAdmobId

                }
                else
                {
                    bannerView.adUnitID = testAdmobId

                }
                // bannerView.rootViewController = self
                bannerView.delegate = self
                 bannerView.load(GADRequest())
            }
        }
        else
        {
            constHeightBannervw.constant = 50
        }
    }
    func checkSubscribeUserOrnot()
    {
        self.apiCallGetBlogCategoryList()
    }
    func setNotificationObserverMethod()
    {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apicallTalkShowTab(notification:)), name: Notification.Name("APICall_TalkShow"), object: nil)
    }
    @objc func apicallTalkShowTab(notification: Notification)
    {
        self.checkSubscribeUserOrnot()
    }
    func getUserId()
    {
        inputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.dateFormat = "MMMM dd, yyyy"
        
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
        userRole = AppUserDefaults.object(forKey: "USERROLE") as? String ?? ""
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
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["TalkShowTBC"], withNibNames: ["TalkShowTBC"], tbl: tblTalkShow)
        tblTalkShow.isHidden = false
        lblNoData.isHidden = true
        objWebViewSeason1BTS.isHidden = true
        
        
        tblTalkShow.delegate = self
        tblTalkShow.dataSource = self
        tblTalkShow.reloadData()
    }
    func setupCollectionview()
    {
        self.objCollectionViewCategory.register(UINib.init(nibName: "NewsCTC", bundle: .main), forCellWithReuseIdentifier: "NewsCTC")
        self.objCollectionViewCategory.dataSource = self
        self.objCollectionViewCategory.delegate = self
        
        self.objCollectionViewCategory.reloadData()
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
        
    }
}
//MARK: IBAction
extension TalkShowVC
{
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        if userRole == USERROLE.SignInUser
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
        }
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        if userRole == USERROLE.SignInUser
        {
            NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
        }
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension TalkShowVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objTalkShowListResponse?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TalkShowTBC", for: indexPath) as! TalkShowTBC
        cell.selectionStyle = .none
        
        let strBlogUrl = "\(objTalkShowListResponse?.data?[indexPath.row].thumbnail ?? "")"
        cell.imgVideo.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
       // cell.lblTitle.text = "\(objTalkShowListResponse?.data?[indexPath.row].title ?? "")"
        
        cell.lblTitle.text = (objTalkShowListResponse?.data?[indexPath.row].title ?? "").decodingHTMLEntities()

        
        let dateString = "\(objTalkShowListResponse?.data?[indexPath.row].date ?? "")"
        
        if let date = inputFormatter.date(from: dateString) {
            // Create another DateFormatter to format the Date object
            
            
            // Convert the Date object to the formatted string
            let formattedDate = outputFormatter.string(from: date)
            print(formattedDate) // Output: November 26, 2024
            cell.lblDate.text  = formattedDate
        } else {
            print("Invalid date string")
            cell.lblDate.text = "-"
        }
        
        let strDuration = "\(objTalkShowListResponse?.data?[indexPath.row].duration ?? "")"
        cell.lblDuration.text = strDuration == "" ? "0 min" : "\(strDuration) min"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        strSelectedPostName = "talk_shows"
        if userRole == USERROLE.SignInUser
        {
            let videoId = "\(objTalkShowListResponse?.data?[indexPath.row].id ?? "0")"
            NavigationHelper.pushWithPassData(storyboardKey.InnerScreen, viewControllerIdentifier: "VideoDetailsVC", from: navigationController!, data: "\(videoId)")
        }
        else
        {
            AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
        }
    }
}
//MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension TalkShowVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objBlogCategoryResponse?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCTC",for: indexPath) as! NewsCTC
        
        let htmlString = "\(objBlogCategoryResponse?.data?[indexPath.item].categoryName ?? "")"
//        cell.lblCategory.text = htmlString.htmlToString()
        cell.lblCategory.text = htmlString.decodingHTMLEntities()

        
        if indexPath.item == selectedIndex
        {
            
            cell.vwMain.backgroundColor = UIColor(named: "ThemePinkColor")
            cell.vwMain.borderColor = .clear
            cell.vwMain.borderWidth = 0
            cell.lblCategory.textColor = UIColor(named: "SystemWhite_Tag")
            
            if indexPath.row == 0
            {
                categoryId = "\(objBlogCategoryResponse?.data?[0].categoryID ?? 0)"
                strSelectedBlog = "\(objBlogCategoryResponse?.data?[0].categoryName ?? "")"
                
//                if strSelectedBlog == "Season1BTS" || categoryId == "291152"
                if categoryId == "291152"
                {
                    KVSpinnerView.dismiss()
                    
                    
                    objWebViewSeason1BTS.isHidden = false
                    tblTalkShow.isHidden = true
                    lblNoData.isHidden = true
                    let season1BTSUrl: String = "\(objBlogCategoryResponse?.data?[indexPath.item].url ?? "")"
                    
                    isSubscribedUser = AppUserDefaults.object(forKey: "SubscribedUserType") as? String ?? "\(SubscibeUserType.free)"
                    if isSubscribedUser == "\(SubscibeUserType.premium)" || isSubscribedUser == "\(SubscibeUserType.basic)"
                        
                    {
                        self.loadSeason1BTSURL(strURL: season1BTSUrl)
                        
                    }
                    else
                    {
                        AlertUtility.presentAlert(in: self, title: "", message: "\(AlertMessages.subscribeForTabMsg)", options: "Ok","Cancel") { option in
                            switch(option) {
                            case 0:
                                NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SubsciberVC", from: self.navigationController!, animated: false)
                                
                                break
                            case 1:
                                break
                                
                            default:
                                break
                            }
                        }
                    }
                    
                }
                else
                {
                    objCollectionViewCategory.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    self.pageNo = 1
                    self.isLoadingList = false
                    isValFromUserClick = false
                    self.apiCallGetTalkShowList(isFromUserClick: isValFromUserClick)
                }
            }
        }
        else
        {
            cell.vwMain.backgroundColor = .clear
            cell.vwMain.borderColor = UIColor(named: "ThemeFontColorUnselect")
            cell.vwMain.borderWidth = 1
            cell.lblCategory.textColor = UIColor(named: "ThemeFontColorUnselect")
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
//        if strSelectedBlog == "Season1BTS"  || categoryId == "291152"
        if categoryId == "291152"

        {
            objWebViewSeason1BTS.isHidden = false
            tblTalkShow.isHidden = true
            lblNoData.isHidden = true
            let season1BTSUrl: String = "\(objBlogCategoryResponse?.data?[indexPath.item].url ?? "")"
            
            isSubscribedUser = AppUserDefaults.object(forKey: "SubscribedUserType") as? String ?? "\(SubscibeUserType.free)"
            if isSubscribedUser == "\(SubscibeUserType.premium)" || isSubscribedUser == "\(SubscibeUserType.basic)"
                
            {
                self.loadSeason1BTSURL(strURL: season1BTSUrl)
                objCollectionViewCategory.reloadData()
                
            }
            else
            {
               // NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SubsciberVC", from: navigationController!, animated: false)
                if userRole == USERROLE.SignInUser
                {
                    NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SubsciberVC", from: navigationController!, animated: true)
                }
                else
                {
                    AlertUtility.presentSimpleAlert(in: self, title: "", message: AlertMessages.ForceFullyRegister)
                }
            }
        }
        else
        {
            objWebViewSeason1BTS.isHidden = true
            tblTalkShow.isHidden = false
            lblNoData.isHidden = true
            self.pageNo = 1
            self.isLoadingList = false
            isValFromUserClick = true
            self.apiCallGetTalkShowList(isFromUserClick: isValFromUserClick)
            
            objCollectionViewCategory.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            objCollectionViewCategory.reloadData()
        }
       
        
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadData()
        }
    }
    @objc func loadData() {
        pageNo += 1
        self.apiCallGetTalkShowList(isFromUserClick: isValFromUserClick)
    }
    func loadSeason1BTSURL(strURL: String) {
        if let url = URL(string: strURL) {
            let requestObj = URLRequest(url: url)
            objWebViewSeason1BTS.navigationDelegate = self
            objWebViewSeason1BTS.uiDelegate = self
            objWebViewSeason1BTS.load(requestObj)
        } else {
            // Handle the case where the URL string is invalid or nil
            // print("Invalid URL string: \(PrivacyPolicyURL)")
        }
    }
}
//MARK: API Call
extension TalkShowVC
{
    func setUpUIAfterGettingResponse(response: blogCategoryResponse?)
    {
        if response?.data?.count ?? 0 > 0
        {
            self.objBlogCategoryResponse = response
            self.objCollectionViewCategory.dataSource = self
            self.objCollectionViewCategory.delegate = self
            //self.setInitialCollectionRow()
            self.objCollectionViewCategory.reloadData()
            
        }
    }
    func apiCallGetBlogCategoryList()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objblogCategoryViewModel.blogCategoryList(userId: userId, categortType: "\(blogCategories.TalkShow)") { result in
                switch result {
                case .success(let response):
                    print(response)
                    //                    KVSpinnerView.dismiss()
                    if response.settings?.success == true
                    {
                        self.setUpUIAfterGettingResponse(response: response)
                        
                    }
                    else
                    {
                        KVSpinnerView.dismiss()
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
    func apiCallGetTalkShowList(isFromUserClick: Bool)
    {
        if isFromUserClick == true
        {
            KVSpinnerView.show()
        }
        if Reachability.isConnectedToNetwork()
        {
            objTalkShowViewModel.takShowList(userId: userId, category_id: categoryId, pagination_number: "\(pageNo)") { result in
                switch result {
                case .success(let response):
                    print(response)
                    
                    
                    if response.settings?.success == true {
                        let newData = response.data ?? []
                        
                        if newData.count > 0 {
                            // If it's the first page, initialize or reset the data
                            if self.pageNo == 1 {
                                self.objTalkShowListResponse = response
                            } else {
                                // If it's not the first page, append data
                                self.objTalkShowListResponse?.data?.append(contentsOf: newData)
                            }
                            
                            self.isLoadingList = false
                            self.tblTalkShow.isHidden = false
                            self.lblNoData.isHidden = true
                            self.objWebViewSeason1BTS.isHidden = true
                        } else {
                            // Handle case where data is empty for pages other than the first
                            if self.pageNo == 1 {
                                self.objTalkShowListResponse = response
                            }
                            self.tblTalkShow.isHidden = self.pageNo == 1
                            self.lblNoData.isHidden = self.pageNo != 1
                            self.objWebViewSeason1BTS.isHidden = true
                        }
                        KVSpinnerView.dismiss()
                        self.tblTalkShow.dataSource = self
                        self.tblTalkShow.delegate = self
                        self.tblTalkShow.reloadData()
                        
                    } else {
                        KVSpinnerView.dismiss()
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
//MARK: WKUIDelegate
extension TalkShowVC : WKUIDelegate, WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        KVSpinnerView.dismiss()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        KVSpinnerView.show()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        KVSpinnerView.dismiss()
    }
}
//MARK: - GADBannerViewDelegate
extension TalkShowVC: GADBannerViewDelegate
{
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
