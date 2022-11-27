import Foundation

protocol BaseResponse {
    var success: Bool { get }
    var status: Int? { get }
    var message: String? { get }
}

struct MessageResponse: BaseResponse, Decodable {
    let success: Bool
    let status: Int?
    let message: String?
}
