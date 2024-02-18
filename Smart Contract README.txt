Smart Contracts logic is made by 6 contracts in total:

Tama.sol => It contains 2 contracts: The ERC721 Tama contract where mint, play and evolve functions take place along with the TamaFood ERC-20 token, used to actually feed the character in the eat() function.

NFT images are dynamic, with random generated traits colors, and stored on-chain in the _setTokenURI(uint256 tokenId, string memory _tokenURI) function of the ERC721URIStorage OZ extension: when you use one of the 2 play functions, the counter parameter in gameData[tokenId] gets increased by a value. When the value reaches certain level evolution triggers, the image of the NFT changes by the ERC721 contract, that calls the respective Character image SVG contract, that gets encoded in base64 and then incapsulated in a JSON object. Each Character starting from the Character1 contains traits with colors that get randomly assigned at each call of the respective Character contract when evolution happens.

One of the two functions is the eat(tokenId): it has to get a quantity of TamaToken in input in order to execute. You can mint TamaToken with ETH directly on the TamaToken contract itself.

Character0.sol => Contains the initial Egg image, that gets visualized before the call to the start(tokenId) function that represent its hatching

Character1.sol => Contains Character1
Character2.sol => Contains Character2
Character3.sol => Contains Character3