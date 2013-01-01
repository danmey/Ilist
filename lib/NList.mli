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

(** Implementation of indexed lists.
    Type level invariants:

    List of exact number of elements
    List of exact or greater number of elements
*)

(** Module used for syntax extensions *)
module Types : sig

  (** Cons cell at the type level *)
  type _ cons

  (** Empty list at the type level *)
  type nil

  (** Arbitral list, ['a] denotes type of element that this list holds, ['b] is invariant type *)
  type ('a,_) t =
    | Cons : 'a * ('a, 'b) t -> ('a, 'b cons) t
    | Nil : ('a, nil) t
end

open Types

(** List of 1 elements  *)
type 'a list1 = ('a, nil cons) t

(** List of 1 or more elements  *)
type ('a, 'b) list1x = ('a, 'b cons) t

(** List of 2 elements  *)
type 'a list2 = ('a, nil cons cons) t

(** List of 2 or more elements  *)
type ('a, 'b) list2x = ('a, 'b cons cons) t

(** List of 3 elements  *)
type 'a list3 = ('a, nil cons cons cons) t

(** List of 3 or more elements  *)
type ('a, 'b) list3x = ('a, 'b cons cons cons) t

(** Invariant preserving head of list *)
val hd : ('a, 'b cons) t -> 'a

(** Invariant preserving tail of list *)
val tl : ('a, 'b cons) t -> ('a, 'b) t

(** Invariant preserving cons operation on list *)
val cons : 'a -> ('a, 'b) t -> ('a, 'b cons) t

(** Invariant preserving map operation *)
val map : ('a -> 'c) -> ('a, 'b) t -> ('c, 'b) t

(** Invariant preserving iter operation *)
val iter : ('a -> unit) -> ('a, 'b) t -> unit

(** Invariant preserving rev operation *)
val rev : ('a, 'b) t -> ('a, 'b) t

(** List of one element *)
val singleton : 'a ->
('a, nil cons) t

(** Convert list of exact 2 elements to tuple *)
val tuple2 : 'a list2 -> 'a * 'a

(** Convert list of exact 3 elements to tuple *)
val tuple3 : 'a list3 -> 'a * 'a * 'a

(** Convert list of first 2 elements to tuple *)
val first2 : ('a, 'b) list2x -> 'a * 'a

(** Convert list of first 3 elements to tuple *)
val first3 : ('a, 'b) list3x -> 'a * 'a * 'a

(** Converting to normal list *)
val unsafe : ('a, 'b) t -> 'a list

(** Converting from normal list - requires final type to be denoted *)
val safe : 'a list -> ('a, 'b) t

(** Infix cons operator *)
val (^:) : 'a -> ('a, 'b) t -> ('a, 'b cons) t

(** End of list marker *)
val e: ('a,nil) t
