package regaut;

import java.util.*;

/**
 * Deterministic finite state automaton. [Martin, Def. 2.11]
 */
public class FA implements Cloneable {

    /**
     * Set of {@link State} objects (Q). 
     */
    public Set<State> states;

    /**
     * The automaton alphabet (<img src="http://cs.au.dk/~amoeller/RegAut/Sigma.gif" alt="sigma">). 
     */
    public Alphabet alphabet;

    /**
     * Initial state (q<sub>0</sub>). Member of {@link #states}. 
     */
    public State initial;

    /**
     * Accept states (A). Subset of {@link #states}. 
     */
    public Set<State> accept;

    /**
     * Transition function (<img src="http://cs.au.dk/~amoeller/RegAut/delta.gif" alt="delta">). 
     * This is a map from pairs of states and alphabet symbols to states
     * (<img src="http://cs.au.dk/~amoeller/RegAut/delta.gif" alt="delta">: 
     * Q<img src="http://cs.au.dk/~amoeller/RegAut/times.gif" 
     *      alt="x"><img src="http://cs.au.dk/~amoeller/RegAut/Sigma.gif" alt="sigma">
     * <img src="http://cs.au.dk/~amoeller/RegAut/rightarrow.gif" alt="-&gt;"> Q).
     */
    public Map<StateSymbolPair,State> transitions;

    /**
     * Checks that this automaton is well-defined.
     * In particular, this method checks that the transition function is total.
     * This method should be invoked after each <tt>FA</tt> operation during testing.
     * @return this automaton
     * @exception AutomatonNotWellDefinedException if this automaton is not well-defined
     */
    public FA checkWellDefined() throws AutomatonNotWellDefinedException {
        if (states==null || alphabet==null || alphabet.symbols==null ||
                initial==null || accept==null || transitions==null)
            throw new AutomatonNotWellDefinedException("invalid null pointer");
        if (!states.contains(initial))
            throw new AutomatonNotWellDefinedException("the initial state is not in the state set");
        if (!states.containsAll(accept))
            throw new AutomatonNotWellDefinedException("not all accept states are in the state set");
        for (State s : states)
            for (char c : alphabet.symbols) {
                if (c==NFA.LAMBDA)
                    throw new AutomatonNotWellDefinedException("lambda transition appears in transitions");
                State s2 = transitions.get(new StateSymbolPair(s, c));
                if (s2==null)
                    throw new AutomatonNotWellDefinedException("transition function is not total");
                if (!states.contains(s2))
                    throw new AutomatonNotWellDefinedException("there is a transition to a state that is not in state set");
            }
        for (StateSymbolPair sp : transitions.keySet()) {
            if (!states.contains(sp.state))
                throw new AutomatonNotWellDefinedException("transitions refer to a state not in the state set");
            if (!alphabet.symbols.contains(sp.symbol))
                throw new AutomatonNotWellDefinedException("non-alphabet symbol appears in transitions");
        }
        return this;
    }

    /**
     * Constructs an uninitialized FA. 
     * <tt>states</tt> and <tt>accept</tt> are set to empty sets,
     * <tt>transitions</tt> is set to an empty map.
     */
    public FA() {
        states = new HashSet<State>();
        accept = new HashSet<State>();
        transitions = new HashMap<StateSymbolPair,State>();
    }

    /**
     * Constructs a new FA consisting of one reject state. 
     * @param a automaton alphabet
     */
    public FA(Alphabet a) {
        states = new HashSet<State>();
        accept = new HashSet<State>();
        alphabet = a;

        // make a state
        State s = new State();
        states.add(s);
        initial = s;

        // add a loop transition for each alphabet symbol
        transitions = new HashMap<StateSymbolPair,State>();
        for (char c : alphabet.symbols)
            transitions.put(new StateSymbolPair(s, c), s);
    }

