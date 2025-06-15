import benchmarks/at_index
import benchmarks/concat
import benchmarks/insert
import benchmarks/length
import benchmarks/slice
import benchmarks/tools/eflambe
import benchmarks/value
import gleam/erlang/process
import gleam/io
import glychee/configuration

pub fn main() {
  configuration.initialize()
  configuration.set_pair(configuration.Warmup, 2)
  // concat.benchmark_concat()
  // insert.benchmark_insert()
  // value.benchmark_value()
  // length.benchmark_length()
  // slice.benchmark_slice()
  //at_index.benchmark_at_index()
  // eflambe.apply(
  //   #(at_index.at_index_ropes_rebalance_benchmark, [
  //     at_index.generate_at_index_input(100),
  //   ]),
  //   [eflambe.OutputFormat(eflambe.BrendanGregg)],
  // )

  process.spawn(fn() {
    process.sleep(1000)
    io.println("Hello World")
    at_index.at_index_ropes_rebalance_benchmark(
      at_index.generate_at_index_input(100),
    )
  })

  eflambe.capture(
    #("benchmarks@at_index", "at_index_ropes_rebalance_benchmark", 1),
    1,
    [eflambe.OutputFormat(eflambe.BrendanGregg)],
  )
  //at_index.benchmark_at_index()
}
