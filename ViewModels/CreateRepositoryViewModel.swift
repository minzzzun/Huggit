func createRepository() async throws {
    do {
        let response = try await githubService.createRepository(name: repositoryName)
        // 응답 상태 코드 확인
        if response.statusCode == 201 {  // GitHub API는 생성 성공시 201을 반환
            // 성공 처리
        } else {
            throw GithubAPIError.failedToCreateRepository
        }
    } catch {
        print("Repository creation error: \(error)")
        throw error
    }
} 