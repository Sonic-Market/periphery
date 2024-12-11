import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { DeployFunction } from 'hardhat-deploy/types'
import { BOOK_MANAGER, deployWithVerify } from '../utils'

const deployFunction: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments } = hre
  if (await deployments.getOrNull('Controller')) {
    return
  }

  await deployWithVerify(hre, 'Controller', [BOOK_MANAGER[146]])
}

deployFunction.tags = ['Controller']
export default deployFunction
