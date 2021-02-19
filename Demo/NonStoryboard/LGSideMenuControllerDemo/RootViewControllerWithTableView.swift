//
//  RootViewControllerWithTableView.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

private let cellIdentifier = "cell"

class RootViewControllerWithTableView: RootViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView
    private var numberOfCells: Int = 100

    override init() {
        self.tableView = UITableView()

        super.init()

        self.automaticallyAdjustsScrollViewInsets = false

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        self.view.addSubview(self.tableView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let buttonHeight: CGFloat = 44.0
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? .zero
        let statusBarHeight = UIApplication.shared.statusBarFrame.height

        self.tableView.frame = CGRect(x: 0.0,
                                      y: statusBarHeight + navigationBarHeight,
                                      width: self.view.frame.size.width,
                                      height: self.view.frame.size.height - statusBarHeight - navigationBarHeight - buttonHeight)
    }

    override func setColors() {
        super.setColors()
        self.tableView.backgroundColor = UIColor(white: (isLightTheme() ? 1.0 : 0.0), alpha: 0.5)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfCells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        cell.accessoryType = .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel?.text = "You can delete me by swiping"
        cell.backgroundColor = .clear

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.numberOfCells -= 1
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
