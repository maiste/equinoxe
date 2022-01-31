# 1 "endianBytes.cppo.ml"
(************************************************************************)
(*  ocplib-endian                                                       *)
(*                                                                      *)
(*    Copyright 2014 OCamlPro                                           *)
(*                                                                      *)
(*  This file is distributed under the terms of the GNU Lesser General  *)
(*  Public License as published by the Free Software Foundation; either *)
(*  version 2.1 of the License, or (at your option) any later version,  *)
(*  with the OCaml static compilation exception.                        *)
(*                                                                      *)
(*  ocplib-endian is distributed in the hope that it will be useful,    *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of      *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       *)
(*  GNU General Public License for more details.                        *)
(*                                                                      *)
(************************************************************************)

module type EndianBytesSig = sig
  (** Functions reading according to Big Endian byte order *)

  val get_char : Bytes.t -> int -> char
  (** [get_char buff i] reads 1 byte at offset i as a char *)

  val get_uint8 : Bytes.t -> int -> int
  (** [get_uint8 buff i] reads 1 byte at offset i as an unsigned int of 8
  bits. i.e. It returns a value between 0 and 2^8-1 *)

  val get_int8 : Bytes.t -> int -> int
  (** [get_int8 buff i] reads 1 byte at offset i as a signed int of 8
  bits. i.e. It returns a value between -2^7 and 2^7-1 *)

  val get_uint16 : Bytes.t -> int -> int
  (** [get_uint16 buff i] reads 2 bytes at offset i as an unsigned int
  of 16 bits. i.e. It returns a value between 0 and 2^16-1 *)

  val get_int16 : Bytes.t -> int -> int
  (** [get_int16 buff i] reads 2 byte at offset i as a signed int of
  16 bits. i.e. It returns a value between -2^15 and 2^15-1 *)

  val get_int32 : Bytes.t -> int -> int32
  (** [get_int32 buff i] reads 4 bytes at offset i as an int32. *)

  val get_int64 : Bytes.t -> int -> int64
  (** [get_int64 buff i] reads 8 bytes at offset i as an int64. *)

  val get_float : Bytes.t -> int -> float
  (** [get_float buff i] is equivalent to
      [Int32.float_of_bits (get_int32 buff i)] *)

  val get_double : Bytes.t -> int -> float
  (** [get_double buff i] is equivalent to
      [Int64.float_of_bits (get_int64 buff i)] *)

  val set_char : Bytes.t -> int -> char -> unit
  (** [set_char buff i v] writes [v] to [buff] at offset [i] *)

  val set_int8 : Bytes.t -> int -> int -> unit
  (** [set_int8 buff i v] writes the least significant 8 bits of [v]
  to [buff] at offset [i] *)

  val set_int16 : Bytes.t -> int -> int -> unit
  (** [set_int16 buff i v] writes the least significant 16 bits of [v]
  to [buff] at offset [i] *)

  val set_int32 : Bytes.t -> int -> int32 -> unit
  (** [set_int32 buff i v] writes [v] to [buff] at offset [i] *)

  val set_int64 : Bytes.t -> int -> int64 -> unit
  (** [set_int64 buff i v] writes [v] to [buff] at offset [i] *)

  val set_float : Bytes.t -> int -> float -> unit
  (** [set_float buff i v] is equivalent to
      [set_int32 buff i (Int32.bits_of_float v)] *)

  val set_double : Bytes.t -> int -> float -> unit
  (** [set_double buff i v] is equivalent to
      [set_int64 buff i (Int64.bits_of_float v)] *)

end

let get_char (s:Bytes.t) off =
  Bytes.get s off
  [@@ocaml.inline]
let set_char (s:Bytes.t) off v =
  Bytes.set s off v
  [@@ocaml.inline]
let unsafe_get_char (s:Bytes.t) off =
  Bytes.unsafe_get s off
  [@@ocaml.inline]
let unsafe_set_char (s:Bytes.t) off v =
  Bytes.unsafe_set s off v
  [@@ocaml.inline]

# 1 "common.ml"
[@@@warning "-32"]

let sign8 v =
  (v lsl ( Sys.int_size - 8 )) asr ( Sys.int_size - 8 )
  [@@ocaml.inline]

let sign16 v =
  (v lsl ( Sys.int_size - 16 )) asr ( Sys.int_size - 16 )
  [@@ocaml.inline]

let get_uint8 s off =
  Char.code (get_char s off)
  [@@ocaml.inline]
let get_int8 s off =
  ((get_uint8 s off) lsl ( Sys.int_size - 8 )) asr ( Sys.int_size - 8 )
  [@@ocaml.inline]
