//
//  WeatherImageLoader.swift
//  GoWalk
//
//  Created by seohuibaek on 1/13/25.
//

// 삭제 예정
import UIKit

final class WeatherImageLoader {
    static func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            DispatchQueue.main.async {
                completion(image.withRenderingMode(.alwaysOriginal).withTintColor(.label))
            }
        }
    }
}
