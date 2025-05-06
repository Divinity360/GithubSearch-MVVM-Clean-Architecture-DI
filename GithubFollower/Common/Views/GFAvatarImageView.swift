import SwiftUI

struct GFAvatarImageView: View {
    @Environment(\.diContainer) private var diContainer
    var urlString: String
    @State private var image: UIImage? = nil
    
    var body: some View {
        Image(uiImage: image ?? UIImage(systemName: "person.fill")!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .onAppear {
                loadImage()
            }
    }
    
    private func loadImage() {
        diContainer.networkService.downloadImage(from: urlString) { uiImage in
            if let uiImage = uiImage {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }
    }
}