import gleam/int
import gleam/io
import gleam/list
import gleam/string
import gleamy/bench
import gropes/rope
import gropes/strategies

pub fn main() {
  benchmark_insert()
  benchmark_concat()
}

fn benchmark_insert() {
  bench.run(
    [
      bench.Input("10_insert  ", generate_insert_input(10)),
      bench.Input("100_insert ", generate_insert_input(100)),
      bench.Input("1000_insert", generate_insert_input(1000)),
    ],
    [
      bench.Function("insert_ropes_benchmark          ", insert_ropes_benchmark),
      bench.Function("insert_ropes_rebalance_benchmark",
        insert_ropes_rebalance_benchmark,
      ),
      bench.Function("insert_strings_benchmark        ", insert_strings_benchmark),
    ],
    [bench.Warmup(10)],
  )
  |> bench.table([bench.IPS, bench.Mean, bench.Max, bench.Min])
  |> io.println()
}

fn benchmark_concat() {
  bench.run(
    [
      bench.Input("10_concat  ", generate_concat_input(10)),
      bench.Input("100_concat ", generate_concat_input(100)),
      bench.Input("1000_concat", generate_concat_input(1000)),
      bench.Input("10000_concat", generate_concat_input(10_000)),
    ],
    [
      bench.Function("concat_ropes_benchmark          ", concat_ropes_benchmark),
      bench.Function("concat_ropes_rebalance_benchmark",
        concat_ropes_rebalance_benchmark,
      ),
      bench.Function("concat_strings_benchmark        ", concat_strings_benchmark),
    ],
    [bench.Warmup(10)],
  )
  |> bench.table([bench.IPS, bench.Mean, bench.Max, bench.Min, bench.SD])
  |> io.println()
}

fn generate_concat_input(length: Int) -> List(#(Bool, String)) {
  list.range(1, length)
  |> list.fold([], fn(acc, _i) {
    let input = #(int.random(2) == 1, string.repeat("", int.random(100)))
    [input, ..acc]
  })
}

fn concat_ropes_benchmark(ropes: List(#(Bool, String))) {
  list.fold(ropes, rope.from_string(""), fn(acc, input) {
    case input {
      #(True, rope) -> rope.concat(acc, rope.from_string(rope))
      #(False, rope) -> rope.concat(rope.from_string(rope), acc)
    }
  })
  Nil
}

fn concat_ropes_rebalance_benchmark(ropes: List(#(Bool, String))) {
  list.fold(ropes, rope.from_string(""), fn(acc, input) {
    case input {
      #(True, rope) -> rope.concat(acc, rope.from_string(rope))
      #(False, rope) -> rope.concat(rope.from_string(rope), acc)
    }
    |> rope.rebalance(strategies.fibonnacci_rebalance)
  })
  Nil
}

fn concat_strings_benchmark(strings: List(#(Bool, String))) {
  list.fold(strings, "", fn(acc, input) {
    case input {
      #(True, string) -> acc <> string
      #(False, string) -> string <> acc
    }
  })
  Nil
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
}

fn insert_ropes_rebalance_benchmark(strings: List(#(Int, String))) {
  let rope = rope.from_string("")

  list.fold(strings, rope, fn(acc, input) {
    let #(index, string) = input
    acc
    |> rope.insert(index, rope.from_string(string))
  })
  Nil
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
}
