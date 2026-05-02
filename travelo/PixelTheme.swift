import SwiftUI

enum PixelPalette {
    static let ink = Color(
        light: UIColor(red: 0.17, green: 0.22, blue: 0.39, alpha: 1),
        dark: UIColor(red: 0.90, green: 0.93, blue: 1.0, alpha: 1)
    )
    static let blue = Color(
        light: UIColor(red: 0.17, green: 0.42, blue: 0.68, alpha: 1),
        dark: UIColor(red: 0.44, green: 0.73, blue: 1.0, alpha: 1)
    )
    static let sky = Color(
        light: UIColor(red: 0.75, green: 0.80, blue: 0.96, alpha: 1),
        dark: UIColor(red: 0.18, green: 0.24, blue: 0.39, alpha: 1)
    )
    static let background = Color(
        light: UIColor(red: 0.95, green: 0.96, blue: 1.0, alpha: 1),
        dark: UIColor(red: 0.07, green: 0.09, blue: 0.16, alpha: 1)
    )
    static let panel = Color(
        light: UIColor.white,
        dark: UIColor(red: 0.11, green: 0.14, blue: 0.24, alpha: 1)
    )
    static let lime = Color(
        light: UIColor(red: 0.53, green: 0.93, blue: 0.35, alpha: 1),
        dark: UIColor(red: 0.62, green: 0.97, blue: 0.46, alpha: 1)
    )
    static let pink = Color(
        light: UIColor(red: 0.84, green: 0.25, blue: 0.49, alpha: 1),
        dark: UIColor(red: 1.0, green: 0.47, blue: 0.67, alpha: 1)
    )
    static let gold = Color(
        light: UIColor(red: 0.94, green: 0.78, blue: 0.35, alpha: 1),
        dark: UIColor(red: 1.0, green: 0.84, blue: 0.49, alpha: 1)
    )
    static let mint = Color(
        light: UIColor(red: 0.81, green: 1.0, blue: 0.89, alpha: 1),
        dark: UIColor(red: 0.15, green: 0.28, blue: 0.22, alpha: 1)
    )
    static let line = Color(
        light: UIColor(red: 0.73, green: 0.79, blue: 0.92, alpha: 1),
        dark: UIColor(red: 0.28, green: 0.34, blue: 0.50, alpha: 1)
    )
}

struct PixelCardModifier: ViewModifier {
    let fill: Color
    let border: Color

    func body(content: Content) -> some View {
        content
            .background(fill)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(border, lineWidth: 1.8)
            )
            .shadow(color: PixelPalette.ink.opacity(0.08), radius: 3, x: 2, y: 2)
    }
}

extension View {
    func pixelCard(fill: Color = PixelPalette.panel, border: Color = PixelPalette.ink) -> some View {
        modifier(PixelCardModifier(fill: fill, border: border))
    }
}

extension Color {
    init(light: UIColor, dark: UIColor) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        })
    }
}

struct PixelSectionTitle: View {
    let title: String
    let trailing: String?

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(title)
                .font(.system(size: 15, weight: .black, design: .monospaced))
                .foregroundStyle(PixelPalette.ink)
            Spacer()
            if let trailing {
                Text(trailing)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(PixelPalette.pink)
            }
        }
    }
}

struct PixelScreenTitle: View {
    let title: String
    var brand: String? = nil

    var body: some View {
        VStack(spacing: 2) {
            Text(title.uppercased())
                .font(.system(size: 18, weight: .black, design: .monospaced))
                .tracking(1.4)
                .foregroundStyle(
                    LinearGradient(
                        colors: [PixelPalette.blue, PixelPalette.pink, PixelPalette.gold],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            if let brand {
                Text(brand.uppercased())
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .tracking(3.2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [PixelPalette.gold, PixelPalette.pink, PixelPalette.blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: PixelPalette.ink.opacity(0.08), radius: 1, x: 1, y: 1)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(PixelPalette.panel.opacity(0.94))
        .overlay(Rectangle().stroke(PixelPalette.line, lineWidth: 1.5))
    }
}

struct PixelTopBar: View {
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 10, weight: .bold))
            Text("TRAVELLO")
                .font(.system(size: 12, weight: .black, design: .monospaced))
            Spacer()
            Image(systemName: "scope")
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundStyle(PixelPalette.blue)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(PixelPalette.panel)
        .overlay(Rectangle().stroke(PixelPalette.line, lineWidth: 1.5))
    }
}

struct PixelPageScroll<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: true) {
                content
                    .frame(maxWidth: .infinity, alignment: .top)
                    .frame(minHeight: proxy.size.height, alignment: .top)
                    .padding(.bottom, 24)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}
