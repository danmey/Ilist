
(* This type represents relative path, which can't be empty *)
type relative = P : (string, _) NList.list1x -> relative

(* Concatante the list *)
let string_of_relative : relative -> string = fun (P l) -> String.concat "/" (NList.unsafe l)

(* We have to bind it to Type as syntax extension expects it *)
module Type = NList.Type

let _ = string_of_relative (P [@ "src"; "projects"; "Ilist"])

(* Following will not work *)
(* let _ = string_of_relative (P [@ ]) *)
