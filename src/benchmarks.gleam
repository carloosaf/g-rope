import gleam/int
import gleam/io
import gleam/list
import gleam/string
import gleamy/bench
import gropes/rope

pub fn main() {
  bench.run(
    [
      bench.Input("10_insert  ", generate_insert_input(10)),
      bench.Input("100_insert ", generate_insert_input(100)),
      bench.Input("1000_insert", generate_insert_input(1000)),
    ],
    [
      bench.Function("insert_ropes_benchmark  ", insert_ropes_benchmark),
      bench.Function("insert_strings_benchmark", insert_strings_benchmark),
    ],
    [bench.Warmup(10)],
  )
  |> bench.table([bench.IPS, bench.Mean, bench.Max, bench.Min])
  |> io.println()
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
      string.repeat("a", int.random(100)),
    )
    [input, ..acc]
  })
  |> list.reverse()
}

fn insert_ropes_benchmark(strings: List(#(Int, String))) {
  let rope = rope.from_string("")

  list.fold(strings, rope, fn(acc, input) {
    let #(index, string) = input
    rope.insert(acc, index, rope.from_string(string))
  })
  Nil
  // io.debug(rope.value(result))
}

fn string_insert(original: String, index: Int, string: String) {
  let left = string.slice(original, 0, index)
  let right = string.slice(original, index, string.length(original))
  left <> string <> right
}

fn insert_strings_benchmark(strings: List(#(Int, String))) {
  list.fold(strings, "", fn(acc, input) {
    let #(index, string) = input
    string_insert(acc, index, string)
  })
  Nil
  // io.debug(result)
}
