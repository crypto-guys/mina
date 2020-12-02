(* sql.ml -- (Postgresql) SQL queries for missing blocks auditor *)

open Core_kernel

module Unparented_blocks = struct
  (* state hashes of ends of chains leading to an orphan block *)

  let query =
    Caqti_request.collect Caqti_type.unit Caqti_type.string
      {|
           SELECT parent_state_hash FROM blocks
           WHERE parent_id IS NULL
      |}

  let run (module Conn : Caqti_async.CONNECTION) () =
    Conn.collect_list query ()
end
