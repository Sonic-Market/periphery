// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {BookId} from "core/libraries/BookId.sol";
import {IBookManager} from "core/interfaces/IBookManager.sol";
import {Tick} from "core/libraries/Tick.sol";

import {IController} from "./IController.sol";

/**
 * @title IBookViewer
 * @notice Interface for the book viewer contract
 */
interface IBookViewer {
    struct Liquidity {
        Tick tick;
        uint64 depth;
    }

    /**
     * @notice Returns the book manager
     * @return The instance of the book manager
     */
    function bookManager() external view returns (IBookManager);

    /**
     * @notice Returns the liquidity for a specific book
     * @param id The id of the book
     * @param from The starting tick
     * @param n The number of ticks to return
     * @return liquidity An array of liquidity data
     */
    function getLiquidity(BookId id, Tick from, uint256 n) external view returns (Liquidity[] memory liquidity);

    /**
     * @notice Returns the expected input for a take order
     * @param params The parameters of the take order
     * @return takenQuoteAmount The expected taken quote amount
     * @return spentBaseAmount The expected spend base amount
     */
    function getExpectedInput(IController.TakeOrderParams memory params)
        external
        view
        returns (uint256 takenQuoteAmount, uint256 spentBaseAmount);

    /**
     * @notice Returns the expected output for a spend order
     * @param params The parameters of the spend order
     * @return takenQuoteAmount The expected taken quote amount
     * @return spentBaseAmount The expected spend base amount
     */
    function getExpectedOutput(IController.SpendOrderParams memory params)
        external
        view
        returns (uint256 takenQuoteAmount, uint256 spentBaseAmount);
}
