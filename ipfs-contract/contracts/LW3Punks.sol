// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract LW3Punks is ERC721Enumerable, Ownable {
  using Strings for uint256;
  /**
   * @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
   * token will be the concatenation of the `baseURI` and the `tokenId`.
   */
  string _baseTokenURI;

  uint256 public _price = 0.01 ether;

  bool public _paused;

  uint256 public maxTokenIds = 10;

  uint256 public tokenIds;

  modifier onlyWhenNotPaused() {
    require(!_paused, "contract currently paused");
    _;
  }

  constructor(string memory baseURI) ERC721("LW3Punks", "LW3P") {
    _baseTokenURI = baseURI;
  }

  /**
   * @dev mint allows an user to mint 1 NFT per transaction.
   */
  function mint() public payable onlyWhenNotPaused {
    require(tokenIds < maxTokenIds, "Exceed maximum LW3PUNKS supply");
    require(msg.value >= _price, "Ether sent is not correct");
    tokenIds += 1;
    _safeMint(msg.sender, tokenIds);
  }

  /**
   * @dev _baseURI overides the Openzeppelin's ERC721 implementation which by default
   * returned an empty string for the baseURI
   */
  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  function tokenURI(
    uint256 tokenId
  ) public view virtual override returns (string memory) {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    string memory baseURI = _baseURI();

    return
      bytes(baseURI).length > 0
        ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
        : "";
  }

  function setPaused(bool val) public onlyOwner {
    _paused = val;
  }

  function withdraw() public onlyOwner {
    address _owner = owner();
    uint256 amount = address(this).balance;
    (bool sent, ) = _owner.call{ value: amount }("");
    require(sent, "failed to send ether");
  }

  // Function to receive Ether. msg.data must be empty
  receive() external payable {}

  // Fallback function is called when msg.data is not empty
  fallback() external payable {}
}
