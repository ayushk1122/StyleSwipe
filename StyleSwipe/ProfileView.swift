import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @ObservedObject var orderManager: OrderManager  // Pass OrderManager to manage orders
    @State private var currentUserEmail: String? = nil  // State to hold the user's email or username

    var body: some View {
        NavigationView {
            VStack {
                // Add the logo at the top-left corner
                HStack {
                    Image("StyleSwipe log")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    Spacer()
                }

                // Username and Profile Picture
                VStack(spacing: 15) {
                    // Display the user's email or a placeholder if not available
                    Text(currentUserEmail ?? "Guest")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    Image(systemName: "person.circle.fill")  // Profile Picture placeholder
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()

                // Buttons for Profile Options with Navigation Links
                VStack(spacing: 15) {
                    NavigationLink(destination: SettingsView()) {
                        ProfileOptionButton(title: "Settings", hasArrow: true)
                    }
                    
                    NavigationLink(destination: PreferencesView()) {
                        ProfileOptionButton(title: "Preferences", hasArrow: true)
                    }
                    
                    // Navigate to MyOrdersView with orderManager
                    NavigationLink(destination: MyOrdersView(orderManager: orderManager)) {
                        ProfileOptionButton(title: "My Orders", hasArrow: true)
                    }
                    
                    NavigationLink(destination: ContactSupportView()) {
                        ProfileOptionButton(title: "Contact Support", hasArrow: true)
                    }
                }
                .padding(.horizontal, 30)

                Spacer()
            }
            .onAppear(perform: fetchCurrentUser)
            .navigationBarHidden(true)
        }
    }

    // Fetch the currently signed-in user's email
    private func fetchCurrentUser() {
        if let user = Auth.auth().currentUser {
            currentUserEmail = user.email
        } else {
            currentUserEmail = "Guest"  // Placeholder for unsigned users
        }
    }
}

// Custom Button View for Profile Options
struct ProfileOptionButton: View {
    var title: String
    var hasArrow: Bool = false

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)

            Spacer()

            if hasArrow {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(white: 0.95))  // Light gray background
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)  // Border for buttons
        )
    }
}

#Preview {
    ProfileView(orderManager: OrderManager())  // Provide OrderManager instance for preview
}
