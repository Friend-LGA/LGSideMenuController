//
//  RightViewCell.swift
//  LGSideMenuControllerDemo
//

class RightViewCell: UITableViewCell {

    @IBOutlet var separatorView: UIView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        backgroundColor = .clear

        textLabel!.textAlignment = .center
        textLabel!.numberOfLines = 0
        textLabel!.lineBreakMode = .byWordWrapping
        textLabel!.textColor = .white

        // -----

        separatorView = UIView()
        separatorView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        addSubview(separatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel!.frame.origin.x = 8.0
        textLabel!.frame.size.width = self.frame.width - 16.0

        let height = UIScreen.main.scale == 1.0 ? 1.0 : 0.5 as CGFloat

        separatorView.frame = CGRect(x: frame.size.width*0.1, y: frame.size.height-height, width: frame.size.width*0.9, height: height)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        textLabel!.alpha = highlighted ? 0.5 : 1.0
    }
    
}
