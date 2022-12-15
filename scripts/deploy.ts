import { InMemorySigner } from '@taquito/signer';
import { TezosToolkit } from '@taquito/taquito';
import { config } from 'dotenv';
import * as code from "../src/compiled/main.json";
import * as path from 'path';

config({ path: path.join(__dirname, '..', '.env') });

const Tezos = new TezosToolkit(process.env.NODE_URL as string);

const deploy = async () => {
  try {
    const signer = await InMemorySigner.fromSecretKey(process.env.ADMIN_SK as string);
    Tezos.setProvider({ signer });

    const storage = 0;

    const op = await Tezos.contract.originate({ code, storage });
    await op.confirmation();

    console.log(`[OK] Token FA2: ${op.contractAddress}`);
    // check contract storage with CLI
    console.log(`tezos-client --endpoint http://localhost:20000 get contract storage for ${op.contractAddress}`);
  }
  catch (err) {
    console.log(err);
  }
}

deploy();