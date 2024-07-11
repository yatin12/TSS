//
//  CountryListVC.swift
//  TSS
//
//  Created by apple on 09/07/24.
//

import UIKit
import KVSpinnerView
protocol countryDataPassProtocol
{
    func countryNamePass(strSelectCountry: String)
}
class CountryListVC: UIViewController {
    //  - Variables - 
    private let objCountryListViewModel = countryListViewModel()
    var objCountryList: [String: String] = [:]
    var delegate: countryDataPassProtocol!
    var selectedIndex: IndexPath?
    
    //  - Outlets - 
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblCountry: UITableView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
   
}
extension CountryListVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.registerNib()
        self.apiCallGetCountryList()
    }
}
extension CountryListVC
{
    func setUpHeaderView()
    {
        DeviceUtility.setHeaderViewHeight(constHeightHeader)
    }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["CountryTBC"], withNibNames: ["CountryTBC"], tbl: tblCountry)
    }
}
//MARK: IBAction
extension CountryListVC
{
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension CountryListVC
{
    func apiCallGetCountryList()
    {
        KVSpinnerView.show()
        if Reachability.isConnectedToNetwork()
        {
            objCountryListViewModel.getCountryList { result in
                KVSpinnerView.dismiss()
                switch result {
                case .success(let loginResponse):
                    // Handle successful
                    print(loginResponse)
                    let countryList = loginResponse.countrylist
                       self.objCountryList = countryList
                    print(self.objCountryList)
                    self.tblCountry.delegate = self
                    self.tblCountry.dataSource = self
                    self.tblCountry.reloadData()
                  break
                    
                case .failure(let error):
                    // Handle failure
                    
                    if let apiError = error as? APIError {
                        ErrorHandlingUtility.handleAPIError(apiError, in: self)
                    } else {
                        // Handle other types of errors
                       // print("Unexpected error: \(error)")
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
//MARK: UITableViewDataSource
extension CountryListVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTBC", for: indexPath) as! CountryTBC
        cell.selectionStyle = .none
        
        let countryCodes = Array(objCountryList.keys)
        let countryCode = countryCodes[indexPath.row]
        let countryName = objCountryList[countryCode]
        
        if indexPath == selectedIndex
        {
            cell.imgTick.isHidden = false
        }
        else
        {
            cell.imgTick.isHidden = true
        }
        cell.lblCountryName.text = countryName
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath
        tblCountry.reloadData()
        
        let countryCodes = Array(objCountryList.keys)
        let countryCode = countryCodes[indexPath.row]
        let countryName = objCountryList[countryCode]
        
        delegate?.countryNamePass(strSelectCountry: countryName ?? "")
        self.navigationController?.popViewController(animated: true)

    }
}
//MARK: UITextFieldDelegate
extension CountryListVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            let textRange = Range(range, in: currentText)!
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            
            // Filter the itemsDocument based on the updated text
            if updatedText.isEmpty {
                objCountryList.removeAll()
                apiCallGetCountryList()
                
            } else {
                //isSearchText = true
                objCountryList = objCountryList.filter { $0.value.localizedCaseInsensitiveContains(updatedText) }

            }
          
            tblCountry.reloadData()
            
            return true
        }
}
