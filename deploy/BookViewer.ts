import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { DeployFunction } from 'hardhat-deploy/types'
import { deployWithVerify, BOOK_MANAGER } from '../utils'
import { Address, encodeFunctionData } from 'viem'

const deployFunction: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre
  const deployer = (await getNamedAccounts())['deployer'] as Address

  if (await deployments.getOrNull('BookViewer_Implementation')) {
    return
  }

  let owner: Address = deployer

  const implementation = (await deployWithVerify(hre, 'BookViewer_Implementation', [BOOK_MANAGER[146]], {
    contract: 'BookViewer',
  })) as Address

  let viewer = (await deployments.getOrNull('BookViewer'))?.address
  const bookViewerArtifact = await hre.artifacts.readArtifact('BookViewer')
  if (!viewer) {
    const initData = encodeFunctionData({
      abi: bookViewerArtifact.abi,
      functionName: '__BookViewer_init',
      args: [owner],
    })
    viewer = await deployWithVerify(hre, 'BookViewer_Proxy', [implementation, initData], {
      contract: 'ERC1967Proxy',
    })
  }

  await deployments.save('BookViewer', {
    address: viewer,
    abi: bookViewerArtifact.abi,
    implementation: implementation,
  })
}

deployFunction.tags = ['BookViewer']
export default deployFunction
