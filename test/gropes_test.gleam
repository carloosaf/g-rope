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
