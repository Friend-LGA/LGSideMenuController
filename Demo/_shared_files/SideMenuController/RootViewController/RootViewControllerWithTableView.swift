//
//  RootViewControllerWithTableView.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

private let cellIdentifier = "cell"

class RootViewControllerWithTableView: RootViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private var rowNumbers = Array(1...100)

    private let tableViewBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        // For iOS < 11.0 use this property to avoid artefacts if necessary
        // automaticallyAdjustsScrollViewInsets = false

        view.insertSubview(tableViewBackgroundView, aboveSubview: imageView)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .clear
        view.insertSubview(tableView, aboveSubview: tableViewBackgroundView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.contentOffset = {
            let safeAreaLayoutFrame = view.safeAreaLayoutGuide.layoutFrame
            let topOffset = demoDescriptionBackgroundView?.frame.maxY ?? safeAreaLayoutFrame.minY
            return CGPoint(x: 0.0, y: -topOffset)
        }()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        tableViewBackgroundView.frame = view.bounds

        let safeAreaLayoutFrame = view.safeAreaLayoutGuide.layoutFrame

        tableView.frame = view.bounds
        tableView.contentInset = {
            let topInset = demoDescriptionBackgroundView?.frame.maxY ?? safeAreaLayoutFrame.minY
            return UIEdgeInsets(top: topInset, left: 0.0, bottom: buttonBackground.bounds.height, right: 0.0)
        }()
        tableView.scrollIndicatorInsets = {
            let topInset = demoDescriptionBackgroundView != nil ?
                demoDescriptionBackgroundView!.frame.maxY - safeAreaLayoutFrame.minY : 0.0
            return UIEdgeInsets(top: topInset, left: 0.0, bottom: buttonBackground.bounds.height, right: 0.0)
        }()
    }

    // MARK: - UITableViewDataSource -

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNumbers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let rowNumber = rowNumbers[indexPath.row]

        cell.textLabel?.text = "Row number \(rowNumber)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.textLabel?.textColor = isLightTheme() ? .black : .white
        cell.backgroundColor = .clear

        return cell
    }

    // MARK: - UITableViewDelegate -

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            rowNumbers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Other -

    override func setColors() {
        super.setColors()
        tableView.reloadData()
    }
    
}