    /**
     * Clones this automaton. 
     */
    @Override
    public Object clone() {
        FA f;
        try {
            f = (FA) super.clone(); // always clone using super.clone()
        } catch (CloneNotSupportedException e) {
            throw new RuntimeException(e);
        }
        f.states = new HashSet<State>();
        f.accept = new HashSet<State>();
        f.transitions = new HashMap<StateSymbolPair,State>();
        Map<State,State> m = new HashMap<State,State>(); // map from old states to new states
        for (State p : states) {
            State s = (State)p.clone();
            f.states.add(s);
            m.put(p, s);
            if (accept.contains(p))
                f.accept.add(s);
        }
        f.initial = m.get(initial);
        for (Map.Entry<StateSymbolPair,State> e : transitions.entrySet()) {
            StateSymbolPair ssp = e.getKey();
            State q = e.getValue();
            f.transitions.put(new StateSymbolPair(m.get(ssp.state), ssp.symbol), m.get(q));
        }
        return f;
    }

    /**
     * Returns <a href="http://www.graphviz.org/" target="_top">Graphviz Dot</a> 
     * representation of this automaton. 
     * (To convert a dot file to postscript, run '<tt>dot -Tps -o file.ps file.dot</tt>'.)
     */
    public String toDot() {
        StringBuffer b = new StringBuffer("digraph Automaton {\n");
        b.append("  rankdir = LR;\n");
        Map<State,Integer> id = new HashMap<State,Integer>();
        for (State s : states)
            id.put(s, Integer.valueOf(id.size()));
        for (State s : states) {
            b.append("  ").append(id.get(s));
            if (accept.contains(s))
                b.append(" [shape=doublecircle,label=\""+s.name+"\"];\n");
            else
                b.append(" [shape=circle,label=\""+s.name+"\"];\n");
            if (s==initial) {
                b.append("  in [shape=plaintext,label=\"\"];\n");
                b.append("  in -> ").append(id.get(s)).append(";\n");
            }
        }
        for (Map.Entry<StateSymbolPair,State> e : transitions.entrySet()) {
            StateSymbolPair ssp = e.getKey();
            State q = e.getValue();
            b.append("  ").append(id.get(ssp.state)).append(" -> ").append(id.get(q));
            b.append(" [label=\"");
            char c = ssp.symbol.charValue();
            if (c>=0x21 && c<=0x7e && c!='\\' && c!='%')
                b.append(c);
            else {
                b.append("\\u");
                String s = Integer.toHexString(c);
                if (c<0x10)
                    b.append("000").append(s);
                else if (c<0x100)
                    b.append("00").append(s);
                else if (c<0x1000)
                    b.append("0").append(s);
                else
                    b.append(s);
            }
            b.append("\"];\n");
        }
        return b.append("}\n").toString();
    }

    /**
     * Returns number of states in this automaton. 
     */
    public int getNumberOfStates() {
        return states.size();
    }

    /**
     * Sets a transition in the transition function. 
     * <img src="http://cs.au.dk/~amoeller/RegAut/delta.gif" alt="delta">(q,c)=p
     */
    public void setTransition(State q, char c, State p) {
        transitions.put(new StateSymbolPair(q, c), p);
    }

    /**
     * Looks up transition in transition function.
     * @return <img src="http://cs.au.dk/~amoeller/RegAut/delta.gif" alt="delta">(q,c) 
     * @exception IllegalArgumentException if <tt>c</tt> is not in the alphabet
     */
    public State delta(State q, char c) throws IllegalArgumentException {
        if (!alphabet.symbols.contains(c))
            throw new IllegalArgumentException("symbol '"+c+"' not in alphabet");
        return transitions.get(new StateSymbolPair(q, c));
    }


    /**
     * Performs transitions in extended transition function. [Martin, Def. 2.12]
     * @return <img src="http://cs.au.dk/~amoeller/RegAut/delta.gif" alt="delta">*(q,s)
     * @exception IllegalArgumentException if a symbol in <tt>s</tt> is not in the alphabet
     */
    public State deltaStar(State q, String s) throws IllegalArgumentException {
        // (Using recursion instead of iteration would have been closer to
        // the mathematical definition, but this code is simpler...)
        for (char c : s.toCharArray())
            q = delta(q,c);
        return q;
    }


