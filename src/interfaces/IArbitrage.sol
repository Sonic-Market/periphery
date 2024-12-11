// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {BookId} from "core/libraries/BookId.sol";
import {Currency} from "core/libraries/Currency.sol";

interface IArbitrage {
    error InvalidAccess();
    error NotOperator();

    event SetOperator(address indexed operator, bool status);

    function setOperator(address operator, bool status) external;

    function arbitrage(BookId id, address router, bytes calldata data) external;

    function withdrawToken(Currency currency, uint256 amount, address recipient) external;
}
