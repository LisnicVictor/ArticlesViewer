import UIKit

class TagsBuilder {
    func build(with article: Article) -> TagsViewController {
        let vc = UIStoryboard(name: "Tags", bundle: .main)
            .instantiateViewController(withIdentifier: "TagsViewController") as! TagsViewController
        let interactor = TagsInteractor(article: article,
                                        view: vc,
                                        mappingSetFetcher: MappingSetFetcher(requestSender: RequestSender()),
                                        mappingFetcher: MappingFetcher(requestSender: RequestSender()))
        vc.interactor = interactor

        return vc
    }
}
