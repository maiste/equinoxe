
module MenhirBasics = struct
  
  exception Error
  
  let _eRR : exn =
    Error
  
  type token = 
    | SEMICOLON
    | PERCENT
    | OPEN
    | LT
    | INT of (
# 3 "src/duration_parser.mly"
       (int)
# 18 "src/duration_parser.ml"
  )
    | GT
    | EQ
    | EOF
    | DIRECTIVE of (
# 2 "src/duration_parser.mly"
       (char)
# 26 "src/duration_parser.ml"
  )
    | DASH
    | CLOSE
    | CHAR of (
# 2 "src/duration_parser.mly"
       (char)
# 33 "src/duration_parser.ml"
  )
  
end

include MenhirBasics

type _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  _menhir_token: token;
  mutable _menhir_error: bool
}

and _menhir_state = 
  | MenhirState66
  | MenhirState64
  | MenhirState61
  | MenhirState53
  | MenhirState51
  | MenhirState44
  | MenhirState40
  | MenhirState36
  | MenhirState30
  | MenhirState28
  | MenhirState26
  | MenhirState23
  | MenhirState21
  | MenhirState12
  | MenhirState7
  | MenhirState2
  | MenhirState0

[@@@ocaml.warning "-4-39"]

let rec _menhir_goto_option_else_expr_defined_value__ : _menhir_env -> 'ttv_tail -> 'tv_option_else_expr_defined_value__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _v ->
    let _menhir_stack = (_menhir_stack, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : (((((('freshtv291 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 75 "src/duration_parser.ml"
    ))) * _menhir_state * 'tv_exprs_defined_value_) * 'tv_option_else_expr_defined_value__) = Obj.magic _menhir_stack in
    assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    ((match _tok with
    | CLOSE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((((('freshtv287 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 85 "src/duration_parser.ml"
        ))) * _menhir_state * 'tv_exprs_defined_value_) * 'tv_option_else_expr_defined_value__) = Obj.magic _menhir_stack in
        let _menhir_env = _menhir_discard _menhir_env in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((((('freshtv285 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 92 "src/duration_parser.ml"
        ))) * _menhir_state * 'tv_exprs_defined_value_) * 'tv_option_else_expr_defined_value__) = Obj.magic _menhir_stack in
        let ((((((_menhir_stack, _menhir_s), _startpos__2_), _, (cmp : 'tv_condition)), (i : (
# 3 "src/duration_parser.mly"
       (int)
# 97 "src/duration_parser.ml"
        ))), _, (x : 'tv_exprs_defined_value_)), (y : 'tv_option_else_expr_defined_value__)) = _menhir_stack in
        let _v : 'tv_expr_defined_value_ = 
# 28 "src/duration_parser.mly"
    ( Duration_private.check_condition cmp i x y )
# 102 "src/duration_parser.ml"
         in
        (_menhir_goto_expr_defined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv286)) : 'freshtv288)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((((('freshtv289 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 112 "src/duration_parser.ml"
        ))) * _menhir_state * 'tv_exprs_defined_value_) * 'tv_option_else_expr_defined_value__) = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv290)) : 'freshtv292)

and _menhir_goto_option_else_expr_undefined_value__ : _menhir_env -> 'ttv_tail -> 'tv_option_else_expr_undefined_value__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _v ->
    let _menhir_stack = (_menhir_stack, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : (((((('freshtv283 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 124 "src/duration_parser.ml"
    ))) * _menhir_state * 'tv_exprs_undefined_value_) * 'tv_option_else_expr_undefined_value__) = Obj.magic _menhir_stack in
    assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    ((match _tok with
    | CLOSE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((((('freshtv279 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 134 "src/duration_parser.ml"
        ))) * _menhir_state * 'tv_exprs_undefined_value_) * 'tv_option_else_expr_undefined_value__) = Obj.magic _menhir_stack in
        let _menhir_env = _menhir_discard _menhir_env in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((((('freshtv277 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 141 "src/duration_parser.ml"
        ))) * _menhir_state * 'tv_exprs_undefined_value_) * 'tv_option_else_expr_undefined_value__) = Obj.magic _menhir_stack in
        let ((((((_menhir_stack, _menhir_s), _startpos__2_), _, (cmp : 'tv_condition)), (i : (
# 3 "src/duration_parser.mly"
       (int)
# 146 "src/duration_parser.ml"
        ))), _, (x : 'tv_exprs_undefined_value_)), (y : 'tv_option_else_expr_undefined_value__)) = _menhir_stack in
        let _v : 'tv_expr_undefined_value_ = 
# 28 "src/duration_parser.mly"
    ( Duration_private.check_condition cmp i x y )
# 151 "src/duration_parser.ml"
         in
        (_menhir_goto_expr_undefined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv278)) : 'freshtv280)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((((('freshtv281 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 161 "src/duration_parser.ml"
        ))) * _menhir_state * 'tv_exprs_undefined_value_) * 'tv_option_else_expr_undefined_value__) = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv282)) : 'freshtv284)

and _menhir_goto_simple_condition : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_simple_condition -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv269 * _menhir_state)) * _menhir_state * 'tv_simple_condition) = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        ((match _tok with
        | SEMICOLON ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv265 * _menhir_state)) * _menhir_state * 'tv_simple_condition) = Obj.magic _menhir_stack in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | CHAR _v ->
                _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState7 _v
            | DASH ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState7 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
            | EQ ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState7
            | GT ->
                _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState7
            | INT _v ->
                _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState7 _v
            | LT ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState7
            | OPEN ->
                _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState7
            | CLOSE ->
                _menhir_reduce29 _menhir_env (Obj.magic _menhir_stack) MenhirState7
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState7) : 'freshtv266)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv267 * _menhir_state)) * _menhir_state * 'tv_simple_condition) = Obj.magic _menhir_stack in
            let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv268)) : 'freshtv270)
    | MenhirState28 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv275 * _menhir_state)) * _menhir_state * 'tv_simple_condition) = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        ((match _tok with
        | SEMICOLON ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv271 * _menhir_state)) * _menhir_state * 'tv_simple_condition) = Obj.magic _menhir_stack in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | CHAR _v ->
                _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState30 _v
            | DASH ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState30 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
            | EQ ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState30
            | GT ->
                _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState30
            | INT _v ->
                _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState30 _v
            | LT ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState30
            | OPEN ->
                _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState30
            | CLOSE ->
                _menhir_reduce27 _menhir_env (Obj.magic _menhir_stack) MenhirState30
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState30) : 'freshtv272)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv273 * _menhir_state)) * _menhir_state * 'tv_simple_condition) = Obj.magic _menhir_stack in
            let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv274)) : 'freshtv276)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_expr_defined_value__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_expr_defined_value__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState26 | MenhirState53 | MenhirState51 | MenhirState40 | MenhirState30 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv259) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_expr_defined_value__) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv257) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((l : 'tv_list_expr_defined_value__) : 'tv_list_expr_defined_value__) = _v in
        let _v : 'tv_exprs_defined_value_ = 
