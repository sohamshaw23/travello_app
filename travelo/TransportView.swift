import SwiftUI

struct TransportView: View {
    @State private var source = "Sector 7 Slums"
    @State private var destination = ""
    @State private var routes: [Route] = Route.sampleRoutes

    var body: some View {
        PixelPageScroll {
            VStack(spacing: 14) {
                PixelTopBar()

                VStack(alignment: .leading, spacing: 14) {
                    Text("SET YOUR DESTINATION")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundStyle(PixelPalette.ink)

                    HStack(spacing: 10) {
                        PixelInputField(title: "SOURCE LOCATION", placeholder: "Sector 7 Slums", text: $source, icon: "location")
                        PixelInputField(title: "FINAL DESTINATION", placeholder: "Enter arrival point...", text: $destination, icon: "mappin")
                    }

                    Button {
                        fetchRoutes()
                    } label: {
                        Text("FIND CHEAPEST ROUTE")
                            .font(.system(size: 13, weight: .black, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.white)
                            .background(PixelPalette.blue)
                            .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 2))
                    }
                }
                .padding(14)
                .pixelCard(border: PixelPalette.ink)

                VStack(spacing: 12) {
                    PixelSectionTitle(title: "TRAVEL OPTIONS FOUND (\(routes.count))", trailing: "SORT BY: PRICE")

                    ForEach(routes) { route in
                        RouteCard(route: route)
                    }
                }

                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.85, green: 0.86, blue: 0.90), Color(red: 0.72, green: 0.74, blue: 0.80)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    gridOverlay
                    Rectangle()
                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                        .padding(18)

                    Text("LIVE TRAFFIC OVERLAY ACTIVE")
                        .font(.system(size: 12, weight: .black, design: .monospaced))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.88))
                        .overlay(Rectangle().stroke(PixelPalette.line, lineWidth: 2))
                }
                .frame(height: 132)
                .pixelCard(border: PixelPalette.ink)
            }
            .padding(.horizontal, 12)
        }
        .background(PixelPalette.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .principal) {
                PixelScreenTitle(title: "Transport Finder")
            }
        }
    }

    func fetchRoutes() {
        routes = Route.sampleRoutes
    }
}

private struct PixelInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(PixelPalette.ink.opacity(0.65))

            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(PixelPalette.blue)
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.words)
            }
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .padding(12)
            .background(PixelPalette.sky.opacity(0.75))
            .overlay(Rectangle().stroke(PixelPalette.ink.opacity(0.55), lineWidth: 1.5))
        }
    }
}

private struct RouteCard: View {
    let route: Route

    var accentColor: Color {
        switch route.accentName {
        case "green":
            return PixelPalette.lime
        case "blue":
            return Color(red: 0.42, green: 0.70, blue: 1.0)
        case "pink":
            return Color(red: 0.96, green: 0.79, blue: 0.86)
        default:
            return PixelPalette.sky
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Rectangle()
                        .fill(accentColor)
                        .frame(width: 62, height: 62)
                        .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 1.5))
                    Image(systemName: routeIcon)
                        .foregroundStyle(PixelPalette.ink)
                }

                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Text(route.mode)
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundStyle(PixelPalette.ink)
                        if route.mode == "Bus + Walk" {
                            Text("% CHEAPEST")
                                .font(.system(size: 9, weight: .black, design: .monospaced))
                                .foregroundStyle(Color.green)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.white)
                                .overlay(Rectangle().stroke(Color.green, lineWidth: 1))
                        }
                    }

                    HStack(spacing: 10) {
                        SearchMetric(label: "COST", value: route.cost)
                        SearchMetric(label: "TIME", value: route.time)
                        SearchMetric(label: "TRANSFERS", value: "\(route.transfers)")
                        SearchMetric(label: "CONVENIENCE", value: route.convenience)
                    }
                }

                Spacer()
            }
            .padding(12)

            if !route.path.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    if route.mode == "Bus + Walk" {
                        Text("ROUTE BREAKDOWN")
                            .font(.system(size: 9, weight: .black, design: .monospaced))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(PixelPalette.blue)
                            .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 1))
                    }
                    HStack(spacing: 6) {
                        ForEach(route.path.indices, id: \.self) { index in
                            Text(route.path[index])
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundStyle(PixelPalette.ink)
                            if index < route.path.count - 1 {
                                Text(">")
                                    .font(.system(size: 10, weight: .black, design: .monospaced))
                                    .foregroundStyle(PixelPalette.ink.opacity(0.65))
                            }
                        }
                    }

                    Text(route.note)
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .foregroundStyle(PixelPalette.ink.opacity(0.7))
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                                .foregroundStyle(PixelPalette.line)
                        )
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            } else {
                Text(route.note)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(PixelPalette.ink.opacity(0.75))
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
            }
        }
        .pixelCard(border: route.mode == "Bus + Walk" ? Color.green : PixelPalette.ink)
    }

    private var routeIcon: String {
        if route.mode.contains("Bus") {
            return "bus"
        }
        if route.mode.contains("Metro") {
            return "tram"
        }
        return "car.side"
    }
}

private struct SearchMetric: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundStyle(PixelPalette.ink.opacity(0.6))
            Text(value)
                .font(.system(size: 11, weight: .black, design: .rounded))
                .foregroundStyle(metricColor)
        }
    }

    private var metricColor: Color {
        switch value {
        case "HIGH":
            return Color.green
        case "MEDIUM":
            return PixelPalette.blue
        case "LOW":
            return PixelPalette.pink
        default:
            return PixelPalette.ink
        }
    }
}

private var gridOverlay: some View {
    GeometryReader { proxy in
        Path { path in
            let width = proxy.size.width
            let height = proxy.size.height

            stride(from: 0.0, through: width, by: 28.0).forEach { x in
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: height))
            }

            stride(from: 0.0, through: height, by: 28.0).forEach { y in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: width, y: y))
            }
        }
        .stroke(Color.white.opacity(0.24), lineWidth: 0.8)
    }
}

private extension Route {
    static let sampleRoutes: [Route] = [
        Route(
            mode: "Bus + Walk",
            cost: "$30",
            time: "45 MINS",
            transfers: 1,
            convenience: "HIGH",
            accentName: "green",
            note: "Way to victory: ultra-cheapest transport chain and short final approach to destination.",
            path: ["Walk (5m)", "Bus 402 (35m)", "Walk (5m)"]
        ),
        Route(
            mode: "Metro Rail",
            cost: "$50",
            time: "30 MINS",
            transfers: 0,
            convenience: "MEDIUM",
            accentName: "blue",
            note: "Blue Line direct sector 7 to central hub.",
            path: []
        ),
        Route(
            mode: "Auto-Rickshaw",
            cost: "$120",
            time: "20 MINS",
            transfers: 0,
            convenience: "LOW",
            accentName: "pink",
            note: "Door-to-door point pickup.",
            path: []
        )
    ]
}
