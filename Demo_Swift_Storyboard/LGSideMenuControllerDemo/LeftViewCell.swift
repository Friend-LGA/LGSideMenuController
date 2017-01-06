//
//  LeftViewCell.swift
//  LGSideMenuControllerDemo
//

class LeftViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        titleLabel.alpha = highlighted ? 0.5 : 1.0
    }

}
