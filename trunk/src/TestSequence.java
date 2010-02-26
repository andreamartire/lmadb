import java.io.*;


public class TestSequence {
	public static void main(String[] args) {
		Sequencer seq = null;
		
		FileInputStream fin = null;
		try {
			fin = new FileInputStream("sequences");
			ObjectInputStream ois = null;
			ois = new ObjectInputStream(fin); 
			seq = (Sequencer) ois.readObject();
			
		} catch (Exception e) {
			System.err.println("fuck");
			seq = new Sequencer();
		}
		
		try {
			System.out.println( seq.next("prova") );
		} catch (Exception e) {
			System.out.println("niente");
		}
		

		// scrittura
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream("sequences");
			ObjectOutputStream oos = null;
			oos = new ObjectOutputStream(fos);
			oos.writeObject( seq );
			
		} catch (Exception e) {
		}

	}
}
