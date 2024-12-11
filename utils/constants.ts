import { arbitrum, arbitrumSepolia, base, berachainTestnetbArtio, zkSync, zkSyncSepoliaTestnet } from 'viem/chains'
import { Address } from 'viem'

export const BOOK_MANAGER: { [chainId: number]: Address } = {
  [146]: '0xD4aD5Ed9E1436904624b6dB8B1BE31f36317C636',
}

export const SAFE_WALLET: { [chainId: number]: Address } = {}
