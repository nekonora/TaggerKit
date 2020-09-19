//
//  RootViewController.swift
//  TaggerKit_Example
//
//  Created by Filippo Zaffoni on 01/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if #available(iOS 13, *) {
                guard let vc = storyboard?.instantiateViewController(withIdentifier: "SingleTagViewVC") else { return }
                navigationController?.pushViewController(vc, animated: true)
            } else {
                showUnavailableAlert()
            }
        case 1:
            if #available(iOS 13, *) {
                guard let vc = storyboard?.instantiateViewController(withIdentifier: "TagsInTableViewCells") else { return }
                navigationController?.pushViewController(vc, animated: true)
            } else {
                showUnavailableAlert()
            }
        case 2:
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "TKCollectionViewVC") else { return }
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    private func showUnavailableAlert() {
        let ac = UIAlertController(
            title: "Unavailable on iOS 12",
            message: "This API is not available prior to iOS 13, if you need to support iOS 12, you can refer to the old APIs in TKCollectionView",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "Ok :(", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
}
