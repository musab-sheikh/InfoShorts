import SwiftUI

struct CategoryButton: View {
    let category: String
    let isSelected: Bool
    
    var body: some View {
        Text(category)
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color("PrimaryColor") : Color("SecondaryColor").opacity(0.3))
            )
            .foregroundColor(isSelected ? .white : Color("PrimaryColor"))
            .shadow(color: isSelected ? Color("PrimaryColor").opacity(0.3) : Color.clear, radius: 5, x: 0, y: 2)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
