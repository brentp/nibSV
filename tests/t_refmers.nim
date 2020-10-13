# vim: sw=2 ts=2 sts=2 tw=0 et:
from nibpkg/refmers import nil
from nibpkg/svidx import nil
import unittest
import json
import os

let original = """
{
  "3": {
    "refCount": 0,
    "altCount": 0,
    "svs": [
    ]
  },
  "4": {
    "refCount": 0,
    "altCount": 0,
    "svs": [
    ]
  }
}
"""
# 4 -> ACA forward
# 3 -> ATT reverse

let expected = """
{
  "3": {
    "refCount": 1,
    "altCount": 0,
    "svs": [
    ]
  },
  "4": {
    "refCount": 1,
    "altCount": 0,
    "svs": [
    ]
  }
}
"""

let original_spaced = """
{
  "2244": {
    "refCount": 0,
    "altCount": 0,
    "svs": [
    ]
  },
  "3789": {
    "refCount": 0,
    "altCount": 0,
    "svs": [
    ]
  }
}
"""
let expected_spaced = """
{
  "2244": {
    "refCount": 1,
    "altCount": 0,
    "svs": [
    ]
  },
  "3789": {
    "refCount": 1,
    "altCount": 0,
    "svs": [
    ]
  }
}
"""

suite "refmers":
  test "updateSvIdx":
    var idx = svidx.loadIdxFromJson(original)
    #let path = os.absolutePath("tests/foo.fasta")
    # foo.fasta contains "GATTACA", which matches 2 3-mers from our index:
    #  "ACA" (==4 forward)
    #  "ATT" (==3 reversed)
    let
      fn = "foo.fasta"
      kmer_size = 3
      space = 0
    refmers.updateSvIdx(fn, idx, kmer_size, 0, space=space)
    #echo "result:", svidx.dumpIdxtoJson(idx)
    var result = svidx.dumpIdxtoJson(idx)
    check json.parseJson(result) == json.parseJson(expected)
  test "updateSvIdx_spaced":
    var idx = svidx.loadIdxFromJson(original_spaced)
    #let path = os.absolutePath("tests/foo.fasta")
    # foo.fasta contains "GATTACA", which matches 2 3-mers:
    #  "GATACA" (==2244 forward)
    #  "GATACA" (==3789 reversed)
    let
      fn = "foo.fasta"
      kmer_size = 3
      space = 1
    refmers.updateSvIdx(fn, idx, kmer_size, 0, space=space)
    #echo "result:", svidx.dumpIdxtoJson(idx)
    var result = svidx.dumpIdxtoJson(idx)
    check json.parseJson(result) == json.parseJson(expected_spaced)
