import gleam/list
import gleam/string
import glychee/benchmark
import gropes/rope
import gropes/strategies

pub type LengthBenchmarkData {
  LengthBenchmarkData(string: String, rope: rope.Rope)
}

pub fn benchmark_length() {
  benchmark.run(
    [
      benchmark.Function(label: "rope.length", callable: fn(test_data) {
        fn() { benchmark_rope_length(test_data) }
      }),
      benchmark.Function(
        label: "rope.rebalance |> rope.length",
        callable: fn(test_data) {
          fn() { benchmark_rope_length_rebalance(test_data) }
        },
      ),
      benchmark.Function(label: "string.length", callable: fn(test_data) {
        fn() { benchmark_string_length(test_data) }
      }),
    ],
    [
      benchmark.Data(label: "value 100", data: generate_length_input(100)),
      benchmark.Data(label: "value 1000", data: generate_length_input(1000)),
      benchmark.Data(label: "value 10000", data: generate_length_input(10_000)),
    ],
  )
}

fn generate_length_input(length: Int) -> LengthBenchmarkData {
  let rope =
    list.range(0, length)
    |> list.fold(rope.from_string(""), fn(acc, _i) {
      rope.concat(acc, rope.from_string("a"))
    })

  LengthBenchmarkData(string: string.repeat("a", length), rope: rope)
}

fn benchmark_rope_length(input: LengthBenchmarkData) {
  rope.length(input.rope)
}

fn benchmark_rope_length_rebalance(input: LengthBenchmarkData) {
  input.rope
  |> rope.rebalance(strategies.fibonnacci_rebalance)
  |> rope.length()
}

fn benchmark_string_length(input: LengthBenchmarkData) {
  string.length(input.string)
}
