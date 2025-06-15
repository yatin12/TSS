
import Foundation

struct paypalTokenRequest: Encodable {
    let userId: String
}

@MainActor
class GetPaypalTokenViewModel: ObservableObject {
    @Published var objGetPaypalTokenResponse: GetPaypalTokenResponse?
    var errorMessage: String?
  //  var isLoading = false
    var showAlert = false

    func getPaypalToken(userId: String) async -> GetPaypalTokenResponse? {
      
      //  isLoading = true

        let submitData = paypalTokenRequest(
            userId: userId
        )
        
        guard let parameters = submitData.parseHandler() else {
            self.errorMessage = "Failed to encode login data"
            self.showAlert = true
          //  self.isLoading = false
            return nil
        }

        do {
            let response: GetPaypalTokenResponse = try await APIHandler.shared.request(
                url: "\(APIConfig.baseURL + paypalTokenEndpoint)",
                method: .post,
                parameters: parameters
            )

          //  self.isLoading = false
            self.objGetPaypalTokenResponse = response
            self.showAlert = false

            print("Decoded MirrorModel: \(response)")

            return response
        } catch let error as APIErrorSwiftUI {
           // self.isLoading = false
            self.errorMessage = error.localizedDescription
            self.showAlert = true
            return nil
        } catch {
          //  self.isLoading = false
            self.errorMessage = "An unknown error occurred"
            self.showAlert = true
            return nil
        }
    }
}
