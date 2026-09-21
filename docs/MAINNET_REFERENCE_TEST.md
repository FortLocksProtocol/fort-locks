# FortLocks V1 — Mainnet Reference Test

FortLocks V1 has been exercised using a real Uniswap V3 liquidity position on Ethereum mainnet.

This reference provides independently verifiable evidence of the live contract's behavior. It is not a simulation or testnet deployment.

## Deployment

FortLocks V1:

`0x07AEbCE1f6DC40288E9AeE447E57B0289702DD4F`

Etherscan:
https://etherscan.io/address/0x07AEbCE1f6DC40288E9AeE447E57B0289702DD4F#code

Network: Ethereum Mainnet
Chain ID: `1`

## Reference Position

Uniswap V3 NFT: `#1369638`

Pair: HEX / WETH
Fee tier: `0.30%`
Range: Full range
Liquidity: `6858692122`

Beneficiary:

`0x4159629D910ea8282e3c581bEf3081822d97180f`

## Permanent Lock

Lock transaction:

`0xa1a34a3fdff8a1809e36e6d9046fee3ccd39001a6cd5c25a2c69df5e0633fd8f`

Etherscan:
https://etherscan.io/tx/0xa1a34a3fdff8a1809e36e6d9046fee3ccd39001a6cd5c25a2c69df5e0633fd8f

Block: `26028266`

The transaction:

- transferred Uniswap V3 NFT #1369638 to FortLocks V1;
- recorded the permanent beneficiary;
- flushed pre-existing owed tokens directly to the beneficiary without charging the FortLocks fee;
- left the position liquidity unchanged.

After the transaction, the canonical Uniswap V3 NonfungiblePositionManager reported FortLocks V1 as the owner of NFT #1369638.

## Live Fee Collection

Post-lock fees were subsequently collected through FortLocks V1.

Collection transaction:

`0x38292632ff6cf7228d2afab84758eb53fe6fec1059341ea0458d9a7f15799bb5`

Etherscan:
https://etherscan.io/tx/0x38292632ff6cf7228d2afab84758eb53fe6fec1059341ea0458d9a7f15799bb5

Block: `26028367`

Collected:

| Asset | Total Collected | FortLocks Fee | Beneficiary |
| --- | ---: | ---: | ---: |
| HEX | 0.00001477 HEX | 0.00000013 HEX | 0.00001464 HEX |
| WETH | 0.000000000004463953 WETH | 0.000000000000040175 WETH | 0.000000000004423778 WETH |

For exact on-chain accounting, the corresponding raw amounts were:

| Asset | Total | FortLocks Fee | Beneficiary |
| --- | ---: | ---: | ---: |
| HEX | 1477 | 13 | 1464 |
| WETH | 4463953 | 40175 | 4423778 |

HEX uses 8 decimals and WETH uses 18 decimals. The raw amounts are the integer values used by the contracts.

The collection transaction emitted the corresponding `FeesCollected` event.

The FortLocks fee represented the contract's `0.9%` cumulative fee calculation, with fractional fee remainders carried forward by the contract.

## Post-Collection Verification

After fee collection:

- Uniswap V3 NFT #1369638 remained owned by FortLocks V1;
- the permanent beneficiary remained unchanged;
- position liquidity remained exactly `6858692122`;
- no liquidity was removed as part of fee collection.

## Result

The reference position completed the live FortLocks V1 lifecycle:

`lock → pre-existing owed-token flush → post-lock fee accrual → permissionless fee collection → beneficiary/FortLocks distribution`

while the Uniswap V3 position NFT remained in FortLocks and its liquidity remained unchanged.

**Lock: Permanently Locked — VERIFIED**

Anyone can independently verify these results directly from Ethereum mainnet without relying on a FortLocks website, API, database, or frontend.
