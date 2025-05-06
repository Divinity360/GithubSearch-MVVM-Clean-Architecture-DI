import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    @State private var selectedScheme: String
    
    init() {
        switch ColorSchemeManager.shared.colorScheme {
        case .dark:
            _selectedScheme = State(initialValue: "dark")
        case .light:
            _selectedScheme = State(initialValue: "light")
        case .none:
            _selectedScheme = State(initialValue: "system")
        case .some(_):
            _selectedScheme = State(initialValue: "system")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $selectedScheme) {
                        Text("System").tag("system")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedScheme) { newValue in
                        switch newValue {
                        case "dark":
                            colorSchemeManager.setColorScheme(.dark)
                        case "light":
                            colorSchemeManager.setColorScheme(.light)
                        default:
                            colorSchemeManager.setColorScheme(nil)
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}