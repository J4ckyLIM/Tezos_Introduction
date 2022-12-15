#import "./storage.mligo" "Storage"
#import "./parameter.mligo" "Parameter"
#import "./errors.mligo" "Errors"

type parameter =
    InviteAdmin of Storage.user
  | RemoveAdmin of Storage.user
  | AcceptAdmin of Storage.user
  | WriteMessage of string

let get_user_info (_get_user_param, store : Parameter.get_user_parameter * Storage.storage) : Storage.info =
  let user_info : Storage.info option =
    Map.find_opt (Tezos.get_sender()) store.user_map in
  match user_info with 
    Some (info) -> info
    | None -> failwith Errors.no_entry

let assert_admin (_assert_admin_parameter, store : Parameter.assert_admin_parameter * Storage.storage) : unit =
    let user_info : Storage.info = get_user_info (Tezos.get_sender(), store) in
    if(user_info.is_admin) then ()
    else failwith Errors.not_admin

let remove_admin (remove_admin_parameter, store: Parameter.remove_admin_parameter * Storage.storage) : Storage.storage =
    let user_info : Storage.info = get_user_info (Tezos.get_sender(), store) in
    if(user_info.is_admin) then
        let new_user_map : Storage.user_mapping =
            match Map.find_opt (remove_admin_parameter) store.user_map with
                Some (user_info) -> 
                  if (user_info.is_admin) then 
                    let new_user_info : Storage.info = 
                      { user_info with is_invited_to_be_admin = false } in
                    Map.update (remove_admin_parameter) (Some new_user_info) store.user_map 
                  else failwith Errors.user_not_admin
                | None -> failwith Errors.no_entry
            in
            { store with user_map = new_user_map }
    else failwith Errors.not_admin

let invite_admin (invite_admin_param, store : Parameter.invite_admin_parameter * Storage.storage) : Storage.storage =
  let new_user_map : Storage.user_mapping =
        match Map.find_opt (invite_admin_param) store.user_map with
            Some (user_info) -> 
              if (user_info.is_admin) then failwith Errors.user_already_admin
              else  (
                let new_user_info : Storage.info = 
                      { user_info with is_invited_to_be_admin = true } in
                Map.update (invite_admin_param) (Some new_user_info) store.user_map 
              )
            | None -> 
                (
                  let new_user_info : Storage.info = 
                      { is_admin = false; is_whitelisted = false; rank = (Chad : Storage.rank); is_invited_to_be_admin = true } in
                  Map.add (invite_admin_param) new_user_info store.user_map 
                )
        in
        { store with user_map = new_user_map }

let accept_admin (_accept_admin_parameter, store : Parameter.accept_admin_parameter * Storage.storage) : Storage.storage =
  let new_user_map : Storage.user_mapping =
        match Map.find_opt (Tezos.get_sender()) store.user_map with
            Some (user_info) -> 
              if (user_info.is_admin) then failwith Errors.user_already_admin
              else if (user_info.is_invited_to_be_admin) then
                let new_user_info : Storage.info = 
                      { user_info with is_admin = true; is_invited_to_be_admin = false } in
                Map.update (Tezos.get_sender()) (Some new_user_info) store.user_map 
              else failwith Errors.user_not_invited
            | None -> failwith Errors.no_entry
        in
        { store with user_map = new_user_map }

[@view]
let get_user_rank (get_user_rank_parameter, store : Parameter.get_user_rank_parameter * Storage.storage) : Storage.rank =
  let user_info : Storage.info = get_user_info (get_user_rank_parameter, store) in
  user_info.rank

let write_message (write_message_parameter, store : Parameter.write_message_parameter * Storage.storage) : Storage.storage =
  let user_info : Storage.info = get_user_info (Tezos.get_sender(), store) in
  if (user_info.is_whitelisted) then
    let new_message_map : Storage.message_mapping = 
      Map.add (Tezos.get_sender()) write_message_parameter store.message_map in
    { store with message_map = new_message_map }
  else failwith Errors.not_whitelisted


(* Main access point that dispatches to the entrypoints according to
   the smart contract parameter. *)
   
let main (action, store : parameter * Storage.storage) : operation list * Storage.storage =
 ([] : operation list),    // No operations
 (match action with
   InviteAdmin (n) -> 
    let () : unit = assert_admin(Tezos.get_sender(), store) in
    invite_admin (n, store)
 | RemoveAdmin (n) -> 
    let () : unit = assert_admin(Tezos.get_sender(), store) in
    remove_admin (n, store)
 | AcceptAdmin (n) -> accept_admin (n, store)
 | WriteMessage (n) -> write_message (n, store)
 )
