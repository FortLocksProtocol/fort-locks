# FortLocks V1 Verification Specification

## 1. Purpose

This specification defines how a third party can independently verify that a canonical Uniswap V3 position NFT is permanently locked by FortLocks V1 using Ethereum on-chain data and the published FortLocks V1 source code.

Verification does not require trust in the FortLocks website, a FortLocks-operated API, an off-chain FortLocks database, a FortLocks-operated RPC endpoint, or any statement by FortLocksProtocol that a particular position is locked.

A successful verification establishes that the specified Uniswap V3 position NFT is held by a verified FortLocks V1 implementation and that the implementation provides no mechanism to release the position.

The canonical FortLocks V1 permanence guarantee is:

**Once a canonical Uniswap V3 position NFT has been successfully locked in a verified FortLocks V1 contract, FortLocks V1 provides no mechanism to withdraw, transfer, approve, decrease, burn, migrate, recover, or otherwise release that position, and no administrator or upgrade authority exists that can add such a mechanism later.**

For this specification, a canonical Uniswap V3 position NFT is an ERC-721 position NFT issued by the canonical Ethereum mainnet Uniswap V3 NonfungiblePositionManager.

A `VERIFIED` result means that the specified on-chain conditions have been independently confirmed according to this specification. It does not require approval, certification, registration, or authorization by FortLocksProtocol.

---

## 2. Canonical FortLocks V1 Identity

The canonical FortLocks V1 implementation is defined by the implementation source contained in the canonical V1 commit and the reproducible build configuration specified in this document.

### Source

* Repository: `FortLocksProtocol/fort-locks`
* Canonical V1 commit: `489b53b`
* Solidity compiler: `0.8.35`
* Network: Ethereum mainnet
* Chain ID: `1`

The canonical V1 commit remains the definition of the FortLocks V1 implementation even if the repository's `main` branch later advances.

Later repository commits, including documentation-only changes, do not modify the canonical FortLocks V1 implementation unless explicitly designated as a new implementation version.

Revisions to this verification specification that do not alter the canonical FortLocks V1 implementation do not create a new FortLocks implementation version.

### Canonical Uniswap V3 Position Manager

The canonical Ethereum mainnet Uniswap V3 NonfungiblePositionManager used throughout this specification is:

`CANONICAL_POSITION_MANAGER = 0xC36442b4a4522E871399CD717aBDD847Ab11FE88`

FortLocks V1 accepts position NFTs only from this contract.

The address is compiled into FortLocks V1 and cannot be changed during or after deployment.

### Official Deployment

The official FortLocks V1 Ethereum mainnet contract address will be recorded here after deployment.

Until an official deployment address has been published, no address can be classified as:

`Official FortLocks V1 — VERIFIED`

Once published, official deployment identity is determined by exact address equality with that published Ethereum mainnet address.

A contract MUST NOT be identified as the official FortLocks V1 deployment solely because its source code or bytecode matches the FortLocks V1 implementation.

An independently deployed contract may reproduce and successfully verify as the FortLocks V1 implementation while remaining a non-official deployment.

Official deployment classification is not a prerequisite for implementation verification or permanent-lock verification.

FortLocksProtocol's publication of the official deployment address identifies which verified implementation is the official protocol deployment. FortLocksProtocol is not otherwise an authority for determining whether a position satisfies the permanent-lock verification conditions in this specification.

---

## 3. Required Inputs

To verify a FortLocks V1 lock, a verifier requires only:

1. The FortLocks contract address (`fortLocksAddress`)
2. The Uniswap V3 position NFT token ID (`tokenId`)

All other information required for verification MUST be independently derived from Ethereum on-chain data and the canonical FortLocks V1 implementation.

A verifier MUST NOT require data supplied by the FortLocks website, API, database, event index, or any other FortLocks-operated off-chain service.

The specification does not designate a particular Ethereum RPC provider.

A verifier MAY use its own Ethereum node or any other Ethereum data source capable of reliably providing the required on-chain state.

---

## 4. Implementation Verification

Before verifying an individual position, the verifier MUST establish that `fortLocksAddress` implements the canonical FortLocks V1 code.

