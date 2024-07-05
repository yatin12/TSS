//
//  EVideoVC.swift
//  TSS
//
//  Created by apple on 29/06/24.
//

import UIKit

class EVideoVC: UIViewController {
    private let arrCategory = ["Short", "A bit longer", "This is a longer label", "An even longer label than the previous one"]
    var selectedIndex: Int = 0
    
    @IBOutlet weak var tblEvideo: UITableView!
    
    @IBOutlet weak var imgLogo: UIImageView!
   
    @IBOutlet weak var objCollectionViewCategory: UICollectionView!
    
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var constHeightHeader: NSLayoutConstraint!
}
//MARK: UIViewLifeCycle Methods
extension EVideoVC
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBackButtonView()
        self.setUpHeaderView()
        self.registerNib()
        self.setupCollectionview()
    }
}
//MARK: General Methods
extension EVideoVC
{
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
        GenericFunction.registerNibs(for: ["TalkShowTBC"], withNibNames: ["TalkShowTBC"], tbl: tblEvideo)
//        tblNotification.estimatedRowHeight = UITableView.automaticDimension
//        tblNotification.rowHeight = 90.0
        tblEvideo.delegate = self
        tblEvideo.dataSource = self
        tblEvideo.reloadData()
    }
    func setupCollectionview()
    {
        self.objCollectionViewCategory.register(UINib.init(nibName: "NewsCTC", bundle: .main), forCellWithReuseIdentifier: "NewsCTC")
        self.objCollectionViewCategory.dataSource = self
        self.objCollectionViewCategory.delegate = self
        
        self.objCollectionViewCategory.reloadData()
    }
}
//MARK: IBAction
extension EVideoVC
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
extension EVideoVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TalkShowTBC", for: indexPath) as! TalkShowTBC
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
//MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension EVideoVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCTC",for: indexPath) as! NewsCTC
        cell.lblCategory.text = "\(arrCategory[indexPath.item])"

        if indexPath.item == selectedIndex
        {
            cell.vwMain.backgroundColor = UIColor(named: "ThemePinkColor")
            cell.vwMain.borderColor = .clear
            cell.vwMain.borderWidth = 0
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
            let text = arrCategory[indexPath.item]
            let size = text.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: AppFontName.Poppins_Medium.rawValue, size: 14)!])
            return CGSize(width: size.width + 30, height: 40) // 16 is for padding
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        objCollectionViewCategory.reloadData()
    }
//    func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
}
