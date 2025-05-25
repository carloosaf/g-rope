# g-rope ⭐🪢

Gropes is an implementatation of the rope data structure in Gleam.

## Why did I make this?

This is a mainly a **learning exercise**, i found the rope data structure to be a simple project to
learn the basics of Gleam. This means **the support for this project may be limited**, but I hope
that it will be useful to someone.

## Benchmarks

You can find benchmarks comparing all the operations in the docs folder, follow the links below.

- [concat](./docs/concat_results.txt)
- [value](./docs/value_results.txt)
- [length](./docs/length_results.txt)
- [slice](./docs/slice_results.txt)
- [at_index](./docs/at_index_results.txt)
- [insert](./docs/insert_results.txt)

> [!IMPORTANT]  
> All benchmarks compare string and ropes directly, ignoring the cost of creating the rope itself. I've found this to be a problem in situation where the rope is very long. If that is the case, many of the pros of using ropes may be counteracted.


## Objectives

- [x] Implement the rope data structure and its basic operations
  - [x] `from_string`
  - [x] `concat`
  - [x] `value`
  - [x] `length`
  - [x] `slice`
  - [x] `at_index`
  - [x] `insert`
  - [x] `rebalance`
- [x] Benchmark the implementation against the standard library String
  - [x] Compare implemented operations with their string equivalent
  - [ ] Compare different rebalancing strategies (TODO: Currently we only support one rebalancing strategy)
