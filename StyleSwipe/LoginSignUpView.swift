import SwiftUI

struct LoginSignUpView: View {
    @State private var isLogin = true // Toggle between Login and Sign Up
    @State private var username = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var gender = ""

    var body: some View {
        NavigationView {
            VStack {
                // Logo at the top
                Image("StyleSwipeFullLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding(.top, 20)

                // Login | Sign Up Toggle
                HStack(spacing: 8) {
                    Button(action: { isLogin = true }) {
                        Text("Login")
                            .font(.title2)
                            .fontWeight(isLogin ? .bold : .regular)
                            .foregroundColor(isLogin ? .black : .gray)
                    }

                    Text("|")
                        .font(.title2)
                        .foregroundColor(.gray)

                    Button(action: { isLogin = false }) {
                        Text("Sign Up")
                            .font(.title2)
                            .fontWeight(isLogin ? .bold : .regular)
                            .foregroundColor(isLogin ? .gray : .black)
                    }
                }
                .padding(.top, 5)

                // Input Fields - Centered on Page
                Group {
                    if isLogin {
                        loginFields
                    } else {
                        signUpFields
                    }
                }
                .padding(.top, 20)

                // Navigate to Home Page Button
                NavigationLink(destination: ContentView()) {
                    Text(isLogin ? "Login" : "Sign Up")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                .padding(.bottom, 30)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }

    // Login Fields View with Bold Borders
    var loginFields: some View {
        VStack(spacing: 15) {
            textFieldWithBoldBorder(placeholder: "Username", text: $username)
            textFieldWithBoldBorder(placeholder: "Password", text: $password, isSecure: true)
        }
    }

    // Sign Up Fields View with Bold Borders
    var signUpFields: some View {
        VStack(spacing: 15) {
            textFieldWithBoldBorder(placeholder: "First Name", text: $firstName)
            textFieldWithBoldBorder(placeholder: "Last Name", text: $lastName)
            textFieldWithBoldBorder(placeholder: "Phone Number", text: $phoneNumber)
            textFieldWithBoldBorder(placeholder: "Email", text: $email)
            textFieldWithBoldBorder(placeholder: "Gender", text: $gender)
        }
    }

    // Helper Function to Create TextField with Bold Borders
    @ViewBuilder
    func textFieldWithBoldBorder(placeholder: String, text: Binding<String>, isSecure: Bool = false) -> some View {
        if isSecure {
            SecureField(placeholder, text: text)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 2) // Bold border
                )
                .padding(.horizontal, 30)
        } else {
            TextField(placeholder, text: text)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 2) // Bold border
                )
                .padding(.horizontal, 30)
        }
    }
}

#Preview {
    LoginSignUpView()
}
