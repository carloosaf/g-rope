import gleam/int
import gleam/list
import gleam/string
import glychee/benchmark
import gropes/rope
import gropes/strategies

pub fn benchmark_concat() {
  benchmark.run(
    [
      benchmark.Function(label: "rope.concat", callable: fn(test_data) {
        fn() { concat_ropes_benchmark(test_data) }
      }),
      benchmark.Function(label: "string.concat", callable: fn(test_data) {
        fn() { concat_strings_benchmark(test_data) }
      }),
      benchmark.Function(
        label: "rope.concat_and_merge",
        callable: fn(test_data) {
          fn() { concat_merge_ropes_benchmark(test_data) }
        },
      ),
    ],
    [
      benchmark.Data(label: "concat 100", data: generate_concat_input(100)),
      benchmark.Data(label: "concat 1000", data: generate_concat_input(1000)),
      benchmark.Data(label: "concat 10000", data: generate_concat_input(10_000)),
    ],
  )
}

fn generate_concat_input(length: Int) -> List(#(Bool, String, rope.Rope)) {
  list.range(1, length)
  |> list.fold([], fn(acc, _i) {
    let string = string.repeat("a", int.random(50))
    let input = #(int.random(2) == 1, string, rope.from_string(string))
    [input, ..acc]
  })
}

fn concat_ropes_benchmark(ropes: List(#(Bool, String, rope.Rope))) {
  let _result =
    list.fold(ropes, rope.from_string(""), fn(acc, input) {
      case input {
        #(True, _string, rope) -> rope.concat(acc, rope)
        #(False, _string, rope) -> rope.concat(rope, acc)
      }
    })
  Nil
}

fn concat_merge_ropes_benchmark(ropes: List(#(Bool, String, rope.Rope))) {
  let _result =
    list.fold(ropes, rope.from_string(""), fn(acc, input) {
      case input {
        #(True, _string, rope) -> rope.concat_and_merge(acc, rope)
        #(False, _string, rope) -> rope.concat_and_merge(rope, acc)
      }
    })
  Nil
}

fn concat_ropes_rebalance_benchmark(ropes: List(#(Bool, String, rope.Rope))) {
  list.fold(ropes, rope.from_string(""), fn(acc, input) {
    case input {
      #(True, _string, rope) -> rope.concat(acc, rope)
      #(False, _string, rope) -> rope.concat(rope, acc)
    }
    |> rope.rebalance(strategies.fibonnacci_rebalance)
  })
  Nil
}

fn concat_strings_benchmark(strings: List(#(Bool, String, rope.Rope))) {
  list.fold(strings, "", fn(acc, input) {
    case input {
      #(True, string, _rope) -> acc <> string
      #(False, string, _rope) -> string <> acc
    }
  })
  Nil
}
