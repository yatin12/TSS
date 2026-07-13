import SwiftUI
import KVSpinnerView
import PassKit
import BraintreeCore
import BraintreeApplePay

// MARK: - Main View
struct RelationshipCoachingView: View {
    @State private var showTermsConditionView = false

    
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var applePayHandler: ApplePayHandler?
    @State private var paymentErrorMessage: String = ""
    @State private var strAmount: String = ""

    private let merchantID = "merchant.com.thesistersshowllc.thesistershow"
    @State private var clientToken = "" // Replace with actual token

    @Environment(\.dismiss) var dismiss
    @StateObject private var objPackageViewModel = PackageViewModel()
    @StateObject private var objRelationshipDataSubmitViewModel = RelationshipDataSubmitViewModel()
    @StateObject private var objGetPaypalTokenViewModel = GetPaypalTokenViewModel()
    @StateObject private var objpaypalNonceSubmitViewModel = paypalNonceSubmitViewModel()

    @State private var userId = ""
    @State private var userRole = ""
    @State private var wantCoaching = true
    @State private var relationshipStatus: RelationshipStatus = .single
    @State private var coachingGoal = ""
    @State private var selectedPlan: PackageData?
    @State private var agreedToTerms = false
    @State private var showTermsAlert = false
    @State private var showNoPlanAlert = false
    @State var strSelectedRelationshipStatus: String = "Are you single"
    @State var strSelectedCoachingStatus: String = "1"
    @State private var showDescCoachingSessionAlert = false
    @State var strPaypalNonce: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                customNavigationBar
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerSection
                        coachingSignupSection
                        relationshipStatusSection
                        feminineEnergySection
                        coachingPlansSection
                        termsAndConditionsSection
                        totalAndPaymentSection
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            getUserId()
            apiCallToFetchPackage()
        }
        .alert("Payment Success", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Your payment was completed successfully.")
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Payment Failed"), message: Text(paymentErrorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    enum RelationshipStatus: String {
        case single = "single"
        case married = "married"
        case dating = "dating?"
    }
    
    var coachingPlans: [PackageData] {
        return objPackageViewModel.objPackageModelResponse?.data ?? []
    }
    
    func startApplePay() {
        guard PKPaymentAuthorizationViewController.canMakePayments() else {
                // Device/region doesn't support Apple Pay at all
                showErrorAlert = true
                paymentErrorMessage = "Apple Pay is not available on this device."
                return
            }
        
        guard PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.visa, .masterCard, .amex]) else {
            showErrorAlert = true
            paymentErrorMessage = "Please add a card to Apple Wallet to use Apple Pay."
            return
        }
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = merchantID
        paymentRequest.supportedNetworks = [.visa, .masterCard, .amex]
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: selectedPlan?.title ?? "Coaching Plan", amount: NSDecimalNumber(string: selectedPlan?.packagePrice ?? "0"))
        ]
        
        if let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest),
           let braintreeClient = BTAPIClient(authorization: clientToken) {
           
            let handler = ApplePayHandler(
                braintreeClient: braintreeClient,
                nonceHandler: { nonce in
                    DispatchQueue.main.async {
                        self.strPaypalNonce = nonce
                        self.apiCallToSubmitPaypalNonceData()
                    }
                },
                completion: { success in
                    DispatchQueue.main.async {
                        if !success {
                            self.paymentErrorMessage = "Unable to complete payment."
                            self.showErrorAlert = true
                        }
                    }
                }
            )
            
            self.applePayHandler = handler
            controller.delegate = handler
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(controller, animated: true)
            }
        } else {
            showErrorAlert = true
            paymentErrorMessage = "Failed to initiate Apple Pay."
        }
    }
}

