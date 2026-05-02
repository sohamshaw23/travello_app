import SwiftUI

struct TripView: View {
    var body: some View {
        PixelPageScroll {
            VStack(spacing: 14) {
                PixelTopBar()

                heroBanner

                HStack(spacing: 8) {
                    TripStatCard(label: "DURATION", value: "05", unit: "DAYS", accent: PixelPalette.background)
                    TripStatCard(label: "DIFFICULTY", value: "EASY", unit: nil, accent: Color(red: 0.92, green: 1.0, blue: 0.92))
                    TripStatCard(label: "EXP REWARD", value: "+2500", unit: "PTS", accent: Color(red: 1.0, green: 0.87, blue: 0.91))
                }

                VStack(alignment: .leading, spacing: 12) {
                    Label("MISSION BRIEFING", systemImage: "doc.text")
                        .font(.system(size: 13, weight: .black, design: .monospaced))
                        .foregroundStyle(PixelPalette.ink)
                    Text("Infiltrate the neon-soaked labyrinth of Neo-Shinjuku. Your objective involves navigating the high-speed MagLev networks, decoding hidden ramen stalls in Akihabara, and securing safe passage through the Shibuya Crossing singularity. This journey requires high mental bandwidth and a penchant for digital aesthetics.")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(PixelPalette.ink.opacity(0.75))
                        .lineSpacing(3)
                }
                .padding(14)
                .pixelCard(fill: PixelPalette.background, border: PixelPalette.line)

                HStack(alignment: .top, spacing: 10) {
                    GridCoordinatesCard()
                    ItemsToBringCard()
                }

                NavigationLink {
                    BookingView()
                } label: {
                    Text("JOIN QUEST")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .frame(maxWidth: 170)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                        .background(PixelPalette.blue)
                        .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 2))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            }
            .padding(.horizontal, 12)
        }
        .background(PixelPalette.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .principal) {
                PixelScreenTitle(title: "Trip Details")
            }
        }
    }

    private var heroBanner: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.04, green: 0.13, blue: 0.19), Color(red: 0.16, green: 0.49, blue: 0.54)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 138)
                    .overlay {
                        HStack(spacing: 10) {
                            ForEach(0..<4) { _ in
                                Rectangle()
                                    .fill(Color.black.opacity(0.33))
                                    .frame(maxHeight: .infinity)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 18)
                    }
                    .overlay(alignment: .leading) {
                        Text("東京\n現光むと")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.leading, 92)
                    }
                    .overlay(alignment: .topTrailing) {
                        Text("LVL: EXPERT")
                            .font(.system(size: 8, weight: .black, design: .monospaced))
                            .foregroundStyle(PixelPalette.ink)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .background(PixelPalette.lime)
                            .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 1))
                            .padding(10)
                    }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("QUEST: CYBER-TOKYO")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Text("S-Rank urban infiltration")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.white.opacity(0.75))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(PixelPalette.blue)
        }
        .pixelCard(border: PixelPalette.ink)
    }
}

private struct TripStatCard: View {
    let label: String
    let value: String
    let unit: String?
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundStyle(PixelPalette.ink.opacity(0.6))
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundStyle(statColor)
                if let unit {
                    Text(unit)
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundStyle(PixelPalette.ink.opacity(0.8))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .pixelCard(fill: accent, border: PixelPalette.line)
    }

    private var statColor: Color {
        if label == "EXP REWARD" {
            return PixelPalette.pink
        }
        if label == "DIFFICULTY" {
            return Color.green
        }
        return PixelPalette.blue
    }
}

