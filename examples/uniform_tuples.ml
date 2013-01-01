module Type = IList.Type;;

(* With hetergonous list it's possibe to do *)
let list_of_three = [@ 2; "string"; 1.3]

let list_of_three' = [@ 2; 3.14; "string"]

let extract_second = function
| [@ _;x;_] -> x;;

extract_second list_of_three;;
extract_second list_of_three';;

(* So far no difference than with tuples, but we can also do following: *)

let list_of_four'' = [@ 2; 42; "string"; "test"]

(* This will match tuple of length greater than 3, the pattern here is not exhaustive, but let's see later *)
(* Perhaps it requires some heavy annotations, but with Camlp4 or -ppx we can lift it *)
let extract_second_or_first_in_four : type a b c d . (((d, a) Types.cons, b) Types.cons, b) Types.cons Types.t -> b = function
| [@_; x; _ ] -> x
| [@x; _; _;_ ] -> x
| _ -> failwith "No static gurantees"

extract_second_or_first_in_four list_of_four'';;

(*  *)
let extract_second_from_ant : type a b c d . (((d, a) Types.cons, b) Types.cons, b) Types.cons Types.t -> b = function
| [@_ @:: x @:: _ ] -> x