The verifier MUST first confirm that the connected network is Ethereum mainnet with chain ID `1`.

Contract names, function names, ABI compatibility, matching function selectors, matching events, explorer labels, deployer addresses, or claims made by external services MUST NOT be treated as proof of FortLocks V1 implementation identity.

A position MUST NOT be described as permanently locked by FortLocks V1 unless the contract holding the position has first passed the implementation verification procedure defined in this section.

### Runtime Bytecode Verification

The verifier MUST obtain the runtime bytecode at `fortLocksAddress` directly from Ethereum and compare it against runtime bytecode reproduced from the canonical FortLocks V1 source and build configuration.

The canonical FortLocks V1 deployed runtime bytecode is:

`5,725 bytes`

The FortLocks V1 runtime contains one compiler-defined immutable variable:

`FORT_FEE_RECIPIENT`

Solidity compiler `0.8.35` identifies three 32-byte references to this immutable in the deployed runtime bytecode, beginning at byte offsets:

* `699`
* `2243`
* `2327`

To verify a deployed FortLocks V1 implementation, the verifier MUST:

1. Obtain the runtime bytecode of `fortLocksAddress` from Ethereum.
2. Confirm that the runtime bytecode is exactly 5,725 bytes.
3. Read `FORT_FEE_RECIPIENT()` and confirm that it is not the zero address.
4. Confirm that each of the three compiler-defined immutable reference regions contains the deployed `FORT_FEE_RECIPIENT` value encoded as a 32-byte address value.
5. Replace only those three immutable reference regions in the obtained runtime bytecode with 32 zero bytes.
6. Compare the resulting runtime bytecode byte-for-byte with the canonical deployed runtime bytecode template reproduced from the canonical FortLocks V1 source and build configuration.

The comparison MUST match exactly.

A verifier MUST normalize only the compiler-defined immutable reference regions specified above. No other bytecode region may be ignored, masked, normalized, or excluded from comparison.

No bytecode difference outside the three compiler-defined `FORT_FEE_RECIPIENT` immutable references is permitted.

The verifier MUST additionally confirm:

* `POSITION_MANAGER()` equals `CANONICAL_POSITION_MANAGER`
* `FORT_FEE_BPS()` equals `90`
* `BPS_DENOMINATOR()` equals `10000`
* `FORT_FEE_RECIPIENT()` is not the zero address

A deployment that fails any required implementation check MUST NOT be identified as a verified FortLocks V1 implementation.

### No Proxy or Upgrade Authority

FortLocks V1 is deployed as the implementation contract itself.

It does not use a proxy architecture and contains no mechanism for replacing or modifying its runtime implementation.

The bytecode verified at `fortLocksAddress` is therefore the executable code of the contract that holds the locked position NFTs.

### No Administrator

The canonical FortLocks V1 implementation contains no owner, administrator, governance role, privileged operator, or access-control mechanism capable of modifying the locking rules or exercising administrative control over locked positions.

`FORT_FEE_RECIPIENT` is an immutable payment destination, not an administrative authority.

Control of `FORT_FEE_RECIPIENT` provides no authority over locked position NFTs, beneficiaries, liquidity, the protocol fee rate, contract configuration, or FortLocks V1 code.

Loss, compromise, or transfer of control of `FORT_FEE_RECIPIENT` does not provide a mechanism to release or modify a locked position.

---

## 5. Position Verification

After verifying `fortLocksAddress` as a FortLocks V1 implementation, the verifier MUST establish that the specified Uniswap V3 position was successfully locked and is held by that implementation.

### Lock Record

The verifier MUST read:

`locks(tokenId)`

from `fortLocksAddress`.

The recorded beneficiary MUST NOT be the zero address.

A persistent non-zero `locks(tokenId).beneficiary` establishes that the FortLocks V1 `lock()` transaction completed successfully for that `tokenId`.

The beneficiary reported by the verifier MUST be the beneficiary returned by `locks(tokenId)`.

It MUST NOT be inferred from the transaction sender, previous NFT owner, `FORT_FEE_RECIPIENT`, an event index, or any off-chain source.

