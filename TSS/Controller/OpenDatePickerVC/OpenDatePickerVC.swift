//
//  OpenDatePickerVC.swift
//  Uveaa Solar
//
//  Created by apple on 19/02/24.
//

import UIKit
protocol dataPassProtocol
{
    func dataPassing(strSelectDate: String, strStatus: String)
    func doneButtonTapped(isDonebtnPress: Bool, strDate: String)
}

class OpenDatePickerVC: UIViewController {
    var whichBtnPress: String = ""
    var selectDate: Date = Date()
    
    @IBOutlet weak var objDatePicker: UIDatePicker!
    var delegate: dataPassProtocol!
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        let strDate = DateFormatter.convertDateToStringForserver(inputDate: selectDate) ?? ""


        delegate?.doneButtonTapped(isDonebtnPress: true, strDate: strDate)
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        objDatePicker.maximumDate = Date()
        self.view.backgroundColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        objDatePicker.addTarget(self, action: #selector(handleTimePickerChange), for: .valueChanged)
    }
    
    @objc func handleTimePickerChange() {
        
       // print("Selected Time: \(objDatePicker.date)")
         let strSelectedDate = DateFormatter.convertDateToStringForserver(inputDate: objDatePicker.date) ?? ""
        selectDate = objDatePicker.date
        delegate.dataPassing(strSelectDate: strSelectedDate, strStatus: whichBtnPress)

    }
}
