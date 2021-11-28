pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./FestivalNFT.sol";
import "./FestivalMarketplace.sol";

contract FestiveTicketsFactory is Ownable {
    struct Festival {
        string EventName;
        string EventSymbol;
        uint256 ticketPrice;
        uint256 totalSupply;
        address marketplace;
    }

    address[] private activeFests;
    mapping(address => Festival) private activeFestsMapping;

    event Created(address ntfAddress, address marketplaceAddress);

    // Creates new NFT and a marketplace for its purchase
    function createNewFest(
        FestToken token,
        string memory EventName,
        string memory EventSymbol,
        uint256 ticketPrice,
        uint256 totalSupply
    ) public onlyOwner returns (address) {
        FestivalNFT newFest =
            new FestivalNFT(
                EventName,
                EventSymbol,
                ticketPrice,
                totalSupply,
                msg.sender
            );

        FestivalMarketplace newMarketplace =
            new FestivalMarketplace(token, newFest);

        address newFestAddress = address(newFest);

        activeFests.push(newFestAddress);
        activeFestsMapping[newFestAddress] = Festival({
            EventName: EventName,
            EventSymbol: EventSymbol,
            ticketPrice: ticketPrice,
            totalSupply: totalSupply,
            marketplace: address(newMarketplace)
        });

        emit Created(newFestAddress, address(newMarketplace));

        return newFestAddress;
    }

    // Get all active fests
    function getActiveFests() public view returns (address[] memory) {
        return activeFests;
    }

    // Get fest's details
    function getFestDetails(address festAddress)
        public
        view
        returns (
            string memory,
            string memory,
            uint256,
            uint256,
            address
        )
    {
        return (
            activeFestsMapping[festAddress].EventName,
            activeFestsMapping[festAddress].EventSymbol,
            activeFestsMapping[festAddress].ticketPrice,
            activeFestsMapping[festAddress].totalSupply,
            activeFestsMapping[festAddress].marketplace
        );
    }
}
