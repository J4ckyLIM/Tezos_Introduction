let tx_failure (res : test_exec_result) (expected : string) : unit =
  let expected = Test.eval expected in
  match res with
      Success _ -> failwith "contract failed as expected"
    | Fail (error) ->
        (match error with 
          Rejected (actual, _) -> assert (actual = expected)
        | Balance_too_low _err-> failwith "contract failed: balance too low"
        | Other s -> failwith s
        )


let tx_success (res : test_exec_result) (expected : string) =
  let expected = Test.eval expected in
  match res with
      Success _ -> ()
    | Fail (_) -> failwith "contract failed"