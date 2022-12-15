#import "../../src/contracts/main.mligo" "Main"
#import "../../src/contracts/storage.mligo" "Storage"
#import "assert.mligo" "Assert"

type taddr = (Main.parameter, Storage.storage) typed_address
type contr = Main.parameter contract

let get_storage(taddr : taddr) =
  Test.get_storage taddr

let call (p, contr : Main.parameter * contr) =
  Test.transfer_to_contract contr (p) 0mutez

let call_invite_admin (p, contr : address * contr) =
  call(InviteAdmin(p), contr)

let call_invite_admin_success (p, contr : address * contr) =
  Assert.tx_success(call_invite_admin(p, contr))