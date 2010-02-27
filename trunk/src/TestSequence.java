public class TestSequence {
	public static void main(String[] args) {
		try {
			System.out.println( SequencerDB.nextval("sequenza") );
		} catch (Exception e) {
			System.out.println("niente");
		}
	}
}
