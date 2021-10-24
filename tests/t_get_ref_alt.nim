# vim: sts=2:ts=2:sw=2:et:tw=0
import nibsv
import strutils
import unittest

suite "nibsv":
  test "[parse_sv_allele]":
    let
      s = "T[chr1_KI270709v1_random:461["
    var bnd = parse_sv_allele(s)
    check bnd.pos == 461
    check bnd.chrom == "chr1_KI270709v1_random"
    check bnd.pre_bases == "T"
  test "[generate_sv_sequences]":
    var s: Sv
    var ref_seq: string
    var alt_seq: string
    generate_sv_sequences(s, ref_seq, alt_seq)
    
