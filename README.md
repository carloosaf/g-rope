# gropes ⭐🪢

[![Package Version](https://img.shields.io/hexpm/v/gropes)](https://hex.pm/packages/gropes)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gropes/)

Gropes is an implementatation of the rope data structure in Gleam.

## Why did I make this?

This is a mainly a **learning exercise**, i found the rope data structure to be a simple project to 
learn the basics of Gleam. This means **the support for this project may be limited**, but I hope 
that it will be useful to someone.

## Objectives

- [ ] Implement the rope data structure and its basic operations
  - [x] `from_string`
  - [x] `concat`
  - [x] `value`
  - [x] `length`
  - [x] `slice`
  - [ ] `an_index`
  - [ ] `insert`
  - [ ] `rebalance`
- [ ] Benchmark the implementation against the standard library String
  - [ ] Compare different rebalancing strategies
  - [ ] Determine whether Ropes are worth the effort in a language without manual memory management
  - [ ] **Optionally:** Create a cool 🤩 visualization of the performance of different rebalancing strategies
