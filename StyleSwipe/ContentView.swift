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
            .padding(.horizontal, 40)  // Adjust spacing between buttons
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
