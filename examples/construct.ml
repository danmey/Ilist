module Types = NList.Types

let list_of_three = [@ 1; 2; 3 ]

let print_three : (int,'b) NList.list3x -> unit = fun lst ->
  let (a,b,c) = NList.first3 lst in
  Printf.printf "%d %d %d" a b c;;

let first_two = function
| x @:: y @:: _ -> x,y;;

print_three list_of_three;;
first_two list_of_three;;