The address that submitted the successful `lock()` transaction is not necessarily the permanent beneficiary.

The lock record alone does not establish current custody or permanence.

### Custody

The verifier MUST call:

`ownerOf(tokenId)`

directly on `CANONICAL_POSITION_MANAGER`.

The returned owner MUST equal `fortLocksAddress`.

This ownership information comes directly from the canonical Uniswap V3 NonfungiblePositionManager, not from FortLocks.

`ownerOf(tokenId)` proves current custody of the position NFT.

The verified FortLocks V1 implementation establishes that the custodian contains no mechanism capable of releasing that position.

Together with the persistent FortLocks lock record, these conditions establish the FortLocks V1 permanent lock.

If `ownerOf(tokenId)` definitively reverts because the specified position NFT does not exist, verification returns `INVALID`.

If the call cannot be reliably completed because of an RPC, network, or infrastructure failure, verification returns `NOT VERIFIED`.

Both the non-zero FortLocks lock record and canonical Uniswap custody MUST be present.

---

## 6. Permanence Verification

A verified FortLocks V1 lock has no unlock date or unlock mechanism.

Permanence is established by the verified FortLocks V1 implementation itself.

The canonical FortLocks V1 implementation provides no mechanism to:

* transfer a successfully locked position NFT out of FortLocks;
* approve another address to transfer the position NFT;
* decrease the position's liquidity;
* burn the position NFT;
* migrate the position;
* recover or rescue the position NFT;
* assign an administrator capable of performing any of these actions;
* upgrade or replace the FortLocks V1 implementation; or
* execute arbitrary external calls that could provide an alternative route to any of these actions.

FortLocks V1 contains no owner or administrative role capable of overriding these properties.

The beneficiary is also not an administrative authority.

Control of the beneficiary address provides no ability to transfer, approve, decrease, burn, migrate, recover, or otherwise release the locked position NFT or its liquidity.

Loss or compromise of the beneficiary address does not create a mechanism to release the locked position.

The complete FortLocks V1 permanence guarantee is:

**Once a canonical Uniswap V3 position NFT has been successfully locked in a verified FortLocks V1 contract, FortLocks V1 provides no mechanism to withdraw, transfer, approve, decrease, burn, migrate, recover, or otherwise release that position, and no administrator or upgrade authority exists that can add such a mechanism later.**

The term `permanently locked` in this specification refers specifically to these properties of the verified FortLocks V1 implementation.

---

## 7. Beneficiary and Fee Verification

For every successfully locked position, FortLocks V1 records a permanent beneficiary in:

`locks(tokenId).beneficiary`

The beneficiary cannot be changed after the position has been successfully locked.

### Pre-Lock Owed Amounts

During `lock()`, after FortLocks receives the position NFT, FortLocks immediately collects all amounts already owed by the position directly to the permanent beneficiary.

FortLocks charges no protocol fee on these pre-lock owed amounts.

This establishes the boundary between amounts already owed before the position was locked and fees collected after the lock.

This distinction is important because amounts already owed before locking may include amounts arising from liquidity decreased before FortLocks received the position NFT.

FortLocks V1 itself never decreases the position's liquidity.

### Post-Lock Fees

Amounts subsequently collected through `collectFees(tokenId)` are treated by FortLocks V1 as post-lock fee proceeds.

FortLocks V1 charges a cumulative protocol fee of:

`90 / 10,000 = 0.9%`

on collected post-lock fees.

The beneficiary receives the collected post-lock fees remaining after the FortLocks protocol fee.

Fractional fee remainders are carried forward between collections so that dividing the same total fees across multiple collection transactions cannot reduce the cumulative FortLocks fee through integer rounding.

For cumulative collected post-lock amount `T`, the FortLocks fee accounting is equivalent to:

`floor(T × 90 / 10,000)`

subject to the separate accounting maintained for each underlying token.

The verifier MUST confirm:

* `FORT_FEE_BPS()` equals `90`
* `BPS_DENOMINATOR()` equals `10000`
* `FORT_FEE_RECIPIENT()` is non-zero and corresponds to the immutable value verified during implementation verification
* `locks(tokenId).beneficiary` is non-zero

