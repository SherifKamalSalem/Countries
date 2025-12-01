//
//  AppColors.swift
//  DesignSystem
//
//  Created by Sherif Kamal on 01/12/2025.
//


public enum AppColors {
    public static let primary = Color(hex: "1B365D")
    public static let primaryLight = Color(hex: "2D5A8E")
    public static let primaryDark = Color(hex: "0F1F38")
    
    public static let accent = Color(hex: "D4A574")
    public static let accentLight = Color(hex: "E8C9A6")
    
    public static let background = Color(hex: "F7F5F2")
    public static let backgroundSecondary = Color(hex: "FFFFFF")
    public static let backgroundCard = Color(hex: "FFFFFF")
    
    public static let textPrimary = Color(hex: "1A1A1A")
    public static let textSecondary = Color(hex: "6B6B6B")
    public static let textTertiary = Color(hex: "9A9A9A")
    
    public static let success = Color(hex: "4CAF50")
    public static let error = Color(hex: "E53935")
    public static let warning = Color(hex: "FF9800")
    
    public static let divider = Color(hex: "E0E0E0")
    public static let shadow = Color.black.opacity(0.08)
}

extension Color {
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

