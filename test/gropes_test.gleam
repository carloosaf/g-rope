import gleam/io
import gleam/result
import gleam/string
import gleeunit
import gleeunit/should
import gropes/rope
import gropes/strategies

pub fn main() {
  gleeunit.main()
}

pub fn value_test() {
  let expected = "Test string"

  expected
  |> rope.from_string()
  |> rope.value()
  |> should.equal(expected)
}

pub fn concat_two_leafs_test() {
  let left = "Left part, "
  let right = "right part"

  rope.concat(rope.from_string(left), rope.from_string(right))
  |> rope.value()
  |> should.equal(left <> right)
}

pub fn multiple_concat_test() {
  let left = "Left part, "
  let right = "right part"
  let middle = "middle part"
  let expected = left <> middle <> right

  rope.concat(rope.from_string(left), rope.from_string(middle))
  |> rope.concat(rope.from_string(right))
  |> rope.value()
  |> should.equal(expected)
}

pub fn length_one_leaf_test() {
  let test_string = "Test string"

  test_string
  |> rope.from_string()
  |> rope.length()
  |> should.equal(string.length(test_string))
}

pub fn length_two_leafs_test() {
  let left = "Left part, "
  let right = "right part"

  rope.concat(rope.from_string(left), rope.from_string(right))
  |> rope.length()
  |> should.equal(string.length(left) + string.length(right))
}

pub fn multiple_leaf_length_test() {
  let left = "Left part, "
  let right = "right part"
  let middle = "middle part"
  let expected =
    string.length(left) + string.length(middle) + string.length(right)

  rope.concat(rope.from_string(left), rope.from_string(middle))
  |> rope.concat(rope.from_string(right))
  |> rope.length()
  |> should.equal(expected)
}

pub fn slice_inside_leaf_test() {
  let abc = "abc"
  let def = "def"
  let ghi = "ghi"
  let rope =
    rope.concat(
      rope.concat(rope.from_string(abc), rope.from_string(def)),
      rope.from_string(ghi),
    )

  rope
  |> rope.slice(6, 3)
  |> result.unwrap(rope.from_string("error"))
  |> rope.value()
  |> should.equal("ghi")
}

pub fn slice_in_middle_of_leaf_test() {
  let abc = "abc"
  let def = "def"
  let ghi = "ghi"
  let rope =
    rope.concat(
      rope.concat(rope.from_string(abc), rope.from_string(def)),
      rope.from_string(ghi),
    )

  rope
  |> rope.slice(7, 2)
  |> result.unwrap(rope.from_string("error"))
  |> rope.value()
  |> should.equal("hi")
}

pub fn slice_in_two_leafs_test() {
  let abc = "abc"
  let def = "def"
  let ghi = "ghi"
  let rope =
    rope.concat(
      rope.concat(rope.from_string(abc), rope.from_string(def)),
      rope.from_string(ghi),
    )

  rope
  |> rope.slice(1, 5)
  |> result.unwrap(rope.from_string("error"))
  |> rope.value()
  |> should.equal("bcdef")
}

pub fn slice_in_three_leafs_test() {
  let abc = "abc"
  let def = "def"
  let ghi = "ghi"
  let rope =
    rope.concat(
      rope.concat(rope.from_string(abc), rope.from_string(def)),
      rope.from_string(ghi),
    )

  rope
  |> rope.slice(1, 7)
  |> result.unwrap(rope.from_string("error"))
  |> rope.value()
  |> should.equal("bcdefgh")
}

pub fn slice_in_four_leafs_test() {
  let abc = "abc"
  let def = "def"
  let ghi = "ghi"
  let jkl = "jkl"
  let rope =
    rope.concat(
      rope.concat(rope.from_string(abc), rope.from_string(def)),
      rope.concat(rope.from_string(ghi), rope.from_string(jkl)),
    )

  rope
  |> rope.slice(1, 10)
  |> result.unwrap(rope.from_string("error"))
  |> rope.value()
  |> should.equal("bcdefghijk")
}

