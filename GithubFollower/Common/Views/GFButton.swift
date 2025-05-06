import SwiftUI

struct GFButton: View {
    var title: String
    var backgroundColor: Color = .blue
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(10)
        }
    }
}