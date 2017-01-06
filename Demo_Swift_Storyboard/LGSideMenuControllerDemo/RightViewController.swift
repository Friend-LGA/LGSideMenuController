//
//  RightViewController.swift
//  LGSideMenuControllerDemo
//

class RightViewController: UITableViewController {
    
    private let titlesArray = ["Open Left View",
                               "",
                               "1",
                               "2",
                               "3",
                               "4",
                               "5",
                               "6",
                               "7",
                               "8",
                               "9",
                               "10"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 44.0, left: 0.0, bottom: 44.0, right: 0.0)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RightViewCell

        cell.titleLabel.text = titlesArray[indexPath.row]
        cell.titleLabel.font = UIFont.boldSystemFont(ofSize: indexPath.row == 0 ? 15.0 : 30.0)
        cell.separatorView.isHidden = (indexPath.row <= 1 || indexPath.row == titlesArray.count - 1)
        cell.isUserInteractionEnabled = (indexPath.row != 1)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 1 ? 50.0 : 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainViewController = UIApplication.shared.delegate!.window!!.rootViewController! as! MainViewController

        if indexPath.row == 0 {
            if mainViewController.isRightViewAlwaysVisibleForCurrentOrientation {
                mainViewController.showLeftView(animated: true, completionHandler: nil)
            }
            else {
                mainViewController.hideRightView(animated: true, completionHandler: {
                    mainViewController.showLeftView(animated: true, completionHandler: nil)
                })
            }
        }
        else {
            let viewController = UIViewController()
            viewController.view.backgroundColor = .white
            viewController.title = "Test \(titlesArray[indexPath.row])"

            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(viewController, animated: true)
            
            mainViewController.hideRightView(animated: true, completionHandler: nil)
        }
    }

}
