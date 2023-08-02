open! Core
open! Import

module Ml_z_compare = struct
  let%expect_test "print (a, b, compare a b)" =
    Static.quickcheck_pair
      ~f:(fun a b -> [%message (a : t) (b : t) (compare a b : int)])
      ();
    [%expect "((hash 1f5ae6577a1ebc7c342fdcf1dde524af) (uniqueness_rate 96.529814))"]
  ;;
end

module Ml_z_equal = struct
  let%test_unit "a = a" = Dynamic.quickcheck () ~f:(fun x -> assert (Z.equal x x))

  let%test_unit "succ a != a" =
    Dynamic.quickcheck () ~f:(fun x -> assert (not (Z.equal x (succ x))))
  ;;

  let%test _ = Bool.equal (Z.equal Z.one Z.one) (Int.equal 1 1)
  let%test _ = Bool.equal (Z.equal Z.one Z.zero) (Int.equal 1 0)
end

module Ml_z_hash = struct
  (* We don't expect hash to be the same in javascript and native 64bit *)

  let%expect_test ("print x, hash x (no-js)" [@tags "64-bits-only"]) =
    Static.quickcheck ~f:(fun x -> [%message (x : t) (hash x : int)]) ();
    [%expect
      {|
      ((hash 776eb15c9cfd7c9e3a001bc79c8b193b) (uniqueness_rate 85.742188)) |}]
  ;;

  let%expect_test ("print x, hash x (js-only)" [@tags "js-only"]) =
    Static.quickcheck ~f:(fun x -> [%message (x : t) (hash x : int)]) ();
    [%expect
      {|
      ((hash 06e8f27264e3dcc3b402b536aa76725a) (uniqueness_rate 85.742188)) |}]
  ;;
end
