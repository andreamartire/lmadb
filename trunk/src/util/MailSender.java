/**
 * Copyright (C) 2010 Salvatore Loria, Andrea Martire, Agosto Umberto
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc., 51
 * Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */

package util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class MailSender {
	
	static Socket s;
	static PrintWriter out;
	static BufferedReader in;
	static String fromserver;
	static String toserver;
	
	static String username = "c2xhc2gxNw==";
	static String password = "bWV0YWxsaWNh";
	
	static String server = "smtp.tele2.it";
	static int porta = 587;
	
	public static void main(String[] args) {
		String body = "Mime-Version: 1.0;\n" +
		"Content-Type: text/html;\n"+
		"<html>" +
			"<body>" +
				"<h1>Prova invio mail in formato html</h1>" +
			"</body>" +
		"</html>";
			
		MailSender.sendMail("prova@gmail.com", "deadlyomen17@gmail.com", "prova", body);
	}
	
	public static void sendMail( final String from, final String to, final String subject, final String body ) {
		Thread t = new Thread() {
			public void run() {
				sendmail(from, to, subject, body);
				return;
			}
		};
		t.start();
	}
	
	private static synchronized void sendmail( String from, String to, String subject, String body ) {
		try {
			s = new Socket( server, porta );
			System.out.println("Connesso a " + s.getInetAddress() + " sulla porta " + s.getLocalPort() + " dalla porta " + s.getPort() );
		} catch (Exception e) {
			System.err.println("Errore connessione");
			return;
		}
		
		try {
			out = new PrintWriter( s.getOutputStream() );
			in = new BufferedReader( new InputStreamReader( s.getInputStream() ) );
			System.out.println("Buffer ottenuti");
		} catch (IOException e1) {
			System.err.println("Impossibile ottenere i buffer");
			return;
		}
		
		System.out.println("Inizio conversazione \n");
		
		read();
		write("HELO " + server);
		read();
		write("AUTH LOGIN");
		read();
		write(username);
		read();
		write(password);
		read();
		write("MAIL FROM: <" + from + ">");
		read();
		write("RCPT TO: <" + to + ">");
		read();
		write("DATA");
		read();
		write("FROM: " + from);
		write("TO: " + to);
		write("SUBJECT: " + subject);
		write(body);
		write("\r\n.\r\n");
		read();
		
		System.out.println("\n*Email spedita*");
		
		close();
	}
	
	private static void close() {
		try {
			System.out.println("\nFine conversazione");			
			out.close();
			in.close();
			System.out.println("Buffer chiusi");
			s.close();
			System.out.println("Disconnessione");
		} catch (IOException e) {
			System.err.println("Errore disconnessione");
			return;
		}
	}

	private static void write( String toserver ) {
		out.println( toserver );
		out.flush();
		System.out.println("To server: " + toserver);
//		try {
//			Thread.sleep(1000);
//		} catch (Exception e) {
//		}
	}

	private static void read() {
		String fromserver;
		try {
			fromserver = in.readLine();
			
			try {
				String res = fromserver.split(" ")[0];
				if( Integer.parseInt(res) > 500 ) {
					System.err.println( "\nERROR: " + fromserver );
					close();
					System.exit(0);
				} else {
					System.err.println( "From server: " + fromserver);
//					Thread.sleep(1000);
				}
			} catch (Exception e) {
				System.err.println( "From server: " + fromserver);
//				Thread.sleep(1000);
			}
		} catch (Exception e) {
			System.err.println("Il server non risponde...");
		}
	}
	
}
