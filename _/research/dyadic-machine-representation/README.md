# Dyadic machine-representation evidence

This note records external precedent relevant to issues #61 and #62. It does not change the accepted shader subset.

## External evidence

### HoTT Book

`HoTT/book@578b85cc8d586b1677ec4335148adeb443057d24` names the dyadic rationals `n / 2^k` as an example of an approximate field and says an approximate field is more suitable for constructive mathematics implemented on a computer.

That is mathematical motivation, not a GLSL representation specification.

### Lean 4

`leanprover/lean4@2c2bdd9630a7a6c51d7620d5efefcdba104f38f3` implements dyadics in core as zero or an odd integer numerator with an integer binary exponent. Construction removes trailing factors of two; addition aligns exponents with shifts; multiplication multiplies numerators and adds exponents.

For non-dyadic division, Lean provides `invAtPrec` and `divAtPrec`: the precision request is explicit and the approximation is bounded rather than disguised as an exact rational operation.

### ConwayHs

`ming-t18/ConwayHs@d80a4ced80527c28306c781b60ae560975ab394a`, `src/Data/Conway/Dyadic.hs`, independently uses an arbitrary-precision pair `(n,p)` representing `n / 2^p` and normalizes by removing factors of two. Its repository declares no license at this revision, so treat it as inspectable precedent, not vendored source.

## Shader consequence

Finite IEEE binary floating values are themselves dyadic rationals, but the current shader representation treats them as floating scalars, not as exact rational objects with preserved semantic numerator/exponent identity.

Issue #62 should therefore be read literally: when the *meaning* is an exact dyadic or triadic scale, retain that identity through the checked representation as far as practical. Conversion to GLSL Float16/Float32 is a lowering/approximation boundary.

Issue #61 remains the acceptance rule for width: a wider float is justified only when the narrower representation creates a material error at the declared mathematical/visible boundary.

## Cross-repository source archive

The detailed notes and legally mirrorable upstream snapshots are kept in `isomorphisms/idric-arm-thumb` under `_/dyadic-rationals/`. This shader note intentionally avoids duplicating those mirrors.
