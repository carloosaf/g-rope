import gleam/int
import gleam/list
import gleam/string
import glychee/benchmark
import gropes/rope
import gropes/strategies

pub type ConcatBenchmarkInput {
  ConcatBenchmarkInput(concat_left: Bool, string: String, rope: rope.Rope)
}

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
      //      benchmark.Function(
    //        label: "rope.concat_and_merge |> rope.rebalance",
    //        callable: fn(test_data) {
    //          fn() { concat_merge_ropes_rebalance_benchmark(test_data) }
    //       },
    //    ),
    //   benchmark.Function(
    //    label: "rope.concat |> rope.rebalance",
    //  callable: fn(test_data) {
    //     fn() { concat_ropes_rebalance_benchmark(test_data) }
    //        },
    //      ),
    ],
    [
      //      benchmark.Data(label: "concat 100", data: generate_concat_input(100)),
      //     benchmark.Data(label: "concat 1000", data: generate_concat_input(1000)),
      benchmark.Data(label: "concat 10000", data: generate_concat_input(10_000)),
    ],
  )
}

fn generate_concat_input(length: Int) -> List(ConcatBenchmarkInput) {
  list.range(1, length)
  |> list.fold([], fn(acc, _i) {
    let string = string.repeat("a", int.random(50))
    let input =
      ConcatBenchmarkInput(int.random(2) == 1, string, rope.from_string(string))
    [input, ..acc]
  })
}

fn concat_ropes_benchmark(ropes: List(ConcatBenchmarkInput)) {
  let _result =
    list.fold(ropes, rope.from_string(""), fn(acc, input) {
      case input {
        ConcatBenchmarkInput(True, _string, rope) -> rope.concat(acc, rope)
        ConcatBenchmarkInput(False, _string, rope) -> rope.concat(rope, acc)
      }
    })
  Nil
}

fn concat_merge_ropes_benchmark(ropes: List(ConcatBenchmarkInput)) {
  let _result =
    list.fold(ropes, rope.from_string(""), fn(acc, input) {
      case input {
        ConcatBenchmarkInput(True, _string, rope) ->
          rope.concat_and_merge(acc, rope)
        ConcatBenchmarkInput(False, _string, rope) ->
          rope.concat_and_merge(rope, acc)
      }
    })
  Nil
}

fn concat_ropes_rebalance_benchmark(ropes: List(ConcatBenchmarkInput)) {
  list.fold(ropes, rope.from_string(""), fn(acc, input) {
    case input {
      ConcatBenchmarkInput(True, _string, rope) -> rope.concat(acc, rope)
      ConcatBenchmarkInput(False, _string, rope) -> rope.concat(rope, acc)
    }
    |> rope.rebalance(strategies.fibonnacci_rebalance)
  })
  Nil
}

fn concat_merge_ropes_rebalance_benchmark(ropes: List(ConcatBenchmarkInput)) {
  list.fold(ropes, rope.from_string(""), fn(acc, input) {
    case input {
      ConcatBenchmarkInput(True, _string, rope) ->
        rope.concat_and_merge(acc, rope)
      ConcatBenchmarkInput(False, _string, rope) ->
        rope.concat_and_merge(rope, acc)
    }
    |> rope.rebalance(strategies.fibonnacci_rebalance)
  })
  Nil
}

fn concat_strings_benchmark(strings: List(ConcatBenchmarkInput)) {
  list.fold(strings, "", fn(acc, input) {
    case input {
      ConcatBenchmarkInput(True, string, _rope) -> acc <> string
      ConcatBenchmarkInput(False, string, _rope) -> string <> acc
    }
  })
  Nil
}
