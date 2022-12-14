#import "../../src/contracts/main.mligo" "Main"
#import "assert.mligo" "Assert"

type taddr = (Main.parameter, Main.storage) typed_address
type contr = Main.parameter contract

let get_storage(taddr : taddr) =
  Test.get_storage taddr

let call (p, contr : Main.parameter * contr) =
  Test.transfer_to_contract contr (p) 0mutez

let call_increment (p, contr : int * contr) =
  call(Increment(p), contr)

let call_decrement (p, contr : int * contr) =
  call(Decrement(p), contr)

let call_increment_success (p, contr : int * contr) =
  Assert.tx_success(call_increment(p, contr))