type nodeid = int

type tensorid = int

type tensorstate = {
  id: int;
  iset: bool;
  }

type state = tensorstate list

let rec fold_left : type a b. (a -> (b -> a)) -> a -> (b list) ->  a =
  fun f acc l -> match l with
    | [] -> acc
    | x :: xs -> fold_left f (f acc x) xs

let rec map : type a b. (a -> b) -> (a list) ->  (b list) =
  fun f l -> match l with
    | [] -> [] 
    | x :: xs -> f x :: map f xs

let rec mem_concrete (x: int) (l: (int) list) : bool =
  match l with
  | [] -> false
  | y :: r -> x = y || mem_concrete x r

let rec list_diff (l1: (int) list) (l2: (int) list) : (int) list =
  match l1 with
  | [] -> [] 
  | h :: tl ->
    if mem_concrete h l2 then list_diff tl l2 else h :: list_diff tl l2

let fold_left_and (l: (bool) list) : bool =
  fold_left (fun (acc: bool) (x: bool) -> acc && x) true l

let eq_node (n1: int) (n2: int) : bool = n1 = n2

type onnxgraph = ((int) * ((int) list) * (int)) list

let rec mem_node (g: ((int) * ((int) list) * (int)) list) (n: int) : 
  bool =
  match g with
  | [] -> false
  | (n', _, _) :: g' -> eq_node n n' || mem_node g' n

let rec tensor_state (s: tensorstate list) (tid: int) : bool =
  match s with
  | [] -> false
  | h :: tl -> if h.id = tid then h.iset else tensor_state tl tid

let rec find_inputs (g: ((int) * ((int) list) * (int)) list) (n: int) :
  ((int) list) option =
  match g with
  | [] -> None 
  | (n', i, _) :: g' -> if eq_node n n' then Some i else find_inputs g' n

let rec find_output (g: ((int) * ((int) list) * (int)) list) (n: int) :
  (int) option =
  match g with
  | [] -> None 
  | (n', _, o) :: g' -> if eq_node n n' then Some o else find_output g' n

let add_node (g: ((int) * ((int) list) * (int)) list) (n: int)
             (inputs: (int) list) (output: int) :
  ((int) * ((int) list) * (int)) list = (n, inputs, output) :: g

let is_executable (g: ((int) * ((int) list) * (int)) list) (n: int)
                  (s: tensorstate list) : bool =
  let inputs = find_inputs g n in
  match inputs with
  | None -> true
  | Some i -> fold_left_and (map (fun (tid: int) -> tensor_state s tid) i)

let rec get_all_outputs (g: ((int) * ((int) list) * (int)) list) : (int) list
  = match g with
    | [] -> [] 
    | (_, _, o) :: g' -> o :: get_all_outputs g'

let remove_duplicates_1 (l: (int) list) : (int) list =
  let rec aux (l1: (int) list) (acc1: (int) list) : (int) list =
    match l1 with
    | [] -> acc1
    | h :: tl ->
      if mem_concrete h acc1 then aux tl acc1 else aux tl (h :: acc1) in
  aux l ([] )

let rec remove_duplicates (l: (int) list) : (int) list =
  match l with
  | [] -> [] 
  | h :: tl ->
    if mem_concrete h tl
    then remove_duplicates tl
    else begin let r = remove_duplicates tl in h :: r end

let get_all_inputs (g: ((int) * ((int) list) * (int)) list) : (int) list =
  let rec aux1 :
    type xi xi1 xi2. ((xi * (xi1 list) * xi2) list) ->  (xi1 list) =
    fun g1 -> match g1 with
      | [] -> [] 
      | (_, i, _) :: g' -> List.append i (aux1 g') in
  remove_duplicates (aux1 g)

let get_all_free_inputs (g: ((int) * ((int) list) * (int)) list) : (int) list
  = list_diff (get_all_inputs g) (get_all_outputs g)

let get_executable_nodes (g: ((int) * ((int) list) * (int)) list)
                         (s: tensorstate list) : (int) list =
  let rec aux2 (g1: ((int) * ((int) list) * (int)) list) (acc1: (int) list) :
    (int) list =
    match g1 with
    | [] -> acc1
    | (n, _, _) :: g' ->
      if is_executable g1 n s then aux2 g' (n :: acc1) else aux2 g' acc1 in
  aux2 g ([] )

