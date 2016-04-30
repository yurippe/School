import regaut.*;

import java.util.*;

/**
 * Created by Kristian on 4/25/2016.
 */
public class Main {

    public static void main(String[] args) {

        Handin3NFAToFA();

    }

    public static void Handin3NFAToFA(){
        NFA nfa = new NFA();
        nfa.alphabet = new Alphabet("ab");
        nfa.states = new HashSet<>();

        State q1 = new State("1");
        State q2 = new State("2");
        State q3 = new State("3");
        State q4 = new State("4");

        nfa.states.add(q1);
        nfa.states.add(q2);
        nfa.states.add(q3);
        nfa.states.add(q4);

        nfa.accept = new HashSet<>();
        nfa.accept.add(q2);

        nfa.transitions = new HashMap<>();

        nfa.transitions.put(new StateSymbolPair(q1, 'a'), new HashSet<>(Arrays.asList(q2, q3)));
        nfa.transitions.put(new StateSymbolPair(q2, 'a'), new HashSet<>(Arrays.asList(q1)));
        nfa.transitions.put(new StateSymbolPair(q3, 'b'), new HashSet<>(Arrays.asList(q4)));
        nfa.transitions.put(new StateSymbolPair(q4, NFA.LAMBDA), new HashSet<>(Arrays.asList(q2)));
        nfa.transitions.put(new StateSymbolPair(q4, 'a'), new HashSet<>(Arrays.asList(q4)));

        nfa.initial = q1;
        System.out.println("\n\n------------ORIGINAL------------\n\n");
        System.out.println(nfa.toDot());
        System.out.println("\n\n------------LAMBDA-ELIMINATED------------\n\n");
        System.out.println(nfa.removeLambdas().toDot());
        System.out.println("\n\n------------DETERMINIZED------------\n\n");
        FA dfa = nfa.determinize();
        System.out.println(dfa.toDot());

    }

    public static void SlidesNFAToFA(){

        NFA nfa = new NFA();
        nfa.alphabet = new Alphabet("01");
        nfa.states = new HashSet<>();

        State q0 = new State("q0");
        State q1 = new State("q1");
        State q2 = new State("q2");
        State q3 = new State("q3");
        State q4 = new State("q4");

        nfa.states.add(q0);
        nfa.states.add(q1);
        nfa.states.add(q2);
        nfa.states.add(q3);
        nfa.states.add(q4);

        nfa.accept = new HashSet<>();
        nfa.accept.add(q4);

        nfa.transitions = new HashMap<>();
        nfa.transitions.put(new StateSymbolPair(q0, '1'), new HashSet<>(Arrays.asList(q1, q2)));
        nfa.transitions.put(new StateSymbolPair(q0, '0'), new HashSet<>(Arrays.asList(q4)));
        nfa.transitions.put(new StateSymbolPair(q1, '1'), new HashSet<>(Arrays.asList(q0)));
        nfa.transitions.put(new StateSymbolPair(q2, '1'), new HashSet<>(Arrays.asList(q3)));
        nfa.transitions.put(new StateSymbolPair(q3, '0'), new HashSet<>(Arrays.asList(q0)));

        nfa.initial = q0;


        System.out.println(nfa.toDot());

        FA dfa = nfa.determinize();
        System.out.println("\n\n--------------------------\n\n");
        System.out.println(dfa.toDot());

    }
}
