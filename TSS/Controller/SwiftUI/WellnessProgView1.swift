//import SwiftUI
//import WebKit
//import KVSpinnerView
//import PassKit
//import BraintreeCore
//import BraintreeApplePay
//
//struct WellnessProgView1: View {
//    @State private var showTermsConditionView = false
//    @State private var showTermsConditionViewCoach = false
//
//    
//    @Environment(\.dismiss) var dismiss
//    @State private var userId = ""
//    @State private var userRole = ""
//    @StateObject private var objPackageViewModel = PackageViewModel()
//    @State private var selectedPlan: PackageData?
//    @State private var hasCheckedForDefaultPlan = false
//    @State private var totalPrice: Int = 0
//    @State private var emergencyConsultationPrice: Int = 100
//    @State private var maternalCarePrice: Int = 100
//    @State var strPaypalNonce: String = ""
//    @StateObject private var objpaypalNonceSubmitViewModel = paypalNonceSubmitViewModel()
//
//    // Form fields
//    @State private var phoneNumber: String = ""
//    @State private var address: String = ""
//    
//    // Medical Information
//    @State private var selectedMedicalCondition: MedicalCondition = .highCholesterol
//    @State private var otherMedicalCondition: String = ""
//    
//    // Surgical Information
//    @State private var selectedSurgicalCondition: SurgicalCondition = .fibroids
//    @State private var otherSurgicalCondition: String = ""
//    
//    // Food
//    @State private var selectedMeal: Meal = .breakfast
//    @State private var regularFood: String = "Breakfast"
//    
//    // Package selection
//    @State private var selectedPackage: String = ""
//    
//    // Additional options
//    @State private var includeEmergencyConsultation: Bool = true
//    @State private var includeMaternalCare: Bool = true
//    
//    @State private var wantWellnessProgramer: Bool = true
//    
//    // Terms and conditions
//    @State private var agreeToTerms: Bool = false
//    @State private var agreeToTermsCoach: Bool = false
//
//    @State private var showTermsAlert = false
//    @State private var showTermsAlertCoach = false
//
//    //  var totalPrice: Int = 300
//    @StateObject private var objWellnessDataSubmitViewModel = WellnessDataSubmitViewModel()
//    @StateObject private var objGetPaypalTokenViewModel = GetPaypalTokenViewModel()
//    @State private var showBlankPhoneNumAlert = false
//    @State private var showBlankAddressAlert = false
//    @State private var clientToken = "" // Replace with actual token
//    private let merchantID = "merchant.com.thesistersshowllc.thesistershow"
//    @State private var showSuccessAlert = false
//    @State private var showErrorAlert = false
//    @State private var applePayHandler: ApplePayHandler?
//    @State private var paymentErrorMessage: String = ""
//    
//    
//    var packages: [PackageData] {
//        let plans = objPackageViewModel.objPackageModelResponse?.data ?? []
//        
//        // Check if we need to set a default plan
//        if !hasCheckedForDefaultPlan && !plans.isEmpty && selectedPlan == nil {
//            DispatchQueue.main.async {
//                selectedPlan = plans.first
//                if let firstPlan = plans.first {
//                    selectedPackage = firstPlan.postID
//                }
//                hasCheckedForDefaultPlan = true
//            }
//        }
//        
//        return plans
//    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                customNavigationBar
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 20) {
//                        headerView
//                        wellnessProgramSection
//                        contactDetailsSection
//                        //medicalInformationSection
//                       // surgicalInformationSection
//                        foodSection
//                        packageSection
//                        emergencyConsultationSection
//                        maternalCareSection
//                        termsAndTotalSection
//                        termsAndConditionForCoatching
//                        totalAndPaymentSection
//                    }
//                    .padding()
//                }
//            }
//        }
//        .onAppear {
//            getUserId()
//            apiCallToFetchPackage()
//        }
//        .alert("Payment Success", isPresented: $showSuccessAlert) {
//            Button("OK", role: .cancel) { }
//        }
//        .alert(isPresented: $showErrorAlert) {
//            Alert(title: Text("Payment Failed"), message: Text(paymentErrorMessage), dismissButton: .default(Text("OK")))
//        }
//    }
//    
//    // MARK: - View Components
//    
//    var customNavigationBar: some View {
//        VStack(spacing: 0) {
//            // Status bar and notch area color
//            GeometryReader { geo in
//                Color("ThemePinkColor")
//                    .frame(height: geo.safeAreaInsets.top)
//                    .edgesIgnoringSafeArea(.top)
//            }
//            .frame(height: 0)
//            
//            // Actual navigation bar content
//            HStack {
//                Image("Logo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 51, height: 46)
//                    .padding(.leading)
//                
//                Spacer()
//                
//                Button(action: { dismiss() }) {
//                    Image(systemName: "xmark")
//                        .font(.system(size: 16, weight: .bold))
//                        .foregroundColor(.white)
//                        .frame(width: 30, height: 30)
//                        .background(Color.white.opacity(0.2))
//                        .clipShape(Circle())
//                }
//                .padding(.trailing)
//            }
//            .frame(height: 44)
//            .background(Color("ThemePinkColor"))
//        }
//    }
//    
//    var headerView: some View {
//        Text("Wellness program package")
//            .font(.custom("\(AppFontName.Poppins_SemiBold.rawValue)", size: 18.0))
//            .foregroundColor(Color("Wellness_FontDark"))
//    }
//    
//    var wellnessProgramSection: some View {
//        VStack(alignment: .leading) {
//            SectionHeaderView(title: "Do you want to sign up for a wellness program?")
//            
//            HStack {
//                RadioButton(
//                    checked: wantWellnessProgramer,
//                    action: { wantWellnessProgramer = true }
//                )
//                Text("Yes")
//                    .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 15.0))
//                    .foregroundColor(Color("Wellness_FontDark"))
//                
//                Spacer().frame(width: 30)
//                
//                RadioButton(
//                    checked: !wantWellnessProgramer,
//                    action: { wantWellnessProgramer = false }
//                )
//                Text("No")
//                    .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 15.0))
//                    .foregroundColor(Color("Wellness_FontDark"))
//            }
//            .padding(.leading)
//        }
//    }
//    
//    var contactDetailsSection: some View {
//        VStack(alignment: .leading, spacing: 15) {
//            // Phone number
//            VStack(alignment: .leading) {
//                Text("Phone number")
//                    .foregroundColor(Color("ThemePinkColor"))
//                    .font(.custom("\(AppFontName.Poppins_SemiBold.rawValue)", size: 14.0))
//                
//                TextField("", text: $phoneNumber)
//                    .font(.custom(AppFontName.Poppins_Regular.rawValue, size: 14.0))
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color("ThemeDefaultBorderColor")))
//                    .keyboardType(.phonePad)
//            }
//            
//            // Address
//            VStack(alignment: .leading) {
//                Text("Country")
//                    .foregroundColor(Color("ThemePinkColor"))
//                    .font(.custom("\(AppFontName.Poppins_SemiBold.rawValue)", size: 14.0))
//                
//                TextField("", text: $address)
//                    .font(.custom(AppFontName.Poppins_Regular.rawValue, size: 14.0))
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color("ThemeDefaultBorderColor")))
//                    .keyboardType(.default)
//                
//                /*
//                TextEditor(text: $address)
//                    .font(.custom(AppFontName.Poppins_Regular.rawValue, size: 14.0))
//                    .frame(height: 100)
//                    .padding(5)
//                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("ThemeDefaultBorderColor")))
//                */
//            }
//        }
//    }
//    
//    var medicalInformationSection: some View {
//        VStack(alignment: .leading) {
//            SectionHeaderView(title: "Medical information")
//            
//            VStack(alignment: .leading, spacing: 10) {
//                Text("Have you had any medical in the past?")
//                    .font(.custom("\(AppFontName.Poppins_SemiBold.rawValue)", size: 16.0))
//                    .foregroundColor(Color("Wellness_FontDark"))
//                
//                VStack(alignment: .leading) {
//                    ForEach(MedicalCondition.allCases, id: \.self) { condition in
//                        HStack {
//                            RadioButton(
//                                checked: selectedMedicalCondition == condition,
//                                action: { selectedMedicalCondition = condition }
//                            )
//                            
//                            Text(condition.rawValue)
//                                .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 14.0))
//                                .foregroundColor(Color("Wellness_FontLight"))
//                        }
//                        .padding(.vertical, 2)
//                    }
//                }
//                
//                if selectedMedicalCondition == .other {
//                    otherMedicalConditionInput
//                }
//            }
//        }
//    }
//    
//    var otherMedicalConditionInput: some View {
//        ZStack(alignment: .topLeading) {
//            TextEditor(text: $otherMedicalCondition)
//                .font(.custom(AppFontName.Poppins_Regular.rawValue, size: 14.0))
//                .frame(height: 80)
//                .padding(5)
//                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("ThemeDefaultBorderColor")))
//            
//            if otherMedicalCondition.isEmpty {
//                Text("Please specify")
//                    .foregroundColor(.gray)
//                    .padding(.horizontal, 10)
//                    .padding(.top, 12)
//                    .font(.custom(AppFontName.Poppins_Regular.rawValue, size: 14.0))
//            }
//        }
//    }
//    
//    var surgicalInformationSection: some View {
//        VStack(alignment: .leading) {
//            SectionHeaderView(title: "Surgical information")
//            
//            VStack(alignment: .leading, spacing: 10) {
//                Text("Have you had any surgery's in the past?")
//                    .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 16.0))
//                    .foregroundColor(Color("Wellness_FontDark"))
//                
//                VStack(alignment: .leading) {
//                    ForEach(SurgicalCondition.allCases, id: \.self) { condition in
//                        HStack {
//                            RadioButton(
//                                checked: selectedSurgicalCondition == condition,
//                                action: { selectedSurgicalCondition = condition }
//                            )
//                            
//                            Text(condition.rawValue)
//                                .font(.custom("\(AppFontName.Poppins_Medium.rawValue)", size: 14.0))
//                                .foregroundColor(Color("Wellness_FontLight"))
//                        }
//                        .padding(.vertical, 2)
//                    }
//                }
//                
//                if selectedSurgicalCondition == .other {
//                    otherSurgicalConditionInput
//                }
//            }
//        }
//    }
//    
//    var otherSurgicalConditionInput: some View {
//        ZStack(alignment: .topLeading) {
//            TextEditor(text: $otherSurgicalCondition)
//                .font(.custom(AppFontName.Poppins_Regular.rawValue, size: 14.0))
//                .frame(height: 100)
//                .padding(5)
//                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("ThemeDefaultBorderColor")))
//            
//            if otherSurgicalCondition.isEmpty {
//                Text("Please specify")
//                    .foregroundColor(.gray)
//                    .padding(.horizontal, 10)
//                    .padding(.top, 12)
//                    .font(.custom(AppFontName.Poppins_Regular.rawValue, size: 14.0))
//            }
//        }
//    }
//    
//    var foodSection: some View {
//        VStack(alignment: .leading) {
//            SectionHeaderView(title: "Food")
//            
//            VStack(alignment: .leading, spacing: 10) {
//                Text("Enter the food you take on a regular basis?")
//                    .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 16.0))
//                    .foregroundColor(Color("Wellness_FontDark"))
//                
//                HStack {
//                    ForEach(Meal.allCases, id: \.self) { meal in
//                        HStack {
//                            RadioButton(
//                                checked: selectedMeal == meal,
//                                action: {
//                                    selectedMeal = meal
//                                    regularFood = selectedMeal.rawValue
//                                }
//                            )
//                            
//                            Text(meal.rawValue)
//                                .font(.custom("\(AppFontName.Poppins_Medium.rawValue)", size: 14.0))
//                                .foregroundColor(Color("Wellness_FontLight"))
//                        }
//                        .padding(.horizontal, 5)
//                    }
//                }
//            }
//        }
//    }
//    
//    var packageSection: some View {
//        VStack(alignment: .leading) {
//            SectionHeaderView(title: "Package")
//            
//            VStack(alignment: .leading, spacing: 10) {
//                Text("All packages come with an initial consultation with Dr. Jay of 20 mins")
//                    .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 14.0))
//                    .foregroundColor(Color("ThemePinkColor"))
//                    .padding(.bottom, 5)
//                
//                ForEach(packages) { package in
//                    packageItem(package)
//                }
//            }
//        }
//    }
//    
//    func packageItem(_ package: PackageData) -> some View {
//        Button(action: { selectedPackage = package.postID }) {
//            HStack(alignment: .top, spacing: 10) {
//                RadioButton(
//                    checked: selectedPackage == package.postID,
//                    action: { selectedPackage = package.postID }
//                )
//                
//                VStack(alignment: .leading, spacing: 2) {
//                    Text(package.title)
//                        .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 15.0))
//                        .foregroundColor(Color("SUbscriptionDotColor"))
//                    
//                    Text("\(package.duration)")
//                        .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 12.0))
//                        .foregroundColor(Color("SUbscriptionDotColor"))
//                    
//                    Text(package.description)
//                        .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 12.0))
//                        .foregroundColor(Color("SUbscriptionDotColor"))
//                    
//                    Text("$\(package.packagePrice)")
//                        .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 20.0))
//                        .foregroundColor(Color("ThemePinkColor"))
//                        .padding(.top, 2)
//                }
//                Spacer()
//            }
//            .padding(.vertical, 8)
//            .padding(.horizontal, 12)
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(selectedPackage == package.postID ?
//                          Color("Wellness_BGColor") :
//                            Color(.systemGray6))
//            )
//        }
//        .buttonStyle(PlainButtonStyle())
//        .padding(.vertical, 4)
//    }
//    
//    var emergencyConsultationSection: some View {
//        VStack(alignment: .leading) {
//            SectionHeaderView(title: "Emergency Consultation")
//            
//            VStack(alignment: .leading, spacing: 10) {
//                HStack {
//                    Text("(Hospital Admission) ")
//                        .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 14.0))
//                        .foregroundColor(Color("ThemePinkColor"))
//                    
//                    Text("$100")
//                        .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 20.0))
//                        .foregroundColor(Color("ThemePinkColor"))
//                }
//                
//                HStack {
//                    RadioButton(
//                        checked: includeEmergencyConsultation,
//                        action: { includeEmergencyConsultation = true }
//                    )
//                    Text("Yes")
//                        .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 15.0))
//                        .foregroundColor(Color("Wellness_FontDark"))
//                    
//                    Spacer().frame(width: 30)
//                    
//                    RadioButton(
//                        checked: !includeEmergencyConsultation,
//                        action: { includeEmergencyConsultation = false }
//                    )
//                    Text("No")
//                        .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 15.0))
//                        .foregroundColor(Color("Wellness_FontDark"))
//                }
//            }
//        }
//    }
//    
//    var maternalCareSection: some View {
//        VStack(alignment: .leading) {
//            SectionHeaderView(title: "Maternal Care Package (MC package)")
//            
//            VStack(alignment: .leading, spacing: 10) {
//                HStack {
//                    Text("$100 ")
//                        .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 20.0))
//                        .foregroundColor(Color("ThemePinkColor"))
//                    
//                    Text("for 3 consultations (1st to 3rd trimester)")
//                        .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 14.0))
//                        .foregroundColor(Color("ThemePinkColor"))
//                }
//                
//                HStack {
//                    RadioButton(
//                        checked: includeMaternalCare,
//                        action: { includeMaternalCare = true }
//                    )
//                    Text("Yes")
//                        .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 15.0))
//                        .foregroundColor(Color("Wellness_FontDark"))
//                    
//                    Spacer().frame(width: 30)
//                    
//                    RadioButton(
//                        checked: !includeMaternalCare,
//                        action: { includeMaternalCare = false }
//                    )
//                    Text("No")
//                        .font(.custom(AppFontName.Poppins_Medium.rawValue, size: 15.0))
//                        .foregroundColor(Color("Wellness_FontDark"))
//                }
//            }
//        }
//    }
//    private var termsAndTotalSection: some View {
//        VStack(spacing: 0) {
//            Divider()
//                .background(Color.gray.opacity(0.3))
//                .padding(.horizontal)
//
//            HStack {
//                Button(action: { agreeToTerms.toggle() }) {
//                    HStack(alignment: .center, spacing: 10) {
//                        Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
//                            .font(.system(size: 22))
//                            .foregroundColor(Color("ThemePinkColor"))
//
//                        // Split text so only "Terms and Conditions" is underlined & tappable
//                        HStack(spacing: 0) {
//                            Text("I agree to ")
//                                .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 12.0))
//                                .foregroundColor(Color("ThemePinkColor"))
//
//                            Text("Terms and Conditions")
//                                .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 12.0))
//                                .foregroundColor(Color("ThemePinkColor"))
//                                .underline()
//                                .onTapGesture {
//                                    showTermsConditionView = true
//                                }
//                        }
//                    }
//                }
//                .buttonStyle(PlainButtonStyle())
//
//                Spacer()
//            }
//            .padding(.vertical)
//            .padding(.horizontal)
//
//            // Hidden NavigationLink triggered by showTermsConditionView
//            NavigationLink(
//                destination: TermsConditionWellnessView(),
//                isActive: $showTermsConditionView
//            ) {
//                EmptyView()
//            }
//            .hidden()
//        }
//    }
//    private var termsAndConditionForCoatching: some View {
//        VStack(spacing: -10) {
////            Divider()
////                .background(Color.gray.opacity(0.3))
////                .padding(.horizontal)
//
//            HStack {
//                Button(action: { agreeToTermsCoach.toggle() }) {
//                    HStack(alignment: .center, spacing: 10) {
//                        Image(systemName: agreeToTermsCoach ? "checkmark.square.fill" : "square")
//                            .font(.system(size: 22))
//                            .foregroundColor(Color("ThemePinkColor"))
//
//                        // Split text so only "Terms and Conditions" is underlined & tappable
//                        HStack(spacing: 0) {
//                            Text("I understand this is coaching (not medical care) and I agree to the ")
//                                .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 12.0))
//                                .foregroundColor(Color("ThemePinkColor"))
//
//                            Text("coaching agreement")
//                                .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 12.0))
//                                .foregroundColor(Color("ThemePinkColor"))
//                                .underline()
//                                .onTapGesture {
//                                    showTermsConditionViewCoach = true
//                                }
//                        }
//                    }
//                }
//                .buttonStyle(PlainButtonStyle())
//
//                Spacer()
//            }
//            .padding(.vertical)
//            .padding(.horizontal)
//
//            // Hidden NavigationLink triggered by showTermsConditionViewCoach
//            NavigationLink(
//                destination: TermsConditionCoachingWellnessView(),
//                isActive: $showTermsConditionViewCoach
//            ) {
//                EmptyView()
//            }
//            .hidden()
//        }
//    }
//        private var totalAndPaymentSection: some View {
//        VStack(spacing: 20) {
//            HStack {
//                Text("TOTAL")
//                    .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 20.0))
//                    .foregroundColor(Color("ThemePinkColor"))
//                
//                Spacer()
//                
//                Text("$\(totalPrice)")
//                    .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 20.0))
//                    .foregroundColor(Color("ThemePinkColor"))
//            }
//            
//            Button(action: {
//                if !agreeToTerms {
//                    showTermsAlert = true
//                } else   if !agreeToTermsCoach {
//                    showTermsAlertCoach = true
//                }
//                else {
//                    if phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                        showBlankPhoneNumAlert = true
//                    } else if address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                        showBlankAddressAlert = true
//                    } else {
//                        apiCallToSubmitWellnessData()
//                        // startApplePay()
//                    }
//                }
//            }) {
//                Text("PAYMENT")
//                    .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 16.0))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color("ThemePinkColor"))
//                    .cornerRadius(5)
//            }
//            .alert("Terms Required", isPresented: $showTermsAlert) {
//                Button("OK", role: .cancel) { }
//            } message: {
//                Text("Please check the Terms and Conditions to proceed with payment.")
//            }
//            .alert("Coaching agreement Required", isPresented: $showTermsAlertCoach) {
//                Button("OK", role: .cancel) { }
//            } message: {
//                Text("Please check the Coaching agreement to proceed with payment.")
//            }
//            
//        }
//        .padding(.top)
//        .onChange(of: selectedPackage) { _ in
//            calculateTotalPrice()
//        }
//        .onChange(of: includeEmergencyConsultation) { _ in
//            calculateTotalPrice()
//        }
//        .onChange(of: includeMaternalCare) { _ in
//            calculateTotalPrice()
//        }
//        .alert("", isPresented: $showBlankPhoneNumAlert) {
//            Button("OK", role: .cancel) { }
//        } message: {
//            Text("Please enter Phone Number")
//        }
//        .alert("", isPresented: $showBlankAddressAlert) {
//            Button("OK", role: .cancel) { }
//        } message: {
//            Text("Please enter Address")
//        }
//    }
//}
//
//// MARK: - Helper Views
//
//struct SectionHeaderView: View {
//    var title: String
//    
//    var body: some View {
//        Text(title)
//            .font(.custom("\(AppFontName.Poppins_Bold.rawValue)", size: 16.0))
//            .foregroundColor(.white)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.leading, -10)
//            .padding(.vertical, 8)
//            .padding(.horizontal)
//            .background(Color("ThemePinkColor"))
//            .cornerRadius(10)
//    }
//}
//
//struct RadioButton: View {
//    var checked: Bool
//    var action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            ZStack {
//                Circle()
//                    .stroke(Color("ThemePinkColor"), lineWidth: 1)
//                    .frame(width: 20, height: 20)
//                
//                if checked {
//                    Circle()
//                        .fill(Color("ThemePinkColor"))
//                        .frame(width: 12, height: 12)
//                }
//            }
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//// MARK: - Helper Models
//
//enum MedicalCondition: String, CaseIterable {
//    case highCholesterol = "High Cholesterol"
//    case highBloodPressure = "High Blood Pressure"
//    case diabetes = "Diabetes"
//    case other = "Other"
//}
//
//enum SurgicalCondition: String, CaseIterable {
//    case fibroids = "Fibroids"
//    case gallbladder = "Gallbladder"
//    case other = "Other"
//}
//
//enum Meal: String, CaseIterable {
//    case breakfast = "Breakfast"
//    case lunch = "Launch"
//    case dinner = "Dinner"
//}
//
//// MARK: - API Functions
//extension WellnessProgView {
//    func calculateTotalPrice() {
//        var total = 0
//        
//        // Add selected package price
//        if let selectedPlan = packages.first(where: { $0.postID == selectedPackage }) {
//            if let packagePrice = Int(selectedPlan.packagePrice) {
//                total += packagePrice
//            }
//        }
//        
//        // Add emergency consultation if selected
//        if includeEmergencyConsultation {
//            total += emergencyConsultationPrice
//        }
//        
//        // Add maternal care if selected
//        if includeMaternalCare {
//            total += maternalCarePrice
//        }
//        // Update total price
//        totalPrice = total
//    }
//    
//    func getUserId() {
//        userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""
//        userRole = AppUserDefaults.object(forKey: "USERROLE") as? String ?? ""
//    }
//    
//    func apiCallToFetchPackage() {
//        if Reachability.isConnectedToNetwork() {
//            KVSpinnerView.show()
//            
//            Task {
//                _ = await objPackageViewModel.fetchPackageDetails(
//                    userId: userId,
//                    package_type: "\(dynamicPackageType.wellnessProgram)",
//                    pagination_number: "1"
//                )
//                KVSpinnerView.dismiss()
//                DispatchQueue.main.async {
//                    if selectedPlan == nil, let firstPlan = objPackageViewModel.objPackageModelResponse?.data.first {
//                        selectedPlan = firstPlan
//                        selectedPackage = firstPlan.postID
//                        hasCheckedForDefaultPlan = true
//                        
//                        // Calculate initial price after data is loaded
//                        calculateTotalPrice()
//                    }
//                }
//            }
//        } else {
//            AlertUtility.showAlert(message: "\(AlertMessages.NoInternetAlertMsg)")
//        }
//    }
//    func apiCallToSubmitWellnessData() {
//        let strAgree = agreeToTerms ? "1" : "0"
//
//        if Reachability.isConnectedToNetwork() {
//            KVSpinnerView.show()
//
//            Task {
//                let response = await objWellnessDataSubmitViewModel.submitWellnessDetails(
//                    userId: userId,
//                    phone_number: phoneNumber,
//                    address: address,
//                    medical_information: selectedMedicalCondition.rawValue,
//                    medical_information_other: otherMedicalCondition,
//                    surgery_information: selectedSurgicalCondition.rawValue,
//                    surgery_information_other: otherSurgicalCondition,
//                    food_take: regularFood,
//                    select_package: selectedPackage,
//                    emergency_consultation: includeEmergencyConsultation ? "1" : "0",
//                    mc_package: includeMaternalCare ? "1" : "0",
//                    IAgree_RelationShip: strAgree
//                )
//
//                KVSpinnerView.dismiss()
//
//                if let response = response {
//                    print(response.settings?.success ?? "No success flag")
//
//                    if response.settings?.success == true {
//                        print("Wellness data submitted successfully1")
//                        apiCallToGetPaypalToken()
//                       
//                    } else {
//                        print("API error: \(response.settings?.message ?? "Unknown server message")")
//                        AlertUtility.showAlert(message: response.settings?.message ?? "Something went wrong")
//                    }
//                } else {
//                    print("ViewModel error: \(objWellnessDataSubmitViewModel.errorMessage ?? "Unknown error")")
//                    AlertUtility.showAlert(message: objWellnessDataSubmitViewModel.errorMessage ?? "Something went wrong")
//                }
//            }
//        } else {
//            AlertUtility.showAlert(message: AlertMessages.NoInternetAlertMsg)
//        }
//    }
//    func apiCallToGetPaypalToken() {
//
//        if Reachability.isConnectedToNetwork() {
//            KVSpinnerView.show()
//
//            Task {
//                let response = await objGetPaypalTokenViewModel.getPaypalToken(userId: userId)
//                KVSpinnerView.dismiss()
//
//                if let response = response {
//                    print(response.settings?.success ?? "No success flag")
//
//                    if response.settings?.success == true {
//                        print("Wellness data submitted successfully")
//                        clientToken = response.data ?? ""
//                         startApplePay()
//                    } else {
//                        print("API error: \(response.settings?.message ?? "Unknown server message")")
//                        AlertUtility.showAlert(message: response.settings?.message ?? "Something went wrong")
//                    }
//                } else {
//                    print("ViewModel error: \(objGetPaypalTokenViewModel.errorMessage ?? "Unknown error")")
//                    AlertUtility.showAlert(message: objGetPaypalTokenViewModel.errorMessage ?? "Something went wrong")
//                }
//                    
//            }
//        } else {
//            AlertUtility.showAlert(message: AlertMessages.NoInternetAlertMsg)
//        }
//    }
//    func startApplePay() {
//        guard PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.visa, .masterCard, .amex]) else {
//            showErrorAlert = true
//            paymentErrorMessage = "Apple Pay is not available."
//            return
//        }
//        
//        let paymentRequest = PKPaymentRequest()
//        paymentRequest.merchantIdentifier = merchantID
//        paymentRequest.supportedNetworks = [.visa, .masterCard, .amex]
//        paymentRequest.merchantCapabilities = .capability3DS
//        paymentRequest.countryCode = "US"
//        paymentRequest.currencyCode = "USD"
////        paymentRequest.paymentSummaryItems = [
////            PKPaymentSummaryItem(label: selectedPlan?.title ?? "Coaching Plan", amount: NSDecimalNumber(string: selectedPlan?.packagePrice ?? "0"))
////        ]
//        
//        paymentRequest.paymentSummaryItems = [
//            PKPaymentSummaryItem(label: selectedPlan?.title ?? "Coaching Plan", amount: NSDecimalNumber(string: "\(totalPrice)"))
//        ]
//
//        
//        if let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest),
//           let braintreeClient = BTAPIClient(authorization: clientToken) {
//            
//            let handler = ApplePayHandler(
//                braintreeClient: braintreeClient,
//                nonceHandler: { nonce in
//                    DispatchQueue.main.async {
//                        self.strPaypalNonce = nonce
//                        self.apiCallToSubmitPaypalNonceData()
//                    }
//                },
//                completion: { success in
//                    DispatchQueue.main.async {
//                        if success {
//                            self.showSuccessAlert = true
//                        } else {
//                            self.paymentErrorMessage = "Unable to complete payment."
//                            self.showErrorAlert = true
//                        }
//                    }
//                }
//            )
//            
//            self.applePayHandler = handler
//            controller.delegate = handler
//            
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let rootVC = windowScene.windows.first?.rootViewController {
//                rootVC.present(controller, animated: true)
//            }
//        } else {
//            showErrorAlert = true
//            paymentErrorMessage = "Failed to initiate Apple Pay."
//        }
//    }
//    func apiCallToSubmitPaypalNonceData() {
//       
//       if Reachability.isConnectedToNetwork() {
//           KVSpinnerView.show()
//           
//           Task {
//               let response = await
//              
//               objpaypalNonceSubmitViewModel.submitPaypalNonceDetails(userId: userId, Nonce: strPaypalNonce)
//               
//               KVSpinnerView.dismiss()
//               
//               if let response = response {
//                   print(response.settings?.success ?? "No success flag")
//                   
//                   if response.settings?.success == true {
//                       print("Nonce Wellness data submitted successfully")
//                       AlertUtility.showAlert(message: "Data submitted successfully")
//
//                   } else {
//                       print("API error: \(response.settings?.message ?? "Unknown server message")")
//                       AlertUtility.showAlert(message: response.settings?.message ?? "Something went wrong")
//                   }
//               } else {
//                   print("ViewModel error: \(objpaypalNonceSubmitViewModel.errorMessage ?? "Unknown error")")
//                   AlertUtility.showAlert(message: objpaypalNonceSubmitViewModel.errorMessage ?? "Something went wrong")
//               }
//           }
//       } else {
//           AlertUtility.showAlert(message: "\(AlertMessages.NoInternetAlertMsg)")
//       }
//   }
//}
//
//// MARK: - WKWebView Representable
//struct WebView: UIViewRepresentable {
//    let url: URL
//    @Binding var isLoading: Bool
//
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        webView.navigationDelegate = context.coordinator
//        // ✅ Load ONCE here in makeUIView, not in updateUIView
//        let request = URLRequest(url: url)
//        webView.load(request)
//        return webView
//    }
//
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        // ✅ Do NOT load here — this causes the flicker on every re-render
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var parent: WebView
//
//        init(_ parent: WebView) {
//            self.parent = parent
//        }
//
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            DispatchQueue.main.async {
//                self.parent.isLoading = true
//            }
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            DispatchQueue.main.async {
//                self.parent.isLoading = false
//            }
//        }
//
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            DispatchQueue.main.async {
//                self.parent.isLoading = false
//            }
//        }
//
//        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//            DispatchQueue.main.async {
//                self.parent.isLoading = false
//            }
//        }
//    }
//}
//// MARK: - TermsConditionWellnessView
//struct TermsConditionCoachingWellnessView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var isLoading = true
//
//    private let termsURL = URL(string: "https://thesistersshow.com/coaching-agreement-liability-waiver/")!
//
//    var body: some View {
//        VStack(spacing: 0) {
//            customNavigationBar
//
//            ZStack {
//                // ✅ WebView always present underneath — no flickering
//                WebView(url: termsURL, isLoading: $isLoading)
//
//                // ✅ Spinner sits on top, fades out when done
//                if isLoading {
//                    VStack(spacing: 12) {
//                        ProgressView()
//                            .progressViewStyle(CircularProgressViewStyle(tint: Color("ThemePinkColor")))
//                            .scaleEffect(1.5)
//                        Text("Loading...")
//                            .font(.custom(AppFontName.Poppins_Regular.rawValue, size: 14.0))
//                            .foregroundColor(Color("ThemePinkColor"))
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color.white)
//                }
//            }
//        }
//        .navigationBarHidden(true)
//        .ignoresSafeArea(edges: .bottom)
//    }
//
//    var customNavigationBar: some View {
//        VStack(spacing: 0) {
//            GeometryReader { geo in
//                Color(.systemBackground)
//                    .frame(height: geo.safeAreaInsets.top)
//                    .edgesIgnoringSafeArea(.top)
//            }
//            .frame(height: 0)
//
//            HStack {
//                Button(action: { dismiss() }) {
//                    HStack(spacing: 4) {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 16, weight: .semibold))
//                            .foregroundColor(Color("ThemePinkColor"))
//                        Text("Term & Condition")
//                            .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 16.0))
//                            .foregroundColor(Color("ThemePinkColor"))
//                    }
//                }
//
//                Spacer()
//
//                Button(action: {}) {
//                    Image(systemName: "bell")
//                        .font(.system(size: 18))
//                        .foregroundColor(.primary)
//                }
//
//                Button(action: {}) {
//                    Image(systemName: "magnifyingglass")
//                        .font(.system(size: 18))
//                        .foregroundColor(.primary)
//                }
//                .padding(.leading, 12)
//            }
//            .padding(.horizontal, 16)
//            .frame(height: 44)
//            .background(Color(.systemBackground))
//            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
//        }
//    }
//}
//// MARK: - TermsConditionWellnessView
//struct TermsConditionWellnessView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var isLoading = true
//
//    private let termsURL = URL(string: "https://thesistersshow.com/term-condition/")!
//
//    var body: some View {
//        VStack(spacing: 0) {
//            customNavigationBar
//
//            ZStack {
//                // ✅ WebView always present underneath — no flickering
//                WebView(url: termsURL, isLoading: $isLoading)
//
//                // ✅ Spinner sits on top, fades out when done
//                if isLoading {
//                    VStack(spacing: 12) {
//                        ProgressView()
//                            .progressViewStyle(CircularProgressViewStyle(tint: Color("ThemePinkColor")))
//                            .scaleEffect(1.5)
//                        Text("Loading...")
//                            .font(.custom(AppFontName.Poppins_Regular.rawValue, size: 14.0))
//                            .foregroundColor(Color("ThemePinkColor"))
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color.white)
//                }
//            }
//        }
//        .navigationBarHidden(true)
//        .ignoresSafeArea(edges: .bottom)
//    }
//
//    var customNavigationBar: some View {
//        VStack(spacing: 0) {
//            GeometryReader { geo in
//                Color(.systemBackground)
//                    .frame(height: geo.safeAreaInsets.top)
//                    .edgesIgnoringSafeArea(.top)
//            }
//            .frame(height: 0)
//
//            HStack {
//                Button(action: { dismiss() }) {
//                    HStack(spacing: 4) {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 16, weight: .semibold))
//                            .foregroundColor(Color("ThemePinkColor"))
//                        Text("Term & Condition")
//                            .font(.custom(AppFontName.Poppins_SemiBold.rawValue, size: 16.0))
//                            .foregroundColor(Color("ThemePinkColor"))
//                    }
//                }
//
//                Spacer()
//
//                Button(action: {}) {
//                    Image(systemName: "bell")
//                        .font(.system(size: 18))
//                        .foregroundColor(.primary)
//                }
//
//                Button(action: {}) {
//                    Image(systemName: "magnifyingglass")
//                        .font(.system(size: 18))
//                        .foregroundColor(.primary)
//                }
//                .padding(.leading, 12)
//            }
//            .padding(.horizontal, 16)
//            .frame(height: 44)
//            .background(Color(.systemBackground))
//            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
//        }
//    }
//}
