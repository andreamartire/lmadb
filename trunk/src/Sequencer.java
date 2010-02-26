import java.io.Serializable;
import java.util.HashMap;

/**
 * @author sal
 */
public class Sequencer implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private HashMap<String, Sequence> sequences;
	
	public Sequencer() {
		sequences = new HashMap<String, Sequence>();
	}
	
	/** Funzione <code>next( String seq )</code><br>
	 * Ritorna il prossimo valore della sequenza specificata; se la sequenza specificata non esiste 
	 * viene creata e inizializzata.
	 * 
	 * @param seq - <b>String</b> - Il nome della sequenza
	 * @return <b>int</b> - il prossimo valore della sequenza specificata
	 * 
	 * @throws Exception
	 */
	public synchronized int next( String seq ) throws Exception {
		// se non esiste, la sequenza richiesta viene creata al momento
		if( sequences.get(seq) == null ) {
			System.out.println("creo una nuova sequenza");
			sequences.put(seq, new Sequence() );
		}
		// incremento il valore della sequenza richiesta e ritorno il valore
		return sequences.get(seq).nextVal();
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
