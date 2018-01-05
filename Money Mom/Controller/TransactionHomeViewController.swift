import UIKit
import AVFoundation
import CoreData

protocol UnderstandHowToCreateTransaction {
    func userWannaCreateTransactionFrom(quickRecord: QuickRecord)
}

class TransactionHomeViewController: UIViewController {
    override var title: String? {
        get {
            return super.title ?? "收支記錄"
        }
        set {
            super.title = newValue
        }
    }

    lazy var transactionTableView: TransactionTableView = {
        var tableView = TransactionTableView()
        tableView.dataSource = self
        return tableView
    }()

    lazy var fetchedResultsController: NSFetchedResultsController<Transaction> = {
        let request = NSFetchRequest<Transaction>(entityName: String(describing: Transaction.self))
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Transaction.createdAt), ascending: false)]
        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer!.viewContext
        let fetchedResultsController = NSFetchedResultsController<Transaction>(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = MMColor.white

//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showQuickCreateViewController))

        view.addSubview(transactionTableView)
        transactionTableView.translatesAutoresizingMaskIntoConstraints = false
        transactionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        transactionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        transactionTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        transactionTableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        try! fetchedResultsController.performFetch()
    }

//    @objc func showQuickCreateViewController() {
//        navigationController?.pushViewController(QuickCreateViewController(), animated: true)
//    }
}

extension TransactionHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let transactions = fetchedResultsController.fetchedObjects else {
            return 0
        }

        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView as! TransactionTableView).dequeueReusableCell(for: indexPath)

        cell.transaction = fetchedResultsController.object(at: indexPath)
        cell.delegate = self

        return cell
    }
}

extension TransactionHomeViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        transactionTableView.reloadData()
    }
}

extension TransactionHomeViewController: TransactionTableViewCellDelegate {
    func userWannaEdit(transaction: Transaction) {
        dump("bla bla bla...")
    }
}

extension TransactionHomeViewController: UnderstandHowToCreateTransaction {
    func userWannaCreateTransactionFrom(quickRecord: QuickRecord) {
        navigationController?.pushViewController(CreateTransactionViewController(quickRecord: quickRecord), animated: true)
    }
}