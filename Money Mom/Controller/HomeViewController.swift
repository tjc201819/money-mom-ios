import UIKit
import AVFoundation
import CoreData

class HomeViewController: UIViewController {
    lazy var quickRecordTableView: QuickRecordTableView = {
        var tableView = QuickRecordTableView()
        tableView.dataSource = self
        return tableView
    }()

    lazy var fetchedResultsController: NSFetchedResultsController<QuickRecord> = {
        let request = NSFetchRequest<QuickRecord>(entityName: "QuickRecord")
        request.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]
        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer!.viewContext
        let fetchedResultsController = NSFetchedResultsController<QuickRecord>(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = MMColor.white

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showQuickCreateViewController))

        view.addSubview(quickRecordTableView)
        quickRecordTableView.translatesAutoresizingMaskIntoConstraints = false
        quickRecordTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        quickRecordTableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        quickRecordTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        quickRecordTableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        try! fetchedResultsController.performFetch()
    }

    @objc func showQuickCreateViewController() {
        navigationController?.pushViewController(QuickCreateViewController(), animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let quickRecords = fetchedResultsController.fetchedObjects else {
            return 0
        }

        return quickRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView as! QuickRecordTableView).dequeueReusableCell(for: indexPath)

        cell.quickRecord = fetchedResultsController.object(at: indexPath)

        return cell
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        quickRecordTableView.reloadData()
    }
}
