import gleam/int
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/string

const max_merge_size = 35

pub type RopeNode {
  RopeNode(weight: Int, left: RopeNode, right: Option(RopeNode))
  RopeLeaf(weight: Int, value: String)
}

pub type Rope =
  RopeNode

pub type Strategy =
  fn(Rope) -> Rope

pub fn print(rope: Rope) -> Rope {
  print_helper(rope, 0)

  rope
}

fn print_helper(node: RopeNode, identation: Int) {
  case node {
    RopeNode(_, left, right) -> {
      print_node(node, identation)
      print_helper(left, identation + 1)
      case right {
        Some(node) -> print_helper(node, identation + 1)
        None -> io.print("None")
      }
    }
    RopeLeaf(_, value) -> print_value(value, identation)
  }
}

fn print_value(value: String, identation: Int) {
  io.print(string.repeat(" ", identation * 2) <> value <> "\n")
}

fn print_node(node: RopeNode, identation: Int) {
  io.print(
    string.repeat(" ", identation * 2)
    <> "Node weight: "
    <> int.to_string(node.weight)
    <> "\n",
  )
}

pub fn from_string(string: String) -> Rope {
  RopeLeaf(string.length(string), string)
}

pub fn value(rope: Rope) -> String {
  case rope {
    RopeNode(_, left, right) ->
      case right {
        Some(node) -> value(left) <> value(node)
        None -> value(left)
      }
    RopeLeaf(_, value) -> value
  }
}

fn check_and_merge_right(original: Rope, concat: Rope) -> Option(Rope) {
  case original {
    RopeNode(weight, left, right) -> {
      let assert Some(new_original) = right
      let result = check_and_merge_right(new_original, concat)
      case result {
        Some(rope) -> Some(RopeNode(weight, left, Some(rope)))
        None -> None
      }
    }

    RopeLeaf(weight, value) if weight + concat.weight < max_merge_size -> {
      let assert RopeLeaf(concat_weight, concat_value) = concat
      Some(RopeLeaf(weight + concat_weight, value <> concat_value))
    }

    _leaf -> None
  }
}

pub fn concat_and_merge(left: Rope, right: Rope) -> Rope {
  case left, right {
    RopeLeaf(lweight, lvalue), RopeLeaf(rweight, rvalue)
      if lweight + rweight < max_merge_size
    -> {
      RopeLeaf(lweight + rweight, lvalue <> rvalue)
    }
    RopeNode(_, _, _), RopeLeaf(_, _) ->
      case check_and_merge_right(left, right) {
        Some(rope) -> rope
        None -> concat(left, right)
      }
    _, _ -> concat(left, right)
  }
}

pub fn concat(left: Rope, right: Rope) -> Rope {
  RopeNode(length(left), left, Some(right))
}

pub fn length(rope: Rope) -> Int {
  length_helper(rope, 0)
}

pub fn length_helper(node: RopeNode, acc: Int) -> Int {
  case node {
    RopeNode(weight, _, right) -> {
      case right {
        Some(right) -> length_helper(right, acc + weight)
        None -> acc + weight
      }
    }
    RopeLeaf(weight, ..) -> {
      weight + acc
    }
  }
}

// pub fn split(rope: Rope, at_index idx: Int) -> Result(#(Rope, Rope), Nil) {
//   case idx > length(rope) {
//     True -> Error(Nil)
//     False -> Ok(split_helper(rope.root, idx))
//   }
// }
//
// fn split_helper(node: RopeNode, index: Int) -> #(Rope, Rope) {
//   case node {
//     RopeNode(_, left, _) if index < node.weight -> split_helper(left, index)
//     RopeLeaf(_, _) if index < node.weight ->
//     RopeNode(_, _, Some(right)) if index > node.weight ->
//       split_helper(right, index)
//     RopeLeaf(_, _) if index > node.weight -> todo
//     RopeNode(_, left, Some(right)) -> {
//       #(Rope(left), Rope(right))
//     }
//     _ -> panic
//   }
// }

pub fn slice(
  from rope: Rope,
  at_index idx: Int,
  length len: Int,
) -> Result(Rope, Nil) {
  case { idx + len } > length(rope) {
    True -> Error(Nil)
    False -> Ok(slice_helper(rope, idx, len))
  }
}

fn slice_helper(node: RopeNode, index: Int, length: Int) -> Rope {
  case node {
    RopeNode(weight, left, right)
      if index < node.weight && index + length > node.weight
    -> {
      let assert Some(right) = right

      concat(
        slice_helper(left, index, weight - index),
        slice_helper(right, 0, length - { weight - index }),
      )
    }

    RopeNode(_weight, left, _right) if index < node.weight ->
      slice_helper(left, index, length)

    RopeNode(weight, _left, right) -> {
      let assert Some(right_node) = right
      slice_helper(right_node, index - weight, length)
    }

    RopeLeaf(_weight, value) -> {
      from_string(string.slice(value, index, length))
    }
  }
}

pub fn at_index(rope: Rope, at_index idx: Int) -> Result(String, Nil) {
  case idx > length(rope) {
    True -> Error(Nil)
    False -> Ok(at_index_helper(rope, idx))
  }
}

fn at_index_helper(node: RopeNode, index: Int) -> String {
  case node {
    RopeNode(_, left, _) if index < node.weight -> at_index_helper(left, index)
    RopeNode(weight, _, right) -> {
      let assert Some(right_node) = right
      at_index_helper(right_node, index - weight)
    }
    RopeLeaf(_, value) -> string.slice(value, index, 1)
  }
}

pub fn insert(rope: Rope, at_index: Int, insert_value: Rope) -> Rope {
  insert_helper(rope, at_index, insert_value)
}

fn insert_helper(node: RopeNode, index: Int, insert_value: Rope) -> RopeNode {
  case node {
    RopeNode(_weight, left, right) if index < node.weight -> {
      let new_left = insert_helper(left, index, insert_value)
      RopeNode(length_helper(new_left, 0), new_left, right)
    }
    RopeNode(weight, left, right) -> {
      let assert Some(right_node) = right
      let new_right = insert_helper(right_node, index - weight, insert_value)
      RopeNode(weight, left, Some(new_right))
    }
    RopeLeaf(weight, value) -> {
      case index {
        0 -> RopeNode(insert_value.weight, insert_value, Some(node))
        _ if index == weight -> RopeNode(node.weight, node, Some(insert_value))
        _ -> {
          // TODO: Check if you can do this in just one pass over the string and if 
          // its better
          let left_value =
            value
            |> string.slice(0, index)
          let right_value =
            value
            |> string.slice(index, weight - index)

          let left_node =
            RopeNode(
              index,
              RopeLeaf(string.length(left_value), left_value),
              Some(insert_value),
            )

          RopeNode(
            index + insert_value.weight,
            left_node,
            Some(RopeLeaf(weight - index, right_value)),
          )
        }
      }
    }
  }
}

pub fn depth(rope: Rope) -> Int {
  case rope {
    RopeNode(_weight, left, Some(right)) -> {
      1 + int.max(depth(left), depth(right))
    }
    RopeNode(_weight, left, None) -> depth(left)
    RopeLeaf(_, ..) -> 0
  }
}

pub fn rebalance(rope: Rope, strategy: Strategy) -> Rope {
  strategy(rope)
}
