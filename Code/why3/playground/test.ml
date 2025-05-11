type point = {
  x: float;
  y: float;
}

type rectangle = {
  ll: point; (* lower left *)
  ur: point; (* upper right *)
}



let () = 
  let p = {x = 1.0; y = 2.0} in
   print_string "Hello, world!\n" ;
   Printf.printf "%f %f"  p.x p.y ;