### Permissionless Collection

`collectFees(tokenId)` may be called by any address.

The caller:

* cannot specify or change the beneficiary;
* cannot specify or change `FORT_FEE_RECIPIENT`;
* cannot redirect collected funds; and
* receives no portion of collected fees merely for calling.

Permissionless collection changes who may trigger fee distribution, but not who receives the proceeds.

The beneficiary, `FORT_FEE_RECIPIENT`, and a caller of `collectFees()` are economic or operational participants only. None has administrative authority over the locked position.

---

## 8. Lock Discovery and Historical Indexing

FortLocks V1 emits the following event after a position has been successfully locked:

`Locked(uint256 indexed tokenId, address indexed beneficiary)`

Indexers MAY use `Locked` events to discover FortLocks V1 locks and build historical records.

Event indexing is optional and is not part of the required verification procedure.

A verifier that already knows `fortLocksAddress` and `tokenId` can perform complete FortLocks V1 verification using Ethereum state without retrieving historical `Locked` events.

A `Locked` event MUST NOT, by itself, be treated as proof that a position is currently a verified FortLocks V1 lock.

After discovering a position through an event, the verifier MUST independently:

1. verify the FortLocks V1 implementation;
2. read the current lock record from `locks(tokenId)`; and
3. verify custody through `ownerOf(tokenId)` on `CANONICAL_POSITION_MANAGER`.

Event data is therefore useful for discovery and historical indexing. Current contract state and canonical Uniswap custody are the authoritative evidence used for verification.

---

## 9. Verification Result

Verification distinguishes three independent facts:

1. implementation identity;
2. official deployment identity; and
3. permanent-lock status.

A successful official FortLocks V1 verification may be reported as:

```text
Implementation: FortLocks V1 — VERIFIED
Deployment:     Official FortLocks V1 — VERIFIED
Lock:           Permanently Locked — VERIFIED
```

An independently deployed exact FortLocks V1 implementation may validly produce:

```text
Implementation: FortLocks V1 — VERIFIED
Deployment:     Official FortLocks V1 — NOT OFFICIAL
Lock:           Permanently Locked — VERIFIED
```

`NOT OFFICIAL` is a deployment-identity classification and is not a verification failure.

A non-official deployment may independently satisfy the complete FortLocks V1 implementation and permanent-lock verification requirements.

### Verification States

#### `VERIFIED`

The required on-chain verification conditions have been successfully confirmed.

#### `INVALID`

Ethereum data was successfully obtained and a required FortLocks V1 verification condition definitively failed.

Examples include:

* runtime bytecode mismatch;
* incorrect `POSITION_MANAGER`;
* incorrect fee constants;
* zero lock beneficiary;
* `ownerOf(tokenId)` returning an address other than `fortLocksAddress`; or
* definitive evidence that the specified position NFT does not exist.

#### `NOT VERIFIED`

The verifier could not complete the required checks because necessary data or verification resources were unavailable or could not be reliably obtained.

Examples include:

* RPC failure;
* inability to obtain runtime bytecode;
* inability to reproduce the canonical build; or
* an Ethereum call timing out or otherwise failing for infrastructure reasons.

Failure to complete verification MUST NOT be interpreted as evidence that the position is unlocked or invalid.

`INVALID` MUST NOT be used merely because a verified FortLocks V1 implementation is not the official FortLocksProtocol deployment.

### Standard Verification Output

A standard verification result SHOULD retain the following information:

```text
Network:          Ethereum mainnet
Chain ID:         1
Block:            <verification block>

Implementation:   FortLocks V1 — VERIFIED
Deployment:       Official FortLocks V1 — VERIFIED / NOT OFFICIAL
Lock:             Permanently Locked — VERIFIED

FortLocks:        <fortLocksAddress>
Position NFT:     <tokenId>
Beneficiary:      <beneficiary>

Position Manager: 0xC36442b4a4522E871399CD717aBDD847Ab11FE88
Token 0:          <token0>
Token 1:          <token1>
Fee Tier:         <fee>
Liquidity:        <current Uniswap V3 position liquidity>

Unlock Date:      None
Administrator:    None
Upgradeability:   None
```

