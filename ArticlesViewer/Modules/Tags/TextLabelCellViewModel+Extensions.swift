import UIKit

extension TextLableCellViewModel {
    init(tag: Tag) {
        self.text = tag.text
        self.textColor = tag.isMapped ? .black : .red
    }
}
