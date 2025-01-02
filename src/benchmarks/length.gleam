import gleam/list
import gleam/string
import glychee/benchmark
import gropes/rope

pub fn benchmark_length() {
  benchmark.run(
    [
      benchmark.Function(label: "rope.length", callable: fn(test_data) {
        fn() { benchmark_rope_length(test_data) }
      }),
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

fn generate_length_input(length: Int) -> #(String, rope.Rope) {
  let rope =
    list.range(0, length)
    |> list.fold(rope.from_string(""), fn(acc, _i) {
      rope.concat(acc, rope.from_string("a"))
    })

  #(string.repeat("a", length), rope)
}

fn benchmark_rope_length(input: #(String, rope.Rope)) {
  rope.length(input.1)
}

fn benchmark_string_length(input: #(String, rope.Rope)) {
  string.length(input.0)
}
