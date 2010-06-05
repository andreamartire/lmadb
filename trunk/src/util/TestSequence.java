package util;

public class TestSequence {
	public static void main(String[] args) {
		try {
			System.out.println( SequencerDB.nextval("matricole") );
		} catch (Exception e) {
			System.out.println("niente");
		}
	}
}
