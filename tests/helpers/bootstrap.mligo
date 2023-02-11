#import "../../src/contracts/main.mligo" "Main"
#import "../../src/contracts/storage.mligo" "Storage"

// Account 0 a eviter d'ou le fait d'utiliser le account à partir de 1
// 6n = numbre de compte générés
// Name to use: alice, bob, candice, david, eve, ferdinand

let admin_user = {
    is_admin = true;
    is_whitelisted = true;
    rank = (GigaChad : Storage.rank);
    is_invited_to_be_admin = false;
}

let default_user_map : Storage.user_mapping = 
    Map.literal [
        (Tezos.get_sender(), admin_user);
    ]

let base_storage : Storage.storage = {
    user_map = default_user_map;
    message_map = Map.empty;
}

(* Boostrapping of the test environment *)
let boot_accounts (inittime : timestamp) =
    let () = Test.reset_state_at inittime 6n ([] : tez list) in
    let accounts =
        Test.nth_bootstrap_account 1,
        Test.nth_bootstrap_account 2,
        Test.nth_bootstrap_account 3
    in
    accounts

let originate_contract (init_storage : Storage.storage) =
    let (taddr, _, _) = Test.originate Main.main init_storage 0mutez in
    let contr = Test.to_contract taddr in
    let addr = Tezos.address contr in
    (addr, taddr, contr)
