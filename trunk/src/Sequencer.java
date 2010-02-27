import java.io.*;
import java.util.HashMap;

/** Class <code>Sequencer</code>
 * <p>Classe di utilità per gestire sequenze di un database.<br>
 * Le sequenze vengono mantenute su un file dal server che ospita l'applicazione web.
 * </p>
 * <p>Per ottenere il prossimo valore di una sequenza invocare il metodo statico <code>nextval(nome_sequenza)</code><br>
 * Se la sequenza richiesta non esiste viene creata e viene ritornato il primo valore.</p>
 * @author sal
 */
public class Sequencer implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private HashMap<String, Sequence> sequences;
	static Sequencer sequencer;
	
	public Sequencer() {
		sequences = new HashMap<String, Sequence>();
	}
	
	/** Funzione <code>next( String seq )</code><br>
	 * Ritorna il prossimo valore della sequenza specificata; se la sequenza specificata non esiste 
	 * viene creata e inizializzata.</br>
	 * <p>NB: metodo sincronizzato che prevede la lettura e la successiva scrittura del sequencer su
	 * disco per rendere permanenti le modifiche</p>
	 * 
	 * @param sequence - <b>String</b> - Il nome della sequenza
	 * @return <b>int</b> - il prossimo valore della sequenza specificata
	 * 
	 * @throws Exception nel caso in cui la sequenza sia finita
	 */
	public static synchronized int nextval( String sequence ) throws Exception {
		// caricamento sequencer
		try {
			FileInputStream inFile = new FileInputStream("sequencer");
			ObjectInputStream inStream = new ObjectInputStream(inFile); 
			sequencer = (Sequencer) inStream.readObject();
		} catch (Exception e) {
			System.err.println("File non trovato, creazione nuovo sequencer");
			sequencer = new Sequencer();
		}	
		
		// se non esiste la sequenza richiesta viene creata al momento
		if( sequencer.sequences.get(sequence) == null ) {
			System.out.println("creo una nuova sequenza");
			sequencer.sequences.put( sequence, new Sequence() );
		}
		
		// incremento del valore della sequenza richiesta
		int nextVal = sequencer.sequences.get(sequence).nextVal();
		
		// salvataggio del sequencer
		try {
			FileOutputStream outFile = new FileOutputStream("sequencer");
			ObjectOutputStream outStream = new ObjectOutputStream(outFile);
			outStream.writeObject( sequencer );
			
		} catch (Exception e) {
		}
		
		// ritorno del valore
		return nextVal;
	}
	
	protected static class Sequence implements Serializable {
		private static final long serialVersionUID = 1L;
		int startValue;
		int increment;
		int currentValue;
		int maxValue;
		int minValue;
		boolean cycle;
		
		Sequence() {
			startValue = 0;
			increment = 1;
			maxValue = Integer.MAX_VALUE;
			minValue = Integer.MIN_VALUE;
			cycle = false;
			
			currentValue = startValue;
		}
		
		Sequence(int startValue, int increment, int maxValue, int minValue, boolean cycle) throws Exception {
			// controlli di consistenza
			if( startValue < minValue ) {
				startValue = minValue;
			} else if( startValue > maxValue ) {
				if( cycle ) {
					startValue = minValue;
				} else {
					throw new Exception("Invalid start value; start with a value between minValue and maxValue");
				}
			} 
			
			this.startValue = startValue;
			this.increment = increment;
			this.maxValue = maxValue;
			this.minValue = minValue;
			this.cycle = cycle;
			
			currentValue = startValue;
		}
		
		int nextVal() throws Exception {
			// controlli di consistenza
			if( currentValue + 1 > maxValue ) {
				if( cycle ) {
					currentValue = minValue;
				} else {
					throw new Exception("Value out of limits");
				}
			}
			currentValue++;
			return currentValue;
		}
		
		int toInt() {
			return currentValue;
		}
	}
}
