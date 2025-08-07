-- scripts/constants.lua

-- SPDX-License-Identifier: BSD-3-Clause

return {
    MAX_PKT_RX_BURST     = 128,
    MAX_PKT_TX_BURST     = 128,
    DEFAULT_PKT_RX_BURST = 64,
    DEFAULT_PKT_TX_BURST = 64,
    DEFAULT_RX_DESC      = 128 * 8,
    DEFAULT_TX_DESC      = 128 * 16,

    DEFAULT_MBUFS_PER_PORT_MULTIPLER = 8,
    MAX_SPECIAL_MBUFS                = 1024,
    MBUF_CACHE_SIZE                  = 128,

    DEFAULT_PRIV_SIZE = 0,

    NUM_Q = 64
}