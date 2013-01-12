module Types = NList.Types
let a = [1;2;3;4];;
let b = NLIST.(1::[2;3]);;

(* Works *)
NLIST.(match b with
| x :: y :: z -> ());;

(* Works *)
NLIST.(match b with
| [x; y; z] -> ());;

(* Will not compile *)
(* NLIST.(match b with *)
(* | [x; y; z; _] -> ());; *)

(* Works *)
NLIST.(match b with
| x :: y :: _ -> ());;

(* Works *)
NLIST.(match b with
| x :: y :: z :: _ -> ());;

(* Will not compile *)
(* NLIST.(match b with *)
(* | x :: y :: z :: _ :: _ -> ());; *)
