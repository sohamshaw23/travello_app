import SwiftUI

struct HomeView: View {
    var body: some View {
        PixelPageScroll {
            VStack(spacing: 14) {
                PixelTopBar()

                homeHeroBanner

                VStack(spacing: 12) {
                    PixelSectionTitle(title: "TRENDING REALMS", trailing: "VIEW FULL MAP")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            DestinationCard(
                                tag: "HOT EVENT",
                                tagColor: PixelPalette.pink,
                                title: "NEO TOKYO",
                                price: "$1,840",
                                rating: "4.8",
                                icon: "sparkles"
                            )
                            DestinationCard(
                                tag: nil,
                                tagColor: PixelPalette.blue,
                                title: "CITY OF LIGHTS",
                                price: "$980",
                                rating: "4.7",
                                icon: "fleuron"
                            )
                            DestinationCard(
                                tag: "BEST GETAWAY",
                                tagColor: Color.green,
                                title: "PIXEL ISLES",
                                price: "$760",
                                rating: "4.9",
                                icon: "sun.max"
                            )
                        }
                    }
                }

                equipSection
            }
            .padding(.horizontal, 12)
        }
        .background(PixelPalette.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .principal) {
                PixelScreenTitle(title: "Home/Discovery")
            }
        }
    }

    private var homeHeroBanner: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 0)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.32, green: 0.58, blue: 0.63),
                            Color(red: 0.18, green: 0.33, blue: 0.56)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 205)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.black.opacity(0.15))
                        .frame(height: 36)
                }
                .overlay {
                    HStack {
                        mountainShape
                        Spacer()
                        mountainShape.scaleEffect(x: -1, y: 1)
                    }
                }
                .pixelCard(border: PixelPalette.line)

            VStack(spacing: 10) {
                Text("YOUR NEXT\nADVENTURE AWAITS")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)

                Text("[R_P / VXP / FKT-ONLINE]")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.white.opacity(0.8))

                Button("START YOUR QUEST") {}
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
                    .foregroundStyle(.white)
                    .background(Color.green)
                    .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 2))
            }
        }
    }

    private var equipSection: some View {
        HStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 112)
                Circle()
                    .fill(PixelPalette.blue.opacity(0.15))
                    .frame(width: 62, height: 62)
                Image(systemName: "location.north.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(PixelPalette.blue)
            }
            .frame(maxHeight: .infinity)
            .pixelCard(fill: PixelPalette.background, border: PixelPalette.blue)

            VStack(alignment: .leading, spacing: 10) {
                Text("EQUIP YOUR CHARACTER")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(PixelPalette.ink)
                Text("Pick the load-out before you warp. Tokens, quest map, and power pack stack directly into the travel kit slot.")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundStyle(PixelPalette.ink.opacity(0.8))

                HStack(spacing: 8) {
                    SmallLoadoutChip(label: "MISSION MAP", icon: "map")
                    SmallLoadoutChip(label: "JET BOOST", icon: "airplane")
                }
            }
            .padding(16)
            .pixelCard(border: PixelPalette.line)
        }
        .frame(height: 138)
    }

    private var mountainShape: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 180))
            path.addLine(to: CGPoint(x: 54, y: 82))
            path.addLine(to: CGPoint(x: 92, y: 132))
            path.addLine(to: CGPoint(x: 134, y: 58))
            path.addLine(to: CGPoint(x: 168, y: 180))
        }
        .fill(Color(red: 0.22, green: 0.42, blue: 0.40).opacity(0.95))
        .frame(width: 168, height: 180)
        .offset(y: 26)
    }
}

private struct DestinationCard: View {
    let tag: String?
    let tagColor: Color
    let title: String
    let price: String
    let rating: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 0)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.72, green: 0.82, blue: 0.92), Color.white],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 110)
                    .overlay(alignment: .center) {
                        Image(systemName: icon)
                            .font(.system(size: 36))
                            .foregroundStyle(PixelPalette.ink.opacity(0.9))
                    }
                if let tag {
                    Text(tag)
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(tagColor)
                        .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 1))
                        .padding(8)
                }
            }

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundStyle(PixelPalette.ink)
                    Text("Quest-ready city run with curated landmarks and fast travel checkpoints.")
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .foregroundStyle(PixelPalette.ink.opacity(0.8))
                        .lineLimit(3)
                }
                Spacer()
                Text("xp \(rating)")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.green)
            }

            HStack {
                Text(price)
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(PixelPalette.blue)
                Spacer()
                Button {} label: {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .black))
                        .foregroundStyle(.white)
                        .frame(width: 26, height: 26)
                        .background(PixelPalette.blue)
                        .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 1))
                }
            }
        }
        .padding(9)
        .frame(width: 198)
        .pixelCard(border: PixelPalette.line)
    }
}

private struct SmallLoadoutChip: View {
    let label: String
    let icon: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(label)
        }
        .font(.system(size: 10, weight: .black, design: .monospaced))
        .foregroundStyle(PixelPalette.ink)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .overlay(Rectangle().stroke(PixelPalette.line, lineWidth: 2))
    }
}
