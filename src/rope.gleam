import gleam/option.{type Option, None, Some}
import gleam/string

pub opaque type RopeNode {
  RopeNode(weight: Int, left: RopeNode, right: Option(RopeNode))
  RopeLeaf(weight: Int, value: String)
}

pub opaque type Rope {
  Rope(root: RopeNode)
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
    weight: left.root.weight + right.root.weight,
  ))
}

pub fn length(rope: Rope) -> Int {
  case rope.root {
    RopeNode(_, left, right) ->
      left.weight
      + case right {
        Some(node) -> node.weight
        None -> 0
      }
    RopeLeaf(weight, ..) -> weight
  }
}
