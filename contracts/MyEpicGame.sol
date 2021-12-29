// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./libraries/Base64.sol";
import 'hardhat/console.sol';

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyEpicGame is ERC721 {

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageUri;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    struct BigBoss {
        string name;
        string imageUri;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    // The tokenId is the NFTs unique identifier, it's just a number that goes
    // 0, 1, 2, 3, etc.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // We create a mapping from the nft's tokenId => that NFTs attributes.
    mapping (uint256 => CharacterAttributes) public nftHolderAttributes;

    // A mapping from an address => the NFTs tokenId. Gives me an ez way
    // to store the owner of the NFT and reference it later.
    mapping (address => uint256) public nftHolders;
    

    CharacterAttributes[] defaultCharacters;
    BigBoss bigBoss;

    event CharacterNFTMinted(address sender, uint tokenId, uint characterIndex);
    event AttackCompleted(uint newBossHp, uint newPlayerHp);

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHPs,
        uint[] memory characterAttackDamage,
        string memory bossName,
        string memory bossImageUri,
        uint bossHp,
        uint bossAttackDamage
    ) ERC721("Epic-Robots", "EPR") {

        bigBoss = BigBoss(bossName, bossImageUri, bossHp, bossHp, bossAttackDamage);

        for (uint256 i = 0; i < characterNames.length; i++) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                imageUri: characterImageURIs[i],
                hp: characterHPs[i],
                maxHp: characterHPs[i],
                attackDamage: characterAttackDamage[i]
            }));
            CharacterAttributes memory c = defaultCharacters[i];
            console.log('Done initializing %s w/ HP: %s, img: %s', c.name, c.hp, c.imageUri);
        }

        // I increment tokenIds here so that my first NFT has an ID of 1.
        // More on this in the lesson!
        _tokenIds.increment();
    }

    // Users would be able to hit this function and get their NFT based on the
    // characterId they send in!
    function mintCharacterNFT(uint characterIndex) external {
        uint256 newItemId = _tokenIds.current();
        
        // The magical function! Assigns the tokenId to the caller's wallet address.
        _safeMint(msg.sender, newItemId);

        // We map the tokenId => their character attributes. More on this in
        // the lesson below.
        CharacterAttributes memory c = defaultCharacters[characterIndex];
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: characterIndex,
            name: c.name,
            imageUri: c.imageUri,
            hp: c.hp,
            maxHp: c.maxHp,
            attackDamage: c.attackDamage
        });

        console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, characterIndex);

        // Keep an easy way to see who owns what NFT.
        nftHolders[msg.sender] = newItemId;

        _tokenIds.increment();

        emit CharacterNFTMinted(msg.sender, newItemId, characterIndex);
    }

    function tokenURI(uint256 _tokenId) public view override returns(string memory) {
        CharacterAttributes memory c = defaultCharacters[_tokenId];
        string memory strHp = Strings.toString(c.hp);
        string memory strMaxHp = Strings.toString(c.maxHp);
        string memory strAttackDamage = Strings.toString(c.attackDamage);
        string memory json = Base64.encode(bytes(
            string(abi.encodePacked(
                '{"name": "', c.name, ' -- NFT #: ', Strings.toString(_tokenId), '", ',
                '"description": "This is an NFT that lets people play in the game Metaverse Slayer!", ',
                '"image": "', c.imageUri, '", ',
                '"attributes": [',
                    '{ "trait_type": "Health Points", "value": ', strHp,', "max_value":', strMaxHp, '}, ',
                    '{ "trait_type": "Attack Damage", "value": ', strAttackDamage, '} ]}'
                )
            )
            )
        );
        string memory output = string(abi.encodePacked('data:application/json;base64,', json));
        return output;
    }

    function attackBoss() public {
        
        // Get the status of the player's NFT
        uint playerTokenId = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[playerTokenId];

        // Make sure the player has more than 0 HP
        require(player.hp > 0, 'Error: You must have HP to attack the boss');

        // Make sure the boss has more than 0 HP
        require(bigBoss.hp > 0, 'Error: Boss must have HP to player the game (already died)');

        // Allow player to attack the boss
        if (bigBoss.hp > player.attackDamage)   bigBoss.hp -= player.attackDamage;
        else bigBoss.hp = 0;

        // Allow boss to attack this player
        if (player.hp > bigBoss.attackDamage)   player.hp -= bigBoss.attackDamage;
        else    player.hp = 0;

        console.log('Player `%s` attacked boss, current HP for Boss is %d', player.name, bigBoss.hp);
        console.log('Boss attacked the player `%s`, current HP of this player is %d', player.name, player.hp);

        emit AttackCompleted(bigBoss.hp, player.hp);
    }

    function checkIfUserHasNFT() view public returns(CharacterAttributes memory) {
        // Get the tokenId of the user's character NFT
        uint userNftTokenId = nftHolders[msg.sender];
        // If the user has a tokenId in the map, return their character.
        if ( userNftTokenId > 0 )   return nftHolderAttributes[userNftTokenId];
        // Else, return an empty character.
        else {
            CharacterAttributes memory emptyStruct;
            return emptyStruct;
        }
    }

    function getAllDefaultCharacters() view public returns(CharacterAttributes [] memory) {
        return defaultCharacters;
    }

    function getBigBoss() view public returns(BigBoss memory) {
        return bigBoss;
    }
}