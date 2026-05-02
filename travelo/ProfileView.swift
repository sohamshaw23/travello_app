import SwiftUI

struct ProfileView: View {
    var body: some View {
        PixelPageScroll {
            VStack(spacing: 12) {
                PixelTopBar()

                VStack(spacing: 6) {
                    ZStack(alignment: .bottomTrailing) {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.95, green: 0.52, blue: 0.34), Color(red: 0.99, green: 0.74, blue: 0.56)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 132, height: 132)
                            .overlay(Rectangle().stroke(PixelPalette.line, lineWidth: 3))
                            .overlay {
                                AvatarPortrait()
                            }
                            .pixelCard(border: PixelPalette.ink)

                        Image(systemName: "pencil")
                            .font(.system(size: 11, weight: .black))
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .background(PixelPalette.blue)
                            .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 1.5))
                            .offset(x: 2, y: 2)
                    }

                    Text("HERO_EXPLORER_99")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundStyle(PixelPalette.blue)

                    Text("RANK: MASTER VOYAGER")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundStyle(PixelPalette.pink)
                }

                levelCard

                HStack(spacing: 8) {
                    profileBadge("tent", "FOREST DWELLER", Color(red: 0.98, green: 0.82, blue: 0.88), PixelPalette.pink)
                    profileBadge("airplane", "FREQUENT FLYER", Color(red: 0.88, green: 0.90, blue: 0.98), PixelPalette.ink)
                    profileBadge("water.waves", "WAVE RIDER", Color(red: 0.43, green: 0.69, blue: 0.96), PixelPalette.blue)
                    profileBadge("diamond", "HIDDEN GEM", Color(red: 0.60, green: 0.96, blue: 0.34), Color.green)
                }

                VStack(spacing: 8) {
                    PixelSectionTitle(title: "PREVIOUS QUESTS", trailing: "VIEW ARCHIVE (3)")

                    questCard(
                        title: "THE SILK ROAD EXPEDITION",
                        location: "KYOTO, JAPAN - OCT 2023",
                        xp: "+500 XP",
                        shots: "42 SHOTS",
                        accent: PixelPalette.line
                    )

                    questCard(
                        title: "GLACIER PEAK RAID",
                        location: "REYKJAVIK, ICELAND - JUN 2023",
                        xp: "+850 XP",
                        shots: "108 SHOTS",
                        accent: Color(red: 0.77, green: 0.81, blue: 0.94)
                    )
                }

                statBox("globe", "4/7", "CONTINENT COUNT")
                statBox("clock.arrow.circlepath", "214h", "FLIGHT HOURS")
                statBox("flame", "12w", "QUEST STREAK")
            }
            .padding(.horizontal, 12)
        }
        .background(PixelPalette.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .principal) {
                PixelScreenTitle(title: "User Profile")
            }
        }
    }

    private var levelCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("CURRENT LEVEL")
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundStyle(PixelPalette.ink.opacity(0.55))
                    Text("LEVEL 12")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(PixelPalette.ink)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("TOTAL XP")
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundStyle(PixelPalette.ink.opacity(0.55))
                    Text("14,250 / 15,000")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundStyle(Color.green)
                }
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(red: 0.94, green: 0.96, blue: 1.0))
                        .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 2))
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: proxy.size.width * 0.92)
                        .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 2))
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 10, height: 10)
                        .overlay(Rectangle().stroke(PixelPalette.ink, lineWidth: 2))
                        .offset(x: proxy.size.width * 0.88)
                }
            }
            .frame(height: 14)
        }
        .padding(10)
        .pixelCard(fill: PixelPalette.panel, border: PixelPalette.line)
    }
}

private struct AvatarPortrait: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.98, green: 0.90, blue: 0.80))
                .frame(width: 74, height: 74)
                .offset(y: -6)

            Capsule()
                .fill(Color(red: 0.87, green: 0.58, blue: 0.24))
                .frame(width: 72, height: 54)
                .offset(y: 44)

            Path { path in
                path.move(to: CGPoint(x: 34, y: 76))
                path.addQuadCurve(to: CGPoint(x: 104, y: 76), control: CGPoint(x: 69, y: 34))
                path.addLine(to: CGPoint(x: 94, y: 34))
                path.addQuadCurve(to: CGPoint(x: 44, y: 34), control: CGPoint(x: 69, y: 8))
                path.closeSubpath()
            }
            .fill(Color(red: 0.20, green: 0.63, blue: 0.73))

            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 0.18, green: 0.21, blue: 0.40))
                    .frame(width: 26, height: 22)
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 0.18, green: 0.21, blue: 0.40))
                    .frame(width: 26, height: 22)
            }
            .overlay(Rectangle().frame(width: 10, height: 3).offset(y: 1))
            .foregroundStyle(Color(red: 0.95, green: 0.71, blue: 0.24))
            .offset(y: -2)
        }
    }
}

private func profileBadge(_ icon: String, _ title: String, _ fill: Color, _ accent: Color) -> some View {
    VStack(spacing: 8) {
        Image(systemName: icon)
            .font(.system(size: 18, weight: .black))
            .foregroundStyle(accent)
        Text(title)
            .font(.system(size: 8, weight: .black, design: .monospaced))
            .foregroundStyle(accent)
            .multilineTextAlignment(.center)
            .lineLimit(2)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 72)
    .pixelCard(fill: fill, border: PixelPalette.ink)
}

private func questCard(title: String, location: String, xp: String, shots: String, accent: Color) -> some View {
    HStack(spacing: 10) {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(accent)
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.18), Color.black.opacity(0.22)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            Image(systemName: "mountain.2.fill")
                .font(.system(size: 30))
                .foregroundStyle(Color.white.opacity(0.72))
        }
        .frame(width: 92, height: 88)
        .overlay(Rectangle().stroke(PixelPalette.line, lineWidth: 1.5))

        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundStyle(PixelPalette.ink)
            Text(location)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundStyle(PixelPalette.blue)
            HStack(spacing: 8) {
                Label(xp, systemImage: "sparkles")
                    .foregroundStyle(PixelPalette.pink)
                Label(shots, systemImage: "camera")
                    .foregroundStyle(PixelPalette.blue)
            }
            .font(.system(size: 9, weight: .black, design: .monospaced))
        }
        Spacer()

        Text("COMPLETED")
            .font(.system(size: 8, weight: .black, design: .monospaced))
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 5)
            .background(Color.green.opacity(0.8))
            .overlay(Rectangle().stroke(Color.green, lineWidth: 1))
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 8)
            .padding(.trailing, 8)
    }
    .padding(6)
    .pixelCard(fill: PixelPalette.panel, border: PixelPalette.ink)
}

private func statBox(_ icon: String, _ value: String, _ label: String) -> some View {
    HStack(spacing: 10) {
        Image(systemName: icon)
            .font(.system(size: 18, weight: .black))
            .foregroundStyle(PixelPalette.blue)
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundStyle(PixelPalette.ink.opacity(0.55))
            Text(value)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(PixelPalette.ink)
        }
        Spacer()
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 10)
    .pixelCard(fill: Color(red: 0.90, green: 0.92, blue: 1.0), border: PixelPalette.ink)
}
