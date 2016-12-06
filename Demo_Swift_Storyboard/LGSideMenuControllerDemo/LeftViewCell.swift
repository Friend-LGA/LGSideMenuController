//
//  LeftViewCell.swift
//  LGSideMenuControllerDemo
//

class LeftViewCell: UITableViewCell {

    @IBOutlet var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
                
        textLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
        textLabel!.textColor = .white
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        textLabel!.alpha = highlighted ? 0.5 : 1.0
    }

}
