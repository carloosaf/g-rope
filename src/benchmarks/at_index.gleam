import gleam/list
import gleam/string
import glychee/benchmark
import gropes/rope
import gropes/strategies

pub type AtIndexBenchmarkInput {
  AtIndexBenchmarkInput(indexes: List(Int), string: String, rope: rope.Rope)
}

pub fn benchmark_at_index() {
  benchmark.run(
    [
      benchmark.Function(label: "rope.at_index", callable: fn(test_data) {
        fn() { at_index_ropes_benchmark(test_data) }
      }),
      benchmark.Function(
        label: "rope.rebalance |> rope.at_index",
        callable: fn(test_data) {
          fn() { at_index_ropes_rebalance_benchmark(test_data) }
        },
      ),
      benchmark.Function(label: "string.at_index", callable: fn(test_data) {
        fn() { at_index_strings_benchmark(test_data) }
      }),
    ],
    [
      benchmark.Data(label: "concat 100", data: generate_at_index_input(100)),
      benchmark.Data(label: "concat 1000", data: generate_at_index_input(1000)),
      benchmark.Data(
        label: "concat 10000",
        data: generate_at_index_input(10_000),
      ),
    ],
  )
}

pub fn generate_at_index_input(length: Int) -> AtIndexBenchmarkInput {
  let string = string.repeat("a", length)

  let rope =
    list.range(0, length)
    |> list.fold(rope.from_string(""), fn(acc, _i) {
      rope.concat(acc, rope.from_string("a"))
    })

  let indexes = list.range(0, length)

  AtIndexBenchmarkInput(indexes, string, rope)
}

fn at_index_ropes_benchmark(input: AtIndexBenchmarkInput) {
  let _result =
    list.each(input.indexes, fn(index) { rope.at_index(input.rope, index) })
  Nil
}

pub fn at_index_ropes_rebalance_benchmark(input: AtIndexBenchmarkInput) {
  let rope = rope.rebalance(input.rope, strategies.fibonnacci_rebalance)

  let _result =
    list.each(input.indexes, fn(index) { rope.at_index(rope, index) })
  Nil
}

fn at_index_strings_benchmark(input: AtIndexBenchmarkInput) {
  let _result =
    list.each(input.indexes, fn(index) { string.slice(input.string, index, 1) })
  Nil
}
