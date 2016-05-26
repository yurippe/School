import math
from Wrappers import SchemeProcedureWrapper

mathlib = vars(math)
for var in mathlib:
    if callable(mathlib[var]):
        mathlib[var] = SchemeProcedureWrapper(mathlib[var])