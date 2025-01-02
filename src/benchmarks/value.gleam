import gleam/list
import glychee/benchmark
import gropes/rope

pub fn benchmark_value() {
  benchmark.run(
    [
      benchmark.Function(label: "rope.value", callable: fn(test_data) {
        fn() { rope.value(test_data) }
      }),
    ],
    [
      benchmark.Data(label: "value 100", data: generate_value_input(100)),
      benchmark.Data(label: "value 1000", data: generate_value_input(1000)),
      benchmark.Data(label: "value 10000", data: generate_value_input(10_000)),
    ],
  )
}

fn generate_value_input(length: Int) -> rope.Rope {
  list.range(0, length)
  |> list.fold(rope.from_string(""), fn(acc, _i) {
    rope.concat(acc, rope.from_string("a"))
  })
}
