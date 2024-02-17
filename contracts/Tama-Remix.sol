// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

import "./Character0.sol";
import "./Character1.sol";
import "./Character2.sol";
import "./Character3.sol";

contract Tama is ERC721, ERC721URIStorage, ERC721Enumerable, Ownable {
    using Strings for uint256;
    uint256 public mintFee = 0.01 ether;
    uint256 public maxMint = 2;
    uint256 public eatTime = 5 minutes;
    uint256 public playTime = 5 minutes;
    uint256 public eatPoints = 10;
    uint256 public playPoints = 10;
    uint256 public lv1Trigger = 100;
    uint256 public lv2Trigger = 500;
    uint256 public eatFee = 500 ether; //based on TamaFood Token
    uint256 private _nextTokenId;

    address public tama0;
    address public tama1;
    address public tama2;
    address public tama3;

    IERC20 foodToken;
    address public tamaFoodAddress;

    event levelUp(uint256 tokenId, uint8 newLevel);
    event tokenBorn(uint256 tokenId, uint256 birthTimestamp);

    event tokenFeeded(
        uint256 tokenId,
        uint256 lastCounter,
        uint256 eatTimestamp
    );

    event tokenPlayed(
        uint256 tokenId,
        uint256 lastCounter,
        uint256 playTimestamp
    );

    constructor() ERC721("Tama", "TAMA") Ownable(msg.sender) {}

    struct tokenData {
        uint8 level;
        uint256 startTime;
        uint256 lastEat;
        uint256 lastPlay;
        uint256 counter;
    }

    mapping(uint256 => tokenData) public gameData;

    modifier gameChecks(uint256 tokenId) {
        require(
            ownerOf(tokenId) == msg.sender,
            "You are not the tokenId holder"
        );

        require(gameData[tokenId].startTime > 0, "Your Tama is not yet born");

        //require i tempi non siano superiori a quanto necessario per non far morire il tamagotchi
        _;
        if (
            gameData[tokenId].counter >= lv1Trigger &&
            gameData[tokenId].level < 1
        ) {
            gameData[tokenId].level = 1;
            _setTokenURI(tokenId, getTokenURI2(tokenId));
            emit levelUp(tokenId, 1);
        }

        if (
            gameData[tokenId].counter >= lv2Trigger &&
            gameData[tokenId].level < 2
        ) {
            gameData[tokenId].level = 2;
            _setTokenURI(tokenId, getTokenURI3(tokenId));
            emit levelUp(tokenId, 1);
        }
    }

    /**
     * -----------  MINT FUNCTIONS -----------
     */

    function purchase(uint256 amount) public payable {
        require(amount <= maxMint, "maxMint exceeded.");
        require(balanceOf(msg.sender) < maxMint, "maxMint reached.");
        require(msg.value == mintFee * amount, "Wrong ETH value sent.");
        for (uint8 i = 0; i < amount; i++) {
            safeMint(msg.sender);
        }
    }

    function safeMint(address to) internal {
        uint256 tokenId = _nextTokenId++;
        _setTokenURI(tokenId, getTokenURI0(tokenId));
        _safeMint(to, tokenId);
    }

    /**
     * -----------  GAME FUNCTIONS  -----------
     */

    function start(uint256 tokenId) public {
        require(
            ownerOf(tokenId) == msg.sender,
            "You are not the tokenId holder"
        );
        _setTokenURI(tokenId, getTokenURI1(tokenId));
        gameData[tokenId].startTime = block.timestamp;
        emit tokenBorn(tokenId, gameData[tokenId].startTime);
    }

    function eat(uint256 tokenId) public payable gameChecks(tokenId) {
        foodToken = IERC20(tamaFoodAddress);
        require(
            !foodToken.transfer(msg.sender, eatFee),
            "Not enough TamaFood sent. Maybe not approved?"
        );
        gameData[tokenId].lastEat = block.timestamp;
        gameData[tokenId].counter += eatPoints;
        emit tokenFeeded(
            tokenId,
            gameData[tokenId].counter,
            gameData[tokenId].lastEat
        );
    }

    function play(uint256 tokenId) public gameChecks(tokenId) {
        gameData[tokenId].lastPlay = block.timestamp;
        gameData[tokenId].counter += playPoints;
        emit tokenPlayed(
            tokenId,
            gameData[tokenId].counter,
            gameData[tokenId].lastPlay
        );
    }

    /**
     * -----------  SET IMAGE + METADATA FUNCTIONS  -----------
     */

    function getTokenURI0(uint256 tokenId) public view returns (string memory) {
        Character0 ch0 = Character0(tama0);

        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Tama #',
            tokenId.toString(),
            '",',
            '"description": "Your own chain Pet",',
            '"image": "',
            ch0.generateCharacter(),
            '"',
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function getTokenURI1(uint256 tokenId) public view returns (string memory) {
        Character1 ch1 = Character1(tama1);

        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Tama #',
            tokenId.toString(),
            '",',
            '"description": "Your own chain Pet",',
            '"image": "',
            ch1.generateCharacter(),
            '"',
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function getTokenURI2(uint256 tokenId) public view returns (string memory) {
        Character2 ch2 = Character2(tama2);

        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Tama #',
            tokenId.toString(),
            '",',
            '"description": "Your own chain Pet",',
            '"image": "',
            ch2.generateCharacter(),
            '"',
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function getTokenURI3(uint256 tokenId) public view returns (string memory) {
        Character3 ch3 = Character3(tama3);

        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Tama #',
            tokenId.toString(),
            '",',
            '"description": "Your own chain Pet",',
            '"image": "',
            ch3.generateCharacter(),
            '"',
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    /**
     * -----------  SET FUNCTIONS  -----------
     */

    function setMintFee(uint256 _mintFee) public onlyOwner {
        mintFee = _mintFee;
    }

    function setMaxMint(uint256 _maxMint) public onlyOwner {
        maxMint = _maxMint;
    }

    function setEatTime(uint256 _eatTime) public onlyOwner {
        eatTime = _eatTime;
    }

    function setPlayTime(uint256 _playTime) public onlyOwner {
        playTime = _playTime;
    }

    function setEatPoints(uint256 _eatPoints) public onlyOwner {
        eatPoints = _eatPoints;
    }

    function setPlayPoints(uint256 _playPoints) public onlyOwner {
        playPoints = _playPoints;
    }

    function setLv1Trigger(uint256 _lv1Trigger) public onlyOwner {
        lv1Trigger = _lv1Trigger;
    }

    function setLv2Trigger(uint256 _lv2Trigger) public onlyOwner {
        lv2Trigger = _lv2Trigger;
    }

    function setEatFee(uint256 _eatFee) public onlyOwner {
        eatFee = _eatFee;
    }

    function setCharacters(
        address _tama0,
        address _tama1,
        address _tama2,
        address _tama3
    ) public onlyOwner {
        tama0 = _tama0;
        tama1 = _tama1;
        tama2 = _tama2;
        tama3 = _tama3;
    }

    function setTamaFoodAddress(address _tamaFoodAddress) public onlyOwner {
        tamaFoodAddress = _tamaFoodAddress;
    }

    /**
     * -----------  ERC721Storage FUNCTIONS  -----------
     */

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

contract TamaFood is ERC20, Ownable {
    uint256 pricePerEth = 1000;

    //bool freeTokens = false;

    constructor() ERC20("TamaFood", "TAFOO") Ownable(msg.sender) {}

    function mint(address to) public payable {
        require(msg.value != 0, "No ETH sent");
        uint256 amount = (msg.value * pricePerEth);
        _mint(to, amount);
    }

    function setPricePerEth(uint256 _pricePerEth) external onlyOwner {
        pricePerEth = _pricePerEth;
    }
}
