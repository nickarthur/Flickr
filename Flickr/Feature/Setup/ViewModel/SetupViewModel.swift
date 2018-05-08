//
//  SetupViewModel.swift
//  Flickr
//
//  Created by 방성원 on 2018. 5. 8..
//  Copyright © 2018년 makesource. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SetupViewModel {
    // inputs
    let upButtonTapped = PublishSubject<Void>()
    let downButtonTapped = PublishSubject<Void>()

    // outputs
    let intervalTime: Driver<Int>

    init() {
        let upValue = upButtonTapped.map { 1 }
        let downValue = downButtonTapped.map { -1 }

        intervalTime = Observable.merge([upValue, downValue])
            .scanInRange(1, low: 1, high: 10) { $0 + $1 }
            .startWith(1)
            .asDriver(onErrorJustReturn: 1)
    }
}

extension ObservableType where E == Int {
    public func scanInRange<A: Comparable>(_ seed: A, low: A, high: A, accumulator: @escaping (A, Self.E) throws -> A) -> RxSwift.Observable<A> {
        let acc = { (x: A, y: Self.E) throws -> A in
            let z = try accumulator(x, y)
            if (z < low) { return low }
            else if (z > high) { return high }
            else { return z }
        }
        return self.scan(seed, accumulator: acc)
    }
}