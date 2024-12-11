// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity ^0.8.20;

import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {IProviderFactory} from "./interfaces/IProviderFactory.sol";
import {IBookManager} from "core/interfaces/IBookManager.sol";
import {Provider} from "./Provider.sol";

contract ProviderFactory is IProviderFactory, UUPSUpgradeable, Ownable2Step, Initializable {
    uint256 public defaultBrokerShareRatio;
    IBookManager public bookManager;
    address public treasury;

    constructor() Ownable(msg.sender) {}

    function __ProviderFactory_init(
        address owner_,
        address bookManager_,
        address treasury_,
        uint256 defaultBrokerShareRatio_
    ) public initializer {
        _transferOwnership(owner_);
        Ownable2Step(bookManager_).acceptOwnership();
        bookManager = IBookManager(bookManager_);
        treasury = treasury_;
        defaultBrokerShareRatio = defaultBrokerShareRatio_;
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function deployProvider(address broker) external returns (address) {
        return _deployProvider(broker, defaultBrokerShareRatio);
    }

    function deployProvider(address broker, uint256 shareRatio) public onlyOwner returns (address) {
        return _deployProvider(broker, shareRatio);
    }

    function _deployProvider(address broker, uint256 shareRatio) internal returns (address provider) {
        provider = address(new Provider(broker, shareRatio));
        bookManager.whitelist(provider);
        emit DeployProvider(provider, broker, shareRatio);
    }

    function setTreasury(address newTreasury) external onlyOwner {
        treasury = newTreasury;
        emit SetTreasury(newTreasury);
    }

    function whitelist(address provider) external onlyOwner {
        bookManager.whitelist(provider);
    }

    function delist(address provider) external onlyOwner {
        bookManager.delist(provider);
    }

    function setDefaultProvider(address newDefaultProvider) external onlyOwner {
        bookManager.setDefaultProvider(newDefaultProvider);
    }

    function transferBookManagerOwnership(address newOwner) external onlyOwner {
        Ownable2Step(address(bookManager)).transferOwnership(newOwner);
    }
}
