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

open Camlp4;;

module Id : Sig.Id = struct
  let name = "pa_ilist"
  let version = "0.1"
end;;

module Make (Syntax : Sig.Camlp4Syntax) = struct
  open Sig;;
  include Syntax;;

  let sem_expr_for_nlist = Gram.Entry.mk "sem_expr_for_nlist";;
  EXTEND Gram
    GLOBAL: expr patt sem_expr_for_nlist;

    expr: LEVEL "simple"
      [ [ "[@"; "]"                                                  -> <:expr< Types.Nil >>
        | "[@"; mk_nlist = sem_expr_for_nlist; ";"; last = expr; "]" -> mk_nlist last
        | "[@"; mk_nlist = sem_expr_for_nlist; "]"                   -> mk_nlist <:expr< Types.Nil >>
      ] ];

    sem_expr_for_nlist:
      [ [ e = expr LEVEL "top"; ";"; el = SELF -> fun acc -> <:expr< Types.Cons ($e$, $el acc$) >>
        | e = expr LEVEL "top"; ";"            -> fun acc -> <:expr< Types.Cons ($e$, $acc$) >>
        | e = expr LEVEL "top"                 -> fun acc -> <:expr< Types.Cons ($e$, $acc$) >>
      ] ];

    patt: LEVEL "simple"
      [ [ "[@"; "]" -> <:patt< Types.Cons >>
        | "[@"; mk_nlist = sem_patt_for_list; "@::"; last = patt; "]" -> mk_nlist last
        | "[@"; mk_nlist = sem_patt_for_list; "]"                     -> mk_nlist <:patt< Types.Nil >>
      ] ];

    sem_patt_for_list:
        [ [ p = patt; ";"; pl = SELF -> fun acc -> <:patt< Types.Cons ($p$, $pl acc$) >>
          | p = patt; ";"            -> fun acc -> <:patt< Types.Cons ($p$, $acc$) >>
          | p = patt                 -> fun acc -> <:patt< Types.Cons ($p$, $acc$) >>
        ] ];

    patt:
      [ "@::" RIGHTA
          [ p1 = SELF; "@::"; p2 = SELF      -> <:patt< Types.Cons($p1$, $p2$) >> ]
      ] ;

  END;;

end

module M = Register.OCamlSyntaxExtension(Id)(Make);;
