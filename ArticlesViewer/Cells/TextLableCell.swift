import UIKit

struct TextLableCellViewModel {
    let text: String
    let textColor: UIColor

    init(text: String,
         textColor: UIColor = .black) {
        self.text = text
        self.textColor = textColor
    }
}

class TextLableCell: UITableViewCell {
    func config(with viewModel: TextLableCellViewModel) {
        textLabel?.text = viewModel.text
        textLabel?.textColor = viewModel.textColor
    }
}
