import SwiftUI

struct SwipeViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var viewController: ViewController?  // Binding to pass the instance to SwiftUI

    func makeUIViewController(context: Context) -> ViewController {
        let vc = ViewController()  // Create the ViewController instance
        viewController = vc        // Assign it to the binding
        DispatchQueue.main.async {
            self.viewController = vc  // Ensure the ViewController is assigned
            print("ViewController created and assigned (async)")
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
}

struct ContentView: View {
    @State private var viewController: ViewController? = nil  // Store the reference to ViewController
    @State private var showSplashScreen = true  // State to manage splash screen visibility

    var body: some View {
        ZStack {
            if showSplashScreen {
                SplashScreenView()
                    .transition(.opacity)  // Add a fade transition effect
            } else {
                MainContentView(viewController: $viewController)
            }
        }
        .onAppear {
            // Hide splash screen after 1 second
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
            
            SwipeViewControllerRepresentable(viewController: $viewController)
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

            // TabView to switch pages
            TabView {
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .tabItem {
                        Image(systemName: "house.fill")
                    }

                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .tabItem {
                        Image(systemName: "heart.fill")
                    }

                Image(systemName: "cart.fill")
                    .resizable()
                    .scaledToFit()
                    .tabItem {
                        Image(systemName: "cart.fill")
                    }

                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .tabItem {
                        Image(systemName: "person.fill")
                    }
            }
            .frame(height: 60)
            .padding(.bottom, -100)
            .padding(.top, 60)
        }
        .padding()
        .navigationBarHidden(true)
    }
}

#Preview {
    ContentView()
}
