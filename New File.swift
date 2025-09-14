import SwiftUI

struct DressTryOnView: View {
    @State private var imageURLText: String = ""
    @State private var dressImage: UIImage?
    @State private var userImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("👗 Virtual Try-On")
                .font(.title)
            
            // Paste URL
            TextField("Paste dress image URL...", text: $imageURLText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Load dress image
            Button("Load Dress Image") {
                loadDressImage(from: imageURLText)
            }
            
            // Pick user photo
            Button("Select Your Photo") {
                showImagePicker = true
            }
            
            // Preview try-on
            ZStack {
                if let user = userImage {
                    Image(uiImage: user)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 400)
                }
                
                if let dress = dressImage {
                    Image(uiImage: dress)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300) // Adjust for fit
                        .opacity(userImage != nil ? 0.8 : 1.0)
                }
            }
            .padding()
            
            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $userImage)
        }
        .padding()
    }
    
    func loadDressImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.dressImage = uiImage
                }
            }
        }.resume()
    }
}
     
