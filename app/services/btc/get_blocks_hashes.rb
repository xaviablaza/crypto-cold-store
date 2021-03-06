module Btc
  class GetBlocksHashes

    extend LightService::Action
    expects :bitcoiner_client, :unsynced_blocks
    promises :block_hashes

    executed do |c|
      args = c.unsynced_blocks.map do |block_height|
        ["getblockhash", [block_height]]
      end

      response = BitcoindCircuit.run_on_context(c) do
        c.bitcoiner_client.request(args)
      end

      c.block_hashes = response.map { |hash| hash["result"] }
    end

  end
end