    /**
     * Runs the given string on this automaton. [Martin, Def. 2.14]
     * @param s a string
     * @return true iff the string is accepted
     * @exception IllegalArgumentException if a symbol in <tt>s</tt> is not in the alphabet
     */
    public boolean accepts(String s) throws IllegalArgumentException {
        State endstate = deltaStar(initial, s);
        if(accept.contains(endstate)){
            return true;
        } else {
            return false;
        }
    }

    /**
     * Pair of states. Used in product construction and in construction of regular expression. 
     */
    static class StatePair {

        State s1, s2;

        /**
         * Constructs a new pair. 
         */
        StatePair(State s1, State s2) {
            this.s1 = s1;
            this.s2 = s2;
        }

        /**
         * Checks whether two pairs are equal. 
         */
        @Override
        public boolean equals(Object obj) {
            if (!(obj instanceof StatePair))
                return false;
            StatePair ss = (StatePair) obj;
            return s1==ss.s1 && s2==ss.s2;
        }

        /**
         * Computes hash code for this object. 
         */
        @Override
        public int hashCode() {
            return s1.hashCode()*3 + s2.hashCode()*2;
        }
    }

    /**
     * Converts this FA into an equivalent {@link NFA}.
     */
    public NFA toNFA() {
        NFA f = new NFA();
        f.alphabet = alphabet;
        Map<State,State> m = new HashMap<State,State>(); // map from old states to new states
        for (State p : states) {
            State s = (State) p.clone();
            f.states.add(s);
            m.put(p, s);
            if (accept.contains(p))
                f.accept.add(s);
            if (p==initial)
                f.initial = s;
        }
        for (Map.Entry<StateSymbolPair,State> e : transitions.entrySet()) {
            StateSymbolPair ssp = e.getKey();
            State q = e.getValue();
            Set<State> ns = new HashSet<State>();
            ns.add(m.get(q));
            f.transitions.put(new StateSymbolPair(m.get(ssp.state), ssp.symbol), ns);
        }
        return f;
    }

    /**
     * Finds regular expression in table or computes it if not there yet. (Used by {@link #toRegExp}.)
     */
    private RegExp.Node tableLookup(State p, State q, int k, Map<StatePair,RegExp.Node[]> table, Map<Integer,State> statemap) {
        RegExp.Node x = table.get(new StatePair(p, q))[k];
        if (x==null) {
            if (k==0) {
                x = new RegExp.EmptyLanguageNode();
                for (char c : alphabet.symbols)
                    if (delta(p,c)==q)
                        x = new RegExp.UnionNode(x, new RegExp.SymbolNode(c));
                if (p==q)
                    x = new RegExp.UnionNode(x, new RegExp.EmptyStringNode());
            } else {
                State r = statemap.get(k);
                RegExp.Node x1 = tableLookup(p, q, k-1, table, statemap);
                RegExp.Node x2 = tableLookup(p, r, k-1, table, statemap);
                RegExp.Node x3 = tableLookup(r, r, k-1, table, statemap);
                RegExp.Node x4 = tableLookup(r, q, k-1, table, statemap);
                x = new RegExp.UnionNode(x1, new RegExp.ConcatNode(x2, new RegExp.ConcatNode(new RegExp.StarNode(x3), x4)));

            }
            table.get(new StatePair(p, q))[k] = x;
        }
        return x;
    }

    /**
     * Converts this automaton into an equivalent {@link RegExp} regular expression. [Martin, Th. 3.30]
     */
    public RegExp toRegExp() {
        Map<Integer,State> statemap = new HashMap<Integer,State>();
        Map<StatePair,RegExp.Node[]> table = new HashMap<StatePair,RegExp.Node[]>(); // fill out this table lazily
        // initialize
        int n = 0;
        for (State p : states) {
            statemap.put(++n, p); // states are numbered from 1 to states.size()
            for (State q : states)
                table.put(new StatePair(p, q), new RegExp.Node[states.size()+1]);
        }
        // construct the abstract syntax tree for the regular expression
        RegExp.Node x = new RegExp.EmptyLanguageNode();
        for (State p : accept)
            x = new RegExp.UnionNode(x, tableLookup(initial, p, states.size(), table, statemap));
        return new RegExp(x, alphabet);
    }