# 17 "src/duration_parser.mly"
  ( (fun a b -> String.concat "" (List.map (fun f -> f a b) l)) )
# 266 "src/duration_parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv255) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_exprs_defined_value_) = _v in
        let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        (((match _menhir_s with
        | MenhirState30 ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (((('freshtv219 * _menhir_state)) * _menhir_state * 'tv_simple_condition)) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
            assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | CLOSE ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (((('freshtv215 * _menhir_state)) * _menhir_state * 'tv_simple_condition)) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
                let _menhir_env = _menhir_discard _menhir_env in
                ((let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (((('freshtv213 * _menhir_state)) * _menhir_state * 'tv_simple_condition)) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
                let (((_menhir_stack, _menhir_s), _, (check : 'tv_simple_condition)), _, (x : 'tv_exprs_defined_value_)) = _menhir_stack in
                let _v : 'tv_expr_defined_value_ = 
# 26 "src/duration_parser.mly"
    ( Duration_private.check_condition_simple check x )
# 290 "src/duration_parser.ml"
                 in
                (_menhir_goto_expr_defined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv214)) : 'freshtv216)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (((('freshtv217 * _menhir_state)) * _menhir_state * 'tv_simple_condition)) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
                let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv218)) : 'freshtv220)
        | MenhirState40 ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv227 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 305 "src/duration_parser.ml"
            ))) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
            assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | CLOSE ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv223 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 315 "src/duration_parser.ml"
                ))) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
                let _menhir_env = _menhir_discard _menhir_env in
                ((let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv221 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 322 "src/duration_parser.ml"
                ))) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
                let (((_menhir_stack, _menhir_s), (dir : (
# 2 "src/duration_parser.mly"
       (char)
# 327 "src/duration_parser.ml"
                ))), _, (x : 'tv_exprs_defined_value_)) = _menhir_stack in
                let _v : 'tv_expr_defined_value_ = 
# 30 "src/duration_parser.mly"
    ( Duration_private.directive_block dir x )
# 332 "src/duration_parser.ml"
                 in
                (_menhir_goto_expr_defined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv222)) : 'freshtv224)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv225 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 342 "src/duration_parser.ml"
                ))) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
                let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv226)) : 'freshtv228)
        | MenhirState51 ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv235 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 351 "src/duration_parser.ml"
            ))) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
            assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | SEMICOLON ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv229) = Obj.magic _menhir_stack in
                let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                ((match _tok with
                | CHAR _v ->
                    _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState53 _v
                | DASH ->
                    _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState53 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
                | EQ ->
                    _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState53
                | GT ->
                    _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState53
                | INT _v ->
                    _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState53 _v
                | LT ->
                    _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState53
                | OPEN ->
                    _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState53
                | CLOSE ->
                    _menhir_reduce27 _menhir_env (Obj.magic _menhir_stack) MenhirState53
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState53) : 'freshtv230)
            | CLOSE ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv231) = Obj.magic _menhir_stack in
                let _v : 'tv_option_else_expr_defined_value__ = 
# 111 "<standard.mly>"
    ( None )
