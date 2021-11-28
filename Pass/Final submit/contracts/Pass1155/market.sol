import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "./nft.sol";
contract NFTMarket is ReentrancyGuard,ERC165,IERC1155Receiver,IERC1155 {

  PassToken private _token;
    EventNFT private _Event;

    address private _organiser;

    constructor(PassToken token, EventNFT Event) public {
        _token = token;
        _Event = Event;
        _organiser = _Event.getOrganiser();
    }


IERC1155 Token = IERC1155(
      //NFTContractAddress
      );




    modifier isValidSellAmount(uint256 ticketId) {
        uint256 purchasePrice = _ticketDetails[ticketId].purchasePrice;
        uint256 sellingPrice = _ticketDetails[ticketId].sellingPrice;

        require(
            purchasePrice + ((purchasePrice * 110) / 100) > sellingPrice,
            "Re-selling price is more than 110%"
        );
        _;
    }

       function getSellingPrice(uint256 ticketId) public view returns (uint256) {
        return _ticketDetails[ticketId].sellingPrice;
    }




    function purchaseNFT(uint id, uint amount)public payable{
      require(Token.balanceOf(address(this),id)>=amount);
      require(msg.value > 0.1 ether);
      Token.safeTransferFrom(address(this),msg.sender, id, amount,"");
    }

    function secondaryPurchase(uint256 ticketId) public payable isValidSellAmount {
        address seller = _Event.ownerOf(ticketId);
        address buyer = msg.sender;
        uint256 sellingPrice = _Event.getSellingPrice(ticketId);
        uint256 commision = (sellingPrice * 10) / 100;

        _token.transferFrom(buyer, seller, sellingPrice - commision);
        _token.transferFrom(buyer, _organiser, commision);

        _Event.secondaryTransferTicket(buyer, ticketId);

        emit Purchase(buyer, seller, ticketId);
    }

    function onERC1155Received(
    address operator,
    address from,
    uint256 id,
    uint256 value,
    bytes calldata data)
    override external returns (byte4){
      return byte4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));

    }

    function onERC1155BatchReceived(
      address operator,
      address from,
      uint256[] calldata ids,
      uint256[] calldata values,
      bytes  calldata data)
      override external returns (bytes4){
        return byte4(keccak256("onERC1155BatchReceived(address,address,uint256,uint256,bytes)"));
      }

    function supportsInterface(bytes4 interfaceId)public view virtual override (ERC165, IERC165) returns (bool){
      return super.supportsInterface(interfaceId);
    }

    event Purchase(address indexed buyer, address seller, uint256 ticketId);


}
