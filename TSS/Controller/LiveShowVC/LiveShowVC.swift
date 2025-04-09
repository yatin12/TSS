//
//  LiveShowVC.swift
//  TSS
//
//  Created by apple on 20/07/24.
//

import UIKit
import KVSpinnerView

class LiveShowVC: UIViewController {
    @IBOutlet weak var tblLiveShow: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
    let objGetLiveShowDetailsViewModel = getLiveShowDetailsViewModel()
    var userId: String = ""
    var strPostId: String = "13094"
    var objLiveShowDetailResponse: liveShowDetailResponse?

}
extension LiveShowVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNodatFound()
        self.setUpHeaderView()
        self.registerNib()
        self.getUserId()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCallGetLiveShowDetails()
    }
}
//MARk: General Methods
extension LiveShowVC
{
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
    }
    func setupNodatFound()
    {
        tblLiveShow.isHidden = false
        lblNoDataFound.isHidden = true
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)

    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["SearchTBC"], withNibNames: ["SearchTBC"], tbl: tblLiveShow)
        tblLiveShow.estimatedRowHeight = UITableView.automaticDimension
        tblLiveShow.rowHeight = 275.0
       
    }
    
}
//MARk: IBAction
extension LiveShowVC
{
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)

    }
    @IBAction func btnSearchTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SearchVC", from: navigationController!, animated: true)

    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)

    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension LiveShowVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTBC", for: indexPath) as! SearchTBC
        cell.selectionStyle = .none
        
        let strTitle = "\(objLiveShowDetailResponse?.data?.title ?? "")"
        let strDesc = "\(objLiveShowDetailResponse?.data?.description ?? "")"
        
        // Set the title immediately
//        cell.lblTitle.text = strTitle.htmlToString()
        cell.lblTitle.text = strTitle.decodingHTMLEntities()

        
        let strBlogUrl = "\(objLiveShowDetailResponse?.data?.thumbnail ?? "")"
        cell.imgSrach.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)
        cell.imgSrach.contentMode = .scaleAspectFill
        
        // Convert the description in the background
        DispatchQueue.global(qos: .userInitiated).async {
           // let convertedDesc = strDesc.htmlToString()
            let convertedDesc = strDesc.decodingHTMLEntities()
            
            // Update the label on the main thread
            DispatchQueue.main.async {
                // Ensure the cell is still visible
                if let updatedCell = tableView.cellForRow(at: indexPath) as? SearchTBC {
                    updatedCell.lblDescription.text = convertedDesc
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension LiveShowVC
{
    func apiCallGetLiveShowDetails()
    {
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objGetLiveShowDetailsViewModel.liveShowDetails(userId: userId, postId: strPostId) { result in
                switch result {
                case .success(let response):
                    print(response)
                    KVSpinnerView.dismiss()
                   
                    if response.settings?.success == true
                    {
                            
                        
                        self.objLiveShowDetailResponse = response
                       
                        self.tblLiveShow.delegate = self
                        self.tblLiveShow.dataSource = self
                        self.tblLiveShow.reloadData()
                        
                       
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