    /**
     * Constructs a new automaton that accepts the complement of the language of this automaton.
     * The input automaton is unmodified.
     */
    public FA complement() {
        FA f = (FA) clone();
        Set<State> s = new HashSet<State>();
        s.addAll(f.states);
        s.removeAll(f.accept);
        f.accept = s;
        return f;
    }


    /**
     * Finds the set of states that are reachable from the initial state. [Martin, Exercise 2.27(b)]
     */
    public Set<State> findReachableStates() {
        Set<State> reachable = new HashSet<State>(); // contains the states that are reachable and have been visited
        Set<State> pending = new HashSet<State>(); // contains the states that are reachable but have not yet been visited
        pending.add(initial);
        while (!pending.isEmpty()) {
            State q = pending.iterator().next();
            pending.remove(q);
            reachable.add(q);
            for (char a : alphabet.symbols) {
                State p = delta(q, a);
                if (!reachable.contains(p))
                    pending.add(p);
            }
        }
        return reachable;
    }


    /**
     * Constructs a new automaton with the same language as this automaton but without unreachable states.
     * The input automaton is unmodified.
     */
    public FA removeUnreachableStates() {
        FA f = (FA) clone();
        Set<State> reachable = f.findReachableStates();
        f.states.retainAll(reachable);
        f.accept.retainAll(reachable);
        for (StateSymbolPair sp : new HashSet<StateSymbolPair>(f.transitions.keySet())) {
            if (!f.states.contains(sp.state))
                f.transitions.remove(sp);
        }
        return f;
    }


    /**
     * Unordered pair of states. Used in minimization operation.
     */
    static class UnorderedStatePair {

        State s1, s2;

        /**
         * Constructs a new unordered pair.
         */
        UnorderedStatePair(State s1, State s2) {
            this.s1 = s1;
            this.s2 = s2;
        }

        /**
         * Checks whether two unordered pairs are equal.
         */
        @Override
        public boolean equals(Object obj) {
            if (!(obj instanceof UnorderedStatePair))
                return false;
            UnorderedStatePair ss = (UnorderedStatePair) obj;
            return (s1==ss.s1 && s2==ss.s2) || (s1==ss.s2 && s2==ss.s1);
        }

        /**
         * Computes hash code for this object.
         */
        @Override
        public int hashCode() {
            return s1.hashCode() + s2.hashCode();
        }
    }

    /**
     * Constructs a new minimal automaton with the same language as this automaton. [Martin, Sec. 2.6]
     * The input automaton is unmodified.
     * Note: this textbook algorithm is simple to understand but not very efficient
     * compared to other existing algorithms.
     */
    public FA minimize() {
        FA f = removeUnreachableStates();
        Set<UnorderedStatePair> marks = new HashSet<UnorderedStatePair>();
        List<State> statelist = new ArrayList<State>(f.states); // ensure consistent state order
        // first pass, divide into accept/reject states
        for (State p : statelist)
            for (State q : statelist) {
                if (p == q)
                    break; // traversing all *unordered* pairs of states
                if (f.accept.contains(p)!=f.accept.contains(q))
                    marks.add(new UnorderedStatePair(p, q));
            }
        // iteratively perform marking passes until nothing more happens
        boolean done = false;
        while (!done) { // (this could be made more efficient with a worklist)
            done = true;
            for (State p : statelist)
                for (State q : statelist) {
                    if (p == q)
                        break;
                    if (!marks.contains(new UnorderedStatePair(p, q)))
                        for (char a : f.alphabet.symbols) {
                            State r = f.delta(p, a);
                            State s = f.delta(q, a);
                            if (marks.contains(new UnorderedStatePair(r, s))) {
                                marks.add(new UnorderedStatePair(p, q));
                                done = false;
                                break;
                            }
                        }
                }
        }
        // start building the new automaton
        FA n = new FA();
        n.alphabet = alphabet;
        Map<State,State> old2new = new HashMap<State,State>(); // map from old states to new states
        Map<State,State> new2old = new HashMap<State,State>(); // map from new states to representatives in old states
        // make new states
        for (State r : statelist) {
            boolean repr = true; // true if r is representative for its equivalence class
            for (State s : statelist) {
                if (r == s)
                    break;
                if (!marks.contains(new UnorderedStatePair(r, s))) {
                    old2new.put(r, old2new.get(s));
                    repr = false;
                    break;
                }
            }
            if (repr) {
                State p = new State();
                n.states.add(p);
                if (f.accept.contains(r))
                    n.accept.add(p);
                old2new.put(r, p);
                new2old.put(p, r);
            }
            if (r==f.initial)
                n.initial = old2new.get(r);
        }
        // make new transitions
        for (State p : n.states) {
            State r = new2old.get(p);
            for (char a : n.alphabet.symbols)
                n.transitions.put(new StateSymbolPair(p, a), old2new.get(f.delta(r, a)));
        }
        return n;
    }