// MARK: - View Components
extension RelationshipCoachingView {
    private var customNavigationBar: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                Color("ThemePinkColor")
                    .frame(height: geo.safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.top)
            }
            .frame(height: 0)
            
            HStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 51, height: 46)
                    .padding(.leading)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                .padding(.trailing)
            }
            .frame(height: 44)
            .background(Color("ThemePinkColor"))
        }
    }
    
    private var headerSection: some View {
        Text("Relationship coaching")
            .font(.custom("Poppins-SemiBold", size: 18))
            .foregroundColor(Color("Wellness_FontDark"))
    }
    
    private var coachingSignupSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Do you want to sign up for feminine energy coaching")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("ThemePinkColor"))
                .cornerRadius(8)
            
            HStack(spacing: 30) {
                RadioButtonRelationship(selected: wantCoaching, label: "Yes")
                {
                    strSelectedCoachingStatus = "1"
                    wantCoaching = true
                }
                RadioButtonRelationship(selected: !wantCoaching, label: "No")
                {
                    strSelectedCoachingStatus = "0"
                    wantCoaching = false
                }
            }
            .padding(.leading)
        }
    }
    
    private var relationshipStatusSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Relationship status")
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundColor(Color("ThemePinkColor"))
            
            HStack(spacing: 20) {
                RadioButtonRelationship(selected: relationshipStatus == .single, label: "Are you single") {
                    strSelectedRelationshipStatus = "Are you single"
                    relationshipStatus = .single
                }
                RadioButtonRelationship(selected: relationshipStatus == .married, label: "married") {
                    strSelectedRelationshipStatus = "married"
                    relationshipStatus = .married
                }
                RadioButtonRelationship(selected: relationshipStatus == .dating, label: "dating?") {
                    strSelectedRelationshipStatus = "dating"
                    relationshipStatus = .dating
                }
            }
            
            Text("What are you trying to achieve from this coaching session?")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(Color("ThemePinkColor"))
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $coachingGoal)
                    .font(.custom("Poppins-Regular", size: 14))
                    .frame(height: 80)
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("ThemeDefaultBorderColor")))
                
                if coachingGoal.isEmpty {
                    Text("Please specify")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                        .padding(.top, 12)
                        .font(.custom("Poppins-Regular", size: 14))
                }
            }
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("ThemePinkColor"), lineWidth: 1))
    }
    
    private var feminineEnergySection: some View {
        Text("Feminine energy")
            .font(.custom("Poppins-Bold", size: 16))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(Color("ThemePinkColor"))
            .cornerRadius(10)
    }
    
    private var coachingPlansSection: some View {
        VStack(spacing: 12) {
            ForEach(coachingPlans) { plan in
                PlanSelectionView(
                    plan: plan,
                    isSelected: selectedPlan?.postID == plan.postID,
                    action: {
                        selectedPlan = plan
                        strAmount = plan.packagePrice
                    }
                )
            }
        }
    }
    private var termsAndConditionsSection: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.gray.opacity(0.3))
                .padding(.horizontal)

            HStack {
                Button(action: { agreedToTerms.toggle() }) {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                            .font(.system(size: 22))
                            .foregroundColor(Color("ThemePinkColor"))

                        // Split text so only "Terms and Conditions" is underlined & tappable
                        HStack(spacing: 0) {
                            Text("I agree to ")
                                .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 12.0))
                                .foregroundColor(Color("ThemePinkColor"))

                            Text("Terms and Conditions")
                                .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 12.0))
                                .foregroundColor(Color("ThemePinkColor"))
                                .underline()
                                .onTapGesture {
                                    showTermsConditionView = true
                                }
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
            }
            .padding(.vertical)
           // .padding(.horizontal)

            // Hidden NavigationLink triggered by showTermsConditionView
            NavigationLink(
                destination: TermsConditionWellnessView(),
                isActive: $showTermsConditionView
            ) {
                EmptyView()
            }
            .hidden()
        }
    }
    
    
    private var totalAndPaymentSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("TOTAL")
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .foregroundColor(Color("ThemePinkColor"))
                
                Spacer()
                
                Text("$\(selectedPlan?.packagePrice ?? "0")")
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .foregroundColor(Color("ThemePinkColor"))
            }
            
            Button(action: {
                if !agreedToTerms {
                    showTermsAlert = true
                } else if selectedPlan == nil {
                    showNoPlanAlert = true
                } else {
                    if coachingGoal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || coachingGoal == "Please specify" {
                        showDescCoachingSessionAlert = true
                    } else {
                        // Proceed with API call
                        apiCallToSubmitRelationshipData()
                        // startApplePay()
                    }
                }
            }) {
                Text("PAYMENT")
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("ThemePinkColor"))
                    .cornerRadius(5)
            }
            .alert("Terms Required", isPresented: $showTermsAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please check the Terms and Conditions to proceed with payment.")
            }
            .alert("Plan Required", isPresented: $showNoPlanAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please select a coaching plan to proceed with payment.")
            }
            .alert("", isPresented: $showDescCoachingSessionAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter what you trying to achieve from this coaching session?")
            }
            //            .alert("Please enter what you trying to achieve from this coaching session?", isPresented: $showDescCoachingSessionAlert) {
            //                Button("OK", role: .cancel) { }
            //            }
            
        }
        .padding(.top)
    }
}

// MARK: - Helper Views
struct RadioButtonRelationship: View {
    let selected: Bool
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                ZStack {
                    Circle().stroke(Color("ThemePinkColor"), lineWidth: 2).frame(width: 20, height: 20)
                    if selected {
                        Circle().fill(Color("ThemePinkColor")).frame(width: 12, height: 12)
                    }
                }
                Text(label)
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(.black)
            }
        }
    }
}

