const hre = require("hardhat");

async function main() {
    // Get the signers (deployers)
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Define candidates and voting duration
    const candidates = ["Alice", "Bob", "Charlie"];
    const votingDurationInMinutes = 60;  // Example duration: 60 minutes

    // Get the contract factory for DecentralizedVoting
    const VotingContract = await hre.ethers.getContractFactory("DecentralizedVoting");

    // Deploy the contract with candidates and voting duration
    const votingContract = await VotingContract.deploy(candidates, votingDurationInMinutes);
    console.log("Voting Contract deployed to:", votingContract.address);

    // Wait for the deployment to be mined
    await votingContract.deployed();

    // Log contract details
    console.log(`Contract deployed at address: ${votingContract.address}`);
    console.log(`Deployed by: ${deployer.address}`);
}

// Run the deployment script
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
