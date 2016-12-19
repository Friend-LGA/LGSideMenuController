//
//  RightViewCell.swift
//  LGSideMenuControllerDemo
//

class RightViewCell: UITableViewCell {

    @IBOutlet var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
                
        textLabel!.textAlignment = .center
        textLabel!.numberOfLines = 0
        textLabel!.lineBreakMode = .byWordWrapping
        textLabel!.textColor = .white
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        textLabel!.alpha = highlighted ? 0.5 : 1.0
    }
    
}
