(*---------------------------------------------------------------------------
  Copyright (c) 2012 Wojciech Meyer
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the
     distribution.

  3. Neither the name of Wojciech Meyer nor the names of
     contributors may be used to endorse or promote products derived
     from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  ---------------------------------------------------------------------------*)

module Types = struct
  type (_, _) cons
  type nil

  type _ t =
    | Cons : 'a * 'b t -> ('b, 'a) cons t
    | Nil : nil t

end

include Types
let empty : nil t = Nil
let cons : type a b c . a -> b t -> (b,a) cons t = fun x xs -> Cons (x, xs)
let hd : type a b . (b,a) cons t -> a = fun (Cons (x,_)) -> x
let tl : type a b . (b,a) cons t -> b t = fun (Cons (_,xs)) -> xs
let singleton : type a . a -> (nil,a) cons t = fun x -> Cons (x, Nil)

(* type ('a,'b) list1x = ('b cons) t *)
(* type 'a list2 = ('a, nil cons cons) t *)
(* type ('a,'b) list2x = ('a, 'b cons cons) t *)
(* type 'a list3 = ('a, nil cons cons cons) t *)
(* type ('a,'b) list3x = ('a, 'b cons cons cons) t *)


(* let tuple2 : type a . a list2 -> (a * a) = fun (Cons (a, Cons (b, Nil))) -> (a,b) *)

(* let tuple3 : type a . a list3 -> (a * a * a) = fun (Cons (a, Cons (b, Cons (c, Nil)))) -> (a,b,c) *)

(* let first2 : type a b . (a,b) list2x -> (a * a) = fun (Cons (a, Cons (b, _))) -> (a,b) *)

(* let first3 : type a b . (a, b) list3x -> (a * a * a) = fun (Cons (a, Cons (b, Cons (c, _)))) -> (a,b,c) *)
