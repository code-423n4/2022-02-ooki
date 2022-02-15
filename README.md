# OOKI Margin Trading and Lending Protocol contest details
- $40,000 USDC main award pot
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://github.com/code-423n4/2022-02-ooki-findings/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts TODO
- Ends TODO

## Things to Look Out For

Note: The brownie configuration and tests are are out of scope. Only .sol files are in scope

Setup guide, can be found [here.](https://github.com/bZxNetwork/contractsV2/tree/interest-model-redesign) make sure its `interest-model-redesign` branch

The full repository is located [here.](https://github.com/bZxNetwork/contractsV2/)

The protocol's core `bZxProtocol` contract is deployed which is a custom moduled proxy, and the `Modules` that can be found in `contract/modules` folder. .
For every underlying asset there is `IToken` contract is being deployed. 

The highest financial risk lies in the new interest accruing mechanism that was developed, before there was a rollover mechanism using `rollover` function. EOA could trigger once in 28 days rollover function for the loan to pay for the accrued interest. Interest was taken from collateral and paid upfront for 28 days. This mechanism was replaced by dynamic interest rate. since we know current `borrowInterestRate()` we can instead dynamically increase loan every block instead of taking it out from collateral check `InterestHandler.sol`. It's important to make sure that all modules are secure and all edge cases are accounted for appropriately, including cases where iToknes are burned minted traded and transfered.

Next critical change is the dex selector that can be used from ui to indicate which route order should take for the swap. initially `SwapsImplUniswapV3_ETH.sol` , `SwapsImplUniswapV2_ETH.sol` will be supported thru `DexRecords` contract. payload with details for the swap is passed externally and great care should be taken into verifying those details onchain.

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

detailed change can be easily found by the following diff [here](https://github.com/bZxNetwork/contractsV2/pull/163/files))
## Readme

The following is a short into from the main README on how to install and compile


# Lens Protocol

The Lens Protocol is a decentralized, non-custodial social graph. Lens implements unique, on-chain social interaction mechanisms analogous to commonly understood Web2 social media interactions, but significantly expanded with unique functionality that empower communities to form and participants to own their own social graph.

## Setup

The environment is built using Docker Compose, note that your `.env` file must have an `ALCHEMY_KEY` or an `INFURA_KEY` variable, and an optional `MNEMONIC` and `ETHERSCAN_KEY`, defined like so:

```
MNEMONIC="MNEMONIC YOU WANT TO DERIVE WALLETS FROM HERE"
ALCHEMY_KEY="YOUR ALCHEMY KEY HERE"
INFURA_KEY="OR YOUR INFURA KEY HERE"
ETHERSCAN_KEY="YOUR ETHERSCAN API KEY HERE"
```

With the environment file set up, you can move on to using Docker:

```
$ sudo docker-compose up
```

And in another terminal:

```
$ sudo docker-compose exec contracts-env bash
```

From there, have fun!

Here are a few self-explanatory scripts:

```
$ npm run test
$ npm run coverage
$ npm run compile
```

## Protocol Overview

The Lens Protocol transfers ownership of social graphs to the participants of that graph themselves. This is achieved by creating direct links between `profiles` and their `followers`, while allowing fine-grained control of additional logic, including monetization, to be executed during those interactions on a profile-by-profile basis.

Here's how it works...

### Profiles

Any address can create a profile and receive an ERC-721 `Lens Profile` NFT. Profiles are represented by a `ProfileStruct`:

```
/**
 * @notice A struct containing profile data.
 *
 * @param pubCount The number of publications made to this profile.
 * @param followNFT The address of the followNFT associated with this profile, can be empty..
 * @param followModule The address of the current follow module in use by this profile, can be empty.
 * @param handle The profile's associated handle.
 * @param uri The URI to be displayed for the profile NFT.
 */
struct ProfileStruct {
    uint256 pubCount;
    address followNFT;
    address followModule;
    string handle;
    string uri;
}
```

Profiles have a specific URI associated with them, which is meant to include metadata, such as a link to a profile picture or a display name for instance, the JSON standard for this URI is not yet determined. Profile owners can always change their follow module or profile URI.

#### Publications

Profile owners can `publish` to any profile they own. There are three `publication` types: `Post`, `Comment` and `Mirror`. Profile owners can also set and initialize the `Follow Module` associated with their profile.

Publications are on-chain content created and published via profiles. Profile owners can create (publish) three publication types, outlined below. They are represented by a `PublicationStruct`:

```
/**
 * @notice A struct containing data associated with each new publication.
 *
 * @param profileIdPointed The profile token ID this publication points to, for mirrors and comments.
 * @param pubIdPointed The publication ID this publication points to, for mirrors and comments.
 * @param contentURI The URI associated with this publication.
 * @param referenceModule The address of the current reference module in use by this profile, can be empty.
 * @param collectModule The address of the collect module associated with this publication, this exists for all publication.
 * @param collectNFT The address of the collectNFT associated with this publication, if any.
 */
struct PublicationStruct {
    uint256 profileIdPointed;
    uint256 pubIdPointed;
    string contentURI;
    address referenceModule;
    address collectModule;
    address collectNFT;
}
```

#### Publication Types

##### Post

This is the standard publication type, akin to a regular post on traditional social media platforms. Posts contain:

1. A URI, pointing to the actual publication body's metadata JSON, including any images or text.
2. An uninitialized pointer, since pointers are only needed in mirrors and comments.

##### Comment

This is a publication type that points back to another publication, whether it be a post, comment or mirror, akin to a regular comment on traditional social media. Comments contain:

1. A URI, just like posts, pointing to the publication body's metadata JSON.
2. An initialized pointer, containing the profile ID and the publication ID of the publication commented on.

##### Mirror

This is a publication type that points to another publication, note that mirrors cannot, themselves, be mirrored (doing so instead mirrors the pointed content). Mirrors have no original content of its own. Akin to a "share" on traditional social media. Mirrors contain:

1. An empty URI, since they cannot have content associated with them.
2. An initialized pointer, contianing the profile ID and the publication ID of the mirrored publication.

### Profile Interaction

There are two types of profile interactions: follows and collects.

#### Follows

Wallets can follow profiles, executing modular follow processing logic (in that profile's selected follow module) and receiving a `Follow NFT`. Each profile has a connected, unique `FollowNFT` contract, which is first deployed upon successful follow. Follow NFTs are NFTs with integrated voting and delegation capability.

The inclusion of voting and delegation right off the bat means that follow NFTs have the built-in capability to create a spontaneous DAO around any profile. Furthermore, holding follow NFTs allows followers to `collect` publications from the profile they are following (except mirrors, which are equivalent to shares in Web2 social media, and require following the original publishing profile to collect).

#### Collects

Collecting works in a modular fashion as well, every publication (except mirrors) requires a `Collect Module` to be selected and initialized. This module, similarly to follow modules, can contain any arbitrary logic to be executed upon collects. Successful collects result in a new, unique NFT being minted, essentially as a saved copy of the original publication. There is one deployed collect NFT contract per publication, and it's deployed upon the first successful collect.

When a mirror is collected, what happens behind the scenes is the original, mirrored publication is collected, and the mirror publisher's profile ID is passed as a "referrer." This allows neat functionality where collect modules that incur a fee can, for instance, reward referrals. Note that the `Collected` event, which is emitted upon collection, indexes the profile and publication directly being passed, which, in case of a mirror, is different than the actual original publication getting collected (which is emitted unindexed).

Alright, that was a mouthful! Let's move on to more specific details about Lens's core principle: Modularity.

## Lens Modularity

Stepping back for a moment, the core concept behind modules is to allow as much freedom as possible to the community to come up with new, innovative interaction mechanisms between social graph participants. For security purposes, this is achieved by including a whitelisted list of modules controlled by governance.

To recap, the Lens Protocol has three types of modules:

1. `Follow Modules` contain custom logic to be executed upon follow.
2. `Collect Modules` contain custom logic to be executed upon collect. Typically, these modules include at least a check that the collector is a follower.
3. `Reference Modules` contain custom logic to be executed upon comment and mirror. These modules can be used to limit who is able to comment and interact with a profile.

Note that collect and reference modules should _not_ assume that a publication cannot be re-initialized, and thus should include front-running protection as a security measure if needed, as if the publication data was not static. This is even more prominent in follow modules, where it can absolutely be changed for a given profile.

Lastly, there is also a `ModuleGlobals` contract which acts as a central data provider for modules. It is controlled by a specific governance address which can be set to a different executor compared to the Hub's governance. It's expected that modules will fetch dynamically changing data, such as the module globals governance address, the treasury address, the treasury fee as well as a list of whitelisted currencies.

### Upgradeability

This iteration of the Lens Protocol implements a transparent upgradeable proxy for the central hub to be controlled by governance. There are no other aspects of the protocol that are upgradeable. In an ideal world, the hub will not require upgrades due to the system's inherent modularity and openness, upgradeability is there only to implement new, breaking changes that would be impossible, or unreasonable to implement otherwise.

This does come with a few caveats, for instance, the `ModuleGlobals` contract implements a currency whitelist, but it is not upgradeable, so the "removal" of a currency whitelist in a module would require a specific new module that does not query the `ModuleGlobals` contract for whitelisted currencies.
