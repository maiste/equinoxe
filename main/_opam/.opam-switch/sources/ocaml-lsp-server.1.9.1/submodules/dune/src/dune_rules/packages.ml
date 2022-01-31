open! Dune_engine
open! Stdune
open Import
open Dune_file
open Memo.Build.O

let mlds_by_package_def =
  Memo.With_implicit_output.create "mlds by package"
    ~implicit_output:Rules.implicit_output
    ~input:(module Super_context.As_memo_key)
    (fun sctx ->
      let stanzas = Super_context.stanzas sctx in
      Memo.Build.parallel_map stanzas ~f:(fun (w : _ Dir_with_dune.t) ->
          Memo.Build.parallel_map w.data ~f:(function
            | Documentation d ->
              let* dc = Dir_contents.get sctx ~dir:w.ctx_dir in
              let+ mlds = Dir_contents.mlds dc d in
              let name = Package.name d.package in
              Some (name, mlds)
            | _ -> Memo.Build.return None)
          >>| List.filter_map ~f:Fun.id)
      >>| List.concat
      >>| Package.Name.Map.of_list_reduce ~f:List.rev_append)

let mlds_by_package = Memo.With_implicit_output.exec mlds_by_package_def

(* TODO memoize this so that we can cutoff at the package *)
let mlds sctx pkg =
  let+ map = mlds_by_package sctx in
  Package.Name.Map.find map pkg |> Option.value ~default:[]