pub fn at_index_test() {
  rope.from_string("Hello World")
  |> rope.at_index(5)
  |> should.equal(Ok(" "))
}

pub fn at_index_out_of_bounds_test() {
  rope.from_string("Hello World")
  |> rope.at_index(100)
  |> should.equal(Error(Nil))
}

pub fn at_index_two_leafs_test() {
  rope.concat(rope.from_string("Hello"), rope.from_string(" World"))
  |> rope.at_index(6)
  |> should.equal(Ok("W"))
}

pub fn at_index_three_leafs_test() {
  rope.concat(
    rope.concat(rope.from_string("Hello"), rope.from_string(" ")),
    rope.from_string("World"),
  )
  |> rope.at_index(7)
  |> should.equal(Ok("o"))
}

pub fn insert_at_node_beginning_test() {
  let def = "def"
  let ghi = "ghi"
  let rope = rope.concat(rope.from_string(def), rope.from_string(ghi))

  rope
  |> rope.insert(0, rope.from_string("abc"))
  |> rope.value()
  |> should.equal("abcdefghi")
}

pub fn insert_at_node_middle_test() {
  let abc = "abc"
  let ghi = "ghi"
  let rope = rope.concat(rope.from_string(abc), rope.from_string(ghi))

  rope
  |> rope.insert(2, rope.from_string("def"))
  |> rope.value()
  |> should.equal("abdefcghi")
}

pub fn insert_at_node_end_test() {
  let abc = "abc"
  let def = "def"
  let rope = rope.concat(rope.from_string(abc), rope.from_string(def))

  rope
  |> rope.insert(6, rope.from_string("ghi"))
  |> rope.value()
  |> should.equal("abcdefghi")
}

pub fn depth_leaf_test() {
  rope.from_string("abc")
  |> rope.depth()
  |> should.equal(0)
}

pub fn depth_two_leafs_test() {
  let abc = "abc"
  let def = "def"
  let rope = rope.concat(rope.from_string(abc), rope.from_string(def))

  rope
  |> rope.depth()
  |> should.equal(1)
}

pub fn depth_three_leafs_test() {
  let abc = "abc"
  let def = "def"
  let ghi = "ghi"
  let rope =
    rope.concat(
      rope.concat(rope.from_string(abc), rope.from_string(def)),
      rope.from_string(ghi),
    )

  rope
  |> rope.depth()
  |> should.equal(2)
}

pub fn rebalance_test() {
  let rope =
    rope.from_string("hi")
    |> rope.concat(rope.from_string("a"))
    |> rope.concat(rope.from_string("world"))
    |> rope.concat(rope.from_string("!"))

  rope.rebalance(rope, strategies.fibonnacci_rebalance)
  |> rope.print()
}

pub fn reblance_new_rope_with_filled_slot_test() {
  let rope = rope.from_string("")

  let rope =
    rope
    |> rope.insert(0, rope.from_string("aaa"))
    |> rope.rebalance(strategies.fibonnacci_rebalance)
    |> rope.insert(2, rope.from_string("bbbbbbbbb"))
    |> rope.rebalance(strategies.fibonnacci_rebalance)
    |> rope.insert(10, rope.from_string("ccc"))
    |> rope.rebalance(strategies.fibonnacci_rebalance)

  rope
  |> rope.value()
  |> should.equal("aabbbbbbbbcccba")
}

pub fn rebalance_concat_sequence_more_than_two_test() {
  let rope = rope.from_string("")

  let rope =
    rope
    |> rope.insert(0, rope.from_string("aaaaa"))
    |> rope.rebalance(strategies.fibonnacci_rebalance)
    |> rope.insert(4, rope.from_string("bb"))
    |> rope.rebalance(strategies.fibonnacci_rebalance)
    |> rope.insert(0, rope.from_string("ccccccc"))
    |> rope.rebalance(strategies.fibonnacci_rebalance)

  rope
  |> rope.value()
  |> should.equal("cccccccaaaabba")
}
