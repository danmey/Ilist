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

open Asttypes
open Ast_mapper
open Location
open Parsetree
open Longident

let mapper =
  object(this)
    inherit Ast_mapper.mapper as super

    val nlst = false

    method! expr e =
      match e.pexp_desc with

      | Pexp_open ({txt = Lident "NLIST"; loc = _}, e) ->
        {< nlst = true >} # expr e

      | Pexp_open ({txt = Lident "LIST"; loc = _}, e) ->
        {< nlst = false >} # expr e

      | Pexp_construct ({txt = Lident "[]"; loc}, None, false) when nlst = true ->
        { e with pexp_desc = Pexp_construct ({txt = Ldot (Lident "Types", "Nil"); loc}, None, false)}

      | Pexp_construct ({txt = Lident "::"; loc}, (Some ({pexp_desc = Pexp_tuple [first; second]})), f) when nlst = true ->
        { e with pexp_desc = Pexp_construct ({txt = Ldot (Lident "Types", "Cons"); loc},Some ({ e with pexp_desc = Pexp_tuple [this # expr first;this # expr second]}), f)}

      | _ -> super # expr e

    method! pat p =
      match p.ppat_desc with

      | Ppat_construct ({txt = Lident "[]"; loc}, None, false) when nlst = true ->
        { p with ppat_desc = Ppat_construct ({txt = Ldot (Lident "Types", "Nil"); loc}, None, false)}

      | Ppat_construct ({txt = Lident "::"; loc}, (Some ({ppat_desc = Ppat_tuple [first; second]})), f) when nlst = true ->
        { p with ppat_desc = Ppat_construct ({txt = Ldot (Lident "Types", "Cons"); loc},Some ({ p with ppat_desc = Ppat_tuple [this # pat first;this # pat second]}), f)}
      | _ -> super # pat p

    method! structure = function
    | (i :: next) ->
      begin match i.pstr_desc with
        | Pstr_open {txt = Lident "LIST" } -> {< nlst = false >} # structure next
        | Pstr_open {txt = Lident "NLIST"} -> {< nlst = true  >} # structure next
        | _ -> super # structure_item i @ this # structure next end
    | [] -> []
  end

let () = Ast_mapper.main mapper
