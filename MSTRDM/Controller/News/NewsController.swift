//
//  NewsController.swift
//  MSTRDM
//
//  Created by Zakirov Tahir on 28.12.2020.
//

import UIKit
import CoreData
import SDWebImage

class NewsController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    fileprivate let footerId = "footerId"
    var newsData = [Articles]() // Экземпляр класса Articles
    var articlesData = [ArticlesData]()
    var isPadinating = false
    var isDonePaginating = false
    var pages = 1 // Отслеживаем, в какую страницу переходить при достяжении конца scroll - 1
    let pageSize = 5 // Константное значение, указывающее кол-во новостей на одну загрузку
    let dateFrom = "04-28"
    let search = "ios"
    let apiKey = "d56b91fb3687480abfa422ae4a750257"
    
    
    // этот метод вызывается перед представлением контроллера
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<ArticlesData> = ArticlesData.fetchRequest()
        
        // Проверяем, подключен ли интернет? Если да, то удаляем сохраненные данные из core data, и сохраняемся. В противном случае, вызываем метод noInterner с сообщением "Отсутствует интернет"
        if Reachability.isConnected(){
            
            let results = try! context.fetch(fetchRequest)
            for item in results {
                context.delete(item)
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        } else {
            noInternet(title: "Отсутствует интернет", message: "Но вы можете насладится сохраненными новостями")
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(NewsLoadingCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        // Проверяем подключение интернета, и загружаем предварительные данные из сети
        if Reachability.isConnected(){
            moreFetchData()
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<ArticlesData> = ArticlesData.fetchRequest()
        let results = try! context.fetch(fetchRequest)
        
        // проверяем, если интернет присутсвтует, то узнаем количество данных из сети, если нет, то сохраненные данные
        if Reachability.isConnected(){
            return newsData.count
        } else {
            return results.count
        }
        
        
    }
    
    
    // В футер добавляем ячейку с представлением дозагрузки данных.
    // Можно скрыть футер, при отсутсвии интернета, и вывести в хедер ячейку с кнопкой обновления и приверкой доступности сети
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        
        return footer
        
    }
    
    // Задаем высоту ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let height: CGFloat = isDonePaginating ? 0 : 100
        
        return .init(width: view.frame.width, height: height)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsCell
        
        
        // Приваиваем лейблам данные, сохраненные в core data, когда нет соединения с интернетом
        if Reachability.isConnected(){
            
            
            let news = newsData[indexPath.item]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            
            if let date = dateFormatter.date(from: news.publishedAt!) {
                dateFormatter.dateFormat = "dd MMMM yyyy"
                cell.dateLabel.text = dateFormatter.string(from: date)
            }
            
            cell.imageView.sd_setImage(with: URL(string: news.urlToImage ?? ""), completed: nil)
            
            DispatchQueue.global().async {
                
                
                
                guard let imageUrl = URL(string: news.urlToImage ?? "") else { return }
                
                guard let imageData = try? Data(contentsOf: imageUrl) else { return }
                
                
                // Метод сохранения данных из сети в core data
                DispatchQueue.main.async {
                    self.saveData(with: news.title ?? "", descriptions: news.description ?? "", urlToImage: imageData, url: news.url ?? "")
                }
                
            }
            
            cell.titleLabel.text = news.title
            cell.desctiptionLabel.text = news.description
            
            
            
        } else {
            
            let context = getContext()
            let fetchRequest: NSFetchRequest<ArticlesData> = ArticlesData.fetchRequest()
            
            
            do {
                articlesData = try context.fetch(fetchRequest)
                
                cell.titleLabel.text = articlesData[indexPath.item].title
                
                cell.desctiptionLabel.text = articlesData[indexPath.item].descriptions
                
                cell.imageView.image = UIImage(data: articlesData[indexPath.item].urlToImage!)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
            
        }
        
        
        // если количество indextPath равна количеству загруженных данных минус один, и не равна булевому значению false isPaginating,
        // в таком случае догружаем метод moreFetchData и меняем состояние isPadinating = true
        if indexPath.item == newsData.count - 1 && !isPadinating {
            
            isPadinating = true
            
            // Догружаем данные
            moreFetchData()
        }
        
        return cell
    }
    
    // Переход при касании
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = DetailNewsController()
        navigationController?.pushViewController(destination, animated: true)
        if Reachability.isConnected(){
            destination.url = newsData[indexPath.item].url
        }
    }
    
    // Метод догрузки данных из сети
    func moreFetchData() {
        
        let urlString = "https://newsapi.org/v2/everything?&q=\(search)&from=2021-\(dateFrom)&sortBy=publishedAt&apiKey=\(apiKey)&page=\(pages)&pageSize=\(pageSize)"
        print("Догрузка:", urlString)
        
        Service.shared.fetchJSONData(urlString: urlString) { (resultNews: NewsData?, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    self.noInternet(title: "Отсутсвует интернет", message: "Можно повторить кстати")
                }
                return
            }
            
            // Прибавляем 1 в переменную page, при достяжении конца страницы
            self.pages += 1
            
            if resultNews?.articles.count == 0 {
                self.isDonePaginating = true
            }
            
            
            self.newsData += resultNews?.articles ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            self.isPadinating = false
        }
        
    }
    
    
    // Если интернет отсутсвует, выводить алерт контроллер с ошибкой
    func noInternet(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Кнопка повторить вызывает метод moreFetchData для дозагрузки данных, если интернет присутствует
        let retryAction = UIAlertAction(title: "Повторить", style: .default) {_ in
            self.moreFetchData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        // Выводим АлертКонтроллер
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 400)
    }
    
    
    // метод сохранения данных из сети
    private func saveData(with title: String, descriptions: String, urlToImage: Data, url: String) {
        let context = getContext()
        
        //добираемся до своей сущности ArticlesData
        guard let entity = NSEntityDescription.entity(forEntityName: "ArticlesData", in: context) else { return }
        
        // получаем объект
        let articlesObject = ArticlesData(entity: entity, insertInto: context)
        articlesObject.title = title
        articlesObject.descriptions = descriptions
        articlesObject.urlToImage = urlToImage
        articlesObject.url = url
        
        // пытаемся сохранить данные, и добавить в сущность articlesData
        do {
            try context.save()
            articlesData.append(articlesObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
    // Добираемся до viewContext
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    
    
}
