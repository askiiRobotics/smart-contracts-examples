// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./SomeToken.sol";
import "./SomeTokenTimelock.sol";

contract SomeTokenTimelockFactory {
    using SafeMath for uint;

    SomeToken token;
    SomeTokenTimelock[] tlContracts;
    address[] beneficiaries;
    uint contractsCount;
    mapping(address => SomeTokenTimelock) tlContractsMapped;
    mapping(address => uint[]) balances;
    mapping(address => address[]) contracts;
    mapping(address => address[]) senders;
    mapping(address => uint[]) releaseTimes;

    constructor(address tokenContract) public {
        token = SomeToken(tokenContract);
        contractsCount = 0;
    }

    function getTimelocksForUser(address _user) 
        public
        view
        returns(address[] memory, address[] memory, uint[] memory, uint[] memory)
    {
        address[] memory locks = contracts[_user];
        address[] memory sender = senders[_user];
        uint[] memory balance = balances[_user];
        uint[] memory releaseTime = releaseTimes[_user];

        return (locks, sender, balance, releaseTime);
    }

    function getTimelocksInfoForConract(address _contract) 
        public
        view
        returns(address, uint)
    {
        SomeTokenTimelock tlContract = tlContractsMapped[_contract];

        address beneficiary = tlContract.beneficiary();
        uint releaseTime = tlContract.releaseTime();

        return (beneficiary, releaseTime);
    }
    
    function getBeneficiaries() public view returns(address[] memory) {
        return (beneficiaries);
    }

    function getTimelocks() public view returns(address[] memory) {
        address[] memory contractsResult = new address[](contractsCount);
        uint counter = 0;

        for (uint i = 0; i < beneficiaries.length; i++) {
            address beneficiary = beneficiaries[i];
            for (uint j = 0; j < contracts[beneficiary].length; j++) { 
                contractsResult[counter] = contracts[beneficiary][j];
                counter++;
            }
        }

        return (contractsResult);
    }

    // function info() public view returns(address[] memory, address[] memory, uint[] memory, uint[] memory) {
    //     address[] memory contractsResult = new address[](beneficiaries.length);
    //     address[]    memory sendersResult = new address[](beneficiaries.length);
    //     uint[]    memory releaseTimesResult = new uint[](beneficiaries.length);
    //     uint[]    memory balancesResult = new uint[](beneficiaries.length);

    //     uint counter1 = 0;
    //     uint counter2 = 0;
    //     uint counter3 = 0;
    //     uint counter4 = 0;

    //     for (uint i = 0; i < beneficiaries.length; i++) {
    //         address beneficiary = beneficiaries[i];
    //         for (uint j = 0; j < contracts[beneficiary].length; j++) { 
    //             contractsResult[counter1] = contracts[beneficiary][j];
    //             counter1++;
    //         } 
    //         for (uint j = 0; j < senders[beneficiary].length; j++) { 
    //             sendersResult[counter2] = senders[beneficiary][j];
    //             counter2++;
    //         }
    //         for (uint j = 0; j < releaseTimes[beneficiary].length; j++) { 
    //             releaseTimesResult[counter3] = releaseTimes[beneficiary][j];
    //             counter3++;
    //         }
    //         for (uint j = 0; j < balances[beneficiary].length; j++) { 
    //             balancesResult[counter4] = balances[beneficiary][j];
    //             counter4++;
    //         } 
    //     }

    //     return (contractsResult, sendersResult, releaseTimesResult, balancesResult);
    // }

    function contractBalance_() internal view returns(uint) {
        return token.balanceOf(address(this));
    }


    function releaseAllAfterAllTime()
        public
        returns(bool)
    {
        for (uint j = 0; j < tlContracts.length; j++) { 
                SomeTokenTimelock tlContract = tlContracts[j];
                tlContract.release();
                Released(address(tlContract), msg.sender, tlContract.beneficiary(), block.timestamp, tlContract.releaseTime());
        }
        return true;
    }


    function releaseByContract(address _contract)
        public
        returns(bool)
    {
        SomeTokenTimelock tlContract = tlContractsMapped[_contract];
        tlContract.release();
        Released(_contract, msg.sender, tlContract.beneficiary(), block.timestamp, tlContract.releaseTime());

        return true;
    }

    function newTimeLock(address _owner, uint256 _unlockDate, uint _tvalue)
        public
        returns(address)
    {
        require(_owner != address(0));
        require(_owner != address(this));
        require(_unlockDate > block.timestamp);
        require(_tvalue > 0);
        // Create new timelock.
        SomeTokenTimelock tlContract = new SomeTokenTimelock(token, _owner, _unlockDate);
        address timelock = address(tlContract);
        
        uint _contractBalance = contractBalance_();
        require(token.transferFrom(msg.sender, address(this), _tvalue));
        uint _value = contractBalance_().sub(_contractBalance);
        
        // Add info.
        tlContracts.push(tlContract);
        tlContractsMapped[timelock] = tlContract;
        contracts[_owner].push(timelock);
        senders[_owner].push(msg.sender);
        beneficiaries.push(_owner);
        balances[_owner].push(_value);
        releaseTimes[_owner].push(_unlockDate);

        
        // Send token from this transaction to the created contract.
        token.approve(timelock, _value);
        token.transfer(timelock, _value);

        // Emit event.
        Created(timelock, msg.sender, _owner, block.timestamp, _unlockDate, _value);

        contractsCount++;

        return (timelock);
    }

    // Prevents accidental sending of ether to the factory
    fallback() external payable {
        revert();
    }
    receive() external payable {
        revert();
    }

    event Created(address wallet, address from, address to, uint256 createdAt, uint256 unlockDate, uint256 amount);
    event Released(address wallet, address from, address to, uint256 createdAt, uint256 unlockDate);
}
