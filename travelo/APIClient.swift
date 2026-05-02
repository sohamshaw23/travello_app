import Foundation

struct DestinationDTO: Decodable, Identifiable {
    let id: String
    let name: String
    let imageURL: String
    let price: String
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
        case price
        case rating
    }
}

struct CheapestRouteRequestDTO: Encodable {
    let source: String
    let destination: String
}

struct TransportOptionDTO: Decodable, Identifiable {
    let id = UUID()
    let mode: String
    let cost: String
    let time: String
    let transfers: Int
    let convenience: String
    let routeBreakdown: [String]

    enum CodingKeys: String, CodingKey {
        case mode
        case cost
        case time
        case transfers
        case convenience
        case routeBreakdown = "route_breakdown"
    }
}

struct CheapestRouteResponseDTO: Decodable {
    let options: [TransportOptionDTO]
    let bestOption: String

    enum CodingKeys: String, CodingKey {
        case options
        case bestOption = "best_option"
    }
}

struct TripDetailsDTO: Decodable {
    let tripName: String
    let durationDays: Int
    let difficulty: String
    let xpReward: Int
    let missionBriefing: String
    let requiredItems: [String]

    enum CodingKeys: String, CodingKey {
        case tripName = "trip_name"
        case durationDays = "duration_days"
        case difficulty
        case xpReward = "xp_reward"
        case missionBriefing = "mission_briefing"
        case requiredItems = "required_items"
    }
}

struct BookingRequestDTO: Encodable {
    let tripID: String
    let userID: String

    enum CodingKeys: String, CodingKey {
        case tripID = "trip_id"
        case userID = "user_id"
    }
}

struct TicketDTO: Decodable {
    let origin: String
    let destination: String
    let departureTime: String
    let seat: String
    let travelClass: String

    enum CodingKeys: String, CodingKey {
        case origin
        case destination
        case departureTime = "departure_time"
        case seat
        case travelClass = "class"
    }
}

struct BookingResponseDTO: Decodable {
    let status: String
    let ticket: TicketDTO
}

struct UserStatsDTO: Decodable {
    let continentsVisited: Int
    let flightHours: Int
    let streak: Int

    enum CodingKeys: String, CodingKey {
        case continentsVisited = "continents_visited"
        case flightHours = "flight_hours"
        case streak
    }
}

struct PreviousTripDTO: Decodable, Identifiable {
    let tripID: String
    let tripName: String
    let status: String
    let date: String

    var id: String { tripID }

    enum CodingKeys: String, CodingKey {
        case tripID = "trip_id"
        case tripName = "trip_name"
        case status
        case date
    }
}

struct UserProfileDTO: Decodable {
    let username: String
    let rank: String
    let level: Int
    let xp: Int
    let badges: [String]
    let stats: UserStatsDTO
    let previousTrips: [PreviousTripDTO]

    enum CodingKeys: String, CodingKey {
        case username
        case rank
        case level
        case xp
        case badges
        case stats
        case previousTrips = "previous_trips"
    }
}

enum APIError: Error {
    case invalidResponse
    case serverError(Int)
}

protocol TraveloAPIService {
    func fetchDestinations() async throws -> [DestinationDTO]
    func fetchRoutes(source: String, destination: String) async throws -> CheapestRouteResponseDTO
    func fetchProfile(userID: String) async throws -> UserProfileDTO
    func fetchTripDetails(tripID: String) async throws -> TripDetailsDTO
}

final class URLSessionTraveloAPIService: TraveloAPIService {
    static let shared = URLSessionTraveloAPIService()

    private let baseURL = URL(string: "http://localhost:8000")!
    private let session: URLSession
    private let decoder = JSONDecoder()
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = []
        return encoder
    }()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchDestinations() async throws -> [DestinationDTO] {
        try await get(path: "/destinations")
    }

    func fetchRoutes(source: String, destination: String) async throws -> CheapestRouteResponseDTO {
        let payload = CheapestRouteRequestDTO(source: source, destination: destination)
        return try await post(path: "/get-cheapest-route", body: payload)
    }

    func fetchTripDetails(tripID: String) async throws -> TripDetailsDTO {
        try await get(path: "/trip/\(tripID)")
    }

    func fetchProfile(userID: String) async throws -> UserProfileDTO {
        try await get(path: "/profile/\(userID)")
    }

    private func get<Response: Decodable>(path: String) async throws -> Response {
        let request = URLRequest(url: baseURL.appendingPathComponent(path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))))
        let (data, response) = try await session.data(for: request)
        return try decode(data: data, response: response)
    }

    private func post<Body: Encodable, Response: Decodable>(path: String, body: Body) async throws -> Response {
        var request = URLRequest(url: baseURL.appendingPathComponent(path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await session.data(for: request)
        return try decode(data: data, response: response)
    }

    private func decode<Response: Decodable>(data: Data, response: URLResponse) throws -> Response {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        return try decoder.decode(Response.self, from: data)
    }
}
