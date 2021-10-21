import unittest
import nibsv
import hts/fai
import strformat
import strutils
import os

const HERE = currentSourcePath().parentDir()

suite "ref and alt extraction":

  test "simple DEL":

    var fai:Fai
    check open(fai, &"{HERE}/foo.fasta")

    var sv = SV(chrom: "foo", pos: 32, k: 25, space: @[0'u8], ref_allele: "A", alt_allele: "ATTT")

    let res = sv.generate_ref_alt(fai, overlap=6)
    check res.ref_sequence.len == sv.space.len
    check res.ref_sequence[0][0..12] == res.alt_sequence[0][0..12]
    check sv.alt_allele[1..^1] in res.alt_sequence[0]




