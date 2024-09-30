# gropes ⭐🪢

[![Package Version](https://img.shields.io/hexpm/v/gropes)](https://hex.pm/packages/gropes)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gropes/)

Gropes is an implementatation of the rope data structure in Gleam.

## Why did I make this?

This is a mainly a **learning exercise**, i found the rope data structure to be a simple project to
learn the basics of Gleam. This means **the support for this project may be limited**, but I hope
that it will be useful to someone.

## Benchmarks

The following benchmarks were executed on a Lenovo Legion y540 laptot with a 2.6 GHz Intel i7-9750H CPU with 16 GB of RAM

### `insert`



```
Input               	Function            	                       IPS	          Mean	           Max	           Min
10_insert           	insert_ropes_benchmark          	   170486.3641	        0.0058	        6.2094	        0.0041
10_insert           	insert_ropes_rebalance_benchmark	    17495.2336	        0.0571	        1.1447	        0.0435
10_insert           	insert_strings_benchmark        	    76909.9734	        0.0130	        1.0383	        0.0105

100_insert          	insert_ropes_benchmark          	    11338.3615	        0.0881	       11.5688	        0.0715
100_insert          	insert_ropes_rebalance_benchmark	       87.4365	       11.4368	       15.7651	       10.5360
100_insert          	insert_strings_benchmark        	     1076.7065	        0.9287	        1.7565	        0.8377

1000_insert         	insert_ropes_benchmark          	      852.2954	        1.1733	        2.6165	        1.0175
1000_insert         	insert_ropes_rebalance_benchmark	        0.0000	        0.0000	        0.0000	        0.0000
1000_insert         	insert_strings_benchmark        	       14.3841	       69.5208	       73.0706	       65.9439
```

### `concat`

```
Input               	Function            	                      IPS	          Mean	           Max	           Min	            SD
10_concat           	concat_ropes_benchmark          	  1064042.5877	        0.0009	       17.7445	        0.0005	        0.0188
10_concat           	concat_ropes_rebalance_benchmark	   192456.8437	        0.0051	        3.6005	        0.0035	        0.0375
10_concat           	concat_strings_benchmark        	  2072544.5499	        0.0004	       89.4833	        0.0003	        0.0795

100_concat          	concat_ropes_benchmark          	    56765.8180	        0.0176	        3.3477	        0.0055	        0.0608
100_concat          	concat_ropes_rebalance_benchmark	    12594.2401	        0.0794	        6.2457	        0.0596	        0.2356
100_concat          	concat_strings_benchmark        	   321317.2761	        0.0031	       10.8688	        0.0025	        0.0224

1000_concat         	concat_ropes_benchmark          	     6732.5600	        0.1485	        7.0960	        0.1200	        0.1859
1000_concat         	concat_ropes_rebalance_benchmark	     1246.5506	        0.8022	       11.4575	        0.6071	        0.8726
1000_concat         	concat_strings_benchmark        	    35333.2327	        0.0283	        0.2310	        0.0257	        0.0057

10000_concat        	concat_ropes_benchmark          	      651.5036	        1.5349	        7.1123	        1.2238	        0.6990
10000_concat        	concat_ropes_rebalance_benchmark	      127.7558	        7.8274	       15.0101	        6.1752	        2.3433
10000_concat        	concat_strings_benchmark        	     3516.1306	        0.2844	        0.6239	        0.2721	        0.0237
```

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
- [-] Benchmark the implementation against the standard library String
  - [ ] Compare different rebalancing strategies
  - [ ] Determine whether Ropes are worth the effort in a language without manual memory management
  - [ ] **Optionally:** Create a cool 🤩 visualization of the performance of different rebalancing strategies
