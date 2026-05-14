//
//  GalleryViewController.swift
//  GaleriaCuritiba
//
//  Camada Controller: orquestra modelo + UICollectionView (DataSource/Delegate),
//  layout responsivo com UICollectionViewFlowLayout e busca (UISearchController).
//

import UIKit

final class GalleryViewController: UIViewController {

    private var obrasExibidas: [ObraDeArte] = GaleriaCatalogo.todasAsObras

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.minimumInteritemSpacing = 12
        l.minimumLineSpacing = 12
        l.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
        return l
    }()

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemGroupedBackground
        cv.alwaysBounceVertical = true
        cv.register(ObraCollectionViewCell.self, forCellWithReuseIdentifier: ObraCollectionViewCell.reuseId)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Buscar por título ou artista"
        return sc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Artistas Curitibanos"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.flowLayout.invalidateLayout()
        })
    }

    private func itemsPerRow(for width: CGFloat) -> CGFloat {
        let isRegular = traitCollection.horizontalSizeClass == .regular
        if width >= 900 { return isRegular ? 4 : 3 }
        if width >= 600 { return 3 }
        return 2
    }

    private func cellSize(collectionWidth: CGFloat) -> CGSize {
        let columns = itemsPerRow(for: collectionWidth)
        let inset = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let spacing = flowLayout.minimumInteritemSpacing * (columns - 1)
        let totalHorizontal = inset + spacing
        let w = floor((collectionWidth - totalHorizontal) / columns)
        let imageHeight = w * 0.72
        let textHeight: CGFloat = 44
        let verticalPadding: CGFloat = 8 * 2 + 8
        let h = imageHeight + textHeight + verticalPadding
        return CGSize(width: w, height: h)
    }
}

// MARK: - UICollectionViewDataSource

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        obrasExibidas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ObraCollectionViewCell.reuseId,
            for: indexPath
        ) as? ObraCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: obrasExibidas[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let obra = obrasExibidas[indexPath.item]
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            pushDetail(obra: obra)
            return
        }
        UIView.animate(withDuration: 0.12, delay: 0, options: [.curveEaseInOut]) {
            cell.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        } completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut]) {
                cell.transform = .identity
            } completion: { _ in
                self.pushDetail(obra: obra)
            }
        }
    }

    private func pushDetail(obra: ObraDeArte) {
        let detail = DetailViewController(obra: obra)
        navigationController?.pushViewController(detail, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        cellSize(collectionWidth: collectionView.bounds.width)
    }
}

// MARK: - UISearchResultsUpdating

extension GalleryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let q = searchController.searchBar.text ?? ""
        obrasExibidas = GaleriaCatalogo.obras(matching: q)
        collectionView.reloadData()
    }
}
