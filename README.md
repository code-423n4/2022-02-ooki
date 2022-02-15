# OOKI Margin Trading and Lending Protocol contest details
- $28,500 USDC main award pot
- $1,500 gas optimization award pot
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2022-02-ooki-contest/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts February 16, 2022 00:00 UTC
- Ends February 18, 2022 23:59 UTC

## Things to Look Out For

Note: The brownie configuration and tests are are out of scope. `testhelpers` is out of scope as well.

Setup guide, can be found [here.](https://github.com/bZxNetwork/contractsV2/tree/interest-model-redesign) make sure its `interest-model-redesign` branch

The full repository is located [here.](https://github.com/bZxNetwork/contractsV2/commit/acf4c8fc775986c26802c0d8eaf9b775d48df9a7). The scope of this audit is the changes found in the following diff [here](https://github.com/bZxNetwork/contractsV2/pull/163/files), made as a result of a previous audit from another firm.

The protocol's core `bZxProtocol` contract is deployed which is a custom moduled proxy, and the `Modules` can be found in `contract/modules` folder.
For every underlying asset there is an `IToken` contract which is the tokenized lending pool. 

The highest financial risk lies in the new interest accruing mechanism that was developed. The previous version used a rollover mechanism using `rollover` function. An EOA could trigger once every 28 days the rollover function for the loan to pay for the accrued interest. Interest was taken from collateral and paid upfront for 28 days. This mechanism has been replaced by dynamic interest rate that is added to the principal of loan. The new contract that is being used to handle this in the protocol is `InterestHandler.sol`. It is important to make sure that all modules are secure and all edge cases are accounted for appropriately, including cases where iTokens are burned minted traded and transfered.

Next critical change is dex selector which is a new feature that allows users to select a dex and provide the necessary payload to execute the swap for the margin trade on the dex chosen. `DexRecords` will serve as the resolver for the deployed swap implementations for the chain. Each swap implementation on `DexRecords` will have an unique ID that is used to retrieve the address. The `swapsImpl` variable found in `State.sol` has been re-purposed to be set to the address of the deployed `DexRecords` contract. payload with details for the swap is passed externally and great care should be taken into verifying those details onchain.

Another change is we added small fee for the flash loans check `payFlashBorrowFees` use cases



## Lines of Code

Total : 60 files changed, 3995 insertions(+), 3752 deletions(-)

### Files

`git diff development --numstat`
| Added Lines | Deleted Lines | File | 
| :--- | :--- | ---: |
| 7       | 9       | brownie-config.yaml |
| 2       | 2       | contracts/adapters/TokenRegistry.sol |
| 7       | 8       | contracts/connectors/loantoken/LoanTokenBase.sol|
| 0       | 561     | contracts/connectors/loantoken/LoanTokenLogicDai.sol |
| 176     | 318     | contracts/connectors/loantoken/LoanTokenLogicStandard.sol |
| 0       | 109     | contracts/connectors/loantoken/LoanTokenLogicWeth_Arbitrum.sol |
| 21      | 1       | contracts/connectors/loantoken/LoanTokenSettings.sol |
| 33      | 24      | contracts/connectors/loantoken/LoanTokenSettingsLowerAdmin.sol |
| 16      | 0       | contracts/connectors/loantoken/StorageExtension.sol |
| 6       | 6       | contracts/core/Constants.sol |
| 15      | 2       | contracts/core/State.sol |
| 5       | 5       | contracts/core/objects/LenderInterestStruct.sol |
| 3       | 3       | contracts/core/objects/LoanInterestStruct.sol |
| 25      | 0       | contracts/events/InterestRateEvents.sol |
| 2       | 1       | contracts/farm/BuyBackAndBurn.sol |
| 2       | 2       | contracts/helpers/DAppHelper.sol |
| 2       | 2       | contracts/helpers/HelperImpl.sol |
| 27      | 0       | contracts/interfaces/ICurvedInterestRate.sol |
| 14      | 0       | contracts/interfaces/IDexRecords.sol |
| 9       | 1       | contracts/interfaces/ILoanPool.sol |
| 11      | 0       | contracts/interfaces/IUniswapQuoter.sol |
| 1       | 0       | contracts/interfaces/IUniswapV3SwapRouter.sol |
| 0       | 11      | contracts/interfaces/IaeWETH.sol |
| 21      | 96      | contracts/mixins/FeesHelper.sol |
| 5       | 0       | contracts/mixins/Flags.sol |
| 157     | 0       | contracts/mixins/InterestHandler.sol |
| 0       | 77      | contracts/mixins/InterestUser.sol |
| 0       | 137     | contracts/mixins/VaultController_Arbitrum.sol |
| 57      | 0       | contracts/modules/FlashBorrowFees/FlashBorrowFeesHelper.sol |
| 6       | 27      | contracts/modules/LoanClosings/LoanClosings.sol |
| 57      | 373     | contracts/modules/LoanClosings/LoanClosingsBase.sol |
| 65      | 375     | contracts/modules/LoanClosings/LoanClosingsBase_Arbitrum.sol |
| 5       | 26      | contracts/modules/LoanClosings/LoanClosings_Arbitrum.sol |
| 0       | 123     | contracts/modules/LoanMaintenance/LoanCleanup.sol |
| 13      | 308     | contracts/modules/LoanMaintenance/LoanMaintenance.sol |
| 45      | 1       | contracts/modules/LoanMaintenance/LoanMaintenance_2.sol |
| 22      | 311     | contracts/modules/LoanMaintenance/LoanMaintenance_Arbitrum.sol |
| 32      | 152     | contracts/modules/LoanOpenings/LoanOpenings.sol |
| 71      | 3       | contracts/modules/LoanSettings/LoanSettings.sol |
| 7       | 3       | contracts/modules/ProtocolSettings/ProtocolSettings.sol |
| 5       | 4       | contracts/modules/SwapsExternal/SwapsExternal.sol |
| 2       | 2       | contracts/stakingv2/modules/StakeUnstake.sol |
| 25      | 0       | contracts/swaps/DexRecords.sol |
| 21      | 21      | contracts/swaps/ISwapsImpl.sol |
| 106     | 46      | contracts/swaps/SwapsUser.sol |
| 68      | 46      | contracts/swaps/connectors/SwapsImplUniswapV2_ARBITRUM.sol |
| 26      | 11      | contracts/swaps/connectors/SwapsImplUniswapV2_BSC.sol |
| 73      | 54      | contracts/swaps/connectors/SwapsImplUniswapV2_ETH.sol |
| 70      | 48      | contracts/swaps/connectors/SwapsImplUniswapV2_POLYGON.sol |
| 363     | 0       | contracts/swaps/connectors/SwapsImplUniswapV3_ETH.sol |
| 457     | 0       | contracts/testhelpers/TWAI.sol |
| 59      | 0       | contracts/utils/CurvedInterestRate.sol |
| 73      | 28      | interfaces/IBZx.sol |
| 15      | 3       | interfaces/IToken |
| 1       | 0       | package.json |
| 18      | 38      | scripts/add-token/add-itoken-arbitrum.py |
| 94      | 0       | tests/test_selector.py |
| 600     | 0       | testsarbitrum/interest-rate-model/test_InterestRate.py |
| 523     | 0       | testspolygon/interest-rate-model/test_InterestRate.py |
| 449     | 374     | yarn.lock |



## Setup

```
pip3 install eth-brownie==1.17.2
npm install
brownie compile
```
