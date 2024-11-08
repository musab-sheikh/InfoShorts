import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedAccentColor") private var selectedAccentColor: String = "PrimaryColor"
    
    let accentColors = ["PrimaryColor", "SecondaryColor", "AccentColor"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Accent Color", selection: $selectedAccentColor) {
                        ForEach(accentColors, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(Color(color))
                                    .frame(width: 20, height: 20)
                                Text(color.replacingOccurrences(of: "Color", with: ""))
                            }
                            .tag(color)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Your Name")
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}
