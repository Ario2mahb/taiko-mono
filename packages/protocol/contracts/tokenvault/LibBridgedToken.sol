// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/utils/Strings.sol";

/// @title LibBridgedToken
/// @custom:security-contact security@taiko.xyz
library LibBridgedToken {
    error BTOKEN_INVALID_PARAMS();

    function validateInputs(
        address _srcToken,
        uint256 _srcChainId,
        string memory _symbol,
        string memory _name
    )
        internal
        view
    {
        if (
            _srcToken == address(0) || _srcChainId == 0 || _srcChainId == block.chainid
                || bytes(_symbol).length == 0 || bytes(_name).length == 0
        ) {
            revert BTOKEN_INVALID_PARAMS();
        }
    }

    function buildName(
        string memory name,
        uint256 srcChainId
    )
        internal
        pure
        returns (string memory)
    {
        return string.concat("Bridged ", name, unicode" (⭀", Strings.toString(srcChainId), ")");
    }

    function buildSymbol(string memory symbol) internal pure returns (string memory) {
        return string.concat(symbol, ".t");
    }

    function buildURI(address srcToken, uint256 srcChainId) internal pure returns (string memory) {
        // Creates a base URI in the format specified by EIP-681:
        // https://eips.ethereum.org/EIPS/eip-681
        return string(
            abi.encodePacked(
                "ethereum:",
                Strings.toHexString(uint160(srcToken), 20),
                "@",
                Strings.toString(srcChainId),
                "/tokenURI?uint256="
            )
        );
    }
}
