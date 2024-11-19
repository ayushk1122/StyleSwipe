import SwiftUI
import Foundation
import Combine

struct FavoriteProduct: Identifiable {
    let id: UUID
    let name: String
    let details: [String: Any]
}

class FavoritesManager: ObservableObject {
    @Published var favoritedProducts: [FavoriteProduct] = []
    
    func addFavorite(product: (name: String, details: [String: Any])) {
        let newFavorite = FavoriteProduct(id: UUID(), name: product.name, details: product.details)
        favoritedProducts.append(newFavorite)
    }

    func removeProduct(byID id: UUID) {
        favoritedProducts.removeAll { $0.id == id }
    }
}

class CartManager: ObservableObject {
    @Published var cartProducts: [FavoriteProduct] = []
    
    func addToCart(product: FavoriteProduct) {
        cartProducts.append(product)
    }

    func removeFromCart(byID id: UUID) {
        cartProducts.removeAll { $0.id == id }
    }

    func totalPrice() -> Double {
        return cartProducts.compactMap { $0.details["Price"] as? Double }.reduce(0, +)
    }
}

struct ContentView: View {
    @StateObject private var favoritesManager = FavoritesManager()  // Shared favorites manager
    @StateObject private var cartManager = CartManager()  // Shared cart manager
    @State private var viewController: ViewController? = nil
    @State private var showSplashScreen = true
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            if showSplashScreen {
                SplashScreenView()
                    .transition(.opacity)
            } else {
                TabView(selection: $selectedTab) {
                    // Main Home (Swipe) Page
                    MainContentView(viewController: $viewController, favoritesManager: favoritesManager)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)

                    // Favorites View
                    FavoritesView(favoritesManager: favoritesManager, cartManager: cartManager)
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Favorites")
                        }
                        .tag(1)

                    // Cart View
                    CartView(cartManager: cartManager)
                        .tabItem {
                            Image(systemName: "cart.fill")
                            Text("Cart")
                        }
                        .tag(2)

                    // User Profile Page (Renamed)
                    UserProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                        .tag(3)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplashScreen = false
                }
            }
        }
    }
}

struct SplashScreenView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("StyleSwipeFullLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)  // Adjust size as needed
             
            Spacer()
        }
        .background(Color.white)  // Optional: Set background color
        .edgesIgnoringSafeArea(.all)  // Ensure the splash screen covers the entire screen
    }
}

struct MainContentView: View {
    @Binding var viewController: ViewController?
    var favoritesManager: FavoritesManager  // Add favoritesManager here

    var body: some View {
        VStack {
            // Add the logo at the top-left corner
            HStack {
                Image("StyleSwipe log")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.leading, 20)
                    .padding(.top, -60)
                    .padding(.bottom, 10)
                Spacer()
            }

            Spacer()

            // Pass favoritesManager to SwipeViewControllerRepresentable
            SwipeViewControllerRepresentable(viewController: $viewController, favoritesManager: favoritesManager)
                .frame(height: 500)
                .padding(.bottom, -100)

            Spacer()

            // SwiftUI Buttons for 'like' and 'dislike'
            HStack {
                Button(action: {
                    print("Dislike button pressed")
                    if let vc = viewController {
                        vc.swipeLeft()
                    } else {
                        print("ViewController not found!")
                    }
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }

                Spacer()

                Button(action: {
                    print("Like button pressed")
                    if let vc = viewController {
                        vc.swipeRight()
                    } else {
                        print("ViewController not found!")
                    }
                }) {
                    Image(systemName: "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }
            }
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 30)
            .padding(.top, 30)
        }
        .padding()
        .navigationBarHidden(true)
    }
}

struct SwipeViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var viewController: ViewController?  // Binding to pass instance to SwiftUI
    var favoritesManager: FavoritesManager  // Pass the favorites manager

    func makeUIViewController(context: Context) -> ViewController {
        let vc = ViewController(favoritesManager: favoritesManager)  // Initialize with FavoritesManager
        viewController = vc  // Assign it to the binding
        return vc
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

// Renamed from ProfileView to UserProfileView to avoid conflict
struct UserProfileView: View {
    var body: some View {
        Text("Profile Page")
            .font(.title)
    }
}

#Preview {
    ContentView()
}
