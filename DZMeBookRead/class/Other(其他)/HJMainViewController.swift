//
//  HJMainViewController.swift
//  eBookRead
//
//  Created by 文阳 on 2017/5/5.
//  Copyright © 2017年 wen. All rights reserved.
//

import UIKit




class HJMainViewController: UIViewController,UISearchBarDelegate,UIScrollViewDelegate{
    
    /* 
     
     项目思路： 通过一个txt文件解析成 无数个章节模型(也可以理解成无数个 章节.txt文件) 这些章节模型文件使用归档进行存储起来 (可以运行项目之后进入沙河路径看看我的文件夹结构就明白了) 
     
     然后在阅读中每次通过一个章节ID 就能快速获取以及解析出来一个章节模型 进行使用 不用了直接进行销毁 保证了内存问题
     在下载章节缓存小说方面 也是有利的 阅读的整个过程中面对的只有章节ID 通过章节ID就能知道这个章节是否存在以及能够拿出来解析阅读 同时还可以在后台在任何地方进行下载缓存 而不会出问题 因为你只需要去通过章节ID 去获取章节model归档文件即可
     
     同样 既然章节模型都有了归档 也需要一个正对整本书的 缓存 章节信息 书本信息 阅读记录 等等的BOOK模型 这个模型也使用归档进行存储 在重新进入阅读的时候 归档秒解析的速度能够无视觉的延迟的快速进入 然后获取阅读记录进行定位阅读 当然这样也是可以通过网络数据进行更新的
     
     以上的思路针对本地 网络数据都是可行的
     */
    
    var readVC:HJReadPageController!
    
    var searchBar = UISearchBar()
    var bookName = UILabel()
    var imageV = UIImageView()
    var scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = UIColor.white
        view.backgroundColor = UIColor(patternImage: UIImage(named:"sharebg")!)
        
        self.title = "书架"
        
        
        
        //设置按钮
        let button2 = UIButton(frame:CGRect(x: 0, y: 0, width: 44 , height: 44))
        button2.setTitle("选择", for: UIControlState())
        button2.setTitleColor(UIColor.black, for: UIControlState())
        let barButton2 = UIBarButtonItem(customView: button2)
        
        self.navigationItem.rightBarButtonItem = barButton2;
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width , height: view.frame.size.height)
        
        scrollView.contentSize = CGSize(width:0, height:800)
        
        
        scrollView.delegate = self;
        view.addSubview(scrollView)
        
        
        searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width , height: 44)
        searchBar.showsCancelButton = true
        searchBar.showsBookmarkButton = true
        searchBar.setBackgroundImage(UIImage(named:"navbar2"), for: UIBarPosition(rawValue: 0)!, barMetrics: UIBarMetrics(rawValue: 0)!)
        searchBar.delegate = self
        
        scrollView.addSubview(searchBar)
        
        
        for var i in 1..<6 {
            
            print("i = \(i),y = \(44 + (i-1)*140)")
            imageV = UIImageView.init(frame:CGRect(x: 0, y: 44 + (i-1)*140, width: Int(view.frame.size.width), height: 130))
            imageV.image = UIImage(named:"BookShelfCell")
            i += 1
            scrollView.addSubview(imageV)
        }
        
        let button = UIButton(type:UIButtonType.custom)
