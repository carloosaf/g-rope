import gleam/int
import gleam/list
import gleam/string
import glychee/benchmark
import gropes/rope
import gropes/strategies

pub fn benchmark_insert() {
  benchmark.run(
    [
      benchmark.Function(label: "rope.insert", callable: fn(test_data) {
        fn() { insert_ropes_benchmark(test_data) }
      }),
      benchmark.Function(label: "string.insert", callable: fn(test_data) {
        fn() { insert_strings_benchmark(test_data) }
      }),
    ],
    [
      benchmark.Data(label: "insert 100", data: generate_insert_input(100)),
      benchmark.Data(label: "insert 1000", data: generate_insert_input(1000)),
      benchmark.Data(label: "insert 10000", data: generate_insert_input(10_000)),
    ],
  )
}

fn int_to_string(int: Int) -> String {
  case int {
    1 -> "1"
    2 -> "2"
    3 -> "3"
    4 -> "4"
    5 -> "5"
    6 -> "6"
    7 -> "7"
    8 -> "8"
    9 -> "9"
    0 -> "0"
    _ -> ""
  }
}

fn generate_insert_input(length: Int) -> List(#(Int, String)) {
  list.range(1, length)
  |> list.fold([], fn(acc, _i) {
    let input = #(
      acc
        |> list.map(fn(input) {
          let #(_, string) = input
          string
        })
        |> string.join("")
        |> string.length()
        |> int.random(),
      string.repeat(int_to_string(int.random(10)), int.random(10)),
    )
    [input, ..acc]
  })
  |> list.reverse()
}

fn insert_ropes_benchmark(strings: List(#(Int, String))) {
  let rope = rope.from_string("")
  let _result =
    list.fold(strings, rope, fn(acc, input) {
      let #(index, string) = input
      rope.insert(acc, index, rope.from_string(string))
    })

  Nil
}

fn insert_ropes_rebalance_benchmark(strings: List(#(Int, String))) {
  let rope = rope.from_string("")

  let _result =
    list.fold(strings, rope, fn(acc, input) {
      let #(index, string) = input
      let acc =
        acc
        |> rope.insert(index, rope.from_string(string))
        |> rope.rebalance(strategies.fibonnacci_rebalance)

      acc
    })

  Nil
}

fn string_insert(original: String, index: Int, string: String) {
  let left = string.slice(original, 0, index)
  let right = string.slice(original, index, string.length(original))
  left <> string <> right
}

fn insert_strings_benchmark(strings: List(#(Int, String))) {
  let _result =
    list.fold(strings, "", fn(acc, input) {
      let #(index, string) = input
      string_insert(acc, index, string)
    })

  Nil
}
