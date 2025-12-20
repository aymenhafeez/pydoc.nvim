Python 3.14.2
*cmath.pyx*                                   Last change: 2025 Dec 20

"cmath" — Mathematical functions for complex numbers
****************************************************

======================================================================

This module provides access to mathematical functions for complex
numbers.  The functions in this module accept integers, floating-point
numbers or complex numbers as arguments. They will also accept any
Python object that has either a "__complex__()" or a "__float__()"
method: these methods are used to convert the object to a complex or
floating-point number, respectively, and the function is then applied
to the result of the conversion.

Note:

  For functions involving branch cuts, we have the problem of deciding
  how to define those functions on the cut itself. Following Kahan’s
  “Branch cuts for complex elementary functions” paper, as well as
  Annex G of C99 and later C standards, we use the sign of zero to
  distinguish one side of the branch cut from the other: for a branch
  cut along (a portion of) the real axis we look at the sign of the
  imaginary part, while for a branch cut along the imaginary axis we
  look at the sign of the real part.For example, the "cmath.sqrt()"
  function has a branch cut along the negative real axis. An argument
  of "-2-0j" is treated as though it lies _below_ the branch cut, and
  so gives a result on the negative imaginary axis:

>
     >>> cmath.sqrt(-2-0j)
     -1.4142135623730951j
<
  But an argument of "-2+0j" is treated as though it lies above the
  branch cut:

>
     >>> cmath.sqrt(-2+0j)
     1.4142135623730951j
<
+------------------------------------------------------+--------------------------------------------------------------------+
| **Conversions to and from polar coordinates**                                                                             |
+------------------------------------------------------+--------------------------------------------------------------------+
| "phase(z)"                                           | Return the phase of _z_                                            |
+------------------------------------------------------+--------------------------------------------------------------------+
| "polar(z)"                                           | Return the representation of _z_ in polar coordinates              |
+------------------------------------------------------+--------------------------------------------------------------------+
| "rect(r, phi)"                                       | Return the complex number _z_ with polar coordinates _r_ and _phi_ |
+------------------------------------------------------+--------------------------------------------------------------------+
| **Power and logarithmic functions**                                                                                       |
+------------------------------------------------------+--------------------------------------------------------------------+
| "exp(z)"                                             | Return _e_ raised to the power _z_                                 |
+------------------------------------------------------+--------------------------------------------------------------------+
| "log(z[, base])"                                     | Return the logarithm of _z_ to the given _base_ (_e_ by default)   |
+------------------------------------------------------+--------------------------------------------------------------------+
| "log10(z)"                                           | Return the base-10 logarithm of _z_                                |
+------------------------------------------------------+--------------------------------------------------------------------+
| "sqrt(z)"                                            | Return the square root of _z_                                      |
+------------------------------------------------------+--------------------------------------------------------------------+
| **Trigonometric functions**                                                                                               |
+------------------------------------------------------+--------------------------------------------------------------------+
| "acos(z)"                                            | Return the arc cosine of _z_                                       |
+------------------------------------------------------+--------------------------------------------------------------------+
| "asin(z)"                                            | Return the arc sine of _z_                                         |
+------------------------------------------------------+--------------------------------------------------------------------+
| "atan(z)"                                            | Return the arc tangent of _z_                                      |
+------------------------------------------------------+--------------------------------------------------------------------+
| "cos(z)"                                             | Return the cosine of _z_                                           |
+------------------------------------------------------+--------------------------------------------------------------------+
| "sin(z)"                                             | Return the sine of _z_                                             |
+------------------------------------------------------+--------------------------------------------------------------------+
| "tan(z)"                                             | Return the tangent of _z_                                          |
+------------------------------------------------------+--------------------------------------------------------------------+
| **Hyperbolic functions**                                                                                                  |
+------------------------------------------------------+--------------------------------------------------------------------+
| "acosh(z)"                                           | Return the inverse hyperbolic cosine of _z_                        |
+------------------------------------------------------+--------------------------------------------------------------------+
| "asinh(z)"                                           | Return the inverse hyperbolic sine of _z_                          |
+------------------------------------------------------+--------------------------------------------------------------------+
| "atanh(z)"                                           | Return the inverse hyperbolic tangent of _z_                       |
+------------------------------------------------------+--------------------------------------------------------------------+
| "cosh(z)"                                            | Return the hyperbolic cosine of _z_                                |
+------------------------------------------------------+--------------------------------------------------------------------+
| "sinh(z)"                                            | Return the hyperbolic sine of _z_                                  |
+------------------------------------------------------+--------------------------------------------------------------------+
| "tanh(z)"                                            | Return the hyperbolic tangent of _z_                               |
+------------------------------------------------------+--------------------------------------------------------------------+
| **Classification functions**                                                                                              |
+------------------------------------------------------+--------------------------------------------------------------------+
| "isfinite(z)"                                        | Check if all components of _z_ are finite                          |
+------------------------------------------------------+--------------------------------------------------------------------+
| "isinf(z)"                                           | Check if any component of _z_ is infinite                          |
+------------------------------------------------------+--------------------------------------------------------------------+
| "isnan(z)"                                           | Check if any component of _z_ is a NaN                             |
+------------------------------------------------------+--------------------------------------------------------------------+
| "isclose(a, b, *, rel_tol, abs_tol)"                 | Check if the values _a_ and _b_ are close to each other            |
+------------------------------------------------------+--------------------------------------------------------------------+
| **Constants**                                                                                                             |
+------------------------------------------------------+--------------------------------------------------------------------+
| "pi"                                                 | _π_ = 3.141592…                                                    |
+------------------------------------------------------+--------------------------------------------------------------------+
| "e"                                                  | _e_ = 2.718281…                                                    |
+------------------------------------------------------+--------------------------------------------------------------------+
| "tau"                                                | _τ_ = 2_π_ = 6.283185…                                             |
+------------------------------------------------------+--------------------------------------------------------------------+
| "inf"                                                | Positive infinity                                                  |
+------------------------------------------------------+--------------------------------------------------------------------+
| "infj"                                               | Pure imaginary infinity                                            |
+------------------------------------------------------+--------------------------------------------------------------------+
| "nan"                                                | “Not a number” (NaN)                                               |
+------------------------------------------------------+--------------------------------------------------------------------+
| "nanj"                                               | Pure imaginary NaN                                                 |
+------------------------------------------------------+--------------------------------------------------------------------+


