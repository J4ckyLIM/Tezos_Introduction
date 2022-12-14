#import "../src/contracts/main.mligo" "Main"
#import "./helpers/bootstrap.mligo" "Bootstrap"
#import "./helpers/helper.mligo" "Helper"

let test_successful_originate = 
  let accounts = Bootstrap.boot_accounts(Tezos.get_now()) in
  let (_, taddr, _) = Bootstrap.originate_contract(Bootstrap.base_storage) in
  let () = Test.set_source(accounts.0) in
  let init_storage = Helper.get_storage(taddr) in
  let () = Test.println(Test.to_string(init_storage)) in
  assert(Bootstrap.base_storage = init_storage)

let test_successful_increment = 
  let accounts = Bootstrap.boot_accounts(Tezos.get_now()) in
  let (_, taddr, contr) = Bootstrap.originate_contract(Bootstrap.base_storage) in
  let () = Test.set_source(accounts.0) in
  let () = assert(Bootstrap.base_storage = Helper.get_storage(taddr)) in
  let () = Helper.call_increment_success(3, contr) in
  let modified_storage = Helper.get_storage(taddr) in
  let () = Test.println(Test.to_string(modified_storage)) in
  assert(Helper.get_storage(taddr) = Bootstrap.base_storage + 3)