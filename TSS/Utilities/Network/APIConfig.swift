//
//  APIConfig.swift
//  Uveaa Solar
//
//  Created by apple on 07/02/24.
//

import Foundation


struct APIConfig {
    
    
    static var baseURL: String {
        switch currentEnvironment {
        case .production:
            
            guard let productionURL = Bundle.main.infoDictionary?["ProductionURL"] as? String else {
                fatalError("Production URL not found in Info.plist")
            }
            return productionURL
            
        case .beta:
            
            guard let developmentURL = Bundle.main.infoDictionary?["DevelopmentURL"] as? String else {
                fatalError("Development URL not found in Info.plist")
            }
            return developmentURL
        }
    }
}