let set_int8 s off v =
  (* It is ok to cast using unsafe_chr because both String.set
     and Bigarray.Array1.set (on bigstrings) use the 'store unsigned int8'
     primitives that effectively extract the bits before writing *)
  set_char s off (Char.unsafe_chr v)
  [@@ocaml.inline]

let unsafe_get_uint8 s off =
  Char.code (unsafe_get_char s off)
  [@@ocaml.inline]
let unsafe_get_int8 s off =
  ((unsafe_get_uint8 s off) lsl ( Sys.int_size - 8 )) asr ( Sys.int_size - 8 )
  [@@ocaml.inline]
let unsafe_set_int8 s off v =
  unsafe_set_char s off (Char.unsafe_chr v)
  [@@ocaml.inline]


# 116 "endianBytes.cppo.ml"
external unsafe_get_16 : Bytes.t -> int -> int = "%caml_bytes_get16u"
external unsafe_get_32 : Bytes.t -> int -> int32 = "%caml_bytes_get32u"
external unsafe_get_64 : Bytes.t -> int -> int64 = "%caml_bytes_get64u"

external unsafe_set_16 : Bytes.t -> int -> int -> unit = "%caml_bytes_set16u"
external unsafe_set_32 : Bytes.t -> int -> int32 -> unit = "%caml_bytes_set32u"
external unsafe_set_64 : Bytes.t -> int -> int64 -> unit = "%caml_bytes_set64u"

external get_16 : Bytes.t -> int -> int = "%caml_bytes_get16"
external get_32 : Bytes.t -> int -> int32 = "%caml_bytes_get32"
external get_64 : Bytes.t -> int -> int64 = "%caml_bytes_get64"

external set_16 : Bytes.t -> int -> int -> unit = "%caml_bytes_set16"
external set_32 : Bytes.t -> int -> int32 -> unit = "%caml_bytes_set32"
external set_64 : Bytes.t -> int -> int64 -> unit = "%caml_bytes_set64"



# 1 "common_401.cppo.ml"
# 1 "common_401.cppo.ml"
external swap16 : int -> int = "%bswap16"
external swap32 : int32 -> int32 = "%bswap_int32"
external swap64 : int64 -> int64 = "%bswap_int64"
external swapnative : nativeint -> nativeint = "%bswap_native"

module BigEndian = struct

  let get_char = get_char
  let get_uint8 = get_uint8
  let get_int8 = get_int8
  let set_char = set_char
  let set_int8 = set_int8

  

# 1 "be_ocaml_401.ml"
  
# 1 "be_ocaml_401.ml"
  let get_uint16 s off =
    if not Sys.big_endian
    then swap16 (get_16 s off)
    else get_16 s off
  [@@ocaml.inline]

  let get_int16 s off =
   ((get_uint16 s off) lsl ( Sys.int_size - 16 )) asr ( Sys.int_size - 16 )
  [@@ocaml.inline]

  let get_int32 s off =
    if not Sys.big_endian
    then swap32 (get_32 s off)
    else get_32 s off
  [@@ocaml.inline]

  let get_int64 s off =
    if not Sys.big_endian
    then swap64 (get_64 s off)
    else get_64 s off
  [@@ocaml.inline]

  let set_int16 s off v =
    if not Sys.big_endian
    then (set_16 s off (swap16 v))
    else set_16 s off v
  [@@ocaml.inline]

  let set_int32 s off v =
    if not Sys.big_endian
    then set_32 s off (swap32 v)
    else set_32 s off v
  [@@ocaml.inline]

  let set_int64 s off v =
    if not Sys.big_endian
    then set_64 s off (swap64 v)
    else set_64 s off v
  [@@ocaml.inline]


# 2 "common_float.ml"
# 2 "common_float.ml"
let get_float buff i = Int32.float_of_bits (get_int32 buff i) [@@ocaml.inline]
let get_double buff i = Int64.float_of_bits (get_int64 buff i) [@@ocaml.inline]
let set_float buff i v = set_int32 buff i (Int32.bits_of_float v) [@@ocaml.inline]
let set_double buff i v = set_int64 buff i (Int64.bits_of_float v) [@@ocaml.inline]


# 17 "common_401.cppo.ml"
# 17 "common_401.cppo.ml"
end

module BigEndian_unsafe = struct

  let get_char = unsafe_get_char
  let get_uint8 = unsafe_get_uint8
  let get_int8 = unsafe_get_int8
  let set_char = unsafe_set_char
  let set_int8 = unsafe_set_int8
  let get_16 = unsafe_get_16
  let get_32 = unsafe_get_32
  let get_64 = unsafe_get_64
  let set_16 = unsafe_set_16
  let set_32 = unsafe_set_32
  let set_64 = unsafe_set_64

  

