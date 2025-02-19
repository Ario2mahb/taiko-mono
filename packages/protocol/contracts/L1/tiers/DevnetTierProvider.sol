// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "../../common/EssentialContract.sol";
import "./ITierProvider.sol";

/// @title DevnetTierProvider
/// @dev Labeled in AddressResolver as "tier_provider"
/// @custom:security-contact security@taiko.xyz
contract DevnetTierProvider is EssentialContract, ITierProvider {
    uint256[50] private __gap;

    /// @notice Initializes the contract.
    /// @param _owner The owner of this contract. msg.sender will be used if this value is zero.
    function init(address _owner) external initializer {
        __Essential_init(_owner);
    }

    function getTier(uint16 tierId) public pure override returns (ITierProvider.Tier memory) {
        if (tierId == LibTiers.TIER_OPTIMISTIC) {
            return ITierProvider.Tier({
                verifierName: "tier_optimistic",
                validityBond: 250 ether, // TKO
                contestBond: 500 ether, // TKO
                cooldownWindow: 1440, //24 hours
                provingWindow: 120, // 2 hours
                maxBlocksToVerifyPerProof: 16
            });
        }

        if (tierId == LibTiers.TIER_GUARDIAN) {
            return ITierProvider.Tier({
                verifierName: "tier_guardian",
                validityBond: 0, // must be 0 for top tier
                contestBond: 0, // must be 0 for top tier
                cooldownWindow: 60, //1 hours
                provingWindow: 2880, // 48 hours
                maxBlocksToVerifyPerProof: 16
            });
        }

        revert TIER_NOT_FOUND();
    }

    function getTierIds() public pure override returns (uint16[] memory tiers) {
        tiers = new uint16[](2);
        tiers[0] = LibTiers.TIER_OPTIMISTIC;
        tiers[1] = LibTiers.TIER_GUARDIAN;
    }

    function getMinTier(uint256) public pure override returns (uint16) {
        return LibTiers.TIER_OPTIMISTIC;
    }
}
