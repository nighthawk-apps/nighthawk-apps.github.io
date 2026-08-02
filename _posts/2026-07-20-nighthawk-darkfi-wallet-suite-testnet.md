---
layout: post
title: "Nighthawk Apps releases client suite for DarkFi Testnet"
subtitle: "Press Release"
post_type: press release
date: 2026-08-01
---

Sunshine Coast, Australia.

Nighthawk Apps today announced that its updated Nighthawk wallet suite spanning Android, iOS, Desktop and the **Moonshine** CLI; together with the companion **darkfi-lightwalletd** server, is available for public testing for the **DarkFi testnet**. The release positions confidential chain interaction and privacy-preserving light-client sync with UnifOMR as the default path for everyday users, rather than as an optional afterthought.

The majority of cryptocurrency networks still expose user activity by design. Transparent chains publish every transfer in full view, and in privacy chains where transaction graph and amounts are private, the light wallet servers typically learn which block ranges a client requests and the metadata can fingerprint wallets over time. DarkFi inverts that model: transfers are completely confidential on-chain and Nighthawk’s light wallet path is built so a block server need not learn which of a user’s notes decrypt. This release is strictly for testnet and works with highly experimental code.

---

## Closing the privacy gap

On a typical transparent network, balances and payment flows are public records. A light server that answers “give me blocks 1000–2000” can infer interest in those heights even if it never sees keys. Nighthawk on DarkFi takes a different stance. DRK transfers are private by construction, so there is no transparent-versus-shielded split for users to manage. Sync prefers **UnifOMR** (scheme `0x05`): encrypted digests and private information retrieval so the server does not learn which notes match. Production wallets talk only to **darkfi-lightwalletd** and avoid direct access to a full `darkfid` node. Sync also applies range padding, poll jitter, TLS certificate pinning for remote servers and optional Tor so traffic patterns and clearnet endpoints are harder to exploit.

The sync-time benefit is practical, not only cryptographic. Traditional trial decryption downloads every compact block in the scan window and attempts to decrypt every note — work that grows with chain length and output count, so catch-up and periodic sync get slower as the network ages. UnifOMR flips that cost model: the client asks for an encrypted any-match digest over the window, then pulls only the matching heights through PIR. Wallet sync therefore tracks *relevant activity* instead of re-scanning the whole tip history, which keeps restore and incremental sync far snappier on phones and desktops than a full trial-decrypt pass over the same range.

When UnifOMR cannot complete, clients may fall back to padded trial sync. That path is still stronger than raw full-node visibility, but it is intentionally described as degraded relative to the FHE-backed default — slower and heavier precisely because it returns to scanning the window note-by-note. Moonshine is stricter: it is UnifOMR-only and has no PerfOMR or height-list fallback.

---

## darkfi-lightwalletd

**darkfi-lightwalletd** is a dedicated light wallet server for the DarkFi network. It serves compact blocks — with ZK proofs, signatures, and PoW data stripped — over gRPC, runs UnifOMR detection when built with the default `fhe-omr` feature, and relays transactions with optional OMR clues for private receive detection. Cleartext is refused off-loopback; remote deployments expect TLS, and clients pin the leaf certificate’s SHA-256 digest. The server does not keep wallet accounts or session identity, and it is designed not to log detection keys or match heights.

In short: the light wallet server exists so phones, desktops, and CLI clients download far less than a full `darkfid` node would require, without becoming an oracle for “which blocks this wallet cares about” in the UnifOMR path. Under the active UnifOMR Param2 profile, a detection key is about **38 MB** (gRPC per-key cap **48 MB**, total request budget **64 MB**, up to **16** keys), digests are served at the last BFV RNS level for size and noise reduction, and a match returns only the relevant compact blocks via SealPIR-style `FetchPirBatch` instead of streaming every height for trial decryption.

Operators should size the host for UnifOMR detection load and compact-block cache growth. Recommended infrastructure specs for **darkfi-lightwalletd**:

