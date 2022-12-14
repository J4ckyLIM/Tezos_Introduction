let string_failure (res : test_exec_result) (expected : string) : unit =
  let expected = Test.eval expected in
  match res with
    | Fail (Rejected (actual, _)) -> assert (actuel = expected)
    | Fail (Balance_too_low _err) -> failwith "contract failed: balance too low"
    | Fail (Other s) -> failwith s
    

let tx_success () =
  ()