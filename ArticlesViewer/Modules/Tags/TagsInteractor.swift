import Foundation

struct Tag {
    let text: String
    let isMapped: Bool
}

class TagsInteractor: TagsViewControllerOutput {
    weak var view: TagsViewControllerInput?
    let mappingSetFetcher: MappingSetFetching
    let mappingFetcher: MappingFetcher
    let article: Article

    var mappingSets = [MappingSet]()
    var cacheTags = [String: [Tag]]()

    var tags = [Tag]()

    init(article: Article,
         view: TagsViewControllerInput,
         mappingSetFetcher: MappingSetFetching,
         mappingFetcher: MappingFetcher) {
        self.article = article
        self.view = view
        self.mappingSetFetcher = mappingSetFetcher
        self.mappingFetcher = mappingFetcher
    }

    func viewDidLoad() {
        fetchMappingSets()
        view?.setTitle(title: article.name)
    }

    func numberOfRows(in section: Int) -> Int {
        return tags.count
    }

    func viewModel(for indexPath: IndexPath) -> TextLableCellViewModel {
        return TextLableCellViewModel(tag: tags[indexPath.row])
    }

    func segmentValueDidChange(newValue: Int) {
        fetchMapping(with: mappingSets[newValue].uuid)
    }
}

extension TagsInteractor {
    private func fetchMappingSets() {
        mappingSetFetcher.fecthMappingSet { [weak self] result in
            switch result {
            case .success(let mappingSets):
                self?.handleSuccess(with: mappingSets)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func handleSuccess(with mappingSets: [MappingSet]) {
        self.mappingSets = mappingSets

        DispatchQueue.main.async {
            self.view?.setupSegment(with: mappingSets.map { $0.name } )
        }

        fetchMapping(with: mappingSets[0].uuid)
    }

    private func fetchMapping(with uuid: String) {
        if let cachedTags = cacheTags[uuid] { return updateTags(tags: cachedTags) }
        mappingFetcher.fecthMapping(with: uuid) { [weak self] result in
            switch result {
            case .success(let mappings):
                self?.hanldleSuccess(with: mappings, uuid: uuid)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func hanldleSuccess(with mapping: [Mapping], uuid: String) {
        let tags = map(tags: article.tags, mappings: mapping)
        self.cacheTags[uuid] = tags
        updateTags(tags: tags)
    }

    private func updateTags(tags: [Tag]) {
        self.tags = tags

        DispatchQueue.main.async {
            self.view?.reloadData()
        }
    }

    private func map(tags: [String], mappings: [Mapping]) -> [Tag] {
        var tags = Set(tags)
        let sortedMappings = mappings.sorted { $0.sourceTags.count > $1.sourceTags.count }
        var result = [Mapping]()

        sortedMappings.forEach {
            let targetTags = Set($0.sourceTags)
            if targetTags.isSubset(of: tags) {
                tags.subtract(targetTags)
                result.append($0)

                return
            }
        }

        let leftovers = tags.map { Tag(text: $0, isMapped: false) }

        return result.sorted { $0.sortingOrder < $1.sortingOrder }
            .map { $0.destinationValue }
            .map { Tag(text: $0, isMapped: true) } + leftovers
    }
}
