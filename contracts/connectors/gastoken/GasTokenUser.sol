/**
 * Copyright 2017-2020, bZeroX, LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0.
 */

pragma solidity 0.5.17;

import "../../openzeppelin/Ownable.sol";
import "../../openzeppelin/SafeMath.sol";


contract IChiToken {
    function balanceOf(address _who) public view returns (uint256);
    function freeFromUpTo(address from, uint256 value)  public returns (uint256 freed);
}

contract GasTokenUser is Ownable {
    using SafeMath for uint256;

    IChiToken constant public gasToken = IChiToken(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
    address constant public tokenHolder = 0x7E2Afb9224526fD9757e2A61DC07dDA61A41e3A6;

    modifier usesGasToken(address holder) {
        if (holder == address(0)) {
            holder = tokenHolder;
        }

        if (gasToken.balanceOf(holder) != 0) {
            uint256 gasCalcValue = gasleft();

            _;

            gasCalcValue = (_gasUsed(gasCalcValue) + 14154) / 41947;

            gasToken.freeFromUpTo(
                holder,
                gasCalcValue
            );
        } else {
            _;
        }
    }

    function _gasUsed(
        uint256 startingGas)
        internal
        view
        returns (uint256)
    {
        return 21000 +
            startingGas -
            gasleft() +
            16 *
            msg.data.length;

    }
}
