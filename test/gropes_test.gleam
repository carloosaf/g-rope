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