struct PlanSelectionView: View {
    let plan: PackageData
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 10) {
                ZStack {
                    Circle().stroke(Color("ThemePinkColor"), lineWidth: 2).frame(width: 20, height: 20)
                    if isSelected {
                        Circle().fill(Color("ThemePinkColor")).frame(width: 12, height: 12)
                    }
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(plan.title)
                        .font(.custom("Poppins-Medium", size: 15))
                    HStack {
                        Text("$\(plan.packagePrice)")
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(Color("ThemePinkColor"))
                        Text("- \(plan.duration)")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(.black)
                    }
                    Text(plan.description)
                        .font(.custom("Poppins-Medium", size: 11))
                        .foregroundColor(Color("Wellness_FontLight"))
                }
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color("Wellness_BGColor") : Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - API Functions
extension RelationshipCoachingView {
    func getUserId() {
        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
        userRole = AppUserDefaults.object(forKey: "USERROLE") as? String ?? ""
    }
    
    func apiCallToFetchPackage() {
        if Reachability.isConnectedToNetwork() {
            KVSpinnerView.show()
            
            Task {
                _ = await objPackageViewModel.fetchPackageDetails(
                    userId: userId,
                    package_type: "\(dynamicPackageType.relationshipCoaching)",
                    pagination_number: "1"
                )
                KVSpinnerView.dismiss()
            }
        } else {
            AlertUtility.showAlert(message: "\(AlertMessages.NoInternetAlertMsg)")
        }
    }
     func apiCallToSubmitRelationshipData() {
        let strAgree = agreedToTerms ? "1" : "0"
        
        if Reachability.isConnectedToNetwork() {
            KVSpinnerView.show()
            
            Task {
                let response = await objRelationshipDataSubmitViewModel.submitRelationshipDetails(
                    userId: userId,
                    feminine_energy: strSelectedCoachingStatus,
                    relationship_status: strSelectedRelationshipStatus,
                    coaching_session: coachingGoal,
                    energy_package: selectedPlan?.title ?? "",
                    IAgree_RelationShip: strAgree
                )
                
                KVSpinnerView.dismiss()
                
                if let response = response {
                    print(response.settings?.success ?? "No success flag")
                    
                    if response.settings?.success == true {
                        print("Wellness data submitted successfully")
                        apiCallToGetPaypalToken()
                    } else {
                        print("API error: \(response.settings?.message ?? "Unknown server message")")
                        AlertUtility.showAlert(message: response.settings?.message ?? "Something went wrong")
                    }
                } else {
                    print("ViewModel error: \(objRelationshipDataSubmitViewModel.errorMessage ?? "Unknown error")")
                    AlertUtility.showAlert(message: objRelationshipDataSubmitViewModel.errorMessage ?? "Something went wrong")
                }
            }
        } else {
            AlertUtility.showAlert(message: "\(AlertMessages.NoInternetAlertMsg)")
        }
    }
     func apiCallToGetPaypalToken() {
        
        if Reachability.isConnectedToNetwork() {
            KVSpinnerView.show()
            
            Task {
                let response = await objGetPaypalTokenViewModel.getPaypalToken(userId: userId)
                KVSpinnerView.dismiss()
                
                if let response = response {
                    print(response.settings?.success ?? "No success flag")
                    
                    if response.settings?.success == true {
                        print("Wellness data submitted successfully")
                        clientToken = response.data ?? ""
                         startApplePay()
                    } else {
                        print("API error: \(response.settings?.message ?? "Unknown server message")")
                        AlertUtility.showAlert(message: response.settings?.message ?? "Something went wrong")
                    }
                } else {
                    print("ViewModel error: \(objGetPaypalTokenViewModel.errorMessage ?? "Unknown error")")
                    AlertUtility.showAlert(message: objGetPaypalTokenViewModel.errorMessage ?? "Something went wrong")
                }
                
            }
        } else {
            AlertUtility.showAlert(message: AlertMessages.NoInternetAlertMsg)
        }
    }
    func apiCallToSubmitPaypalNonceData() {

        if Reachability.isConnectedToNetwork() {
            KVSpinnerView.show()

            Task {
                let response = await
                objpaypalNonceSubmitViewModel.submitPaypalNonceDetails(userId: userId, Nonce: strPaypalNonce, strAmount: strAmount)

                KVSpinnerView.dismiss()

                if let response = response {
                    print(response.settings?.success ?? "No success flag")

                    if response.settings?.success == true {
                        print("Nonce data submitted successfully")
                        showSuccessAlert = true
                    } else {
                        print("API error: \(response.settings?.message ?? "Unknown server message")")
                        paymentErrorMessage = response.settings?.message ?? "Something went wrong"
                        showErrorAlert = true
                    }
                } else {
                    print("ViewModel error: \(objpaypalNonceSubmitViewModel.errorMessage ?? "Unknown error")")
                    paymentErrorMessage = objpaypalNonceSubmitViewModel.errorMessage ?? "Something went wrong"
                    showErrorAlert = true
                }
            }
        } else {
            paymentErrorMessage = AlertMessages.NoInternetAlertMsg
            showErrorAlert = true
        }
    }
}
