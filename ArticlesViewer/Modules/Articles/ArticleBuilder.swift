import UIKit

struct ArticleBuilder {
    func build() -> ArticlesViewController {
        let vc = UIStoryboard(name: "Articles", bundle: .main)
            .instantiateViewController(withIdentifier: "ArticlesViewController") as! ArticlesViewController
        let interactor = ArticlesInteractor(view: vc,
                                            articleFetcher: ArticleFetcher(requestSender: RequestSender()))
        vc.interactor = interactor

        return vc
    }
}
