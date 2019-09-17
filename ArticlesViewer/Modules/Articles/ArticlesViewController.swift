import Foundation
import UIKit

protocol ArticlesViewControllerOutput {
    func viewDidLoad()
    func numberOfRows(in section: Int) -> Int
    func viewModel(for indexPath: IndexPath) -> TextLableCellViewModel
    func didSelectItem(at indexPath: IndexPath)
}

protocol ArticlesViewControllerInput: class {
    func reloadData()
    func routeToTags(with article: Article)
}

class ArticlesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var interactor: ArticlesViewControllerOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Articles"
        interactor.viewDidLoad()
        tableView.register(TextLableCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ArticlesViewController: ArticlesViewControllerInput {
    func reloadData() {
        tableView.reloadData()
    }

    func routeToTags(with article: Article) {
        let vc = TagsBuilder().build(with: article)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.didSelectItem(at: indexPath)
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TextLableCell
        cell.config(with: interactor.viewModel(for: indexPath))

        return cell
    }
}
