import gleam/int
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/string

pub opaque type RopeNode {
  RopeNode(weight: Int, left: RopeNode, right: Option(RopeNode))
  RopeLeaf(weight: Int, value: String)
}

pub opaque type Rope {
  Rope(root: RopeNode)
}

pub fn print(rope: Rope) {
  print_helper(rope.root, 0)
}

fn print_helper(node: RopeNode, identation: Int) {
  case node {
    RopeNode(_, left, right) -> {
      print_node(node, identation)
      print_helper(left, identation + 1)
      case right {
        Some(node) -> print_helper(node, identation + 1)
        None -> io.debug("None")
      }
    }
    RopeLeaf(_, value) -> io.debug(value)
  }
}

fn print_node(node: RopeNode, identation: Int) {
  io.debug(
    string.repeat(" ", identation * 2)
    <> "Node weight: "
    <> int.to_string(node.weight)
    <> "\n",
  )
}

pub fn from_string(string: String) -> Rope {
  Rope(RopeLeaf(string.length(string), string))
}

pub fn value(rope: Rope) -> String {
  value_helper(rope.root)
}

fn value_helper(node: RopeNode) -> String {
  case node {
    RopeNode(_, left, right) ->
      case right {
        Some(node) -> value_helper(left) <> value_helper(node)
        None -> value_helper(left)
      }
    RopeLeaf(_, value) -> value
  }
}

pub fn concat(left: Rope, right: Rope) -> Rope {
  Rope(root: RopeNode(
    left: left.root,
    right: Some(right.root),
    weight: length(left),
  ))
}

pub fn length(rope: Rope) -> Int {
  length_helper(rope.root, 0)
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
    False -> Ok(slice_helper(rope.root, idx, len))
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

fn slice_helper_with_acc(
  node: RopeNode,
  index: Int,
  length: Int,
  acc: Int,
) -> Rope {
  case node {
    RopeNode(_weight, left, right)
      if index < acc + node.weight && index + length > acc + node.weight
    -> {
      let left_slice_length = int.min(length, index - acc + left.weight)
      let assert Some(right) = right

      io.debug(left_slice_length)

      concat(
        slice_helper_with_acc(left, index, left_slice_length, acc),
        slice_helper_with_acc(
          right,
          0,
          length - left_slice_length,
          acc + node.weight,
        ),
      )
    }

    RopeNode(_weight, left, _right) if index < acc + node.weight ->
      slice_helper_with_acc(left, index, length, acc)

    RopeNode(_weight, _left, right) -> {
      let assert Some(right_node) = right
      slice_helper_with_acc(right_node, index, length, acc + node.weight)
    }

    RopeLeaf(_weight, value) -> {
      //let slice_length = int.min(length, index - acc + weight)
      from_string(string.slice(value, index - acc, length))
    }
  }
}
