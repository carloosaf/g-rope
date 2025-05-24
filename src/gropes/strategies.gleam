import gleam/list
import gleam/option.{type Option, None, Some}
import gropes/rope.{type Rope, type RopeNode, RopeLeaf, RopeNode}

// pub fn fibonnacci_sequence() -> Dict(Int, Int) {
//   dict.from_list([
//     #(0, 0),
//     #(1, 1),
//     #(2, 1),
//     #(3, 2),
//     #(4, 3),
//     #(5, 5),
//     #(6, 8),
//     #(7, 13),
//     #(8, 21),
//     #(9, 34),
//   ])
// }

pub fn fibonnacci_sequence() -> List(Int) {
  [
    1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181,
    6765, 10_946, 17_711, 28_657, 46_368, 75_025, 121_393, 196_418, 317_811,
    514_229,
  ]
}

pub fn fibonnacci_rebalance(rope: Rope) -> Rope {
  let length = rope.length(rope)
  let sequence = build_sequence(length)
  let leaves = prune(rope, [])

  rebuild(leaves, sequence)
}

fn build_sequence(length: Int) -> List(#(Int, Option(Rope))) {
  fibonnacci_sequence()
  |> list.filter(fn(value) { length >= value })
  |> list.map(fn(value) { #(value, None) })
  |> list.reverse()
}

fn rebuild(leaves: List(RopeNode), sequence: List(#(Int, Option(Rope)))) -> Rope {
  case leaves {
    [] -> {
      concat_sequence(sequence)
    }
    [leaf, ..tail] -> {
      let assert RopeLeaf(weight, _) = leaf

      let slot =
        sequence
        |> list.find(fn(tuple) {
          let #(index, _) = tuple
          weight >= index
        })

      case slot {
        Ok(#(index, rope)) -> {
          case rope {
            Some(_rope) -> {
              let new_rope = build_new_rope(sequence, leaf)
              let new_sequence = build_new_sequence(sequence, new_rope)

              rebuild(tail, new_sequence)
            }
            None -> {
              case
                list.any(sequence, fn(tuple) {
                  let #(i, rope) = tuple
                  option.is_some(rope) && i < index
                })
              {
                True -> {
                  let new_rope = build_new_rope(sequence, leaf)
                  let new_sequence = build_new_sequence(sequence, new_rope)

                  rebuild(tail, new_sequence)
                }
                False -> {
                  let new_sequence = list.key_set(sequence, index, Some(leaf))
                  rebuild(tail, new_sequence)
                }
              }
            }
          }
        }
        Error(Nil) -> {
          rebuild(tail, sequence)
        }
      }
    }
  }
}

fn build_new_sequence(
  sequence: List(#(Int, Option(Rope))),
  new_rope: Rope,
) -> List(#(Int, Option(Rope))) {
  let assert Ok(#(index, _rope)) =
    sequence
    |> list.find(fn(tuple) {
      let #(index, _) = tuple
      rope.length(new_rope) >= index
    })

  sequence
  |> list.key_set(index, Some(new_rope))
  |> list.map(fn(tuple) {
    let #(tuple_index, _) = tuple

    case tuple_index < index {
      True -> #(tuple_index, None)
      False -> tuple
    }
  })
}

fn build_new_rope(sequence: List(#(Int, Option(Rope))), new_rope: Rope) -> Rope {
  let ropes =
    sequence
    |> list.filter(fn(tuple) {
      let #(index, option_rope) = tuple
      option.is_some(option_rope)
      && rope.length(option.unwrap(
        option_rope,
        rope.from_string("not possible"),
      ))
      >= index
    })
    |> list.map(fn(tuple) {
      let assert #(_, Some(rope)) = tuple
      rope
    })

  let result = case ropes {
    [] -> rope.from_string("unreachable")
    [rope] -> rope
    [first, second] -> rope.concat(first, second)
    [first, second, ..tail] -> {
      list.fold(tail, rope.concat(first, second), fn(acc, rope) {
        rope.concat(acc, rope)
      })
    }
  }

  rope.concat(result, new_rope)
}

fn concat_sequence(sequence: List(#(Int, Option(Rope)))) -> Rope {
  let ropes =
    sequence
    |> list.filter(fn(tuple) {
      let #(_, rope) = tuple
      option.is_some(rope)
    })
    |> list.map(fn(tuple) {
      let assert #(_, Some(rope)) = tuple
      rope
    })

  case ropes {
    [] -> rope.from_string("")
    [rope] -> {
      rope
    }
    [first, second] -> {
      rope.concat(first, second)
    }
    [first, second, ..tail] -> {
      list.fold(tail, rope.concat(first, second), fn(acc, rope) {
        rope.concat(acc, rope)
      })
    }
  }
}

fn prune(rope: RopeNode, acc: List(RopeNode)) -> List(RopeNode) {
  case rope {
    RopeNode(_, left, right) ->
      case right {
        Some(right) -> list.concat([prune(left, acc), prune(right, acc)])
        None -> prune(left, acc)
      }
    leaf -> {
      [leaf, ..acc]
    }
  }
}
