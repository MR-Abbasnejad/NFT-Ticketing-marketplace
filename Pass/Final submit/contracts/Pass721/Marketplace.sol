// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./EventNFT.sol";
import "./PassToken.sol";

contract EventMarketplace {
    PassToken private _token;
    EventNFT private _Event;

    address private _organiser;

    constructor(PassToken token, EventNFT Event) public {
        _token = token;
        _Event = Event;
        _organiser = _Event.getOrganiser();
    }

    event Purchase(address indexed buyer, address seller, uint256 ticketId);

    // Purchase tickets from the organiser directly
    function purchaseTicket() public {
        address buyer = msg.sender;

        _token.transferFrom(buyer, _organiser, _Event.getTicketPrice());

        _Event.transferTicket(buyer);
    }

    // Purchase ticket from the secondary market hosted by organiser
    function secondaryPurchase(uint256 ticketId) public {
        address seller = _Event.ownerOf(ticketId);
        address buyer = msg.sender;
        uint256 sellingPrice = _Event.getSellingPrice(ticketId);
        uint256 commision = (sellingPrice * 10) / 100;

        _token.transferFrom(buyer, seller, sellingPrice - commision);
        _token.transferFrom(buyer, _organiser, commision);

        _Event.secondaryTransferTicket(buyer, ticketId);

        emit Purchase(buyer, seller, ticketId);
    }
}
