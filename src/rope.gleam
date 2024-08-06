import gleam/option.{type Option, None, Some}
import gleam/string

pub opaque type RopeNode {
  RopeNode(left: RopeNode, right: Option(RopeNode), weight: Int)
  RopeLeaf(value: String, weight: Int)
}

pub opaque type Rope {
  Rope(root: RopeNode)
}

pub fn from_string(string: String) -> Rope {
  Rope(RopeLeaf(string, string.length(string)))
}

pub fn value(rope: Rope) -> String {
  value_helper(rope.root)
}

fn value_helper(node: RopeNode) -> String {
  case node {
    RopeNode(left, right, _) ->
      case right {
        Some(node) -> value_helper(left) <> value_helper(node)
        None -> value_helper(left)
      }
    RopeLeaf(value, _) -> value
  }
}