| Scale | CPU | RAM | Storage | Bandwidth |
|-------|-----|-----|---------|-----------|
| ~1k users | 2 cores | 4 GB | 50 GB SSD | ~50 Mbps |
| ~10k users | 8 cores | 16 GB | 200 GB SSD | ~500 Mbps |
| ~100k users | 32+ cores (detector pool) | 64+ GB | 1 TB NVMe | ~5 Gbps |

A reachable `darkfid` JSON-RPC peer is required for full-block ingest; production remote deployments should terminate TLS and publish a pinable leaf certificate digest for clients.

---

## Client suite on testnet

### Android

The Android wallet is a native application with a shared UniFFI DarkFi core, an encrypted wallet database and UnifOMR-first sync against lightwalletd. Tor is available over SOCKS for both lightwallet traffic and DarkIRC chat. Chat runs in-process rather than depending on a separate desktop IRC daemon. A side-by-side testnet package lets testers run testnet builds without colliding with mainnet installs.

### iOS

The iOS wallet uses the same UniFFI wallet API (`DarkfiWalletHandle`) for sync, send, and receive. DarkIRC chat runs in-process. Tor is provided in-app through embedded **Arti**, covering chat and lightwallet dial when enabled. Separate testnet and mainnet schemes keep network identity explicit. The product continues under the Nighthawk Wallet lineage, with the DarkFi edition in active testnet use.

### Desktop

The desktop product is **nighthawk-desktop**: a Tauri 2 host with a Lit UI covering DarkIRC Chat, Wallet and Mining. It shares the same `darkfi-mobile-ffi` stack as mobile, stores seeds behind a local PIN vault and keeps separate data directories for testnet and mainnet. For any non-loopback lightwalletd or chat use, Tor is recommended so sync and peer-to-peer encrypted messaging do not exit over clearnet by default.

### Moonshine (CLI)

**Moonshine** is a private, lightweight CLI light wallet for DarkFi. It connects to **darkfi-lightwalletd** over gRPC and syncs with **UnifOMR only** (scheme `0x05`) — there is no PerfOMR fallback. Unlike a full node (`darkfid`) or the heavy CLI wallet (`drk`), Moonshine keeps a pruned SQLCipher wallet and a small on-disk footprint, so operators and power users can script send, receive, and sync against the same privacy-preserving light path as the mobile and desktop apps.

---

## What improved across the suite

Relative to Nighthawl's earlier Zcash-era wallets, the Nighthawk DarkFi suite collapses the old shield and deshield theater into a single confidential balance model. One Rust wallet core is shared across Android, iOS and Desktop apps, with Moonshine as the UnifOMR-only CLI sibling on the same lightwalletd stack, which keeps sync and cryptography aligned instead of forking incompatible clients. Users get private payment memos, fee selection, DAO-oriented surfaces and DarkIRC end-to-end direct messages as part of the graphical applications. Most importantly, sync is designed around **what the light server must not learn**, not only around what appears encrypted on the ledger.

---

## Availability

Testnet builds and operator documentation are published through Nighthawk Apps’s GitHub organization. NOTE: This is a testnet trial software and we look forward to feedback to fix issues and deliver bleeding-edge privacy directly into the hands of end users.

**Repositories:**

- [darkfi-lightwalletd](https://github.com/nighthawk-apps/darkfi-lightwalletd) — light wallet server + UnifOMR
- [moonshine](https://github.com/nighthawk-apps/moonshine) — CLI light wallet
- [nighthawk-android-wallet](https://github.com/nighthawk-apps/nighthawk-android-wallet) — Android
- [nighthawk-ios-wallet](https://github.com/nighthawk-apps/nighthawk-ios-wallet) — iOS
- [nighthawk-desktop](https://github.com/nighthawk-apps/nighthawk-desktop) — Desktop (Tauri)

**Contact:** X: [@nighthawkwallet](https://x.com/nighthawkwallet), [@nighthawkapps](https://x.com/nighthawkapps), [email@nighthawkapps.com](mailto:email@nighthawkapps.com)  
**Web:** [nighthawkapps.com](https://nighthawkapps.com) · [nighthawkapps.com/blog](https://nighthawkapps.com/blog/)  
**Source:** [github.com/nighthawk-apps](https://github.com/nighthawk-apps)