private struct GridCoordinatesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("GRID COORDINATES", systemImage: "map")
                .font(.system(size: 12, weight: .black, design: .monospaced))
                .foregroundStyle(PixelPalette.ink)

            ZStack {
                Rectangle()
                    .fill(Color(red: 0.80, green: 0.81, blue: 0.86))
                Path { path in
                    path.move(to: CGPoint(x: 22, y: 22))
                    path.addLine(to: CGPoint(x: 126, y: 96))
                    path.addLine(to: CGPoint(x: 94, y: 168))
                    path.addLine(to: CGPoint(x: 40, y: 142))
                    path.closeSubpath()
                }
                .fill(Color.white.opacity(0.18))

                Path { path in
                    let width: CGFloat = 160
                    let height: CGFloat = 210
                    stride(from: 0.0, through: width, by: 24.0).forEach { x in
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                    stride(from: 0.0, through: height, by: 24.0).forEach { y in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(Color.white.opacity(0.22), style: StrokeStyle(lineWidth: 0.6, dash: [2, 4]))

                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 14, height: 14)
                    .overlay(Rectangle().stroke(PixelPalette.pink, lineWidth: 2))
                    .offset(x: -8, y: 12)
            }
            .frame(height: 210)
            .overlay(alignment: .bottomLeading) {
                Text("ZONE: 26-A / HUB NODE")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundStyle(PixelPalette.ink.opacity(0.65))
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.25))
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .pixelCard(fill: PixelPalette.background, border: PixelPalette.line)
    }
}

private struct ItemsToBringCard: View {
    var items: [(String, String, Bool)] = [
        ("bolt.fill", "UNIVERSAL POWER CELL", true),
        ("creditcard", "SUICA META-CARD", false),
        ("translate", "NEURAL TRANSLATOR", false)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("ITEMS TO BRING", systemImage: "shippingbox")
                .font(.system(size: 12, weight: .black, design: .monospaced))
                .foregroundStyle(PixelPalette.ink)

            ForEach(items, id: \.1) { item in
                HStack(spacing: 10) {
                    Image(systemName: item.0)
                        .frame(width: 26, height: 26)
                        .background(PixelPalette.blue)
                        .foregroundStyle(.white)
                    Text(item.1)
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundStyle(PixelPalette.ink)
                    Spacer()
                    Image(systemName: item.2 ? "checkmark.square.fill" : "square")
                        .foregroundStyle(item.2 ? Color.green : PixelPalette.line)
                }
                .padding(8)
                .overlay(Rectangle().stroke(PixelPalette.line, lineWidth: 1.5))
            }
            Spacer(minLength: 0)
        }
        .padding(8)
        .frame(maxWidth: .infinity, minHeight: 262, alignment: .top)
        .pixelCard(fill: PixelPalette.panel, border: PixelPalette.line)
    }
}

struct BookingView: View {
    var body: some View {
        PixelPageScroll {
            VStack(spacing: 14) {
                PixelTopBar()

                VStack(spacing: 8) {
                    Text("LEVEL COMPLETE: TRIP SECURED")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(PixelPalette.blue)
                        .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 2))

                    Text("YOUR QUEST LOG HAS BEEN UPDATED")
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundStyle(PixelPalette.ink.opacity(0.5))
                }

                BoardingPassCard()

                HStack(spacing: 10) {
                    TicketActionButton(label: "PRINT TICKET", icon: "printer", fill: PixelPalette.blue)
                    TicketActionButton(label: "ADD TO WALLET", icon: "wallet.pass", fill: Color.green.opacity(0.85))
                }

                HStack(spacing: 12) {
                    TicketInfoCard(title: "XP EARNED") {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("+850 MILES", systemImage: "checkmark.circle.fill")
                                .font(.system(size: 11, weight: .black, design: .monospaced))
                                .foregroundStyle(Color.green)
                            ProgressView(value: 0.74)
                                .tint(Color.green)
                            Text("LVL +1%")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundStyle(PixelPalette.ink.opacity(0.65))
                        }
                    }
                    TicketInfoCard(title: "EQUIPMENT") {
                        HStack(spacing: 8) {
                            ForEach(["bag", "fork.knife", "ticket"], id: \.self) { symbol in
                                Image(systemName: symbol)
                                    .frame(width: 28, height: 28)
                                    .overlay(Rectangle().stroke(PixelPalette.line, lineWidth: 1.5))
                            }
                        }
                        .foregroundStyle(PixelPalette.ink)
                    }
                    TicketInfoCard(title: "MAP DATA") {
                        Text("NEO-TKO temp overclocked 14 deg fahren, route discovered near pax hotel.")
                            .font(.system(size: 9, weight: .medium, design: .monospaced))
                            .foregroundStyle(PixelPalette.ink.opacity(0.7))
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .background(PixelPalette.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .principal) {
                PixelScreenTitle(title: "Booking/Ticket")
            }
        }
    }
}

