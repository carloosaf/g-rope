import benchmarks/concat
import benchmarks/insert
import glychee/configuration

pub fn main() {
  configuration.initialize()
  configuration.set_pair(configuration.Warmup, 2)

  // concat.benchmark_concat()
  insert.benchmark_insert()
}
