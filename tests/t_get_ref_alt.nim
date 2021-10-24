# vim: sts=2:ts=2:sw=2:et:tw=0

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


# suite "nibsv":
#   test "[parse_sv_allele]":
#     let
#       s = "T[chr1_KI270709v1_random:461["
#     var bnd = parse_sv_allele(s)
#     check bnd.pos == 461
#     check bnd.chrom == "chr1_KI270709v1_random"
#     check bnd.pre_bases == "T"
#   test "[generate_sv_sequences]":
#     var s: Sv
#     var ref_seq: string
#     var alt_seq: string
#     generate_sv_sequences(s, ref_seq, alt_seq)

