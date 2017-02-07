# -*- coding: utf-8 -*-
"""
Created on Sun Feb 05 15:14:33 2017

@author: Kristian
"""
import IPython.lib.latextools as latextools
import IPython.display as display
try:
    from table2ascii import table2ascii
except:
    def table2ascii(*args):
        raise NotImplemented("You need to download table2ascii from here: https://github.com/Snaipe/table2ascii")

import matplotlib.pyplot as plt

import sympy
from sympy import *
from sympy.stats import Chi, Normal, density, E, P, variance
from sympy import E as e

from scipy.stats import norm as sci_norm #Normal distribution
from scipy.stats import t as sci_t       #t distribution
from scipy.stats import chi2 as sci_chi2 #chi^2 distribution
from scipy.stats import f as sci_f       #F distribution

x, y, z, a, b, lamda, theta, r = symbols("x y z a b lamda theta r")
init_printing()

#So buggy it can almost be considered useless
class PrintLatex(object):
    def __init__(self, lat):
        self.lat = lat
        display.display(self)
    def _repr_png_(self):
        return latextools.latex_to_png(self.lat)

def max_1_none(*args):
    found_none = False
    for arg in args:
        if arg == None and found_none:
            raise Exception("Maximum 1 None parameter allowed")
            return False
        elif arg == None:
            found_none = True
    return True
    
#Page 1 in statistical tables
def phi(x):
    x = float(x)
    return sympify(sci_norm.cdf(x))
    
def solve_phi(phi_value=None, x=None):
    max_1_none(phi_value, x)
    if phi_value == None:
        #We solve for phi, which is easy:
        return phi(x)
    elif x == None:
        return sympify(sci_norm.ppf(float(phi_value)))


#Page 2-4 in statistical tables
def phi_inverse(p):
    p = float(p)
    return sympify(sci_norm.ppf(p))
    
def solve_phi_inverse(phi_inverse_value=None, p=None):
    max_1_none(phi_inverse_value, p)
    if phi_inverse_value == None:
        return phi_inverse(p)
    elif p == None:
        return sympify(sci_norm.cdf(float(phi_inverse_value)))

#Page 5 in statistical tables
def t(f, p):
    p = float(p)
    f = float(f)
    return  sympify(sci_t.ppf(p, f))
    
def solve_t(t_value=None, f=None, p=None):
    max_1_none(t_value, f, p)
    if t_value == None:
        return t(f, p)
    elif f == None:
        raise NotImplemented("Not implemented yet - sorry")
    elif p == None:
        return sympify(sci_t.cdf(float(t_value), float(f)))

#Page 6-9 in statistical tables
def chi_squared(f, p):
    f = float(f)
    p = float(p)
    return sympify(sci_chi2.ppf(p, f))
    
def solve_chi_squared(chi_squared_value=None, f=None, p=None):
    max_1_none(chi_squared_value, f, p)
    if chi_squared_value == None:
        return chi_squared(f,p)
    elif f == None:
        raise NotImplemented("Not implemented yet - sorry")
    elif p == None:
        return sympify(sci_chi2.cdf(float(chi_squared_value), float(f)))

#Page 14-49 in statistical tables
def f(f1, f2, p):
    f1 = float(f1)
    f2 = float(f2)
    p = float(p)
    return sympify(sci_f.ppf(p, f1, f2))
    
def solve_f(f_value=None, f1=None, f2=None, p=None):
    max_1_none(f_value, f1, f2, p)
    if f_value == None:
        return f(f1, f2, p)
    elif p == None:
        return sympify(sci_f.cdf(float(f_value), float(f1), float(f2)))
    else:
        raise NotImplemented("Not implemented yet - sorry")
    
