(* Here we will use NList extensions *)
open NLIST;;

module Types = NList.Types;;
(* This type represents relative path, which can't be empty *)
type relative = P : (string, _) NList.list1x -> relative

(* Concatante the list *)
let string_of_relative : relative -> string = fun (P l) -> String.concat "/" (NList.unsafe l)

(* We have to bind it to Type as syntax extension expects it *)

let _ = string_of_relative (P ["src"; "projects"; "Ilist"]);;

let of_string str =
  string_of_relative (P (LIST.(match Str.split (Str.regexp "/") str with
  | x :: xs -> NList.safe1x x xs
  | _ -> failwith "bad pattern")))

(* Following will not work *)
(* let _ = string_of_relative (P []) *)

(* Disable NList extension *)
open LIST;;

(* Following will not work, we already passing a normal list *)
(* let _ = string_of_relative (P ["ala"]) *)