//        button.setTitle("点击阅读", for: UIControlState())
        
        button.setImage(UIImage(named:"bookImg"), for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState(rawValue: 0))
        
        button.frame = CGRect(x: 10, y: 44, width: 80, height: 100)
        scrollView.addSubview(button)
        
        button.addTarget(self, action: #selector(HJMainViewController.read), for: UIControlEvents.touchDown)
        
        bookName.frame = CGRect(x: 10, y: 144, width: 80, height: 30)
        bookName.text = "求魔"
        bookName.textAlignment = NSTextAlignment.center
        scrollView.addSubview(bookName)
        
        self.addSecond()
        
    }
    
    func addSecond(){
        
        let button1 = UIButton(type:UIButtonType.custom)
        //    button1.setTitle("点击阅读", for: UIControlState())
        button1.setImage(UIImage(named:"bookImg"), for: UIControlState())
        
        button1.setTitleColor(UIColor.black, for: UIControlState(rawValue: 0))
        
        button1.frame = CGRect(x: 100, y: 44, width: 80, height: 100)
        button1.addTarget(self, action: #selector(HJMainViewController.read2), for: UIControlEvents.touchDown)
        scrollView.addSubview(button1)
        
        
        let add1 = UIButton(type:UIButtonType.custom)
        //    button1.setTitle("点击阅读", for: UIControlState())
        add1.setImage(UIImage(named:"add.jpg"), for: UIControlState())
        
        add1.setTitleColor(UIColor.black, for: UIControlState(rawValue: 0))
        
        add1.frame = CGRect(x: view.frame.width - 50, y: view.frame.height - 50, width: 44, height: 44)
        view.addSubview(add1)
        
        let bookName1 = UILabel()
        bookName1.frame = CGRect(x: 100, y: 144, width: 80, height: 30)
        bookName1.text = "心灵鸡汤"
        bookName1.textAlignment = NSTextAlignment.center
        scrollView.addSubview(bookName1)
    
        
        
        //方法1
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                FileManager.SearchPathDomainMask.userDomainMask, true)
        let documnetPath = documentPaths[0] 
        
        
//        let DocPath = NSHomeDirectory() + "/Documents"
        //方法2
        let ducumentPath2 = NSHomeDirectory() + "/Documents"
//        let homeDirectory = NSHomeDirectory()
//    let path = "/Users/wen/Desktop/DZMeBookRead-master/DZMeBookRead"
    let type = "txt"
    
    let name = findFiles(path: ducumentPath2, filterTypes: [type])
        
    print("name = \(name),documnetPath = \(documnetPath),ducumentPath2 = \(ducumentPath2)")
    }
    
    
    /// (recommended) 获取指定文件夹下符合扩展名要求的所有文件名
    /// - parameter path: 文件夹路径
    /// - parameter filterTypes: 扩展名过滤类型(注：大小写敏感)
    /// - returns: 所有文件名数组
    func findFiles(path: String, filterTypes: [String]) -> [String] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
            if filterTypes.count == 0 {
                return files
            }
            else {
                let filteredfiles = NSArray(array: files).pathsMatchingExtensions(filterTypes)
                return filteredfiles
            }
        }
        catch {
            return []
        }
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
//        searchBar.text = "search"
    }
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancle")
        view.endEditing(true)
        searchBar.text = ""
    }
    func read() {
        
        // 发现除了 HJReadPageController 控制器还没找到什么原因  可能引用太多 造成没有释放 但是别的子控件什么都进行了释放 打印测试过 相当于就HJReadPageController 需要第二次点击进入才会释放 HJReadPageController 内部子控件会释放成功 这点不影响代码运行 跟内存问题 内存问题也进行了优化 每一章节都会进行清理看不见的
        
        // 方法一
        
//        MBProgressHUD.showMessage("本地文件第一次解析慢,以后就会秒进了")
        
        let fileURL = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        readVC = HJReadPageController()
        
        HJReadParser.separateLocalURL(fileURL!) { [weak self] (isOK) in
            
             MBProgressHUD.hide()
            
            if self != nil {
                
                self!.readVC!.readModel = HJReadModel.readModelWithFileName("求魔")
                
                self!.navigationController?.pushViewController(self!.readVC!, animated: true)
                
            }
        }
        
        
        
    }
    func read2(){
        // 方法二
                MBProgressHUD.showMessage()
        
                let fileURL = Bundle.main.url(forResource: "心灵鸡汤", withExtension: "txt")
        
                let readVC = HJReadPageController()
        
                DispatchQueue.global().async() {
        
                    readVC.readModel = HJReadModel.readModelWithLocalBook(fileURL!)
        
                    DispatchQueue.main.async(execute: { [weak self] ()->() in
        
                        MBProgressHUD.hide()
        
                        self?.navigationController?.pushViewController(readVC, animated: true)
                        })
                }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
