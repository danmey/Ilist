open Asttypes
open Ast_mapper
open Location
open Parsetree
open Longident

let mapper =
  object(this)
    inherit Ast_mapper.create as super
    val nlst = false
    method! expr e =
      match e.pexp_desc with

      | Pexp_open ({txt = Lident "NLIST"; loc = _}, e) ->
        {< nlst = true >} # expr e

      | Pexp_construct ({txt = Lident "[]"; loc}, None, false) when nlst = true ->
        { e with pexp_desc = Pexp_construct ({txt = Ldot (Lident "Types", "Nil"); loc}, None, false)}

      | Pexp_construct ({txt = Lident "::"; loc}, (Some ({pexp_desc = Pexp_tuple [first; second]})), f) when nlst = true ->
        { e with pexp_desc = Pexp_construct ({txt = Ldot (Lident "Types", "Cons"); loc},Some ({ e with pexp_desc = Pexp_tuple [this # expr first;this # expr second]}), f)}

      | _ -> super # expr e
  end

let () = mapper # main
