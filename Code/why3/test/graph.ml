
let g0 = [ (1, [1 ; 2 ; 3], 4) ; 
           (2, [1 ; 2], 5) ;
           (3, [4 ; 5 ], 6) ]
           

let g1  =  
  Tensor.add_node g0 4 [5 ; 6 ] 7  


  let ts0 : Tensor.tensorstate = {id = 1; iset = true}
let s0 : Tensor.tensorstate list = [ 
  {id = 1; iset = true}; 
  {id = 2; iset = false}; 
  {id = 3; iset = true}; 
  {id = 4; iset = false} ]

let print_node v i o = 
  Printf.printf "(%d, [" v;
  List.iter (fun el -> Printf.printf "%d " el) i;
  Printf.printf "], [";
  Printf.printf "%d" o;
  Printf.printf "])\n"

let print_graph l =
  List.iter (fun (v,i,o) -> print_node v i o  ) l


let print_state (l : Tensor.tensorstate list) =
  List.iter (fun (x) -> Printf.printf " (%d : %b)" x.id x.iset  ) l;
  Printf.printf "\n"

let print_list l =
  List.iter (fun el -> Printf.printf "%d " el) l;
  Printf.printf "\n"

let () = 
  print_graph g1;
  print_list (Tensor.get_all_inputs g1);
  print_list (Tensor.get_all_outputs g1);
  print_state s0;
  print_list (Tensor.get_executable_nodes g1 s0)
