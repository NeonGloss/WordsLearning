//
//  SelectWordsTableCell.swift
//  WordsLearning
//
//  Created by Кузин Роман Эдуардович on 27.10.2022.
//

import UIKit

/// Протокол объекта обрабатывающего события от ячейки
protocol SelectWordsTableCellOutput: AnyObject {
    
    /// Нажата ячейка
    /// - Parameter word: слово в ячейке
    func cellTappedWithWord(_ word: Word)
}

protocol SelectWordsTableCellProtocol {
    
    /// Отобразить снятие выделения слова
    func displayWordDeselection()
}

/// Ячейка экрана стистики
final class SelectWordsTableCell: UITableViewCell,
                                  DRTableViewCellProtocol,
                                  SelectWordsTableCellProtocol {
    
    // TODO: реюзабилити не работает
    var shouldReuse = false
    
    private weak var output: SelectWordsTableCellOutput?
    private var word: Word
    private var isSelectedForPartialStudy: Bool = false
    
    private let foreingWordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Thonburi", size: 23)?.bold()
        return label
    }()
    
    private let nativeWordsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private let fToNRemarkLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.italic()
        return label
    }()
    
    private let nToFRemarkLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.italic()
        return label
    }()
    
    private var  selectButton: UIButton = {
        let button = UIButton()
        button.setImage(SemanticImages.plusCircle.coloredAs(.gray, .gray), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let fToNStudyPercentLabel = UILabel()
    private let nToFStudyPercentLabel = UILabel()
    
    /// Инициализатор
    /// - Parameters:
    ///   - word: слово
    ///   - output: объект обрабатывающий события
    ///   - isSelectedForPartialStudy: было ли слово выбрано ранее для изучения
    init(word: Word, isSelectedForPartialStudy: Bool, output: SelectWordsTableCellOutput) {
        self.isSelectedForPartialStudy = isSelectedForPartialStudy
        self.word = word
        self.output = output
		super.init(style: .subtitle, reuseIdentifier: nil)
		setupUI()
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        word = Word(foreign: "", native: [""], transcription: "")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	func didSelected() {
        selectButtonTapped()
    }

	func someCellWasSelected() {}

	func emptySpaceOnTableWasTapped() {}

	func selectedToBeEdited() {}
	
    func selectedToBeRemoved(complition: @escaping (Bool) -> ()) {}
    
    // MARK: - SelectWordsTableCellProtocol
    
    func displayWordDeselection() {
        isSelectedForPartialStudy = false
        markAsSelectedForPartialStudy(isSelectedForPartialStudy)
    }

	// MARK: - Private

	private func setupConstraints() {
        contentView.addSubview(selectButton)
        contentView.addSubview(fToNRemarkLabel)
        contentView.addSubview(nToFRemarkLabel)
        contentView.addSubview(nativeWordsLabel)
        contentView.addSubview(foreingWordLabel)
		contentView.addSubview(fToNStudyPercentLabel)
        contentView.addSubview(nToFStudyPercentLabel)
		contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
            selectButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            selectButton.heightAnchor.constraint(equalToConstant: 30),
            selectButton.widthAnchor.constraint(equalToConstant: 30),
            
			foreingWordLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			foreingWordLabel.leadingAnchor.constraint(equalTo: selectButton.leadingAnchor, constant: 45),
            
            fToNRemarkLabel.centerYAnchor.constraint(equalTo: foreingWordLabel.centerYAnchor),
            fToNRemarkLabel.leadingAnchor.constraint(equalTo: foreingWordLabel.trailingAnchor, constant: 10),
            
            fToNStudyPercentLabel.centerYAnchor.constraint(equalTo: foreingWordLabel.centerYAnchor),
            fToNStudyPercentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nativeWordsLabel.topAnchor.constraint(equalTo: foreingWordLabel.bottomAnchor, constant: 10),
            nativeWordsLabel.leadingAnchor.constraint(equalTo: foreingWordLabel.leadingAnchor),
			nativeWordsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            nToFRemarkLabel.topAnchor.constraint(equalTo: nativeWordsLabel.bottomAnchor, constant: 10),
            nToFRemarkLabel.leadingAnchor.constraint(equalTo: nativeWordsLabel.leadingAnchor),
            nToFRemarkLabel.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -50),
            nToFRemarkLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            nToFStudyPercentLabel.centerYAnchor.constraint(equalTo: nativeWordsLabel.centerYAnchor),
            nToFStudyPercentLabel.trailingAnchor.constraint(equalTo: fToNStudyPercentLabel.trailingAnchor),
		])
        
        if nToFRemarkLabel.text != nil {
            NSLayoutConstraint.activate([
                nToFRemarkLabel.topAnchor.constraint(equalTo: nativeWordsLabel.bottomAnchor, constant: 10),
                nToFRemarkLabel.leadingAnchor.constraint(equalTo: nativeWordsLabel.leadingAnchor),
                nToFRemarkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
                nToFRemarkLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
        } else {
            NSLayoutConstraint.activate([
                nativeWordsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
        }
    }

	private func setupUI() {
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        markAsSelectedForPartialStudy(isSelectedForPartialStudy)
		backgroundColor = .clear
        foreingWordLabel.text = word.foreign
        nativeWordsLabel.text = makeNativeString(from: word.native)
        fToNStudyPercentLabel.text = String(format: "%.0f", word.foreingToNativeStatistic.studyPercent) + " %"
        nToFStudyPercentLabel.text = String(format: "%.0f", word.nativeToForeignStatistic.studyPercent) + " %"
        
        if let fToNRemarkText = word.fToNRemark, !fToNRemarkText.isEmpty {
			fToNRemarkLabel.text = "(" + fToNRemarkText + ")"
		}
        if let nToFRemarkText = word.nToFRemark, !nToFRemarkText.isEmpty {
            nToFRemarkLabel.text = "(" + nToFRemarkText + ")"
        }
	}
    
    // MAKR: Private
    
    private func makeNativeString(from words: [String]) -> String {
        words.joined(separator: ", ")
    }
    
    @objc private func selectButtonTapped() {
        isSelectedForPartialStudy = !isSelectedForPartialStudy
        output?.cellTappedWithWord(word)
        markAsSelectedForPartialStudy(isSelectedForPartialStudy)
    }
    
    private func markAsSelectedForPartialStudy(_ value: Bool) {
        let image = value ? SemanticImages.checkmarkCircle.coloredAs(.white, .orange) :
                            SemanticImages.plusCircle.coloredAs(.gray, .gray)
            selectButton.setImage(image, for: .normal)
    }
}
