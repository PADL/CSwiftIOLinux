//=== Utils.swift ---------------------------------------------------------===//
//
// Copyright (c) MadMachine Limited
// Licensed under MIT License
//
// Authors: Andy Liu
// Created: 12/08/2021
//
// See https://madmachine.io for more information
//
//===----------------------------------------------------------------------===//

import struct IORing.Errno
import struct SwiftIO.Errno

@inlinable
func validateLength(
    _ array: [UInt8],
    count: Int?,
    length: inout Int
) -> Result<(), SwiftIO.Errno> {
    if let count = count {
        if count > array.count || count < 0 {
            return .failure(Errno.invalidArgument)
        } else {
            length = count
        }
    } else {
        length = array.count
    }

    return .success(())
}

@inlinable
func validateLength(
    _ buffer: UnsafeMutableRawBufferPointer,
    count: Int?,
    length: inout Int
) -> Result<(), SwiftIO.Errno> {
    if let count = count {
        if count > buffer.count || count < 0 {
            return .failure(Errno.invalidArgument)
        } else {
            length = count
        }
    } else {
        length = buffer.count
    }

    return .success(())
}

@inlinable
func validateLength(
    _ buffer: UnsafeRawBufferPointer,
    count: Int?,
    length: inout Int
) -> Result<(), SwiftIO.Errno> {
    if let count = count {
        if count > buffer.count || count < 0 {
            return .failure(Errno.invalidArgument)
        } else {
            length = count
        }
    } else {
        length = buffer.count
    }

    return .success(())
}

func rethrowingIORingErrno<T>(_ body: @escaping () async throws -> T) async rethrows -> T {
    do {
        return try await body()
    } catch let error as IORing.Errno {
        throw SwiftIO.Errno(rawValue: error.rawValue)
    }
}

struct Queue<T> {
    private var storage = [T]()

    mutating func enqueue(_ element: T) {
        storage.append(element)
    }

    mutating func dequeue() -> T? {
        guard !storage.isEmpty else {
            return nil
        }

        return storage.removeFirst()
    }
}