Conversions to and from polar coordinates
=========================================

A Python complex number "z" is stored internally using _rectangular_
or _Cartesian_ coordinates.  It is completely determined by its _real
part_ "z.real" and its _imaginary part_ "z.imag".

_Polar coordinates_ give an alternative way to represent a complex
number.  In polar coordinates, a complex number _z_ is defined by the
modulus _r_ and the phase angle _phi_. The modulus _r_ is the distance
from _z_ to the origin, while the phase _phi_ is the counterclockwise
angle, measured in radians, from the positive x-axis to the line
segment that joins the origin to _z_.

The following functions can be used to convert from the native
rectangular coordinates to polar coordinates and back.

cmath.phase(z)

   Return the phase of _z_ (also known as the _argument_ of _z_), as a
   float. "phase(z)" is equivalent to "math.atan2(z.imag, z.real)".
   The result lies in the range [-_π_, _π_], and the branch cut for
   this operation lies along the negative real axis.  The sign of the
   result is the same as the sign of "z.imag", even when "z.imag" is
   zero:
>
      >>> phase(-1+0j)
      3.141592653589793
      >>> phase(-1-0j)
      -3.141592653589793
<
Note:

  The modulus (absolute value) of a complex number _z_ can be computed
  using the built-in "abs()" function.  There is no separate "cmath"
  module function for this operation.

cmath.polar(z)

   Return the representation of _z_ in polar coordinates.  Returns a
   pair "(r, phi)" where _r_ is the modulus of _z_ and _phi_ is the
   phase of _z_.  "polar(z)" is equivalent to "(abs(z), phase(z))".

cmath.rect(r, phi)

   Return the complex number _z_ with polar coordinates _r_ and _phi_.
   Equivalent to "complex(r * math.cos(phi), r * math.sin(phi))".


Power and logarithmic functions
===============================

cmath.exp(z)

   Return _e_ raised to the power _z_, where _e_ is the base of
   natural logarithms.

cmath.log(z[, base])

   Return the logarithm of _z_ to the given _base_. If the _base_ is
   not specified, returns the natural logarithm of _z_. There is one
   branch cut, from 0 along the negative real axis to -∞.

cmath.log10(z)

   Return the base-10 logarithm of _z_. This has the same branch cut
   as "log()".

cmath.sqrt(z)

   Return the square root of _z_. This has the same branch cut as
   "log()".


Trigonometric functions
=======================

cmath.acos(z)

   Return the arc cosine of _z_. There are two branch cuts: One
   extends right from 1 along the real axis to ∞. The other extends
   left from -1 along the real axis to -∞.

cmath.asin(z)

   Return the arc sine of _z_. This has the same branch cuts as
   "acos()".

cmath.atan(z)

   Return the arc tangent of _z_. There are two branch cuts: One
   extends from "1j" along the imaginary axis to "∞j". The other
   extends from "-1j" along the imaginary axis to "-∞j".

cmath.cos(z)

   Return the cosine of _z_.