An integration does not need to display every field in its user interface, but these values SHOULD remain associated with the verification result where available.

A verifier SHOULD perform all on-chain reads used for a verification result against the same Ethereum block and SHOULD record the chain ID and block number used.

For historical verification, the verifier MUST query the Ethereum state corresponding to the historical block being verified.

A verifier MAY choose its own Ethereum confirmation policy. This specification does not prescribe a required confirmation depth.

---

## 10. Scope of Verification

FortLocks V1 verifies that the liquidity controlled by a specific Uniswap V3 position NFT is permanently locked.

Once the position NFT has been successfully locked, FortLocks V1 has no mechanism to withdraw the NFT, transfer it, or decrease the liquidity controlled by it.

Therefore, the liquidity accessible through that position NFT is permanently locked by FortLocks V1.

The position's current Uniswap V3 liquidity value can be read from `positions(tokenId)` on `CANONICAL_POSITION_MANAGER`.

The `liquidity` value is Uniswap V3's liquidity-unit value for the position. It is not, by itself, the amount of `token0` or `token1` represented by the position and is not a market-value measurement.

A liquidity value of zero MUST NOT cause an otherwise valid FortLocks V1 lock to be classified as `INVALID`.

A position with zero current liquidity may still be a permanently locked position NFT. The zero value SHOULD be reported so that users and integrations can distinguish a permanently locked position containing current liquidity from one with zero current liquidity.

Permanent locking refers to FortLocks V1's inability to withdraw, transfer, approve, decrease, burn, migrate, recover, or otherwise release the position.

It does not mean that the position's market value, token composition, accrued fees, or other properties determined by Uniswap V3 and the underlying assets remain constant.

This verification applies to the specific position NFT.

It does not determine how much other liquidity exists for the token, whether other positions or pools exist, or whether the position's liquidity was reduced before it was locked.

Non-standard behaviour of the underlying tokens may affect fee collection, but does not give FortLocks V1 a mechanism to release the position or access its locked liquidity.

A verified position can therefore be described as:

**"The liquidity accessible through this Uniswap V3 position NFT is permanently locked by FortLocks V1."**

Claims such as `"100% of the token's liquidity is locked"` require separate analysis of the token's overall liquidity and are outside the scope of FortLocks V1 verification.

`Permanent` refers to the absence of any mechanism within the verified FortLocks V1 implementation to release or decrease the locked position. It does not constitute a guarantee about the future operation or existence of Ethereum, Uniswap, or the underlying tokens.

---

## 11. Reference Verification Algorithm

Given:

* `fortLocksAddress`
* `tokenId`

perform the following procedure.

### Step 1 — Verify Network

Confirm:

`chainId = 1`

The connected network MUST be Ethereum mainnet.

If the connected network is not Ethereum mainnet, stop. The deployment cannot be verified as FortLocks V1 under this specification.

### Step 2 — Verify Implementation

Obtain the runtime bytecode at `fortLocksAddress`.

Confirm:

* runtime length is exactly 5,725 bytes;
* `POSITION_MANAGER()` equals `CANONICAL_POSITION_MANAGER`;
* `FORT_FEE_BPS()` equals `90`;
* `BPS_DENOMINATOR()` equals `10000`; and
* `FORT_FEE_RECIPIENT()` is not the zero address.

Confirm that the 32-byte regions beginning at offsets:

* `699`
* `2243`
* `2327`

each contain the 32-byte encoded value returned by `FORT_FEE_RECIPIENT()`.

Replace only these three regions with 32 zero bytes.

Compare the resulting runtime bytecode byte-for-byte against the canonical deployed runtime bytecode template reproduced from the canonical FortLocks V1 source and build configuration.

If any required implementation condition definitively fails:

`Implementation: FortLocks V1 — INVALID`

Do not report the position as permanently locked by FortLocks V1.

### Step 3 — Classify Deployment

If an official FortLocks V1 Ethereum mainnet deployment address has been published, compare `fortLocksAddress` against it.

Exact match:

`Deployment: Official FortLocks V1 — VERIFIED`

Different address:

