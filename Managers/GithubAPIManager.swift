func createRepository(name: String) async throws -> APIResponse {
    print("Creating repository with name: \(name)")
    // API 호출 전
    print("Request URL: \(endpoint)")
    print("Request headers: \(headers)")
    
    let response = try await // API 호출
    
    // 응답 받은 후
    print("Response status code: \(response.statusCode)")
    print("Response body: \(String(data: response.data, encoding: .utf8) ?? "no data")")
    
    return response
} 