import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void
    
    @State private var isEditing = false
    @State private var suggestions: [String] = ["Apple", "Microsoft", "Google", "Tesla", "NASA"]
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search news...", text: $text)
                    .padding(10)
                    .padding(.horizontal, 25)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("SecondaryColor").opacity(0.1))
                    )
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color("PrimaryColor"))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 15)
                            
                            if isEditing && !text.isEmpty {
                                Button(action: {
                                    self.text = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(Color("PrimaryColor"))
                                        .padding(.trailing, 15)
                                }
                            }
                        }
                    )
                    .onTapGesture {
                        withAnimation {
                            self.isEditing = true
                        }
                    }
                    .submitLabel(.search)
                    .onSubmit {
                        onSearchButtonClicked()
                    }
                
                if isEditing {
                    Button(action: {
                        withAnimation {
                            self.isEditing = false
                            self.text = ""
                            hideKeyboard()
                        }
                    }) {
                        Text("Cancel")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut, value: isEditing)
                }
            }
            
            if isEditing && !suggestions.isEmpty && !text.isEmpty {
                List {
                    ForEach(suggestions.filter { $0.lowercased().contains(text.lowercased()) }, id: \.self) { suggestion in
                        Button(action: {
                            self.text = suggestion
                            onSearchButtonClicked()
                            withAnimation {
                                self.isEditing = false
                            }
                        }) {
                            Text(suggestion)
                                .foregroundColor(Color("TextColor"))
                        }
                    }
                }
                .frame(height: 150)
                .listStyle(PlainListStyle())
                .cornerRadius(10)
                .transition(.opacity)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