# 1 "be_ocaml_401.ml"
  
# 1 "be_ocaml_401.ml"
  let get_uint16 s off =
    if not Sys.big_endian
    then swap16 (get_16 s off)
    else get_16 s off
  [@@ocaml.inline]

  let get_int16 s off =
   ((get_uint16 s off) lsl ( Sys.int_size - 16 )) asr ( Sys.int_size - 16 )
  [@@ocaml.inline]

  let get_int32 s off =
    if not Sys.big_endian
    then swap32 (get_32 s off)
    else get_32 s off
  [@@ocaml.inline]

  let get_int64 s off =
    if not Sys.big_endian
    then swap64 (get_64 s off)
    else get_64 s off
  [@@ocaml.inline]

  let set_int16 s off v =
    if not Sys.big_endian
    then (set_16 s off (swap16 v))
    else set_16 s off v
  [@@ocaml.inline]

  let set_int32 s off v =
    if not Sys.big_endian
    then set_32 s off (swap32 v)
    else set_32 s off v
  [@@ocaml.inline]

  let set_int64 s off v =
    if not Sys.big_endian
    then set_64 s off (swap64 v)
    else set_64 s off v
  [@@ocaml.inline]


# 2 "common_float.ml"
# 2 "common_float.ml"
let get_float buff i = Int32.float_of_bits (get_int32 buff i) [@@ocaml.inline]
let get_double buff i = Int64.float_of_bits (get_int64 buff i) [@@ocaml.inline]
let set_float buff i v = set_int32 buff i (Int32.bits_of_float v) [@@ocaml.inline]
let set_double buff i v = set_int64 buff i (Int64.bits_of_float v) [@@ocaml.inline]


# 36 "common_401.cppo.ml"
# 36 "common_401.cppo.ml"
end

module LittleEndian = struct

  let get_char = get_char
  let get_uint8 = get_uint8
  let get_int8 = get_int8
  let set_char = set_char
  let set_int8 = set_int8

  

# 1 "le_ocaml_401.ml"
  
# 1 "le_ocaml_401.ml"
  let get_uint16 s off =
    if Sys.big_endian
    then swap16 (get_16 s off)
    else get_16 s off
  [@@ocaml.inline]

  let get_int16 s off =
   ((get_uint16 s off) lsl ( Sys.int_size - 16 )) asr ( Sys.int_size - 16 )
  [@@ocaml.inline]

  let get_int32 s off =
    if Sys.big_endian
    then swap32 (get_32 s off)
    else get_32 s off
  [@@ocaml.inline]

  let get_int64 s off =
    if Sys.big_endian
    then swap64 (get_64 s off)
    else get_64 s off
  [@@ocaml.inline]

  let set_int16 s off v =
    if Sys.big_endian
    then (set_16 s off (swap16 v))
    else set_16 s off v
  [@@ocaml.inline]

  let set_int32 s off v =
    if Sys.big_endian
    then set_32 s off (swap32 v)
    else set_32 s off v
  [@@ocaml.inline]

  let set_int64 s off v =
    if Sys.big_endian
    then set_64 s off (swap64 v)
    else set_64 s off v
  [@@ocaml.inline]


# 2 "common_float.ml"
# 2 "common_float.ml"
let get_float buff i = Int32.float_of_bits (get_int32 buff i) [@@ocaml.inline]
let get_double buff i = Int64.float_of_bits (get_int64 buff i) [@@ocaml.inline]
let set_float buff i v = set_int32 buff i (Int32.bits_of_float v) [@@ocaml.inline]
let set_double buff i v = set_int64 buff i (Int64.bits_of_float v) [@@ocaml.inline]


# 49 "common_401.cppo.ml"
# 49 "common_401.cppo.ml"
end

module LittleEndian_unsafe = struct

  let get_char = unsafe_get_char
  let get_uint8 = unsafe_get_uint8
  let get_int8 = unsafe_get_int8
  let set_char = unsafe_set_char
  let set_int8 = unsafe_set_int8
  let get_16 = unsafe_get_16
  let get_32 = unsafe_get_32
  let get_64 = unsafe_get_64
  let set_16 = unsafe_set_16
  let set_32 = unsafe_set_32
  let set_64 = unsafe_set_64

  

# 1 "le_ocaml_401.ml"
  
