import benchmarks/concat
import benchmarks/insert
import benchmarks/length
import benchmarks/value
import glychee/configuration

pub fn main() {
  configuration.initialize()
  configuration.set_pair(configuration.Warmup, 2)

  // concat.benchmark_concat()
  // insert.benchmark_insert()
  // value.benchmark_value()
  length.benchmark_length()
}
