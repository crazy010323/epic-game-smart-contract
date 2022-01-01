
const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Asimo", "Wall", "Adam"],       // Names
        [// Images
            "QmabvGZvFyPa26w9tyo8paaLcxTf7GzHoobWHPfTCaPLWM",
            "QmREDREsnW7AdjuscQFW3dx6Wu4BbEHxkr7S2Vmzgk9z42", 
            "QmdFLJG8A18CAkRxGLwsHcBFiABYfNyiypEQZ2r4u3KbZW"
        ],
        [100, 200, 300],                    // HP values
        [100, 50, 25],                      // Attack damage values
        "Elon Musk", // Boss name
        "QmPiX6HgvP7p9nooioap8fv8GaBWZ7wHHK9roHkHBRuLtr", // Boss image
        10000, // Boss hp
        50 // Boss attack damage
    );
    await gameContract.deployed();
    console.log('Contracdt deployed to: ', gameContract.address);
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