# 1 "le_ocaml_401.ml"
  let get_uint16 s off =
    if Sys.big_endian
    then swap16 (get_16 s off)
    else get_16 s off
  [@@ocaml.inline]

  let get_int16 s off =
   ((get_uint16 s off) lsl ( Sys.int_size - 16 )) asr ( Sys.int_size - 16 )
  [@@ocaml.inline]

  let get_int32 s off =
    if Sys.big_endian
    then swap32 (get_32 s off)
    else get_32 s off
  [@@ocaml.inline]

  let get_int64 s off =
    if Sys.big_endian
    then swap64 (get_64 s off)
    else get_64 s off
  [@@ocaml.inline]

  let set_int16 s off v =
    if Sys.big_endian
    then (set_16 s off (swap16 v))
    else set_16 s off v
  [@@ocaml.inline]

  let set_int32 s off v =
    if Sys.big_endian
    then set_32 s off (swap32 v)
    else set_32 s off v
  [@@ocaml.inline]

  let set_int64 s off v =
    if Sys.big_endian
    then set_64 s off (swap64 v)
    else set_64 s off v
  [@@ocaml.inline]


# 2 "common_float.ml"
# 2 "common_float.ml"
let get_float buff i = Int32.float_of_bits (get_int32 buff i) [@@ocaml.inline]
let get_double buff i = Int64.float_of_bits (get_int64 buff i) [@@ocaml.inline]
let set_float buff i v = set_int32 buff i (Int32.bits_of_float v) [@@ocaml.inline]
let set_double buff i v = set_int64 buff i (Int64.bits_of_float v) [@@ocaml.inline]


# 68 "common_401.cppo.ml"
# 68 "common_401.cppo.ml"
end

module NativeEndian = struct

  let get_char = get_char
  let get_uint8 = get_uint8
  let get_int8 = get_int8
  let set_char = set_char
  let set_int8 = set_int8

  

# 1 "ne_ocaml_401.ml"
  
# 1 "ne_ocaml_401.ml"
  let get_uint16 s off =
    get_16 s off
  [@@ocaml.inline]

  let get_int16 s off =
   ((get_uint16 s off) lsl ( Sys.int_size - 16 )) asr ( Sys.int_size - 16 )
  [@@ocaml.inline]

  let get_int32 s off =
    get_32 s off
  [@@ocaml.inline]

  let get_int64 s off =
    get_64 s off
  [@@ocaml.inline]

  let set_int16 s off v =
    set_16 s off v
  [@@ocaml.inline]

  let set_int32 s off v =
    set_32 s off v
  [@@ocaml.inline]

  let set_int64 s off v =
    set_64 s off v
  [@@ocaml.inline]


# 2 "common_float.ml"
# 2 "common_float.ml"
let get_float buff i = Int32.float_of_bits (get_int32 buff i) [@@ocaml.inline]
let get_double buff i = Int64.float_of_bits (get_int64 buff i) [@@ocaml.inline]
let set_float buff i v = set_int32 buff i (Int32.bits_of_float v) [@@ocaml.inline]
let set_double buff i v = set_int64 buff i (Int64.bits_of_float v) [@@ocaml.inline]


# 81 "common_401.cppo.ml"
# 81 "common_401.cppo.ml"
end

module NativeEndian_unsafe = struct

  let get_char = unsafe_get_char
  let get_uint8 = unsafe_get_uint8
  let get_int8 = unsafe_get_int8
  let set_char = unsafe_set_char
  let set_int8 = unsafe_set_int8
  let get_16 = unsafe_get_16
  let get_32 = unsafe_get_32
  let get_64 = unsafe_get_64
  let set_16 = unsafe_set_16
  let set_32 = unsafe_set_32
  let set_64 = unsafe_set_64

  

# 1 "ne_ocaml_401.ml"
  
# 1 "ne_ocaml_401.ml"
  let get_uint16 s off =
    get_16 s off
  [@@ocaml.inline]

  let get_int16 s off =
   ((get_uint16 s off) lsl ( Sys.int_size - 16 )) asr ( Sys.int_size - 16 )
  [@@ocaml.inline]

  let get_int32 s off =
    get_32 s off
  [@@ocaml.inline]

  let get_int64 s off =
    get_64 s off
  [@@ocaml.inline]

  let set_int16 s off v =
    set_16 s off v
  [@@ocaml.inline]

  let set_int32 s off v =
    set_32 s off v
  [@@ocaml.inline]

  let set_int64 s off v =
    set_64 s off v
  [@@ocaml.inline]


# 2 "common_float.ml"
# 2 "common_float.ml"
let get_float buff i = Int32.float_of_bits (get_int32 buff i) [@@ocaml.inline]
let get_double buff i = Int64.float_of_bits (get_int64 buff i) [@@ocaml.inline]
let set_float buff i v = set_int32 buff i (Int32.bits_of_float v) [@@ocaml.inline]
let set_double buff i v = set_int64 buff i (Int64.bits_of_float v) [@@ocaml.inline]


# 100 "common_401.cppo.ml"
# 100 "common_401.cppo.ml"
end
