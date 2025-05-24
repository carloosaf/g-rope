import benchmarks/at_index
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
  concat.benchmark_concat()
  //insert.benchmark_insert()
  //value.benchmark_value()
  //length.benchmark_length()
  //slice.benchmark_slice()
  //at_index.benchmark_at_index()
}
