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
  type nil = private TNil
  type 'a cons = private TCons

  type ('a,_) t =
    | Nil : ('a, nil) t
    | Cons : 'a * ('a, 'b) t -> ('a, 'b cons) t

end

include Types

type 'a list1 = ('a, nil cons) t
type ('a,'b) list1x = ('a, 'b cons) t
type 'a list2 = ('a, nil cons cons) t
type ('a,'b) list2x = ('a, 'b cons cons) t
type 'a list3 = ('a, nil cons cons cons) t
type ('a,'b) list3x = ('a, 'b cons cons cons) t

let hd : type a b . (a, b cons) t -> a = fun (Cons (x,_)) -> x
let tl : type a b . (a, b cons) t -> (a, b) t = fun (Cons (_,xs)) -> xs

let empty : type a . (a, nil) t = Nil
let cons : type a b . a -> (a, b) t -> (a, b cons) t = fun x xs -> Cons (x,xs)

let rec map : type a b . (a -> 'c) -> (a,b) t -> ('c,b) t = fun f l ->
  match l with
  | Cons (x, xs) -> Cons (f x, map f xs)
  | Nil -> Nil

let singleton : type a . a -> (a, nil cons) t = fun x -> Cons (x, Nil)

let rec unsafe : type a b . (a,b) t -> a list = function
| Cons (x, xs) -> x :: unsafe xs
| Nil -> []

(* Warning: This is the only place where the unsafe operations occur. *)
let safe : type a b . a list -> (a,b) t = Obj.magic

let safe0x : type a b . a list -> (a,nil) t = safe
let safe1x : type a b . a -> a list -> (a,b) list1x = fun f l -> cons f (safe l)
let safe2x : type a b . a -> a -> a list -> (a,b) list2x = fun f s l -> cons f (cons s (safe l))
let safe3x : type a b . a -> a -> a -> a list -> (a,b) list3x = fun f s t l -> cons f (cons s (cons t (safe l)))

let safe1 : type a . a -> a list1 = fun f -> Cons (f, Nil)
let safe2 : type a . a -> a -> a list2 = fun f s -> Cons (f, Cons (s, Nil))
let safe3 : type a . a -> a -> a -> a list3 = fun f s t -> Cons (f, Cons (s, Cons (t, Nil)))

let rec rev : type a b . (a,b) t -> (a,b) t = fun l ->
  let l = unsafe l in
  let l = List.rev l in
  safe l

let combine : type a b c . (a, c) t -> (b, c) t -> (a * b, c) t = fun l r ->
  safe (List.combine (unsafe l) (unsafe r))

let split   : type a b c . (a * b, c) t -> (a, c) t * (b, c) t = fun l ->
  let l,r = (List.split (unsafe l)) in safe l, safe r

let rec iter : ('a -> unit) -> ('a, 'b) t -> unit = fun f l ->
  List.iter f (unsafe l)

let tuple2 : type a . a list2 -> (a * a) = fun (Cons (a, Cons (b, Nil))) -> (a,b)

let tuple3 : type a . a list3 -> (a * a * a) = fun (Cons (a, Cons (b, Cons (c, Nil)))) -> (a,b,c)

let first2 : type a b . (a,b) list2x -> (a * a) = fun (Cons (a, Cons (b, _))) -> (a,b)

let first3 : type a b . (a, b) list3x -> (a * a * a) = fun (Cons (a, Cons (b, Cons (c, _)))) -> (a,b,c)

let (^:) x xs = Cons (x, xs)
let (^^:) x xs = Cons (x, Cons (xs, Nil))
let nil = empty