# 388 "src/duration_parser.ml"
                 in
                (_menhir_goto_option_else_expr_defined_value__ _menhir_env _menhir_stack _v : 'freshtv232)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((((('freshtv233 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 398 "src/duration_parser.ml"
                ))) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
                let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv234)) : 'freshtv236)
        | MenhirState53 ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv245) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv243) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
            let (_menhir_stack, _, (x : 'tv_exprs_defined_value_)) = _menhir_stack in
            let _v : 'tv_else_expr_defined_value_ = 
# 52 "src/duration_parser.mly"
                          ( x )
# 411 "src/duration_parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv241) = _menhir_stack in
            let (_v : 'tv_else_expr_defined_value_) = _v in
            (((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv239) = Obj.magic _menhir_stack in
            let (_v : 'tv_else_expr_defined_value_) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv237) = Obj.magic _menhir_stack in
            let ((x : 'tv_else_expr_defined_value_) : 'tv_else_expr_defined_value_) = _v in
            let _v : 'tv_option_else_expr_defined_value__ = 
# 113 "<standard.mly>"
    ( Some x )
# 425 "src/duration_parser.ml"
             in
            (_menhir_goto_option_else_expr_defined_value__ _menhir_env _menhir_stack _v : 'freshtv238)) : 'freshtv240)) : 'freshtv242) : 'freshtv244)) : 'freshtv246)
        | MenhirState26 ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv253 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 433 "src/duration_parser.ml"
            ))) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
            assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | CLOSE ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv249 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 443 "src/duration_parser.ml"
                ))) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
                let _menhir_env = _menhir_discard _menhir_env in
                ((let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv247 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 450 "src/duration_parser.ml"
                ))) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
                let (((_menhir_stack, _menhir_s), (dir : (
# 2 "src/duration_parser.mly"
       (char)
# 455 "src/duration_parser.ml"
                ))), _, (x : 'tv_exprs_defined_value_)) = _menhir_stack in
                let _v : 'tv_expr_undefined_value_ = 
# 30 "src/duration_parser.mly"
    ( Duration_private.directive_block dir x )
# 460 "src/duration_parser.ml"
                 in
                (_menhir_goto_expr_undefined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv248)) : 'freshtv250)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv251 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 470 "src/duration_parser.ml"
                ))) * _menhir_state * 'tv_exprs_defined_value_) = Obj.magic _menhir_stack in
                let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv252)) : 'freshtv254)
        | _ ->
            _menhir_fail ()) : 'freshtv256) : 'freshtv258)) : 'freshtv260)
    | MenhirState36 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv263 * _menhir_state * 'tv_expr_defined_value_) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_expr_defined_value__) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv261 * _menhir_state * 'tv_expr_defined_value_) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_list_expr_defined_value__) : 'tv_list_expr_defined_value__) = _v in
        let (_menhir_stack, _menhir_s, (x : 'tv_expr_defined_value_)) = _menhir_stack in
        let _v : 'tv_list_expr_defined_value__ = 
# 210 "<standard.mly>"
    ( x :: xs )
# 489 "src/duration_parser.ml"
         in
        (_menhir_goto_list_expr_defined_value__ _menhir_env _menhir_stack _menhir_s _v : 'freshtv262)) : 'freshtv264)
    | _ ->
        _menhir_fail ()

and _menhir_goto_condition : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_condition -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState44 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv201 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        ((match _tok with
        | INT _v ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv197 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) = Obj.magic _menhir_stack in
            let (_v : (
# 3 "src/duration_parser.mly"
       (int)
# 511 "src/duration_parser.ml"
            )) = _v in
            let _menhir_stack = (_menhir_stack, _v) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | SEMICOLON ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv193 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 522 "src/duration_parser.ml"
                )) = Obj.magic _menhir_stack in
                let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                ((match _tok with
                | CHAR _v ->
                    _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState51 _v
                | DASH ->
                    _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState51 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
                | EQ ->
                    _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState51
                | GT ->
                    _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState51
                | INT _v ->
                    _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState51 _v
                | LT ->
                    _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState51
                | OPEN ->
                    _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState51
                | CLOSE | SEMICOLON ->
                    _menhir_reduce27 _menhir_env (Obj.magic _menhir_stack) MenhirState51
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState51) : 'freshtv194)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv195 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 554 "src/duration_parser.ml"
                )) = Obj.magic _menhir_stack in
                let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
                (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv196)) : 'freshtv198)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv199 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) = Obj.magic _menhir_stack in
            let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv200)) : 'freshtv202)
    | MenhirState61 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv211 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        ((match _tok with
        | INT _v ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv207 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) = Obj.magic _menhir_stack in
            let (_v : (
# 3 "src/duration_parser.mly"
       (int)
# 577 "src/duration_parser.ml"
            )) = _v in
            let _menhir_stack = (_menhir_stack, _v) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | SEMICOLON ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv203 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 588 "src/duration_parser.ml"
                )) = Obj.magic _menhir_stack in
                let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                ((match _tok with
                | CHAR _v ->
                    _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState64 _v
                | DASH ->
                    _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState64 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
                | EQ ->
                    _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState64
                | GT ->
                    _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState64
                | INT _v ->
                    _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState64 _v
                | LT ->
                    _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState64
                | OPEN ->
                    _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState64
                | CLOSE | SEMICOLON ->
                    _menhir_reduce29 _menhir_env (Obj.magic _menhir_stack) MenhirState64
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState64) : 'freshtv204)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv205 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 620 "src/duration_parser.ml"
                )) = Obj.magic _menhir_stack in
                let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
                (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv206)) : 'freshtv208)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv209 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) = Obj.magic _menhir_stack in
            let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv210)) : 'freshtv212)
    | _ ->
        _menhir_fail ()

and _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

and _menhir_goto_expr_defined_value_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_expr_defined_value_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv191 * _menhir_state * 'tv_expr_defined_value_) = Obj.magic _menhir_stack in
    assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    ((match _tok with
    | CHAR _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
    | DASH ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
    | EQ ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState36
    | GT ->
        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState36
    | INT _v ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
    | LT ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState36
    | OPEN ->
        _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState36
    | CLOSE | SEMICOLON ->
        _menhir_reduce27 _menhir_env (Obj.magic _menhir_stack) MenhirState36
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState36) : 'freshtv192)

and _menhir_goto_nonempty_list_charlike_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_nonempty_list_charlike_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState0 | MenhirState66 | MenhirState64 | MenhirState21 | MenhirState7 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv181) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_nonempty_list_charlike_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv179) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((l : 'tv_nonempty_list_charlike_) : 'tv_nonempty_list_charlike_) = _v in
        let _v : 'tv_expr_undefined_value_ = 
# 31 "src/duration_parser.mly"
                              (
    let size = List.length l in
    let s = Bytes.create size in
    List.iteri (fun i x -> Bytes.set s i x) l;
    Duration_private.static_printer (Bytes.to_string s)
  )
# 688 "src/duration_parser.ml"
         in
        (_menhir_goto_expr_undefined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv180)) : 'freshtv182)
    | MenhirState23 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv185 * _menhir_state * 'tv_charlike) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_nonempty_list_charlike_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv183 * _menhir_state * 'tv_charlike) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_nonempty_list_charlike_) : 'tv_nonempty_list_charlike_) = _v in
        let (_menhir_stack, _menhir_s, (x : 'tv_charlike)) = _menhir_stack in
        let _v : 'tv_nonempty_list_charlike_ = 
# 220 "<standard.mly>"
    ( x :: xs )
# 704 "src/duration_parser.ml"
         in
        (_menhir_goto_nonempty_list_charlike_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv184)) : 'freshtv186)
    | MenhirState26 | MenhirState53 | MenhirState51 | MenhirState40 | MenhirState36 | MenhirState30 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv189) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_nonempty_list_charlike_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv187) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((l : 'tv_nonempty_list_charlike_) : 'tv_nonempty_list_charlike_) = _v in
        let _v : 'tv_expr_defined_value_ = 
# 31 "src/duration_parser.mly"
                              (
    let size = List.length l in
    let s = Bytes.create size in
    List.iteri (fun i x -> Bytes.set s i x) l;
    Duration_private.static_printer (Bytes.to_string s)
  )
# 724 "src/duration_parser.ml"
         in
        (_menhir_goto_expr_defined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv188)) : 'freshtv190)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_expr_undefined_value__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_expr_undefined_value__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState0 | MenhirState66 | MenhirState64 | MenhirState7 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv173) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_expr_undefined_value__) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv171) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((l : 'tv_list_expr_undefined_value__) : 'tv_list_expr_undefined_value__) = _v in
        let _v : 'tv_exprs_undefined_value_ = 
# 17 "src/duration_parser.mly"
  ( (fun a b -> String.concat "" (List.map (fun f -> f a b) l)) )
# 745 "src/duration_parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv169) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_exprs_undefined_value_) = _v in
        let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        (((match _menhir_s with
        | MenhirState7 ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (((('freshtv135 * _menhir_state)) * _menhir_state * 'tv_simple_condition)) * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
            assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | CLOSE ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (((('freshtv131 * _menhir_state)) * _menhir_state * 'tv_simple_condition)) * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
                let _menhir_env = _menhir_discard _menhir_env in
                ((let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (((('freshtv129 * _menhir_state)) * _menhir_state * 'tv_simple_condition)) * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
                let (((_menhir_stack, _menhir_s), _, (check : 'tv_simple_condition)), _, (x : 'tv_exprs_undefined_value_)) = _menhir_stack in
                let _v : 'tv_expr_undefined_value_ = 
# 26 "src/duration_parser.mly"
    ( Duration_private.check_condition_simple check x )
# 769 "src/duration_parser.ml"
                 in
                (_menhir_goto_expr_undefined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv130)) : 'freshtv132)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (((('freshtv133 * _menhir_state)) * _menhir_state * 'tv_simple_condition)) * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
                let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv134)) : 'freshtv136)
        | MenhirState64 ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv143 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 784 "src/duration_parser.ml"
            ))) * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
            assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | SEMICOLON ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv137) = Obj.magic _menhir_stack in
                let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                ((match _tok with
                | CHAR _v ->
                    _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState66 _v
                | DASH ->
                    _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState66 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
                | EQ ->
                    _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState66
                | GT ->
                    _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState66
                | INT _v ->
                    _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState66 _v
                | LT ->
                    _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState66
                | OPEN ->
                    _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState66
                | CLOSE ->
                    _menhir_reduce29 _menhir_env (Obj.magic _menhir_stack) MenhirState66
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState66) : 'freshtv138)
            | CLOSE ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv139) = Obj.magic _menhir_stack in
                let _v : 'tv_option_else_expr_undefined_value__ = 
# 111 "<standard.mly>"
    ( None )
# 821 "src/duration_parser.ml"
                 in
                (_menhir_goto_option_else_expr_undefined_value__ _menhir_env _menhir_stack _v : 'freshtv140)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((((('freshtv141 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 831 "src/duration_parser.ml"
                ))) * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
                let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv142)) : 'freshtv144)
        | MenhirState66 ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv153) * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv151) * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
            let (_menhir_stack, _, (x : 'tv_exprs_undefined_value_)) = _menhir_stack in
            let _v : 'tv_else_expr_undefined_value_ = 
# 52 "src/duration_parser.mly"
                          ( x )
# 844 "src/duration_parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv149) = _menhir_stack in
            let (_v : 'tv_else_expr_undefined_value_) = _v in
            (((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv147) = Obj.magic _menhir_stack in
            let (_v : 'tv_else_expr_undefined_value_) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv145) = Obj.magic _menhir_stack in
            let ((x : 'tv_else_expr_undefined_value_) : 'tv_else_expr_undefined_value_) = _v in
            let _v : 'tv_option_else_expr_undefined_value__ = 
# 113 "<standard.mly>"
    ( Some x )
# 858 "src/duration_parser.ml"
             in
            (_menhir_goto_option_else_expr_undefined_value__ _menhir_env _menhir_stack _v : 'freshtv146)) : 'freshtv148)) : 'freshtv150) : 'freshtv152)) : 'freshtv154)
        | MenhirState0 ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv167 * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
            assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | EOF ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv163 * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
                ((let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv161 * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
                let (_menhir_stack, _menhir_s, (r : 'tv_exprs_undefined_value_)) = _menhir_stack in
                let _v : (
# 9 "src/duration_parser.mly"
      ( Duration_private.O.t -> Duration_private.O.t -> string )
# 876 "src/duration_parser.ml"
                ) = 
# 14 "src/duration_parser.mly"
                                   (r)
# 880 "src/duration_parser.ml"
                 in
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv159) = _menhir_stack in
                let (_menhir_s : _menhir_state) = _menhir_s in
                let (_v : (
# 9 "src/duration_parser.mly"
      ( Duration_private.O.t -> Duration_private.O.t -> string )
# 888 "src/duration_parser.ml"
                )) = _v in
                (((let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv157) = Obj.magic _menhir_stack in
                let (_menhir_s : _menhir_state) = _menhir_s in
                let (_v : (
# 9 "src/duration_parser.mly"
      ( Duration_private.O.t -> Duration_private.O.t -> string )
# 896 "src/duration_parser.ml"
                )) = _v in
                ((let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv155) = Obj.magic _menhir_stack in
                let (_menhir_s : _menhir_state) = _menhir_s in
                let ((_1 : (
# 9 "src/duration_parser.mly"
      ( Duration_private.O.t -> Duration_private.O.t -> string )
# 904 "src/duration_parser.ml"
                )) : (
# 9 "src/duration_parser.mly"
      ( Duration_private.O.t -> Duration_private.O.t -> string )
# 908 "src/duration_parser.ml"
                )) = _v in
                (Obj.magic _1 : 'freshtv156)) : 'freshtv158)) : 'freshtv160) : 'freshtv162)) : 'freshtv164)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv165 * _menhir_state * 'tv_exprs_undefined_value_) = Obj.magic _menhir_stack in
                let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv166)) : 'freshtv168)
        | _ ->
            _menhir_fail ()) : 'freshtv170) : 'freshtv172)) : 'freshtv174)
    | MenhirState21 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv177 * _menhir_state * 'tv_expr_undefined_value_) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_expr_undefined_value__) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv175 * _menhir_state * 'tv_expr_undefined_value_) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_list_expr_undefined_value__) : 'tv_list_expr_undefined_value__) = _v in
        let (_menhir_stack, _menhir_s, (x : 'tv_expr_undefined_value_)) = _menhir_stack in
        let _v : 'tv_list_expr_undefined_value__ = 
# 210 "<standard.mly>"
    ( x :: xs )
# 933 "src/duration_parser.ml"
         in
        (_menhir_goto_list_expr_undefined_value__ _menhir_env _menhir_stack _menhir_s _v : 'freshtv176)) : 'freshtv178)
    | _ ->
        _menhir_fail ()

and _menhir_run3 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv127) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let _v : 'tv_simple_condition = 
# 62 "src/duration_parser.mly"
       ( `LT )
# 948 "src/duration_parser.ml"
     in
    (_menhir_goto_simple_condition _menhir_env _menhir_stack _menhir_s _v : 'freshtv128)

and _menhir_run4 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 3 "src/duration_parser.mly"
       (int)
# 955 "src/duration_parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv125) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((i : (
# 3 "src/duration_parser.mly"
       (int)
# 965 "src/duration_parser.ml"
    )) : (
# 3 "src/duration_parser.mly"
       (int)
# 969 "src/duration_parser.ml"
    )) = _v in
    let _v : 'tv_simple_condition = 
# 61 "src/duration_parser.mly"
          (`EQ i)
# 974 "src/duration_parser.ml"
     in
    (_menhir_goto_simple_condition _menhir_env _menhir_stack _menhir_s _v : 'freshtv126)

and _menhir_run5 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv123) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let _v : 'tv_simple_condition = 
# 63 "src/duration_parser.mly"
         ( `GT )
# 987 "src/duration_parser.ml"
     in
    (_menhir_goto_simple_condition _menhir_env _menhir_stack _menhir_s _v : 'freshtv124)

and _menhir_reduce27 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_expr_defined_value__ = 
# 208 "<standard.mly>"
    ( [] )
# 996 "src/duration_parser.ml"
     in
    _menhir_goto_list_expr_defined_value__ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run27 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DASH ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv107 * _menhir_state) = Obj.magic _menhir_stack in
        let (_startpos : Lexing.position) = _menhir_env._menhir_lexbuf.Lexing.lex_start_p in
        let _menhir_stack = (_menhir_stack, _startpos) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        ((match _tok with
        | EQ ->
            _menhir_run48 _menhir_env (Obj.magic _menhir_stack) MenhirState44
        | GT ->
            _menhir_run47 _menhir_env (Obj.magic _menhir_stack) MenhirState44
        | LT ->
            _menhir_run45 _menhir_env (Obj.magic _menhir_stack) MenhirState44
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState44) : 'freshtv108)
    | DIRECTIVE _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv117 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 2 "src/duration_parser.mly"
       (char)
# 1030 "src/duration_parser.ml"
        )) = _v in
        let _menhir_stack = (_menhir_stack, _v) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        ((match _tok with
        | CLOSE ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv111 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 1041 "src/duration_parser.ml"
            )) = Obj.magic _menhir_stack in
            let _menhir_env = _menhir_discard _menhir_env in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv109 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 1048 "src/duration_parser.ml"
            )) = Obj.magic _menhir_stack in
            let ((_menhir_stack, _menhir_s), (dir : (
# 2 "src/duration_parser.mly"
       (char)
# 1053 "src/duration_parser.ml"
            ))) = _menhir_stack in
            let _v : 'tv_expr_defined_value_ = 
# 22 "src/duration_parser.mly"
    ( (fun d _v ->
      let _,v = Duration_private.apply_directive dir d in
      Duration_private.O.to_string v) )
# 1060 "src/duration_parser.ml"
             in
            (_menhir_goto_expr_defined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv110)) : 'freshtv112)
        | SEMICOLON ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv113 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 1068 "src/duration_parser.ml"
            )) = Obj.magic _menhir_stack in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | CHAR _v ->
                _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _v
            | DASH ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
            | EQ ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState40
            | GT ->
                _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState40
            | INT _v ->
                _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _v
            | LT ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState40
            | OPEN ->
                _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState40
            | CLOSE ->
                _menhir_reduce27 _menhir_env (Obj.magic _menhir_stack) MenhirState40
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState40) : 'freshtv114)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv115 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 1100 "src/duration_parser.ml"
            )) = Obj.magic _menhir_stack in
            let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv116)) : 'freshtv118)
    | PERCENT ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv119 * _menhir_state) = Obj.magic _menhir_stack in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        ((match _tok with
        | GT ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState28
        | INT _v ->
            _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState28 _v
        | LT ->
            _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState28
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState28) : 'freshtv120)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv121 * _menhir_state) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv122)

and _menhir_goto_expr_undefined_value_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_expr_undefined_value_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv105 * _menhir_state * 'tv_expr_undefined_value_) = Obj.magic _menhir_stack in
    assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    ((match _tok with
    | CHAR _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState21 _v
    | DASH ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState21 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
    | EQ ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState21
    | GT ->
        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState21
    | INT _v ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState21 _v
    | LT ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState21
    | OPEN ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState21
    | CLOSE | EOF | SEMICOLON ->
        _menhir_reduce29 _menhir_env (Obj.magic _menhir_stack) MenhirState21
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState21) : 'freshtv106)

and _menhir_run45 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | GT ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv99 * _menhir_state) = Obj.magic _menhir_stack in
        let _menhir_env = _menhir_discard _menhir_env in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv97 * _menhir_state) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _v : 'tv_condition = 
# 55 "src/duration_parser.mly"
          ( `NEQ )
# 1173 "src/duration_parser.ml"
         in
        (_menhir_goto_condition _menhir_env _menhir_stack _menhir_s _v : 'freshtv98)) : 'freshtv100)
    | INT _ ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv101 * _menhir_state) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _v : 'tv_condition = 
# 57 "src/duration_parser.mly"
       ( `LT )
# 1183 "src/duration_parser.ml"
         in
        (_menhir_goto_condition _menhir_env _menhir_stack _menhir_s _v : 'freshtv102)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv103 * _menhir_state) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv104)

and _menhir_run47 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv95) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let _v : 'tv_condition = 
# 58 "src/duration_parser.mly"
       ( `GT )
# 1203 "src/duration_parser.ml"
     in
    (_menhir_goto_condition _menhir_env _menhir_stack _menhir_s _v : 'freshtv96)

and _menhir_run48 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv93) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let _v : 'tv_condition = 
# 56 "src/duration_parser.mly"
       ( `EQ )
# 1216 "src/duration_parser.ml"
     in
    (_menhir_goto_condition _menhir_env _menhir_stack _menhir_s _v : 'freshtv94)

and _menhir_goto_nonempty_list_DASH_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_nonempty_list_DASH_ -> Lexing.position -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v _startpos ->
    match _menhir_s with
    | MenhirState12 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv71 * _menhir_state * Lexing.position) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_nonempty_list_DASH_) = _v in
        let (_startpos : Lexing.position) = _startpos in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv69 * _menhir_state * Lexing.position) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_nonempty_list_DASH_) : 'tv_nonempty_list_DASH_) = _v in
        let (_startpos_xs_ : Lexing.position) = _startpos in
        let (_menhir_stack, _menhir_s, _startpos_x_) = _menhir_stack in
        let x = () in
        let _startpos = _startpos_x_ in
        let _v : 'tv_nonempty_list_DASH_ = 
# 220 "<standard.mly>"
    ( x :: xs )
# 1240 "src/duration_parser.ml"
         in
        (_menhir_goto_nonempty_list_DASH_ _menhir_env _menhir_stack _menhir_s _v _startpos : 'freshtv70)) : 'freshtv72)
    | MenhirState0 | MenhirState66 | MenhirState64 | MenhirState21 | MenhirState7 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv81) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_nonempty_list_DASH_) = _v in
        let (_startpos : Lexing.position) = _startpos in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv79) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_nonempty_list_DASH_) : 'tv_nonempty_list_DASH_) = _v in
        let (_startpos_x_ : Lexing.position) = _startpos in
        let _v =
          let _startpos = _startpos_x_ in
          (
# 42 "src/duration_parser.mly"
                            (failwith (Printf.sprintf "%s not authorized ouside block [%%d: ] (at c%d)" (String.make (List.length x) '#' ) (_startpos).Lexing.pos_cnum))
# 1259 "src/duration_parser.ml"
           : 'tv_undefined_value)
        in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv77) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_undefined_value) = _v in
        (((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv75) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_undefined_value) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv73) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((i : 'tv_undefined_value) : 'tv_undefined_value) = _v in
        let _v : 'tv_expr_undefined_value_ = 
# 20 "src/duration_parser.mly"
         ( Duration_private.show_value i )
# 1277 "src/duration_parser.ml"
         in
        (_menhir_goto_expr_undefined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv74)) : 'freshtv76)) : 'freshtv78) : 'freshtv80)) : 'freshtv82)
    | MenhirState26 | MenhirState53 | MenhirState51 | MenhirState40 | MenhirState36 | MenhirState30 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv91) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_nonempty_list_DASH_) = _v in
        let (_startpos : Lexing.position) = _startpos in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv89) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((l : 'tv_nonempty_list_DASH_) : 'tv_nonempty_list_DASH_) = _v in
        let (_startpos_l_ : Lexing.position) = _startpos in
        let _v : 'tv_defined_value = 
# 39 "src/duration_parser.mly"
                            ( List.length l )
# 1294 "src/duration_parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv87) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_defined_value) = _v in
        (((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv85) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_defined_value) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv83) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((i : 'tv_defined_value) : 'tv_defined_value) = _v in
        let _v : 'tv_expr_defined_value_ = 
# 20 "src/duration_parser.mly"
         ( Duration_private.show_value i )
# 1311 "src/duration_parser.ml"
         in
        (_menhir_goto_expr_defined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv84)) : 'freshtv86)) : 'freshtv88) : 'freshtv90)) : 'freshtv92)
    | _ ->
        _menhir_fail ()

and _menhir_goto_charlike : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_charlike -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv67 * _menhir_state * 'tv_charlike) = Obj.magic _menhir_stack in
    assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    ((match _tok with
    | CHAR _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState23 _v
    | EQ ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState23
    | GT ->
        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState23
    | INT _v ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState23 _v
    | LT ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState23
    | CLOSE | DASH | EOF | OPEN | SEMICOLON ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv65 * _menhir_state * 'tv_charlike) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, (x : 'tv_charlike)) = _menhir_stack in
        let _v : 'tv_nonempty_list_charlike_ = 
# 218 "<standard.mly>"
    ( [ x ] )
# 1342 "src/duration_parser.ml"
         in
        (_menhir_goto_nonempty_list_charlike_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv66)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState23) : 'freshtv68)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState66 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv31) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv32)
    | MenhirState64 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv33 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 1362 "src/duration_parser.ml"
        ))) = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv34)
    | MenhirState61 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv35 * _menhir_state) * Lexing.position) = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv36)
    | MenhirState53 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv37) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv38)
    | MenhirState51 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv39 * _menhir_state) * Lexing.position) * _menhir_state * 'tv_condition) * (
# 3 "src/duration_parser.mly"
       (int)
# 1380 "src/duration_parser.ml"
        ))) = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv40)
    | MenhirState44 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv41 * _menhir_state) * Lexing.position) = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv42)
    | MenhirState40 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv43 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 1394 "src/duration_parser.ml"
        ))) = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv44)
    | MenhirState36 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv45 * _menhir_state * 'tv_expr_defined_value_) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv46)
    | MenhirState30 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv47 * _menhir_state)) * _menhir_state * 'tv_simple_condition)) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv48)
    | MenhirState28 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv49 * _menhir_state)) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv50)
    | MenhirState26 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv51 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 1418 "src/duration_parser.ml"
        ))) = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv52)
    | MenhirState23 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv53 * _menhir_state * 'tv_charlike) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv54)
    | MenhirState21 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv55 * _menhir_state * 'tv_expr_undefined_value_) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv56)
    | MenhirState12 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv57 * _menhir_state * Lexing.position) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv58)
    | MenhirState7 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv59 * _menhir_state)) * _menhir_state * 'tv_simple_condition)) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv60)
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv61 * _menhir_state)) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv62)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv63) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv64)

and _menhir_reduce29 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_expr_undefined_value__ = 
# 208 "<standard.mly>"
    ( [] )
# 1457 "src/duration_parser.ml"
     in
    _menhir_goto_list_expr_undefined_value__ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run1 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DASH ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv15 * _menhir_state) = Obj.magic _menhir_stack in
        let (_startpos : Lexing.position) = _menhir_env._menhir_lexbuf.Lexing.lex_start_p in
        let _menhir_stack = (_menhir_stack, _startpos) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        ((match _tok with
        | EQ ->
            _menhir_run48 _menhir_env (Obj.magic _menhir_stack) MenhirState61
        | GT ->
            _menhir_run47 _menhir_env (Obj.magic _menhir_stack) MenhirState61
        | LT ->
            _menhir_run45 _menhir_env (Obj.magic _menhir_stack) MenhirState61
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState61) : 'freshtv16)
    | DIRECTIVE _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv25 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 2 "src/duration_parser.mly"
       (char)
# 1491 "src/duration_parser.ml"
        )) = _v in
        let _menhir_stack = (_menhir_stack, _v) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        ((match _tok with
        | CLOSE ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv19 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 1502 "src/duration_parser.ml"
            )) = Obj.magic _menhir_stack in
            let _menhir_env = _menhir_discard _menhir_env in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv17 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 1509 "src/duration_parser.ml"
            )) = Obj.magic _menhir_stack in
            let ((_menhir_stack, _menhir_s), (dir : (
# 2 "src/duration_parser.mly"
       (char)
# 1514 "src/duration_parser.ml"
            ))) = _menhir_stack in
            let _v : 'tv_expr_undefined_value_ = 
# 22 "src/duration_parser.mly"
    ( (fun d _v ->
      let _,v = Duration_private.apply_directive dir d in
      Duration_private.O.to_string v) )
# 1521 "src/duration_parser.ml"
             in
            (_menhir_goto_expr_undefined_value_ _menhir_env _menhir_stack _menhir_s _v : 'freshtv18)) : 'freshtv20)
        | SEMICOLON ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv21 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 1529 "src/duration_parser.ml"
            )) = Obj.magic _menhir_stack in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            ((match _tok with
            | CHAR _v ->
                _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState26 _v
            | DASH ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState26 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
            | EQ ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState26
            | GT ->
                _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState26
            | INT _v ->
                _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState26 _v
            | LT ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState26
            | OPEN ->
                _menhir_run27 _menhir_env (Obj.magic _menhir_stack) MenhirState26
            | CLOSE ->
                _menhir_reduce27 _menhir_env (Obj.magic _menhir_stack) MenhirState26
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState26) : 'freshtv22)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv23 * _menhir_state) * (
# 2 "src/duration_parser.mly"
       (char)
# 1561 "src/duration_parser.ml"
            )) = Obj.magic _menhir_stack in
            let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv24)) : 'freshtv26)
    | PERCENT ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv27 * _menhir_state) = Obj.magic _menhir_stack in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        ((match _tok with
        | GT ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState2
        | INT _v ->
            _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState2 _v
        | LT ->
            _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState2
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState2) : 'freshtv28)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv29 * _menhir_state) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        (_menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s : 'freshtv30)

and _menhir_run8 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv13) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let _v : 'tv_charlike = 
# 47 "src/duration_parser.mly"
           ( '<' )
# 1598 "src/duration_parser.ml"
     in
    (_menhir_goto_charlike _menhir_env _menhir_stack _menhir_s _v : 'freshtv14)

and _menhir_run9 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 3 "src/duration_parser.mly"
       (int)
# 1605 "src/duration_parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv11) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((x : (
# 3 "src/duration_parser.mly"
       (int)
# 1615 "src/duration_parser.ml"
    )) : (
# 3 "src/duration_parser.mly"
       (int)
# 1619 "src/duration_parser.ml"
    )) = _v in
    let _v : 'tv_charlike = 
# 46 "src/duration_parser.mly"
           (char_of_int (x + 48) )
# 1624 "src/duration_parser.ml"
     in
    (_menhir_goto_charlike _menhir_env _menhir_stack _menhir_s _v : 'freshtv12)

and _menhir_run10 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv9) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let _v : 'tv_charlike = 
# 48 "src/duration_parser.mly"
           ( '>' )
# 1637 "src/duration_parser.ml"
     in
    (_menhir_goto_charlike _menhir_env _menhir_stack _menhir_s _v : 'freshtv10)

and _menhir_run11 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv7) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let _v : 'tv_charlike = 
# 49 "src/duration_parser.mly"
           ( '=' )
# 1650 "src/duration_parser.ml"
     in
    (_menhir_goto_charlike _menhir_env _menhir_stack _menhir_s _v : 'freshtv8)

and _menhir_run12 : _menhir_env -> 'ttv_tail -> _menhir_state -> Lexing.position -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _startpos ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _startpos) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DASH ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
    | CHAR _ | CLOSE | EOF | EQ | GT | INT _ | LT | OPEN | SEMICOLON ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv5 * _menhir_state * Lexing.position) = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _startpos_x_) = _menhir_stack in
        let x = () in
        let _startpos = _startpos_x_ in
        let _v : 'tv_nonempty_list_DASH_ = 
# 218 "<standard.mly>"
    ( [ x ] )
# 1671 "src/duration_parser.ml"
         in
        (_menhir_goto_nonempty_list_DASH_ _menhir_env _menhir_stack _menhir_s _v _startpos : 'freshtv6)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState12

and _menhir_run14 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 2 "src/duration_parser.mly"
       (char)
# 1682 "src/duration_parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv3) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((x : (
# 2 "src/duration_parser.mly"
       (char)
# 1692 "src/duration_parser.ml"
    )) : (
# 2 "src/duration_parser.mly"
       (char)
# 1696 "src/duration_parser.ml"
    )) = _v in
    let _v : 'tv_charlike = 
# 45 "src/duration_parser.mly"
           (x)
# 1701 "src/duration_parser.ml"
     in
    (_menhir_goto_charlike _menhir_env _menhir_stack _menhir_s _v : 'freshtv4)

and _menhir_discard : _menhir_env -> _menhir_env =
  fun _menhir_env ->
    let lexer = _menhir_env._menhir_lexer in
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_error = false;
    }

and main : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 9 "src/duration_parser.mly"
      ( Duration_private.O.t -> Duration_private.O.t -> string )
# 1720 "src/duration_parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env = {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = Obj.magic ();
      _menhir_error = false;
    } in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv1) = ((), _menhir_env._menhir_lexbuf.Lexing.lex_curr_p) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    ((match _tok with
    | CHAR _v ->
        _menhir_run14 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | DASH ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _menhir_env._menhir_lexbuf.Lexing.lex_start_p
    | EQ ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | GT ->
        _menhir_run10 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | INT _v ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | LT ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | OPEN ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | EOF ->
        _menhir_reduce29 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState0) : 'freshtv2))

# 67 "src/duration_parser.mly"
  

# 1758 "src/duration_parser.ml"
