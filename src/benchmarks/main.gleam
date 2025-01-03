import benchmarks/concat
import benchmarks/insert
import benchmarks/length
import benchmarks/slice
import benchmarks/value
import gleam/io
import glychee/configuration

pub fn main() {
  configuration.initialize()
  configuration.set_pair(configuration.Warmup, 2)
  io.debug(slice.generate_slice_input(100, 10, 100))

  // concat.benchmark_concat()
  // insert.benchmark_insert()
  // value.benchmark_value()
  // length.benchmark_length()
  slice.benchmark_slice()
}