cmath.sin(z)

   Return the sine of _z_.

cmath.tan(z)

   Return the tangent of _z_.


Hyperbolic functions
====================

cmath.acosh(z)

   Return the inverse hyperbolic cosine of _z_. There is one branch
   cut, extending left from 1 along the real axis to -∞.

cmath.asinh(z)

   Return the inverse hyperbolic sine of _z_. There are two branch
   cuts: One extends from "1j" along the imaginary axis to "∞j".  The
   other extends from "-1j" along the imaginary axis to "-∞j".

cmath.atanh(z)

   Return the inverse hyperbolic tangent of _z_. There are two branch
   cuts: One extends from "1" along the real axis to "∞". The other
   extends from "-1" along the real axis to "-∞".

cmath.cosh(z)

   Return the hyperbolic cosine of _z_.

cmath.sinh(z)

   Return the hyperbolic sine of _z_.

cmath.tanh(z)

   Return the hyperbolic tangent of _z_.


Classification functions
========================

cmath.isfinite(z)

   Return "True" if both the real and imaginary parts of _z_ are
   finite, and "False" otherwise.

   Added in version 3.2.

cmath.isinf(z)

   Return "True" if either the real or the imaginary part of _z_ is an
   infinity, and "False" otherwise.

cmath.isnan(z)

   Return "True" if either the real or the imaginary part of _z_ is a
   NaN, and "False" otherwise.

cmath.isclose(a, b, *, rel_tol=1e-09, abs_tol=0.0)

   Return "True" if the values _a_ and _b_ are close to each other and
   "False" otherwise.

   Whether or not two values are considered close is determined
   according to given absolute and relative tolerances.  If no errors
   occur, the result will be: "abs(a-b) <= max(rel_tol * max(abs(a),
   abs(b)), abs_tol)".

   _rel_tol_ is the relative tolerance – it is the maximum allowed
   difference between _a_ and _b_, relative to the larger absolute
   value of _a_ or _b_. For example, to set a tolerance of 5%, pass
   "rel_tol=0.05".  The default tolerance is "1e-09", which assures
   that the two values are the same within about 9 decimal digits.
   _rel_tol_ must be nonnegative and less than "1.0".

   _abs_tol_ is the absolute tolerance; it defaults to "0.0" and it
   must be nonnegative.  When comparing "x" to "0.0", "isclose(x, 0)"
   is computed as "abs(x) <= rel_tol  * abs(x)", which is "False" for
   any "x" and rel_tol less than "1.0".  So add an appropriate
   positive abs_tol argument to the call.

   The IEEE 754 special values of "NaN", "inf", and "-inf" will be
   handled according to IEEE rules.  Specifically, "NaN" is not
   considered close to any other value, including "NaN".  "inf" and
   "-inf" are only considered close to themselves.

   Added in version 3.5.

   See also: **PEP 485** – A function for testing approximate equality


Constants
=========

cmath.pi

   The mathematical constant _π_, as a float.

cmath.e

   The mathematical constant _e_, as a float.

cmath.tau

   The mathematical constant _τ_, as a float.

   Added in version 3.6.

cmath.inf

   Floating-point positive infinity. Equivalent to "float('inf')".

   Added in version 3.6.

cmath.infj

   Complex number with zero real part and positive infinity imaginary
   part. Equivalent to "complex(0.0, float('inf'))".

   Added in version 3.6.

cmath.nan

   A floating-point “not a number” (NaN) value.  Equivalent to
   "float('nan')". See also "math.nan".

   Added in version 3.6.

cmath.nanj

   Complex number with zero real part and NaN imaginary part.
   Equivalent to "complex(0.0, float('nan'))".

   Added in version 3.6.

Note that the selection of functions is similar, but not identical, to
that in module "math".  The reason for having two modules is that some
users aren’t interested in complex numbers, and perhaps don’t even
know what they are.  They would rather have "math.sqrt(-1)" raise an
exception than return a complex number. Also note that the functions
defined in "cmath" always return a complex number, even if the answer
can be expressed as a real number (in which case the complex number
has an imaginary part of zero).

A note on branch cuts: They are curves along which the given function
fails to be continuous.  They are a necessary feature of many complex
functions.  It is assumed that if you need to compute with complex
functions, you will understand about branch cuts.  Consult almost any
(not too elementary) book on complex variables for enlightenment.  For
information of the proper choice of branch cuts for numerical
purposes, a good reference should be the following:

See also:

  Kahan, W:  Branch cuts for complex elementary functions; or, Much
  ado about nothing’s sign bit.  In Iserles, A., and Powell, M.
  (eds.), The state of the art in numerical analysis. Clarendon Press
  (1987) pp165–211.

vim:tw=78:ts=8:ft=help:norl: