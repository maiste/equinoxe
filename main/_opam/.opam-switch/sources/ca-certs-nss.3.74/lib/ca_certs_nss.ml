module Make (C : Mirage_clock.PCLOCK) = struct
  let authenticator =
    let tas =
      List.fold_left
        (fun acc data ->
          Result.bind acc (fun acc ->
              Result.map
                (fun cert -> cert :: acc)
                (X509.Certificate.decode_der (Cstruct.of_string data))))
        (Ok []) Trust_anchor.certificates
    and time () = Some (Ptime.v (C.now_d_ps ())) in
    fun ?crls ?allowed_hashes () ->
      Result.map
        (X509.Authenticator.chain_of_trust ~time ?crls ?allowed_hashes)
        tas
end
