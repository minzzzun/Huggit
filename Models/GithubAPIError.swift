enum GithubAPIError: Error {
    case failedToCreateRepository
    case invalidResponse
    case networkError(Error)
    case unauthorized
    
    var localizedDescription: String {
        switch self {
        case .failedToCreateRepository:
            return "저장소 생성에 실패했습니다."
        case .invalidResponse:
            return "잘못된 응답을 받았습니다."
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .unauthorized:
            return "인증에 실패했습니다."
        }
    }
} 