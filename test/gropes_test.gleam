import gleam/result
import gleam/string
import gleeunit
import gleeunit/should
import rope

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
