
import Foundation
struct packageRequest: Encodable {
    let userId: String
    let package_type: String
    let pagination_number: String
}

@MainActor
class PackageViewModel: ObservableObject {
    @Published var objPackageModelResponse: PackageModelResponse?
    var errorMessage: String?
    var isLoading = false
    var showAlert = false
    
  
    func fetchPackageDetails(userId: String, package_type: String, pagination_number: String) async -> Bool {
      
        isLoading = true

        let packageData = packageRequest(userId: userId, package_type: package_type, pagination_number: pagination_number)
        
        // Convert the struct to a dictionary
        guard let parameters = packageData.parseHandler() else {
            self.errorMessage = "Failed to encode login data"
            self.showAlert = true
            self.isLoading = false
            return false
        }
        do {
            let response: PackageModelResponse = try await APIHandler.shared.request(url: "\(APIConfig.baseURL + packageEndpoint)", method: .post, parameters: parameters)
            
            DispatchQueue.main.async {
                self.isLoading = false
              
                print("Login successful: \(response)")
                
                
                DispatchQueue.main.async {
                    self.objPackageModelResponse = response
                    self.objectWillChange.send() // Force view update
                }
                
                print("Decoded MirrorModel: \(response)")

                self.showAlert = false
            }
            
            return true
        } catch let error as APIErrorSwiftUI {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showAlert = true
            }
            return false
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "An unknown error occurred"
                self.showAlert = true
            }
            return false
        }
    }

}

