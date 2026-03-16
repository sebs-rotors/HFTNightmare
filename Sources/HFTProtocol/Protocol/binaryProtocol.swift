//
//  binaryProtocol.swift
//  HFTNightmare
//
//  Created by Sebastian Sidor on 3/15/26.
//

import Foundation

// Wire Format Constants

public enum WireFormat {
    // Cassandra-style native envelope header (9B)
    // version (1), flags (1), stream (2), opcode (1), bodyLength(4)
    public static let envelopeHeaderSize = 9
    
    // v5 framed transport constants for shared layer
    // TODO: determine endianness across the progject:
        // mixed endianness to incorporate Cassandra binary model exactly?
        // force big endianness (rewrite cassandra model?)
        // force little endianness (reverse transaction model)
}
