import SwiftUI

struct PreferencesView: View {
    // State variables for storing selected preferences
    @State private var selectedSizes: [String] = []
    @State private var selectedClothingTypes: [String] = []
    @State private var selectedGenderOptions: [String] = []
    @State private var price: Double = 50

    // Options for dropdowns
    let sizeOptions = ["XS", "S", "M", "L", "XL", "XXL"]
    let clothingTypeOptions = ["Shorts", "Pants", "Jackets", "Shoes", "Shirts", "Hats", "Tops", "Jeans", "Other"]
    let genderOptions = ["Male", "Female", "Neutral"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Centered Header
                Text("Preferences")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)

                // Size Preference
                VStack(alignment: .leading, spacing: 5) {
                    Text("Size")
                        .font(.subheadline)
                        .padding(.leading)
                    
                    MultipleSelectionList(title: "Select Sizes", options: sizeOptions, selections: $selectedSizes)
                }

                // Type of Clothing Preference
                VStack(alignment: .leading, spacing: 5) {
                    Text("Type of Clothing")
                        .font(.subheadline)
                        .padding(.leading)

                    MultipleSelectionList(title: "Select Clothing Types", options: clothingTypeOptions, selections: $selectedClothingTypes)
                }

                // Price Range Preference
                VStack(alignment: .leading, spacing: 5) {
                    Text("Price: $\(Int(price))")
                        .font(.subheadline)
                        .padding(.leading)

                    Slider(value: $price, in: 10...200, step: 1)
                        .padding(.horizontal)
                        .accentColor(.black)
                }

                // Gender Preference
                VStack(alignment: .leading, spacing: 5) {
                    Text("Gender")
                        .font(.subheadline)
                        .padding(.leading)

                    MultipleSelectionList(title: "Select Gender", options: genderOptions, selections: $selectedGenderOptions)
                }

                Spacer()
            }
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Reusable multiple selection list component
struct MultipleSelectionList: View {
    let title: String
    let options: [String]
    @Binding var selections: [String]
    
    var body: some View {
        DisclosureGroup(title) {
            ForEach(options, id: \.self) { option in
                MultipleSelectionRow(option: option, selections: $selections)
            }
        }
        .padding(.horizontal)
    }
}

// Row for each item with multiple selection
struct MultipleSelectionRow: View {
    let option: String
    @Binding var selections: [String]
    
    var body: some View {
        Button(action: {
            if selections.contains(option) {
                selections.removeAll { $0 == option }
            } else {
                selections.append(option)
            }
        }) {
            HStack {
                Text(option)
                    .foregroundColor(.gray) // Set option text color to light gray
                Spacer()
                if selections.contains(option) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    PreferencesView()
}
