//
//  AppFonts.swift
//  Uveaa Solar
//
//  Created by apple on 12/01/24.
//

import Foundation

import Foundation
import UIKit

enum AppFontName: String {
    case Poppins_Regular      = "Poppins-Regular"
    case Poppins_Italic    = "Poppins-Italic"
    case Poppins_Thin   = "Poppins-Thin"
    case Poppins_ThinItalic    = "Poppins-ThinItalic"
    case Poppins_ExtraLightItalic  = "Poppins-ExtraLightItalic"
    
    case Poppins_Light  = "Poppins-Light"
    case Poppins_LightItalic  = "Poppins-LightItalic"
    case Poppins_Medium  = "Poppins-Medium"
    case Poppins_MediumItalic  = "Poppins-MediumItalic"
    case Poppins_SemiBold  = "Poppins-SemiBold"
    case Poppins_SemiBoldItalic  = "Poppins-SemiBoldItalic"
    case Poppins_Bold  = "Poppins-Bold"
    case Poppins_BoldItalic  = "Poppins-BoldItalic"
    case Poppins_ExtraBold  = "Poppins-ExtraBold"
    case Poppins_ExtraBoldItalic  = "Poppins-ExtraBoldItalic"
    case Poppins_Black  = "Poppins-Black"
    case Poppins_BlackItalic  = "Poppins-BlackItalic"

}

func setFont(strFontName:String,fontSize:CGFloat) -> UIFont {
    return UIFont(name: strFontName, size: fontSize)!
}


