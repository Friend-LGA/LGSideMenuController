//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//

class LeftViewController: UITableViewController {

    private let titlesArray = ["Open Right View",
                               "",
                               "Change Root VC",
                               "",
                               "Profile",
                               "News",
                               "Articles",
                               "Video",
                               "Music"]

    init() {
        super.init(style: .plain)

        view.backgroundColor = .clear

        tableView.register(LeftViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 44.0, left: 0.0, bottom: 44.0, right: 0.0)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeftViewCell

        cell.textLabel!.text = titlesArray[indexPath.row]
        cell.separatorView.isHidden = (indexPath.row <= 3 || indexPath.row == self.titlesArray.count-1)
        cell.isUserInteractionEnabled = (indexPath.row != 1 && indexPath.row != 3)

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sideMenuController = sideMenuController else { return }

        if indexPath.row == 0 {
            if sideMenuController.isLeftViewAlwaysVisibleForCurrentOrientation {
                sideMenuController.showRightView(animated: true, completionHandler: nil)
            }
            else {
                sideMenuController.hideLeftView(animated: true, completionHandler: {
                    sideMenuController.showRightView(animated: true, completionHandler: nil)
                })
            }
        }
        else if indexPath.row == 2 {
            if let navigationController = sideMenuController.rootViewController as? NavigationController {
                navigationController.setViewControllers([ViewController()], animated: false)
            }

            sideMenuController.hideLeftView(animated: true, completionHandler: nil)
        }
        else {
            let viewController = UIViewController()
            viewController.view.backgroundColor = (isLightTheme() ? .white : .black)
            viewController.title = "Test \(titlesArray[indexPath.row])"

            if let navigationController = sideMenuController.rootViewController as? NavigationController {
                navigationController.pushViewController(viewController, animated: true)
            }

            sideMenuController.hideLeftView(animated: true, completionHandler: nil)
        }
    }

}
