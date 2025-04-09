//
//  ApperanceVC.swift
//  TSS
//
//  Created by khushbu bhavsar on 03/12/24.
//

import UIKit

class ApperanceVC: UIViewController {
    let arrTheme: [String] = ["System Default", "Light", "Dark"]
    var selectedIndex: Int = 0
    var tempSelectedIndex: Int = 0
    @IBOutlet weak var tblApperance: UITableView!
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserSelectTheme()

        self.registerNib()
    }
    
    func getUserSelectTheme()
    {
        let strIdx : String = AppUserDefaults.object(forKey: "USERTHEME") as? String ?? "0"
        selectedIndex = Int(strIdx) ?? 0
        tempSelectedIndex = selectedIndex
    }
    func setAppearance(style: UIUserInterfaceStyle) {
            guard let window = UIApplication.shared.windows.first else {
                return
            }
            window.overrideUserInterfaceStyle = style
        }
    func registerNib()
    {
        GenericFunction.registerNibs(for: ["ReportTBC"], withNibNames: ["ReportTBC"], tbl: tblApperance)
        tblApperance.delegate = self
        tblApperance.dataSource = self
        tblApperance.reloadData()
    }
}
//MARK: UITableViewDelegate, UITableViewDataSource
extension ApperanceVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTheme.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTBC", for: indexPath) as! ReportTBC
        cell.selectionStyle = .none
     
        cell.imgRadioBtn.image = selectedIndex == indexPath.row ? imageSelected : imageUnselected
        
        if selectedIndex == indexPath.row
        {
            cell.lblReportReason.text = "\(arrTheme[selectedIndex])"
        }
        else
        {
            cell.lblReportReason.text = "\(arrTheme[indexPath.row])"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tblApperance.reloadData()

        UserDefaultUtility.saveValueToUserDefaults(value: "\(selectedIndex)", forKey: "USERTHEME")

        switch selectedIndex {
        case 0:
            setAppearance(style: .unspecified)
            break
        case 1:
            setAppearance(style: .light)
            break
        case 2:
            setAppearance(style: .dark)
            break
        default:
            setAppearance(style: .unspecified)
            break
        }
    }
}
