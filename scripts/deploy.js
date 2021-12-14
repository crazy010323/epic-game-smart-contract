
const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Asimo", "Wall", "Adam"],       // Names
        ["https://images.unsplash.com/photo-1546776310-eef45dd6d63c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cm9ib3R8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60", // Images
        "https://images.unsplash.com/photo-1589254065909-b7086229d08c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cm9ib3R8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60", 
        "https://images.unsplash.com/photo-1580835239846-5bb9ce03c8c3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHJvYm90fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"],
        [100, 200, 300],                    // HP values
        [100, 50, 25]                       // Attack damage values
    );
    await gameContract.deployed();
    console.log('Contracdt deployed to: ', gameContract.address);

    let txn;
    txn = await gameContract.mintCharacterNFT(0);
    await txn.wait();
    console.log("Minted NFT #1");

    txn = await gameContract.mintCharacterNFT(1);
    await txn.wait();
    console.log("Minted NFT #2");

    txn = await gameContract.mintCharacterNFT(2);
    await txn.wait();
    console.log("Minted NFT #3");

    txn = await gameContract.mintCharacterNFT(1);
    await txn.wait();
    console.log("Minted NFT #4");

    console.log("Done deploying and minting!");
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