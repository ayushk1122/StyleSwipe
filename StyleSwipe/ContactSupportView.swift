import SwiftUI

struct ContactSupportView: View {
    @State private var issueDescription: String = "" // State variable to store user input
    @State private var showSubmissionAlert: Bool = false // State variable to show a submission confirmation

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                Text("Contact Support")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)

                // Description Field Label
                Text("Describe Issue/Question")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .padding(.horizontal)

                // Text Editor for Issue Description
                TextEditor(text: $issueDescription)
                    .frame(height: 150)
                    .padding(5)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                            .padding(.horizontal, 20)
                    )
                    .onTapGesture {
                        // Ensure the TextEditor is editable
                        if issueDescription.isEmpty {
                            issueDescription = "" // Reset the text if needed
                        }
                    }

                // Submit Button
                Button(action: {
                    // Show confirmation when the button is tapped
                    showSubmissionAlert = true

                    // Handle storing or sending the input
                    print("User Issue/Question: \(issueDescription)") // Debugging (can be saved to Firebase)
                }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.horizontal, 100)
                }
                .alert(isPresented: $showSubmissionAlert) {
                    Alert(
                        title: Text("Submission Successful"),
                        message: Text("Your issue has been submitted. Our team will get back to you soon."),
                        dismissButton: .default(Text("OK"))
                    )
                }

                Spacer()
            }
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContactSupportView()
}

