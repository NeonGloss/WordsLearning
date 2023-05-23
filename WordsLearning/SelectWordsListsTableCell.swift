//
//  SelectWordsListsTableCell.swift
//  WordsLearning
//
//  Created by Кузин Роман Эдуардович on 27.10.2022.
//

import UIKit

/// Протокол объекта обрабатывающего события от ячейки
protocol SelectWordsListsTableCellOutput: AnyObject {
    
    /// Нажата ячейка
    /// - Parameter  listName: название выбранного списка
    func cellTappedWith(listName: String)

	/// Ячейка с названием списка слов выбрана для удаления
	/// - Parameter name: название списка
	func cellSelectedToBeRemoved(withWordsListName name: String, completion: @escaping (Bool) -> Void)

	/// Ячейка с названием списка слов выбрана для изменения данных
	/// - Parameter name: название списка
	func cellSelectedToBeEdited(withWordsListName name: String)
}

/// Протокол ячейки для таблицы выбора списка слов для изучения
protocol SelectWordsListsTableCellProtocol {

    /// Отобразить снятие выделения
    func displayDeselection()
}

/// Ячейка экрана стистики
final class SelectWordsListsTableCell: UITableViewCell,
									   DRTableViewCellProtocol,
									   SelectWordsListsTableCellProtocol {

    // TODO: реюзабилити не работает
    var shouldReuse = false
    
    private weak var output: SelectWordsListsTableCellOutput?
    private let name: String
	private let comment: String?
	private let wordsCount: Int

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Thonburi", size: 23)?.bold()
		label.numberOfLines = 3
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private let wordsCountLabel = UILabel()

	/// Инициализатор
	/// - Parameters:
	///   - name: название списка
	///   - comment: комментарий
	///   - wordsCount: количество слов в списке
	///   - isSelected: флаг, является ли ячейка выделенной
	///   - output: объект обрабатывающий события
	init(name: String, comment: String?, wordsCount: Int, isSelected: Bool, output: SelectWordsListsTableCellOutput) {
		self.name = name
        self.comment = comment
		self.wordsCount = wordsCount
		self.output = output
		super.init(style: .subtitle, reuseIdentifier: nil)
		self.isSelected = isSelected
		setupUI()
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - DRTableViewCellProtocol

	func didSelected() {
		isSelected = true
		output?.cellTappedWith(listName: name)
    }

	func someCellWasSelected() {
		isSelected = false
		changeBackgroundColor(isSelected: isSelected)
	}

	func emptySpaceOnTableWasTapped() {}

    func selectedToBeRemoved(complition: @escaping (Bool) -> ()) {
		output?.cellSelectedToBeRemoved(withWordsListName: name) { isConfirmed in
			complition(isConfirmed)
		}
	}

	func selectedToBeEdited() {
		output?.cellSelectedToBeEdited(withWordsListName: name)
	}
    
    // MARK: - SelectWordsTableCellProtocol
    
    func displayDeselection() {
		changeBackgroundColor(isSelected: false)
	}

	// MARK: - Private

	private func setupConstraints() {
        contentView.addSubview(commentLabel)
        contentView.addSubview(nameLabel)
		contentView.addSubview(wordsCountLabel)

		contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
			nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
			nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),

			commentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            commentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
			commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

			wordsCountLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
			wordsCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
		])
    }

	private func setupUI() {
		selectionStyle = .none
		backgroundColor = .clear
        nameLabel.text = name
        commentLabel.text = comment
        wordsCountLabel.text = String(wordsCount) + " слов"
		changeBackgroundColor(isSelected: isSelected)
	}

	func changeBackgroundColor(isSelected: Bool) {
		backgroundColor = isSelected ? Design.Colors.dsNuance0 : .clear
	}
}
