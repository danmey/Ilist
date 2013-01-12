module Types = NList.Types;;

(* NList allows us to define lists of list of the same length *)

(* This will type: *)
[ [@ 1;2]; [@3;4]; [@4;5]];;

(* but this will not: *)
(* [ [@2]; [@3;4]; [@4;5]];; *)
