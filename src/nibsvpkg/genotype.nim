# this code is copied from svtyper which has the license:
#[

The MIT License (MIT)

Copyright (c) 2014 Colby Chiang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]#

import math
import algorithm
import strformat

proc log_choose(n:uint, k:uint): float64 =
  result = 0.0
  var k = k

  if k * 2 > n:
    k = n - k
  var n = n.float64

  for d in 1 ..< k+1:
    result += log10(n)
    result -= log10(d.float64)
    n -= 1

type GL* = object
  hom_ref*: float64
  het*: float64
  hom_alt*: float64
  
proc genotype*(g:GL): tuple[gt:int, GQ:int] =
  ## 0/1/2/-1 for hom-ref/het/hom-alt/unknown
  var vals = [g.hom_ref, g.het, g.hom_alt]
  if g.hom_ref == 0 and g.het == 0 and g.hom_alt == 0:
    return (-1, 0)
  if g.het > g.hom_ref:
    result.gt = 1
  if g.hom_alt > vals[result.gt]:
    result.gt = 2

  vals.sort(order=SortOrder.Descending)
  result.GQ = int(0.5 + min(200, -10 * (vals[1] - vals[0])))


proc `$`*(g:GL): string =
  var geno = g.genotype
  var gt = ["0/0", "0/1", "1/1", "./."][if geno.gt == -1: 3 else: geno.gt]
  return &"{gt}:{geno.GQ}:{g.hom_ref:.3g},{g.het:.3g},{g.hom_alt:.3g}"

proc bayes_gt*(refc:int, altc:int, priors:array[3, float64]): GL =
  if refc < 0 or altc < 0: return

  let log_combo = log_choose(refc.uint + altc.uint, altc.uint)
  let refc = refc.float64
  let altc = altc.float64

  result.hom_ref = log_combo + altc * log10(priors[0]) + refc * log10(1 - priors[0])
  result.het     = log_combo + altc * log10(priors[1]) + refc * log10(1 - priors[1])
  result.hom_alt = log_combo + altc * log10(priors[2]) + refc * log10(1 - priors[2])


when isMainModule:

  import unittest


  suite "genotyping suite":

    test "that basic genotyping works":
      let priors = [1e-3, 0.5, 0.9]

      var gl = bayes_gt(10, 0, priors)
      check gl.genotype.gt == 0
      check gl.genotype.GQ > 20

      gl = bayes_gt(10, 10, priors)
      check gl.genotype.gt == 1
      check gl.genotype.GQ > 20

      gl = bayes_gt(0, 10, priors)
      check gl.genotype.gt == 2
      check gl.genotype.GQ > 20

      gl = bayes_gt(0, 0, priors)
      check gl.genotype.gt == -1
      check gl.genotype.GQ == 0
