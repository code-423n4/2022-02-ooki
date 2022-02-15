# Aave Lens Protocol contest details
- $95,000 USDC main award pot
- $5,000 USDC gas optimization award pot
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2022-02-aave-lens-contest/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts February 3, 2022 00:00 UTC
- Ends February 9, 2022 23:59 UTC

## Things to Look Out For

Note: The `SecretCodeFollowModule` and `mock` contracts are out of scope.

Documentation, including an overview, setup guide, specification and walthrough can be found [here.](https://docs.lens.dev/docs) The readme is copied over in this readme as well for convenience!

The full repository is located [here.](https://github.com/aave/lens-protocol)

The protocol's core `LensHub` contract is deployed with OpenZeppelin's `TransparentUpgradeableProxy`, and the `Clones` library is used extensively. Care should be taken to ensure proper use of these proxying mechanisms (e.g. Potential issues down the line/etc).

Furthermore, the `FollowNFT` has built-in governance, which is only "enabled" for a wallet upon its first delegation. The governance mechanism is inspired by the [Aave token.](https://github.com/aave/aave-token-v2/blob/master/contracts/token/base/GovernancePowerDelegationERC20.sol) There is also extensive use of `unchecked {}` blocks, including some expected underflows. Care should be taken to ensure that voting power is properly accounted for in all cases.

The highest financial risk lies in the system's modules, as those are the contracts that are expected to handle fund transfers. It's important to make sure that all modules are secure and all edge cases are accounted for appropriately, including cases where follow/collect NFTs are burned, transferred, etc. It is also worth noting that, since the `LensHub` is upgradeable, modules should be built assuming that re-initialization is always a possibility (it already is for follow modules, but not for collect & reference modules).

## Lines of Code

Total : 60 files changed, 3995 insertions(+), 3752 deletions(-)

### Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| contracts/core/CollectNFT.sol | Solidity | 49 | 16 | 12 | 77 |
| contracts/core/FollowNFT.sol | Solidity | 233 | 43 | 41 | 317 |
| contracts/core/LensHub.sol | Solidity | 766 | 106 | 89 | 961 |
| contracts/core/base/IERC721Time.sol | Solidity | 10 | 33 | 6 | 49 |
| contracts/core/base/ERC721Enumerable.sol | Solidity | 86 | 71 | 25 | 182 |
| contracts/core/base/ERC721Time.sol | Solidity | 242 | 192 | 56 | 490 |
| contracts/core/base/LensMultiState.sol | Solidity | 33 | 10 | 10 | 53 |
| contracts/core/base/LensNFTBase.sol | Solidity | 136 | 30 | 20 | 186 |
| contracts/core/modules/FeeModuleBase.sol | Solidity | 28 | 8 | 9 | 45 |
| contracts/core/modules/FollowValidationModuleBase.sol | Solidity | 19 | 12 | 4 | 35 |
| contracts/core/modules/ModuleBase.sol | Solidity | 15 | 8 | 6 | 29 |
| contracts/core/modules/ModuleGlobals.sol | Solidity | 80 | 27 | 20 | 127 |
| contracts/core/modules/collect/EmptyCollectModule.sol | Solidity | 23 | 16 | 6 | 45 |
| contracts/core/modules/collect/FeeCollectModule.sol | Solidity | 108 | 48 | 23 | 179 |
| contracts/core/modules/collect/LimitedFeeCollectModule.sol | Solidity | 123 | 50 | 24 | 197 |
| contracts/core/modules/collect/LimitedTimedFeeCollectModule.sol | Solidity | 129 | 53 | 26 | 208 |
| contracts/core/modules/collect/RevertCollectModule.sol | Solidity | 21 | 16 | 5 | 42 |
| contracts/core/modules/collect/TimedFeeCollectModule.sol | Solidity | 116 | 51 | 26 | 193 |
| contracts/core/modules/follow/ApprovalFollowModule.sol | Solidity | 74 | 46 | 14 | 134 |
| contracts/core/modules/follow/FeeFollowModule.sol | Solidity | 61 | 40 | 14 | 115 |
| contracts/core/modules/follow/FollowValidatorFollowModuleBase.sol | Solidity | 22 | 14 | 4 | 40 |
| contracts/core/modules/reference/FollowerOnlyReferenceModule.sol | Solidity | 31 | 21 | 7 | 59 |
| contracts/core/storage/LensHubStorage.sol/cor | Solidity | 35 | 31 | 7 | 73 |
| contracts/interfaces/ICollectModule.sol | Solidity | 15 | 26 | 4 | 45 |
| contracts/interfaces/ICollectNFT.sol | Solidity | 11 | 28 | 5 | 44 |
| contracts/interfaces/IFollowModule.sol | Solidity | 22 | 53 | 6 | 81 |
| contracts/interfaces/IFollowNFT.sol | Solidity | 18 | 45 | 10 | 73 |
| contracts/interfaces/ILensHub.sol | Solidity | 83 | 343 | 53 | 479 |
| contracts/interfaces/ILensNFTBase.sol | Solidity | 18 | 45 | 8 | 71 |
| contracts/interfaces/IModuleGlobals.sol | Solidity | 12 | 59 | 12 | 83 |
| contracts/interfaces/IReferenceModule.sol | Solidity | 18 | 30 | 5 | 53 |
| contracts/libraries/Constants.sol | Solidity | 8 | 1 | 3 | 12 |
| contracts/libraries/DataTypes.sol | Solidity | 131 | 180 | 20 | 331 |
| contracts/libraries/Errors.sol | Solidity | 38 | 3 | 5 | 46 |
| contracts/libraries/Events.sol | Solidity | 170 | 271 | 37 | 478 |
| contracts/libraries/Helpers.sol | Solidity | 31 | 20 | 7 | 58 |
| contracts/libraries/InteractionLogic.sol | Solidity | 106 | 31 | 21 | 158 |
| contracts/libraries/PublishingLogic.sol | Solidity | 294 | 84 | 34 | 412 |
| contracts/upgradeability/VersionedInitializable.sol | Solidity | 17 | 28 | 7 | 52 |


## Setup
```
pip3 install eth-brownie==1.17.2
npm install
brownie compile
```