    /**
     * Checks whether the language of this automaton is finite. [Martin, Example 2.34] 
     */
    public boolean isFinite() {
        throw new UnsupportedOperationException("method not implemented yet!");
    }

    /**
     * Checks whether the language of this automaton is empty. [Martin, Example 2.34] 
     */
    public boolean isEmpty() {
        throw new UnsupportedOperationException("method not implemented yet!");
    }

    /**
     * Checks whether the language of this automaton is a subset of the language of the given automaton. [Martin, Exercise 2.27(g)] 
     */
    public boolean subsetOf(FA f) {
        throw new UnsupportedOperationException("method not implemented yet!");
    }

    /**
     * Computes hash code for this object. 
     * (When {@link #equals(Object)} is implemented, <tt>hashCode</tt> must also be there.)
     */
    @Override
    public int hashCode() {
        return getNumberOfStates(); // a very simple but valid hash code
    }

    /**
     * Checks whether the language of this automaton is equal to the language of the given automaton. 
     */
    @Override
    public boolean equals(Object obj) {
        throw new UnsupportedOperationException("method not implemented yet!");
    }

    /**
     * Returns a shortest string that is accepted by this automaton. 
     * @return a (not necessarily unique) shortest example string, null if the language of this automaton is empty
     */
    public String getAShortestExample() {
        throw new UnsupportedOperationException("method not implemented yet!");
    }

    /**
     * Constructs a new automaton whose language is the intersection of the language of this automaton
     * and the language of the given automaton. [Martin, Th. 2.15]
     * The input automata are unmodified.
     * @exception IllegalArgumentException if the alphabets of <tt>f</tt> and this automaton are not the same
     */
    public FA intersection(FA f) throws IllegalArgumentException {
        return  productConstruct(f, CONSTRUCT.INTERSECT);
    }

    /**
     * Constructs a new automaton whose language is the union of the language of this automaton
     * and the language of the given automaton. [Martin, Th. 2.15]
     * The input automata are unmodified.
     * @exception IllegalArgumentException if the alphabets of <tt>f</tt> and this automaton are not the same
     * @see NFA#union
     */
    public FA union(FA f) throws IllegalArgumentException {
        return  productConstruct(f, CONSTRUCT.UNION);
    }

    /**
     * Constructs a new automaton whose language is equal to the language of this automaton
     * minus the language of the given automaton. [Martin, Th. 2.15]
     * The input automata are unmodified.
     * @exception IllegalArgumentException if the alphabets of <tt>f</tt> and this automaton are not the same
     */
    public FA minus(FA f) throws IllegalArgumentException {
        return  productConstruct(f, CONSTRUCT.MINUS);
    }

    //TODO: Grade from here and down
    private enum CONSTRUCT{UNION, INTERSECT, MINUS}

