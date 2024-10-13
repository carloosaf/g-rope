import gleam/int
import gleam/io
import gleam/list
import gleam/string
import gleamy/bench
import gropes/rope
import gropes/strategies

pub fn main() {
  //let input = generate_concat_input(100)
  // io.debug(input)

  //concat_merge_ropes_benchmark(input)
  //concat_ropes_benchmark(input)
  // insert_ropes_rebalance_benchmark(input)
  // insert_ropes_benchmark(input)
  // insert_strings_benchmark(input)
  //benchmark_insert()
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
      bench.Function(
        "insert_ropes_rebalance_benchmark",
        insert_ropes_rebalance_benchmark,
      ),
      bench.Function(
        "insert_strings_benchmark        ",
        insert_strings_benchmark,
      ),
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
      // bench.Input("10000_concat", generate_concat_input(10_000)),
    ],
    [
      bench.Function("concat_ropes_benchmark          ", concat_ropes_benchmark),
      bench.Function(
        "concat_merge_ropes_benchmark          ",
        concat_merge_ropes_benchmark,
      ),
      bench.Function(
        "concat_ropes_rebalance_benchmark",
        concat_ropes_rebalance_benchmark,
      ),
      bench.Function(
        "concat_strings_benchmark        ",
        concat_strings_benchmark,
      ),
    ],
    [bench.Warmup(10)],
  )
  |> bench.table([bench.IPS, bench.Mean, bench.Max, bench.Min, bench.SD])
  |> io.println()
}

fn generate_concat_input(length: Int) -> List(#(Bool, String)) {
  list.range(1, length)
  |> list.fold([], fn(acc, _i) {
    let input = #(int.random(2) == 1, string.repeat("a", int.random(50)))
    [input, ..acc]
  })
}

fn concat_ropes_benchmark(ropes: List(#(Bool, String))) {
  let result =
    list.fold(ropes, rope.from_string(""), fn(acc, input) {
      case input {
        #(True, rope) -> rope.concat(acc, rope.from_string(rope))
        #(False, rope) -> rope.concat(rope.from_string(rope), acc)
      }
    })

  //io.debug(rope.depth(result))
  Nil
}

fn concat_merge_ropes_benchmark(ropes: List(#(Bool, String))) {
  let result =
    list.fold(ropes, rope.from_string(""), fn(acc, input) {
      case input {
        #(True, rope) -> rope.concat_and_merge(acc, rope.from_string(rope))
        #(False, rope) -> rope.concat_and_merge(rope.from_string(rope), acc)
      }
    })

  //io.debug(rope.depth(result))
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
  let result =
    list.fold(strings, rope, fn(acc, input) {
      let #(index, string) = input
      rope.insert(acc, index, rope.from_string(string))
    })

  Nil
}

fn insert_ropes_rebalance_benchmark(strings: List(#(Int, String))) {
  let rope = rope.from_string("")

  let result =
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
  let result =
    list.fold(strings, "", fn(acc, input) {
      let #(index, string) = input
      string_insert(acc, index, string)
    })

  Nil
}
