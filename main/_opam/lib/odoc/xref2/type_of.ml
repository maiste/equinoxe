(* Type_of.ml *)

(* Deals with expanding `module type of` expressions *)

open Odoc_model
open Lang
module Id = Odoc_model.Paths.Identifier

let again = ref false

let rec signature : Env.t -> Signature.t -> Signature.t =
 fun env sg ->
  let env = Env.open_signature sg env in
  signature_items env sg

and signature_items : Env.t -> Signature.t -> Signature.t =
 fun env s ->
  let open Signature in
  let items =
    List.map
      (fun item ->
        match item with
        | Module (r, m) -> Module (r, module_ env m)
        | ModuleType mt -> ModuleType (module_type env mt)
        | Include i -> Include (include_ env i)
        | item -> item)
      s.items
  in
  { s with items }

and module_ env m =
  match m.type_ with
  | Alias _ -> m
  | ModuleType expr ->
      {
        m with
        type_ = ModuleType (module_type_expr env (m.id :> Id.Signature.t) expr);
      }

and module_type env m =
  match m.expr with
  | None -> m
  | Some expr ->
      {
        m with
        expr = Some (module_type_expr env (m.id :> Id.Signature.t) expr);
      }

and module_type_expr_typeof env (id : Id.Signature.t) t =
  let open Odoc_model.Lang.ModuleType in
  let p, strengthen =
    match t.t_desc with ModPath p -> (p, false) | StructInclude p -> (p, true)
  in
  let cp = Component.Of_Lang.(module_path empty p) in
  let open Expand_tools in
  let open Utils.ResultMonad in
  aux_expansion_of_module_alias env ~strengthen cp >>= handle_expansion env id
  >>= fun (_env, e) -> Ok e

and module_type_expr env (id : Id.Signature.t) expr =
  match expr with
  | Path _ -> expr
  | Functor (Unit, expr) -> Functor (Unit, module_type_expr env id expr)
  | Functor (Named p, expr) ->
      let env = Env.add_functor_parameter (Named p) env in
      Functor (Named (functor_parameter env p), module_type_expr env id expr)
  | Signature sg -> Signature (signature env sg)
  | With w -> With { w with w_expr = u_module_type_expr env id w.w_expr }
  | TypeOf t -> (
      match module_type_expr_typeof env id t with
      | Ok e ->
          let se = Lang_of.(simple_expansion empty id e) in
          TypeOf { t with t_expansion = Some (simple_expansion env se) }
      | Error e
        when Errors.is_unexpanded_module_type_of (e :> Errors.Tools_error.any)
        ->
          again := true;
          expr
      | Error _e -> expr)

and u_module_type_expr env id expr =
  match expr with
  | Path _ -> expr
  | Signature sg -> Signature (signature env sg)
  | With (subs, w) -> With (subs, u_module_type_expr env id w)
  | TypeOf t -> (
      match module_type_expr_typeof env id t with
      | Ok e ->
          let se = Lang_of.(simple_expansion empty id e) in
          TypeOf { t with t_expansion = Some (simple_expansion env se) }
      | Error e
        when Errors.is_unexpanded_module_type_of (e :> Errors.Tools_error.any)
        ->
          again := true;
          expr
      | Error _e -> expr)

and functor_parameter env p =
  { p with expr = module_type_expr env (p.id :> Id.Signature.t) p.expr }

and simple_expansion :
    Env.t -> ModuleType.simple_expansion -> ModuleType.simple_expansion =
 fun env -> function
  | Signature sg -> Signature (signature env sg)
  | Functor (Named n, sg) ->
      Functor (Named (functor_parameter env n), simple_expansion env sg)
  | Functor (Unit, sg) -> Functor (Unit, simple_expansion env sg)

and include_ env i =
  let decl =
    let env = Env.close_signature i.expansion.content env in
    match i.decl with
    | Alias _ -> i.decl
    | ModuleType t -> ModuleType (u_module_type_expr env i.parent t)
  in
  let content =
    let { Include.content; _ } = i.expansion in
    signature_items env content
  in
  { i with expansion = { i.expansion with content }; decl }

let signature env =
  let rec loop sg =
    again := false;
    let sg' = signature env sg in
    Tools.reset_caches ();
    if !again then if sg' = sg then sg else loop sg' else sg'
  in
  loop