##UNGROUPED VARIABLES
def fractile_diagram_table(data):
    
    data = [sympify(dat) for dat in data]

    TABLE = {
    'node': 'table',
    'colspec': [20, 9, 15, 15, 20],
    'rowspec': [2, 1, 1, 1, 1, 1],
    'children': [
      {
        'node': 'head',
        'children': [
            {
              'node': 'row',
              'children': [
                {'node': 'cell', 'data': 'Observation'},
                {'node': 'cell', 'data': 'Number'},
                {'node': 'cell', 'data': 'Cumulative number'},
                {'node': 'cell', 'data': 'Probability in %'},
                {'node': 'cell', 'data': 'p Fractile'}
              ]
            },
            {
              'node': 'row',
              'children': [
                {'node': 'cell', 'data': 'y'},
                {'node': 'cell', 'data': 'a'},
                {'node': 'cell', 'data': 'k'},
                {'node': 'cell', 'data': 'p in %'},
                {'node': 'cell', 'data': 'u_p'},
              ]
            }
          ]
      },
      {
        'node': 'body',
        'children': []
      }
    ]
  }

    n = len(data)    
    
    observations = {}
    for d in data:
        if d in observations.keys():
            observations[d] += 1
        else:
            observations[d] = 1
            
    obsess = sorted(observations.keys())
    
    y = []
    a = []
    k = []
    pp = []
    pf = []
    
    y.append(obsess[0])
    a.append(observations[obsess[0]])
    k.append(a[0])
    pp.append(100 * (k[0] / sympify(2*n)))
    p = (k[0] / sympify(2*n)).evalf()
    pf.append(phi_inverse(p))
            
    i = 1
    for observation in obsess[1:]:
        y.append(observation)
        a.append(observations[observation])
        
        s = 0
        for v in range(i):
            s += a[v]
        
        k.append(a[i] + s)
        pp.append(100 * ((k[i] + k[i-1]) / sympify(2*n)))
        p = (((k[i] + k[i-1]) / sympify(2*n))).evalf()
        pf.append(phi_inverse(p))
        i += 1
    
    rows = len(observations.keys())
    TABLE["rowspec"] = [2, 1] + [1 for i in range(rows)]
    for i in range(rows):
        node = {
            'node': 'row',
            'children': [
              {'node': 'cell', 'data': str(y[i])},
              {'node': 'cell', 'data': str(a[i])},
              {'node': 'cell', 'data': str(k[i])},
              {'node': 'cell', 'data': str(pp[i].evalf(6))},
              {'node': 'cell', 'data': str(pf[i])}
            ]
          }
        TABLE["children"][1]["children"].append(node)
    print(table2ascii(TABLE))
        
def unit_test():
    assert str(phi(0) == "0.5")
    assert str(phi(1.99))[:5] == "0.976"
    assert str(phi(-1.09))[:5] == str(1 - 0.8621)[:5]
    
    assert str(solve_phi(x=0.95)) == str(phi(0.95))
    assert str(solve_phi(phi_value=0.8315))[:5] == "0.960"
    
    assert str(phi_inverse(0.205))[:5] == "-0.82"
    assert str(phi_inverse(0.999))[:5] == "3.090"
    assert str(phi_inverse(0.9999))[:5] == "3.719"
    
    assert str(solve_phi_inverse(p=0.404)) == str(phi_inverse(0.404))
    assert str(solve_phi_inverse(phi_inverse_value=solve_phi_inverse(p=0.404)))[:5] == "0.404"
    
    assert str(t(23, 0.9))[:5] == "1.319"
    assert str(t(130, 0.9))[:5] == "1.288"
    assert str(t(130, 0.1))[:15] == str(-t(130, 0.9))[:15]
    
    assert str(solve_t(t_value=2.086, f=20))[:5] == "0.975"
    
    assert str(chi_squared(10, 0.2))[:5] == "6.179"
    
    assert solve_chi_squared(chi_squared_value=None, f=10, p=0.2) == chi_squared(10, 0.2)
    assert str(solve_chi_squared(chi_squared_value=11.1, f=13, p=None))[:5] == "0.397"
    
    assert str(f(500, 10, 0.9))[:4] == "2.06"
    assert str(f(500, 500, 0.5))[:4] == "1.00"
    
    assert str(solve_f(1.11,60, 6))[:4] == "0.50"
    
    
    print("All unit tests passed")

#fractile_diagram_table([6.3,7.1,7.4,6.8,7.1,7.8,6.9,7.3,7.7,7.3])
unit_test()       
print("Successfully set up")
print("For all methods called 'solve_x(param1=None, param2=None, ...)' you need to supply all but one parameter to solve for the None parameter")
print("\n\n")
print("Use 'fractile_diagram_table(data)' to generate the table on p.31 (data is a list of observations)")
PrintLatex("$\Phi$")
print("---Phi lookups: page 1 in ST ---")
print("\t'phi(x)'")
print("\t'solve_phi(phi_value=None, x=None)'")

PrintLatex("$\Phi^{-1}$")
print("--- Phi^-1 lookups: page 2-4 in ST ---")
print("\tUse 'phi_inverse(p)' (remember that p < 1)")
print("\tUse 'solve_phi_inverse(phi_inverse_value=None, p=None)'")

PrintLatex("$t_p(f)$")
print("--- t lookups: page 5 in ST ---")
print("\tUse 't(f, p)'")
print("\tUse 'solve_t(t_value=None, f=None, p=None)'")

PrintLatex("$\chi^2_p(f)$")
print("--- chi^2 lookups: page 6-9 in ST ---")
print("\tUse 'chi_squared(f, p)'")
print("\tUse 'solve_chi_squared(chi_squared_value=None, f=None, p=None)'")

PrintLatex("$F_p(f_1, f_2)$")
print("--- F lookups: page 14-49 in ST ---")
print("\tUse 'f(f1, f2, p)'")
print("\tUse 'solve_f(f_value=None, f1=None, f2=None, p=None)'")