//
//  ValidationFile.swift
//  Uveaa Solar
//
//  Created by apple on 02/02/24.
//

import Foundation
import UIKit

struct ValidationConstants {
    static let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    static let barcodeRegex = "^\\d{2}[A-Z]{3}\\d{3}[A-Z]\\d{15}$"
    static let minPasswordLength = 8

    static func isNotEmptyPostcode(_ postCode: String) -> Bool {
        return !postCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    static func isNotEmptyState(_ state: String) -> Bool {
        return !state.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    static func isNotEmptySubrub(_ subrub: String) -> Bool {
        return !subrub.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    static func isNotEmptyStreetName(_ streetName: String) -> Bool {
        return !streetName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    static func isNotEmptyStreetNO(_ streetNo: String) -> Bool {
        return !streetNo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    static func isNotEmptyAddress(_ address: String) -> Bool {
        return !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    static func isNotEmptyName(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    static func isNotEmptyPhoneNo(_ phoneNo: String) -> Bool {
        return !phoneNo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    static func isNotEmptyEmail(_ email: String) -> Bool {
        return !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    static func isNotEmptyPassword(_ password: String) -> Bool {
        return !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    static func isNotEmptyTextfiled(_ textfield: String) -> Bool {
        return !textfield.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= minPasswordLength
    }
    static func arePasswordsMatching(newPassword: String?, confirmPassword: String?) -> Bool {
        return newPassword == confirmPassword
    }
    static func isImageValid(_ image: UIImage?) -> Bool {
        return image != nil
    }
    static func isBlankImage(image: UIImage) -> Bool {
        if let data = image.jpeg(.lowest) {
            return data.isEmpty || image.size.width == 0 || image.size.height == 0

        }
        return true
    }
}



