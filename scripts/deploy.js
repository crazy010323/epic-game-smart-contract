
const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Asimo", "Wall", "Adam"],       // Names
        [
            "https://images.unsplash.com/photo-1593376853899-fbb47a057fa0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTl8fHJvYm90fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60", // Images
            "https://images.unsplash.com/photo-1589254065909-b7086229d08c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cm9ib3R8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60", 
            "https://images.unsplash.com/photo-1580835239846-5bb9ce03c8c3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHJvYm90fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"
        ],
        [100, 200, 300],                    // HP values
        [100, 50, 25],                      // Attack damage values
        "Elon Musk", // Boss name
        "https://images.unsplash.com/photo-1593377201811-4516986cbe41?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MXwxMTM5ODg4Mnx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60", // Boss image
        10000, // Boss hp
        50 // Boss attack damage
    );
    await gameContract.deployed();
    console.log('Contracdt deployed to: ', gameContract.address);

    // We only have three characters.
    // an NFT w/ the character at index 2 of our array.
    let txn = await gameContract.mintCharacterNFT(2);
    await txn.wait();

    // Get the value of the NFT's URI.
    let returnedTokenUri = await gameContract.tokenURI(1);
    console.log('Token URI: ', returnedTokenUri);

    // Attack boss twice
    txn = await gameContract.attackBoss();
    await txn.wait();
    
    txn = await gameContract.attackBoss();
    await txn.wait();

    console.log('Done!')
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);   
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();