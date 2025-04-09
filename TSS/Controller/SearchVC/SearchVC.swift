//
//  SearchVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit
import KVSpinnerView

class SearchVC: UIViewController {
    
    //  - Variables - 
    var userId: String = ""
    private let objSearchViewModel = SearchViewModel()
    var objsearchResponse: searchResponse?
    var serachText: String = ""
    
    //  - Outlets - 
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
    
}
//MARK: UIViewLife Cycle Methods
extension SearchVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.getUserId()
        self.registerNib()
        self.setUpNoDataFound()
    }
}
//MARK: General Methods
extension SearchVC
{
    func setUpNoDataFound()
    {
        lblNoData.isHidden = false
        tblSearch.isHidden = true
    }
    func getUserId()
    {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
    }
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
        
    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["SearchTBC"], withNibNames: ["SearchTBC"], tbl: tblSearch)
        tblSearch.estimatedRowHeight = UITableView.automaticDimension
        tblSearch.rowHeight = 275.0
        
    }
}
//MARK: IBAction
extension SearchVC
{
    @IBAction func btnSettingTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "SettingVC", from: navigationController!, animated: true)
        
    }
    @IBAction func btnNotificationTapped(_ sender: Any) {
        NavigationHelper.push(storyboardKey.InnerScreen, viewControllerIdentifier: "NotificationVC", from: navigationController!, animated: true)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
}
extension SearchVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        serachText = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        txtSearch.text = currentText
        
        // Cancel any previous perform requests to debounce the API call
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil)
        
        if updatedText.count > 3 {
            // Debounce the search to wait for 0.5 seconds after the user stops typing
            self.perform(#selector(performSearch), with: serachText, afterDelay: 0.5)
        } else {
            self.clearSearchResults()
        }

        return true
    }

    @objc func performSearch() {
     //   if let searchText = serachText, !searchText.isEmpty {
            self.apiCallSearchList(searchText: serachText)
       // }
    }

    func clearSearchResults() {
        // Implement your logic to clear the search results
        self.objsearchResponse?.data = []
       // txtSearch.text = ""
        self.tblSearch.reloadData()
    }

    
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let textRange = Range(range, in: currentText)!
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        // self.apiCallSearchList(searchText: updatedText)
        serachText = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
        //self.apiCallSearchList(searchText: serachText)
        /*
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil)
        self.perform(#selector(performSearch), with: serachText, afterDelay: 0.5)
        */
        
        txtSearch.text = updatedText
        if updatedText.count > 3 {
            self.apiCallSearchList(searchText: updatedText)
            
        } else {
            self.clearSearchResults()
        }
       
        
        return true
    }
    @objc func performSearch() {
        self.apiCallSearchList(searchText: serachText)
    }
    
    func clearSearchResults() {
        // Implement your logic to clear or reset search results
        self.objsearchResponse?.data = []
        self.tblSearch.reloadData()
        // You can also display a message or a default state if needed
    }
    */
}
extension SearchVC
{
    func setUpUIAfterGettingResponse(response: searchResponse?)
    {
        if response?.data?.count ?? 0 > 0
        {
            lblNoData.isHidden = true
            tblSearch.isHidden = false
            objsearchResponse = response
            
            tblSearch.delegate = self
            tblSearch.dataSource = self
            tblSearch.reloadData()
        }
        else
        {
            lblNoData.isHidden = false
            tblSearch.isHidden = true
        }
    }
    func apiCallSearchList(searchText: String)
    {
        txtSearch.resignFirstResponder()
        if Reachability.isConnectedToNetwork()
        {
            KVSpinnerView.show()
            objSearchViewModel.getSearchList(userId: userId, searchText: searchText) { result in
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
//MARK: UITableViewDelegate, UITableViewDataSource
extension SearchVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objsearchResponse?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTBC", for: indexPath) as! SearchTBC
        cell.selectionStyle = .none
        // Extract the title and content
        let strTitle = "\(objsearchResponse?.data?[indexPath.row].title ?? "")"
        let strDesc = "\(objsearchResponse?.data?[indexPath.row].content ?? "")"
        
        // Set the title immediately
//        cell.lblTitle.text = strTitle.htmlToString()
        cell.lblTitle.text = strTitle.decodingHTMLEntities()

        
        let strBlogUrl = "\(objsearchResponse?.data?[indexPath.row].thumbnail ?? "")"
        cell.imgSrach.sd_setImage(with: URL(string: strBlogUrl), placeholderImage: UIImage(named: "icn_Placehoder"), options: [.progressiveLoad], context: nil)

        
        // Convert the description in the background
        DispatchQueue.global(qos: .userInitiated).async {
//            let convertedDesc = strDesc.htmlToString()
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
        let postType = "\(objsearchResponse?.data?[indexPath.row].post_type ?? "")"
        let id = "\(objsearchResponse?.data?[indexPath.row].id ?? "")"
        
        
        if postType == "\(blogCategories.News)"
        {
            NavigationHelper.pushWithPassData(storyboardKey.InnerScreen, viewControllerIdentifier: "NewsDeatilsVC", from: navigationController!, data: id)
        }
        else
        {
            strSelectedPostName = "\(objsearchResponse?.data?[indexPath.row].post_type ?? "")"
            NavigationHelper.pushWithPassData(storyboardKey.InnerScreen, viewControllerIdentifier: "VideoDetailsVC", from: navigationController!, data: "\(id)")
        }
    }
}
