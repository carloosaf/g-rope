import gleam/int
import gleam/list
import gleam/string
import glychee/benchmark
import gropes/rope
import gropes/strategies

pub type SliceBenchmarkInput {
  SliceBenchmarkInput(
    string: String,
    rope: rope.Rope,
    slices: List(#(Int, Int)),
  )
}

pub fn benchmark_slice() {
  benchmark.run(
    [
      benchmark.Function(label: "string.slice", callable: fn(test_data) {
        fn() { slice_string_benchmark(test_data) }
      }),
      benchmark.Function(label: "rope.slice", callable: fn(test_data) {
        fn() { slice_rope_benchmark(test_data) }
      }),
      benchmark.Function(
        label: "rope.rebalance |> rope.slice",
        callable: fn(test_data) {
          fn() { slice_rope_rebalance_benchmark(test_data) }
        },
      ),
    ],
    [
      benchmark.Data(
        label: "slice text of length 100, take 100 (rope with 10 nodes)",
        data: generate_slice_input(100, 10, 100),
      ),
      benchmark.Data(
        label: "slice text of length 1000, take 100 (rope with 100 nodes)",
        data: generate_slice_input(1000, 100, 100),
      ),
      benchmark.Data(
        label: "slice text of length 1000, take 100 (rope with 10 nodes)",
        data: generate_slice_input(1000, 10, 100),
      ),
    ],
  )
}

pub fn generate_slice_input(
  rope_length: Int,
  nodes: Int,
  slices: Int,
) -> SliceBenchmarkInput {
  let string = string.repeat("a", rope_length)

  let part_length = rope_length / nodes
  let rope =
    list.range(0, nodes)
    |> list.fold(rope.from_string(""), fn(acc, _i) {
      let part = string.repeat("a", part_length)
      let concat_end = int.random(2) % 2 == 0

      case concat_end {
        True -> rope.concat(acc, rope.from_string(part))
        False -> rope.concat(rope.from_string(part), acc)
      }
    })

  let slices =
    list.range(0, slices)
    |> list.fold(#([]), fn(acc, _i) {
      let size = int.random(rope_length)
      let from = int.random(rope_length - size)

      #([#(from, size), ..acc.0])
    })

  SliceBenchmarkInput(string, rope, slices.0)
}

fn slice_rope_benchmark(input: SliceBenchmarkInput) {
  let SliceBenchmarkInput(_string, rope, slices) = input
  let _result =
    slices
    |> list.each(fn(slice) { rope.slice(rope, slice.0, slice.1) })

  Nil
}

fn slice_rope_rebalance_benchmark(input: SliceBenchmarkInput) {
  let SliceBenchmarkInput(_string, rope, slices) = input
  let _result =
    slices
    |> list.each(fn(slice) {
      rope
      |> rope.rebalance(strategies.fibonnacci_rebalance)
      |> rope.slice(slice.0, slice.1)
    })

  Nil
}

fn slice_string_benchmark(input: SliceBenchmarkInput) {
  let SliceBenchmarkInput(string, _rope, slices) = input
  let _result =
    slices
    |> list.each(fn(slice) { string.slice(string, slice.0, slice.1) })

  Nil
}
