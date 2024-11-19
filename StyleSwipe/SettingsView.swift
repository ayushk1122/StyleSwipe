import SwiftUI

struct SettingsView: View {
    // State variables to store user inputs with default values from UserDefaults
    @State private var phoneNumber: String = UserDefaults.standard.string(forKey: "phoneNumber") ?? ""
    @State private var email: String = UserDefaults.standard.string(forKey: "email") ?? ""
    @State private var shippingAddress: String = UserDefaults.standard.string(forKey: "shippingAddress") ?? ""
    @State private var creditCardNumber: String = UserDefaults.standard.string(forKey: "creditCardNumber") ?? ""
    @State private var billingAddress: String = UserDefaults.standard.string(forKey: "billingAddress") ?? ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Centered Header
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)

                // Profile Section
                Text("Profile")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.leading)

                VStack(spacing: 10) {
                    SettingsRow(label: "Phone Number", text: $phoneNumber)
                    SettingsRow(label: "Email", text: $email, isEmail: true)
                    SettingsRow(label: "Shipping Address", text: $shippingAddress, isMultiline: true)
                }
                .padding(.horizontal, 20)

                // Billing Information Section
                Text("Billing Information")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.leading)
                    .padding(.top, 20)

                VStack(spacing: 10) {
                    SettingsRow(label: "Credit Card #", text: $creditCardNumber)
                    SettingsRow(label: "Billing Address", text: $billingAddress, isMultiline: true)
                }
                .padding(.horizontal, 20)

                Spacer()

                // Black Save Settings Button moved up
                Button(action: saveSettings) {
                    Text("Save Settings")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black) // Set button background to black
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40) // Adjusted padding to move it up a bit
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Function to handle saving entered information to UserDefaults
    func saveSettings() {
        UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(shippingAddress, forKey: "shippingAddress")
        UserDefaults.standard.set(creditCardNumber, forKey: "creditCardNumber")
        UserDefaults.standard.set(billingAddress, forKey: "billingAddress")
        
        print("Settings saved.")
    }
}

// Custom view for each settings row
struct SettingsRow: View {
    var label: String
    @Binding var text: String
    var isMultiline: Bool = false
    var isEmail: Bool = false

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.black)

            Spacer()

            if isMultiline {
                // Multiline text editor for addresses with consistent size
                TextEditor(text: $text)
                    .frame(height: 60)
                    .padding(5)
                    .frame(width: 250)  // Set consistent width
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            } else {
                // Single line TextField with consistent size
                TextField("", text: $text)
                    .keyboardType(isEmail ? .emailAddress : .default)
                    .autocapitalization(isEmail ? .none : .words)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(5)
                    .frame(width: 250)  // Set consistent width
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    SettingsView()
}

