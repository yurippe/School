<program>            ::= <toplevel-forms>

<toplevel-forms>     ::= ()
                       | (<toplevel-form> . <toplevel-forms>)

<toplevel-form>      ::= <definition>
                       | <expression>

<definition>         ::= (define <variable> <expression>)

<expressions>        ::= ()
                       | (<expression> . <expressions>)

<expression>         ::= <number>
                       | <boolean>
                       | <character>
                       | <string>
                       | <variable>
                       | <time-expression>
                       | <if-expression>
                       | <and-expression>
                       | <or-expression>
                       | <cond-expression>
                       | <case-expression>
                       | <let-expression>
                       | <letstar-expression>
                       | <letrec-expression>
                       | <begin-expression>
                       | <unless-expression>
                       | <quote-expression>
                       | <lambda-abstraction>
                       | <application>

<time-expression>    ::= (time <expression>)

<if-expression>      ::= (if <expression> <expression> <expression>)

<and-expression>     ::= (and . <expressions>)

<or-expression>      ::= (or . <expressions>)

<cond-expression>    ::= (cond . <cond-clauses>)

<cond-clauses>       ::= (<else-clause>)
                       | (<cond-clause> . <cond-clauses>)

<else-clause>        ::= [else <expression>]

<cond-clause>        ::= [<expression>]
                       | [<expression> <expression>]
                       | [<expression> => <expression>]

<case-expression>    ::= (case <expression> . <case-clauses>)

<case-clauses>       ::= (<else-clause>)
                       | (<case-clause> . <case-clauses>)

<case-clause>        ::= [<quotations> <expression>]

<quotations>         ::= ()
                       | (<quotation> . <quotations>)

<let-expression>     ::= (let <let-bindings> <expression>)
                         ;;; where all the variables declared in the let-bindings are distinct

<let-bindings>       ::= ()
                       | (<let-binding> . <let-bindings>)

<let-binding>        ::= [<variable> <expression>]

<letstar-expression> ::= (let* <letstar-bindings> <expression>)

<letstar-bindings>   ::= ()
                       | (<letstar-binding> . <letstar-bindings>)

<letstar-binding>    ::= [<variable> <expression>]

<letrec-expression>  ::= (letrec <letrec-bindings> <expression>)
                         ;;; where all the variables declared in the letrec-bindings are distinct

<letrec-bindings>    ::= ()
                       | (<letrec-binding> . <letrec-bindings>)

<letrec-binding>     ::= [<variable> <lambda-abstraction>]

<begin-expression>   ::= (begin <expression> . <expressions>)

<unless-expression>  ::= (unless <expression> <expression>)

<quote-expression>   ::= (quote <quotation>)

<quotation>          ::= <number>
                       | <boolean>
                       | <character>
                       | <string>
                       | <symbol>
                       | ()
                       | (<quotation> . <quotation>)

<lambda-abstraction> ::= (lambda <lambda-formals> <expression>)
                       | (trace-lambda <variable> <lambda-formals> <expression>)
                         ;;; where the formals are a list (proper or improper) of distinct variables

<lambda-formals>     ::= ()
                       | <variable>
                       | (<variable> . <lambda-formals>)

<application>        ::= (<expression> . <expressions>)