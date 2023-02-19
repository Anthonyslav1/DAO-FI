
pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";


contract IdentifyNFT is ERC721Enumerable, Ownable {

  
  using Strings for uint256;

  string baseURI;
  string public baseExtension = ".json";
  bool public paused = false;
  bool public revealed = false;
  string public notRevealedUri;
    uint256 maxMintAmount = 1;

  constructor (

    string memory _name,
    string memory _symbol,
    string memory _initBaseURI,
    string memory _initNotRevealedUri
   ) ERC721(_name, _symbol) {
     
    setBaseURI(_initBaseURI);
    setNotRevealedURI(_initNotRevealedUri);
  }



 function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }
  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  // public
  function mint(uint256 _mintAmount) public payable {
    uint256 supply = totalSupply();
    require(!paused);
    
    require(_mintAmount >0 && _mintAmount <= maxMintAmount, "One identity per person" );
  
   require(balanceOf(msg.sender) <= 0, "One identity per person");

  




    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

 

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    if(revealed == false) {
        return notRevealedUri;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  //only owner
  function reveal() public onlyOwner {
      revealed = true;
  }
  


  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintAmount = _newmaxMintAmount;
  }
  
  function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
    notRevealedUri = _notRevealedURI;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
 
  function safeTransferFrom( address from,address to, uint256 tokenId ) public pure
  override(ERC721)
  {
      require (from == address(0) && to == address(0), "None transferable"); 
  }
  function safeTransferFrom( address from,address to, uint256 tokenId, bytes memory data) public pure  
  override(ERC721)
  {
      require (from == address(0) && to == address(0), "None transferable"); 
  }
    function transferFrom( address from,address to, uint256 tokenId) public 
    override(ERC721)
    {
       require (from == address(0) && to == address(0), "None transferable");
       
        transferFrom(msg.sender, to, tokenId);
    }    

}
