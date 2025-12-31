//
//  AsyncSemaphore.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

actor AsyncSemaphore {
    private var value: Int
    init(value: Int) { self.value = value }

    func wait() async {
        while value == 0 {
            await Task.yield()
        }
        value -= 1
    }

    func signal() async {
        value += 1
    }
}
