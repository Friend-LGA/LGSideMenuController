//
//  RightViewCell.swift
//  LGSideMenuControllerDemo
//

class RightViewCell: UITableViewCell {

    @IBOutlet var separatorView: UIView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.backgroundColor = .clear

        self.textLabel!.textAlignment = .center
        self.textLabel!.numberOfLines = 0
        self.textLabel!.lineBreakMode = .byWordWrapping
        self.textLabel!.textColor = .white

        // -----

        self.separatorView = UIView()
        self.separatorView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        addSubview(self.separatorView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.textLabel!.frame.origin.x = 8.0
        self.textLabel!.frame.size.width = self.frame.width - 16.0

        let height = UIScreen.main.scale == 1.0 ? 1.0 : 0.5 as CGFloat
        self.separatorView.frame = CGRect(x: frame.size.width * 0.1, y: frame.size.height - height, width: frame.size.width * 0.9, height: height)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.textLabel!.alpha = highlighted ? 0.5 : 1.0
    }

}
