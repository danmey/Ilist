(* This type represents relative path, which can't be empty *)
type relative = P : (string, _) NList.list1x -> relative

let string_of_relative : relative -> string = fun (P l) -> String.concat "/" (NList.unsafe l)

let _ = string_of_relative (P [@ "src"; "projects"; "Ilist"])

(* Following will not work *)
(* let _ = string_of_relative (P [@ ]) *)
