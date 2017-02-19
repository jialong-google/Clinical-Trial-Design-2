//
//  PageViewController.swift
//  Clinical_Trial
//
//  Created by Jialong on 2/16/17.
//  Copyright © 2017 Jialong. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var VCArr :[UIViewController] = {
        return [self.VCInstance(name: "DoseViewController"),
        self.VCInstance(name: "CohortViewController"),
        self.VCInstance(name: "TargetViewController"),
        self.VCInstance(name: "SafetyViewController")]
    }()
    
    private func VCInstance(name: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        // Do any additional setup after loading the view.
        if let DoseViewController = VCArr.first{
            setViewControllers([DoseViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In terms of navigation direction. For example, for 'UIPageViewControllerNavigationOrientationHorizontal', view controllers coming 'before' would be to the left of the argument view controller, those coming 'after' would be to the right.
    // Return 'nil' to indicate that no more progress can be made in the given direction.
    // For gesture-initiated transitions, the page view controller obtains view controllers via these methods, so use of setViewControllers:direction:animated:completion: is not required.
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = VCArr.index(of: viewController) else{
            return nil
        }
        let previousControllerIndex = viewControllerIndex - 1
        guard previousControllerIndex >= 0 else
        {
            return VCArr.last
        }
        guard VCArr.count > previousControllerIndex else
        {
            return nil
        }
        return VCArr[previousControllerIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = VCArr.index(of: viewController) else{
            return nil
        }
        let LaterControllerIndex = viewControllerIndex + 1
        
        guard VCArr.count > LaterControllerIndex else
        {
            return VCArr.first
        }
        
        return VCArr[LaterControllerIndex]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return VCArr.count
    }
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = VCArr.index(of: firstViewController) else
        {
            return 0
        }
        return firstViewControllerIndex;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
/*
extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
}
 */
