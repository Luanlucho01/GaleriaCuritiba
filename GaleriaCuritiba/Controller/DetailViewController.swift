//
//  DetailViewController.swift
//  GaleriaCuritiba
//
//  Camada Controller: exibe detalhes da obra e compartilhamento (UIActivityViewController).
//

import UIKit

final class DetailViewController: UIViewController {

    private let obra: ObraDeArte

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    init(obra: ObraDeArte) {
        self.obra = obra
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) não usado — tela criada em código.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = obra.titulo

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(compartilhar)
        )

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .fill

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        let imageView = UIImageView(image: UIImage(named: obra.imagemNome))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemFill
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        let meta = makeMetaStack()
        let descLabel = UILabel()
        descLabel.text = obra.descricao
        descLabel.numberOfLines = 0
        descLabel.font = .preferredFont(forTextStyle: .body)
        descLabel.textColor = .label
        descLabel.adjustsFontForContentSizeCategory = true

        let shareButton = UIButton(type: .system)
        shareButton.setTitle("Compartilhar obra", for: .normal)
        shareButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        shareButton.addTarget(self, action: #selector(compartilhar), for: .touchUpInside)

        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(meta)
        contentStack.addArrangedSubview(descLabel)
        contentStack.addArrangedSubview(shareButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),

            imageView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.42),
        ])
    }

    private func makeMetaStack() -> UIStackView {
        let rows: [(String, String)] = [
            ("Título", obra.titulo),
            ("Artista", obra.artista),
            ("Ano", String(obra.ano)),
            ("Estilo", obra.estilo),
        ]
        let outer = UIStackView()
        outer.axis = .vertical
        outer.spacing = 10
        for (k, v) in rows {
            let title = UILabel()
            title.text = k
            title.font = .preferredFont(forTextStyle: .caption1)
            title.textColor = .secondaryLabel
            let value = UILabel()
            value.text = v
            value.font = .preferredFont(forTextStyle: .body)
            value.textColor = .label
            value.numberOfLines = 0
            value.adjustsFontForContentSizeCategory = true
            let col = UIStackView(arrangedSubviews: [title, value])
            col.axis = .vertical
            col.spacing = 2
            outer.addArrangedSubview(col)
        }
        return outer
    }

    @objc private func compartilhar() {
        let texto = """
        \(obra.titulo)
        \(obra.artista)

        Conheça mais artistas curitibanos — explore a arte feita em Curitiba!
        """
        let vc = UIActivityViewController(activityItems: [texto], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
