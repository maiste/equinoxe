let option_of_result = function Result.Ok x -> Some x | Result.Error _ -> None

let rec flatmap ?sep ~f = function
  | [] -> []
  | [ x ] -> f x
  | x :: xs -> (
      let hd = f x in
      let tl = flatmap ?sep ~f xs in
      match sep with None -> hd @ tl | Some sep -> hd @ sep @ tl)

let rec skip_until ~p = function
  | [] -> []
  | h :: t -> if p h then t else skip_until ~p t

let split_at ~f lst =
  let rec loop acc = function
    | hd :: _ as rest when f hd -> (List.rev acc, rest)
    | [] -> (List.rev acc, [])
    | hd :: tl -> loop (hd :: acc) tl
  in
  loop [] lst
