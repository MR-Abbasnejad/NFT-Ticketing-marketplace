pragma solidity ^0.8.7;


import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC1155/ERC1155.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/utils/Strings.sol";



contract Pass is ERC1155,Ownable{

  using Strings for string;
  using SafeMath for uint256;


string private _uri;   //We use moralis "ipfs:// /*Moralis IPFS*/token/{id}.json"

  // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json

  constructor() ERC1155(string memory uri_) public {
    _setURI(_uri=uri_);
    }

    function _setURI(string memory newuri) internal virtual {
        _uri = newuri;
    }

     function setCustomURI(
        uint256 _tokenId,
        string memory _newURI
    ) public creatorOnly(_tokenId) {
        customUri[_tokenId] = _newURI;
        emit URI(_newURI, _tokenId);
    }

    /* Returns the listing price of the contract */
  function getListingPrice() public view returns (uint256) {
    return listingPrice;
  }

    function mint(
        address _to,
        uint256 _id,
        uint256 _quantity,
        bytes memory _data
    ) virtual public creatorOnly(_id) {
        _mint(_to, _id, _quantity, _data);
        tokenSupply[_id] = tokenSupply[_id].add(_quantity);
    }
    // We use 1 ether for ease of understanding!!

    function create (address _to, uint token id, uint amount,string memory _uri,)public payable{
      require(msg.value >= amount*listingPrice * 1 ether);
      require(tokensRemaining[tokenId].sub(amount) >= 0);
      tokensRemaining[tokenId] = tokensRemaining[tokenId].sub(amount);
       if (bytes(_uri).length > 0) {
            customUri[token id] = _uri;
            emit URI(_uri, token id);
        }
      _mint(_to , tokenId, amount, "");
    }


    function burn(address account, uint256 id, uint256 amount) public {
        require(msg.sender == account);
        _burn(account, id, amount);

    }


    function creatorOf(uint256 _id) public view returns (address) {
        return creators[_id];
    }

}
