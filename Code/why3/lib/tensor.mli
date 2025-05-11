(** ONNX Tensor OCaml Interface *)

type 'a tensor

val dim : 'a tensor -> int
val shape : 'a tensor -> int list

val scalar : 'a -> 'a tensor
val vector : 'a list -> 'a tensor
val matrix : 'a list list -> 'a tensor

exception Invalid_index

val mem : int list -> 'a tensor -> bool
val get : int list -> 'a tensor -> 'a
val (.%[]) : 'a tensor -> int -> 'a
val (.%[;..]) : 'a tensor -> int array -> 'a

val pretty : (Format.formatter -> 'a -> unit) -> Format.formatter -> 'a tensor -> unit

val transpose : 'a tensor -> 'a tensor
val where : bool tensor -> 'a tensor -> 'a tensor -> 'a tensor

type tensorstate
val find_inputs : (int * (int list) * int) list -> int -> int list option
val find_output : (int * (int list) * int) list -> int -> int option
val add_node : (int * (int list) * int) list -> int -> int list -> int -> (int * (int list) * int) list 
val is_executable : (int * (int list) * int) list -> int -> tensorstate list -> bool

val get_all_outputs :  (int * (int list) * int) list -> int list
val get_all_inputs : (int * (int list) * int) list -> int list
val get_all_free_inputs : (int * (int list) * int) list -> int list
val get_executable_nodes : (int * (int list) * int) list -> tensorstate list  -> int list