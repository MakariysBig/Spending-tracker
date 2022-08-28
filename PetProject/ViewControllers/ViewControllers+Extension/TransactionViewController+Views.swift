import UIKit

extension TransactionViewController {
    final class Views {
        
        //MARK: - Properties
        
        let yourBalanceLabel = UILabel()
        let calculateAmountLabel = UILabel()
        let tableView = UITableView()
        let searchBar = UISearchBar()
        
        //MARK: - Methods
        
        func loadViews(_ view: UIView) {
            setUpYourBalanceLayout(view)
            setUpCalculateAmountLayout(view)
            setUpTableViewLayout(view)
            setUpSearchBarLayout()
        }
        
        //MARK: - Private methods
        
        private func setUpSearchBarLayout() {
            searchBar.searchBarStyle = .default
            searchBar.placeholder = "Search for note"
            searchBar.sizeToFit()
            tableView.tableHeaderView = searchBar
        }
        
        private func setUpTableViewLayout(_ view: UIView) {
            view.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
        
        private func setUpYourBalanceLayout(_ view: UIView) {
            view.addSubview(yourBalanceLabel)
            yourBalanceLabel.textColor = .black
            yourBalanceLabel.backgroundColor = .white
            yourBalanceLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
            yourBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                yourBalanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                yourBalanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                yourBalanceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
                yourBalanceLabel.heightAnchor.constraint(equalToConstant: 28)
            ])
        }
        
        private func setUpCalculateAmountLayout(_ view: UIView) {
            view.addSubview(calculateAmountLabel)
            calculateAmountLabel.textColor = .black
            calculateAmountLabel.backgroundColor = .white
            calculateAmountLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
            calculateAmountLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                calculateAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                calculateAmountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                calculateAmountLabel.topAnchor.constraint(equalTo: yourBalanceLabel.bottomAnchor),
                calculateAmountLabel.heightAnchor.constraint(equalToConstant: 28)
            ])
        }
    }
}