    /**
     * Combined method for Union, Intersection and Minus, used internally
     */
    private FA productConstruct(FA f, CONSTRUCT construct) throws IllegalArgumentException {
        if(!(f.alphabet.equals(this.alphabet))) {
            throw new IllegalArgumentException("The alphabets of the automata are not the same");
        }

        FA newFA = new FA(alphabet);

        HashMap<StatePair, State> statemap= new HashMap<>();

        HashSet<State> Q = new HashSet<>();
        HashSet<State> A = new HashSet<>();
        HashMap<StateSymbolPair, State> Delta = new HashMap<>();

        //Make Q from Q1 x Q2
        for(State Q1 : this.states){

            for(State Q2 : f.states){
                //Set name as the concatenation of the 2 states it is formed from, this is just a choice, and not important
                State q = new State(Q1.name + Q2.name);
                //Add q as a state of the new automaton
                Q.add(q);
                //Store it in the statemap, so we can refer to it by using Q1 and Q2
                statemap.put(new StatePair(Q1, Q2), q);
            }
        }

        /* Note:
        The reason we need two loops, is because when we are checking the transitions, we need to be sure that Q
        is complete.
         */

        //Loop through Q1 x Q2 again
        for(State Q1 : this.states){

            for(State Q2 : f.states){

                //For every letter in the alphabet, check the transition of Q1 x Q2
                for(Character letter : alphabet.symbols) {
                    //Get transitions for Q1 x letter -> delta1
                    //and transitions for Q2 x letter -> delta2
                    State delta1 = this.transitions.get(new StateSymbolPair(Q1, letter));
                    State delta2 =  f.transitions.get(new StateSymbolPair(Q2, letter));

                    //Get the state corresponding to the statepair (delta1, delta2)
                    State stateTo = statemap.get(new StatePair(delta1, delta2));

                    //Get the state corresponding to the statepair (Q1, Q2)
                    State stateFrom = statemap.get(new StatePair(Q1, Q2));

                    //Set (Q1, Q2) x letter -> (delta1, delta2)
                    Delta.put(new StateSymbolPair(stateFrom, letter), stateTo);
                }


                /* Note:
                This following switch is the only difference between
                Union (||)
                Intersection (&&)
                Subtract (&& !)
                */

                switch (construct) {
                    case UNION:
                        if (this.accept.contains(Q1) || f.accept.contains(Q2)) {

                            A.add(statemap.get(new StatePair(Q1, Q2)));

                        } break;

                    case INTERSECT:
                        if (this.accept.contains(Q1) && f.accept.contains(Q2)) {

                            A.add(statemap.get(new StatePair(Q1, Q2)));

                        } break;
                    case MINUS:
                        if (this.accept.contains(Q1) && !f.accept.contains(Q2)) {

                            A.add(statemap.get(new StatePair(Q1, Q2)));

                        }break;
                }

            }

        }

        //Set q_0
        newFA.initial = statemap.get(new StatePair(this.initial, f.initial));

        //Set Q
        //newFA.states = Q; //Unoptimized -deprecated-
        newFA.states = getReachableStates(newFA.initial, Delta, alphabet); //Optimized by removing unreachable states

        //Set A
        //Optimized by removing unreachable accept states
        Iterator<State> iterA = A.iterator();
        while(iterA.hasNext()){
            if(!(newFA.states.contains(iterA.next()))){
                iterA.remove();
            }
        }
        //Set the new optimized A
        newFA.accept = A;

        //Set Delta
        //Optimize by removing any loops not reachable by q_0 (not in the optimized newFA.states)
        Iterator<StateSymbolPair> iterD = Delta.keySet().iterator();
        while(iterD.hasNext()){
            if(!(newFA.states.contains(iterD.next().state))){
                iterD.remove();
            }
        }
        newFA.transitions = Delta;
        return newFA;
    }


    /**
     * NOTE: This does NOT return the reachable states of this automaton.
     * @return the reachable states, given these parameters
     */
    private Set<State> getReachableStates(State start, Map<StateSymbolPair, State> transitions, Alphabet alphabet, Set<State> visited){

        visited.add(start); //obviously we can reach this so we add it to the visited list
        for(Character letter : alphabet.symbols){ //then we loop through the alphabet, since there is 1 transition for each symbol
            State next = transitions.get(new StateSymbolPair(start, letter));
            if(!(visited.contains(next))) { //If we haven't visited the next node we visit it recursively
                visited.addAll(getReachableStates(next, transitions, alphabet, visited));
            }
        }
        return visited;
    }

    /**
     * NOTE: This does NOT return the reachable states of this automaton.
     * @return the reachable states, given these parameters
     */
    private Set<State> getReachableStates(State start, Map<StateSymbolPair, State> transitions, Alphabet alphabet){

        Set<State> visited = new HashSet<>();
        return getReachableStates(start, transitions, alphabet, visited);
    }



}