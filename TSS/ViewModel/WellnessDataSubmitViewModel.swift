
import Foundation

struct wellnessDataSubmitRequest: Encodable {
    let userId: String
    let phone_number: String
    let address: String
    let medical_information: String
    let medical_information_other: String
    let surgery_information: String
    let surgery_information_other: String
    let food_take: String
    let select_package: String
    let emergency_consultation: String
    let mc_package: String
    let IAgree_RelationShip: String
}

@MainActor
class WellnessDataSubmitViewModel: ObservableObject {
    @Published var objWellnessDataSubmitResponse: WellnessDataSubmitResponse?
    var errorMessage: String?
  //  var isLoading = false
    var showAlert = false

    func submitWellnessDetails(userId: String, phone_number: String, address: String, medical_information: String, medical_information_other: String, surgery_information: String, surgery_information_other: String, food_take: String, select_package: String, emergency_consultation: String, mc_package: String, IAgree_RelationShip: String) async -> WellnessDataSubmitResponse? {
      
      //  isLoading = true

        let submitData = wellnessDataSubmitRequest(
            userId: userId,
            phone_number: phone_number,
            address: address,
            medical_information: medical_information,
            medical_information_other: medical_information_other,
            surgery_information: surgery_information,
            surgery_information_other: surgery_information_other,
            food_take: food_take,
            select_package: select_package,
            emergency_consultation: emergency_consultation,
            mc_package: mc_package,
            IAgree_RelationShip: IAgree_RelationShip
        )
        
        guard let parameters = submitData.parseHandler() else {
            self.errorMessage = "Failed to encode login data"
            self.showAlert = true
          //  self.isLoading = false
            return nil
        }

        do {
            let response: WellnessDataSubmitResponse = try await APIHandler.shared.request(
                url: "\(APIConfig.baseURL + wellnessDataSubmitEndpoint)",
                method: .post,
                parameters: parameters
            )

          //  self.isLoading = false
            self.objWellnessDataSubmitResponse = response
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
