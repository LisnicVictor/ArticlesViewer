import UIKit

protocol TagsViewControllerOutput {
    func viewDidLoad()
    func numberOfRows(in section: Int) -> Int
    func viewModel(for indexPath: IndexPath) -> TextLableCellViewModel
    func segmentValueDidChange(newValue: Int)
}

protocol TagsViewControllerInput: class {
    func reloadData()
    func setupSegment(with titles: [String])
    func setTitle(title: String)
}

class TagsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    var interactor: TagsViewControllerOutput!

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.viewDidLoad()
        tableView.register(TextLableCell.self, forCellReuseIdentifier: "cell")
    }

    @IBAction func segmentValueDidChange(_ sender: Any) {
        interactor.segmentValueDidChange(newValue: segmentControl.selectedSegmentIndex)
    }
}

extension TagsViewController: TagsViewControllerInput {
    func reloadData() {
        tableView.reloadData()
    }

    func setTitle(title: String) {
        self.title = title
    }

    func setupSegment(with titles: [String]) {
        segmentControl.removeAllSegments()
        titles.enumerated().forEach {
            segmentControl.insertSegment(withTitle: $0.element, at: $0.offset, animated: false)
        }
        segmentControl.selectedSegmentIndex = 0
    }
}

extension TagsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TextLableCell
        cell.config(with: interactor.viewModel(for: indexPath))

        return cell
    }
}