private struct BoardingPassCard: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("BOARDING PASS")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Text("VOYAGER ID: PX-749-DELTA")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.white.opacity(0.75))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("GATE 08-B")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Text("ZONE 1")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color.white.opacity(0.75))
                }
            }
            .padding(16)
            .background(PixelPalette.pink)

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    ticketRow(label: "ORIGIN", main: "NEO-TKO", sub: "CYBER-AIRPORT A1")

                    HStack(spacing: 16) {
                        ticketMiniInfo(label: "DATE OF DEPARTURE", value: "24 OCT 20XX")
                        ticketMiniInfo(label: "SEAT ASSIGNMENT", value: "12-F [WINDOW]")
                    }

                    HStack(spacing: 16) {
                        ticketMiniInfo(label: "FLIGHT CLASS", value: "ELITE EXPLORER", valueColor: Color.green)
                        ticketMiniInfo(label: "BOARDING TIME", value: "08:45 AM")
                    }
                }

                ZStack {
                    Rectangle()
                        .fill(Color(red: 0.92, green: 0.93, blue: 1.0))
                        .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 2))
                    VStack(spacing: 10) {
                        Text("QR QUEST KEY")
                            .font(.system(size: 8, weight: .black, design: .monospaced))
                            .foregroundStyle(PixelPalette.ink)
                        Image(systemName: "qrcode")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 84, height: 84)
                            .foregroundStyle(PixelPalette.ink)
                        Text("7762 0921 8821")
                            .font(.system(size: 7, weight: .bold, design: .monospaced))
                            .foregroundStyle(PixelPalette.ink.opacity(0.75))
                    }
                    .padding(12)
                }
                .frame(width: 128, height: 174)
            }
            .padding(16)
            .background(Color.white)
        }
        .pixelCard(border: PixelPalette.ink)
    }

    private func ticketRow(label: String, main: String, sub: String) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundStyle(PixelPalette.ink.opacity(0.55))
                Text(main)
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(PixelPalette.blue)
                Text(sub)
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .foregroundStyle(PixelPalette.ink.opacity(0.75))
            }

            Spacer()
            Image(systemName: "airplane")
                .font(.system(size: 22, weight: .black))
                .foregroundStyle(PixelPalette.blue)
            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("DESTINATION")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundStyle(PixelPalette.ink.opacity(0.55))
                Text("LDN-2.0")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(PixelPalette.blue)
                Text("GRID-CENTRAL")
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .foregroundStyle(PixelPalette.ink.opacity(0.75))
            }
        }
        .padding(.bottom, 16)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(PixelPalette.line)
                .frame(height: 2)
        }
    }

    private func ticketMiniInfo(label: String, value: String, valueColor: Color = PixelPalette.ink) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 7, weight: .bold, design: .monospaced))
                .foregroundStyle(PixelPalette.ink.opacity(0.55))
            Text(value)
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(valueColor)
        }
    }
}

private struct TicketActionButton: View {
    let label: String
    let icon: String
    let fill: Color

    var body: some View {
        Button {} label: {
            Label(label, systemImage: icon)
                .font(.system(size: 12, weight: .black, design: .monospaced))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(.white)
                .background(fill)
                .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 2))
        }
    }
}

private struct TicketInfoCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(PixelPalette.ink)
            content
        }
        .frame(maxWidth: .infinity, minHeight: 98, alignment: .topLeading)
        .padding(12)
        .pixelCard(fill: PixelPalette.panel, border: PixelPalette.line)
    }
}
