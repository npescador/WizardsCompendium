import SwiftUI

struct MovieDetailView: View {
    let initialMovie: Movie
    @State private var viewModel: MovieDetailViewModel

    init(movie: Movie, fetchDetail: FetchMovieDetailUseCase) {
        self.initialMovie = movie
        _viewModel = State(initialValue: MovieDetailViewModel(movieID: movie.id, fetchDetail: fetchDetail))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                content
            }
            .padding()
        }
        .navigationTitle(displayTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.load()
        }
    }

    private var displayTitle: String {
        switch viewModel.state {
        case .loaded(let movie):
            return movie.title
        default:
            return initialMovie.title
        }
    }

    private var header: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue.opacity(0.2))
                .frame(height: 180)
            Image(systemName: "film")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Cargando detalle...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            VStack(spacing: 12) {
                Text(message)
                    .foregroundStyle(.secondary)
                Button("Reintentar") { viewModel.retry() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let movie):
            infoSection(movie)
        }
    }

    private func infoSection(_ movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let date = movie.releaseDate {
                labeled("Estreno", value: date.formatted(date: .abbreviated, time: .omitted))
            }
            if let summary = movie.summary {
                labeled("Sinopsis", value: summary)
            }
            if let wiki = movie.wikiURL {
                Link("Ver en Wiki", destination: wiki)
                    .font(.headline)
                    .padding(.top, 6)
            }
        }
    }

    private func labeled(_ title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
    }
}
