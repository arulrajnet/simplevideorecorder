/**
 * Filename : HTTPSConnectionTest
 * Description :
 * Date : 16 Jan, 2015
 * Owner : www.arulraj.net
 * Project : vrecorder-red5
 * Contact : contact@arulraj.net
 * History :
 */

import java.io.DataOutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * @author <a href="mailto:me@arulraj.net">Arul</a>
 */
public class HTTPSConnectionTest {

    public static void main(String[] args) {
        HttpURLConnection connection = null;
        DataOutputStream outputStream = null;

        if(args.length == 0) {
            System.out.println("Usage: java HTTPSConnectionTest https://www.v-report.co.za");
            // For easy Test
            args = new String[1];
            args[0] = "https://www.v-report.co.za";
        }

        String urlServer = args[0];

        try {
            URL url = new URL(urlServer);
            connection = (HttpURLConnection)url.openConnection();

            connection.setDoInput(true);
            connection.setDoOutput(true);
            connection.setUseCaches(false);

            outputStream = new DataOutputStream(connection.getOutputStream());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
