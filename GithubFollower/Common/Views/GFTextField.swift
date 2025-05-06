import SwiftUI

struct GFTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .keyboardType(keyboardType)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}