`Deployment: Official FortLocks V1 — NOT OFFICIAL`

This classification does not alter implementation or permanent-lock verification.

### Step 4 — Verify Lock Record

Read:

`locks(tokenId)`

from the verified FortLocks V1 implementation.

Confirm:

`beneficiary != address(0)`

Record this value as the permanent beneficiary.

If the beneficiary is zero, the lock verification is `INVALID`.

### Step 5 — Verify Custody Directly with Uniswap

Call:

`ownerOf(tokenId)`

on `CANONICAL_POSITION_MANAGER`.

Confirm:

`ownerOf(tokenId) == fortLocksAddress`

If the returned owner is different, verification is `INVALID`.

If the token definitively does not exist, verification is `INVALID`.

If the call cannot be reliably completed because of an infrastructure failure, verification is `NOT VERIFIED`.

### Step 6 — Read Position Data

The verifier SHOULD call:

`positions(tokenId)`

on `CANONICAL_POSITION_MANAGER`.

The returned data may be used to report:

* `token0`;
* `token1`;
* fee tier;
* tick range; and
* current Uniswap V3 position liquidity.

These values provide information about the position but are not additional permanent-lock conditions.

A current liquidity value of zero does not invalidate an otherwise verified permanent lock.

### Step 7 — Return Verification Result

Only after all required implementation, lock-record, and custody conditions have been successfully verified may the verifier report:

```text
Implementation: FortLocks V1 — VERIFIED
Lock:           Permanently Locked — VERIFIED
```

Official deployment status is reported separately.

The verified permanent-lock result carries the following FortLocks V1 guarantee:

**Once a canonical Uniswap V3 position NFT has been successfully locked in a verified FortLocks V1 contract, FortLocks V1 provides no mechanism to withdraw, transfer, approve, decrease, burn, migrate, recover, or otherwise release that position, and no administrator or upgrade authority exists that can add such a mechanism later.**

---

## 12. Canonical Build Information

### Canonical Source

Repository:

`FortLocksProtocol/fort-locks`

Canonical FortLocks V1 implementation commit:

`489b53b`

The source tree MUST be obtained from this commit, including the dependency revisions recorded below.

Git submodules MUST be initialized at their recorded revisions.

### Compiler Configuration

The canonical FortLocks V1 build uses:

```text
Solidity compiler: 0.8.35
EVM version:       osaka
Optimizer:         disabled
viaIR:             disabled
Bytecode hash:     ipfs
CBOR metadata:     enabled
Literal content:   disabled
```

`optimizer_runs` is configured as `200`, but the optimizer is disabled.

### Forge

Reference Forge version:

```text
forge Version: 1.8.1
Commit SHA: 982849d3140c01fd3b72905759581a132df7aa98
Build Timestamp: 2026-08-28T17:46:00.964391484Z
Build Profile: dist
```

### Dependency Revisions

```text
forge-std
bf647bd6046f2f7da30d0c2bf435e5c76a780c1b

openzeppelin-contracts
cab19933c33c2ad1d4c7a84864a3601dddfd16f3

v3-core
e3589b192d0be27e100cd0daaf6c97204fdb1899

v3-periphery
80f26c86c57b8a5e4b913f42844d4c8bd274d058
```

### Reference Build

A reference reproduction begins with:

```bash
git checkout 489b53b
git submodule update --init --recursive
forge clean
forge build --build-info
```

The canonical deployed runtime is:

`5,725 bytes`

The only compiler-defined immutable in the FortLocks V1 runtime is:

`FORT_FEE_RECIPIENT`

Solidity compiler `0.8.35` records three 32-byte immutable references beginning at byte offsets:

```text
699
2243
2327
```

The canonical deployed runtime template contains 32 zero bytes at each of these locations.

A deployed FortLocks V1 contract contains the constructor-supplied `FORT_FEE_RECIPIENT` value at each location.

The verification procedure in Section 4 requires the verifier to validate those values before normalizing those exact regions for byte-for-byte comparison.

The canonical FortLocks V1 implementation is identified by commit `489b53b`.

A Git tag may provide a human-readable pointer to this commit, but the commit itself remains the authoritative implementation identifier.
