import regaut.*;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Created by Kristian on 4/25/2016.
 */
public class Main {

    public static void main(String[] args) {

        Alphabet alpha = new Alphabet("10");

        //M1
        FA M1 = new FA(alpha);

        HashSet<State> M1states = new HashSet<>();
        HashSet<State> M1accepts = new HashSet<>();
        State A = new State("A");
        State B = new State("B");
        State C = new State("C");

        M1states.add(A);
        M1states.add(B);
        M1states.add(C);

        M1accepts.add(C);

        M1.states = M1states;
        M1.accept = M1accepts;
        M1.initial = A;
        M1.setTransition(A, '1', A);
        M1.setTransition(A, '0', B);
        M1.setTransition(B, '1', C);
        M1.setTransition(B, '0', B);
        M1.setTransition(C, '0', B);
        M1.setTransition(C, '1', A);

        //M2
        FA M2 = new FA(alpha);

        HashSet<State> M2states = new HashSet<>();
        HashSet<State> M2accepts = new HashSet<>();
        State R = new State("R");
        State S = new State("S");
        State TEST = new State("TEST");
        State TEST2 = new State("TEST2");

        M2states.add(R);
        M2states.add(S);
        M2states.add(TEST);
        M2states.add(TEST2);

        M2accepts.add(S);

        M2.states = M2states;
        M2.accept = M2accepts;
        M2.initial = R;
        M2.setTransition(R, '1', S);
        M2.setTransition(R, '0', S);
        M2.setTransition(S, '1', R);
        M2.setTransition(S, '0', R);

        M2.setTransition(TEST, '1', TEST2);
        M2.setTransition(TEST, '0', TEST);
        M2.setTransition(TEST2, '1', TEST);
        M2.setTransition(TEST2, '0', TEST);

        //System.out.println(M1.toDot());
        //System.out.println(M2.toDot());

        for(State state : M2.states){
            System.out.println(state.name);
        }
        System.out.println("");
        for(State state : M2.getReachableStates()){
            System.out.println(state.name);
        }

        System.out.println(M1.intersection(M2).toDot());
        System.out.println(M1.union(M2).toDot());

    }
}
