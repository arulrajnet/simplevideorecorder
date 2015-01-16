/**
 * Filename : Application
 * Description :
 * Date : 16 Jan, 2015
 * Owner : www.arulraj.net
 * Project : vrecorder-red5
 * Contact : contact@arulraj.net
 * History :
 */
package com.org.makeeit.vrecorder;

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.adapter.MultiThreadedApplicationAdapter;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.service.ServiceUtils;
import org.red5.server.api.stream.IServerStream;
import org.red5.server.stream.ClientBroadcastStream;
import org.slf4j.Logger;
import org.springframework.core.io.Resource;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * @author <a href="mailto:me@arulraj.net">Arul</a>
 */
public class Application extends MultiThreadedApplicationAdapter {

    private static Logger log = Red5LoggerFactory.getLogger(Application.class, "VideoRecorder");

    private IScope appScope;
    private long t1 = System.currentTimeMillis();
    private long t2 = 0L;
    private IServerStream serverStream;
    ServiceUtils utils = new ServiceUtils();
    OutputStream output;
    PrintStream printOut;

    public boolean connect(IConnection conn, IScope scope, Object[] params) {
        super.connect(conn, scope, params);
        return true;
    }

    public boolean appConnect(IConnection conn, Object[] params) {
        return true;
    }

    public boolean appJoin(IClient client, IScope scope) {
        return true;
    }

    public boolean appStart(IScope app) {
        return true;
    }

    public void appDisconnect(IConnection conn) {
        if ((this.appScope == conn.getScope()) && (this.serverStream != null)) {
            this.serverStream.close();
        }
        super.appDisconnect(conn);
    }

    public void disconnect(IConnection conn, IScope scope) {
        try {
            super.disconnect(conn, scope);
            deleteFLV();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void recordVideo(String filename) {
        ClientBroadcastStream stream = (ClientBroadcastStream) getBroadcastStream(this.scope, "kannan");
        try {
            stream.saveAs("Kanna.m4v", false);
        } catch (Exception localException) {
        }
    }

    /**
     * Delete the given filename from streams directory of VideoRecorder red5 application.
     *
     * @param filename
     */
    public void deleteFile(String filename) {
        try {
            log.debug("Delete FLV file "+filename);
            Resource[] flvs = this.scope.getResources("streams/" + filename);
            Resource[] meta = this.scope.getResources("streams/*.meta");
            File file = flvs[0].getFile();
            if (file.delete()) ;
            for (int i = 0; i < meta.length; i++) {
                File file1 = meta[i].getFile();
                if (!file1.delete())
                    continue;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Delete all FLV files under streams folder of VideoRecorder red5 application.
     */
    public void deleteAllFLV() {
        try {
            Resource[] flvs = this.scope.getResources("streams/*.flv");
            for (int i = 0; i < flvs.length; i++)
                try {
                    File file = flvs[i].getFile();
                    if (!file.delete())
                        continue;
                } catch (Exception localException1) {
                }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Delete all FLV files which are older than 24 hours under streams folder of VideoRecorder red5 application.
     */
    public void deleteFLV() {
        try {
            this.t2 = System.currentTimeMillis();
            if (this.t2 - this.t1 > 86400000L) {
                Resource[] flvs = this.scope.getResources("streams/*.flv");

                for (int i = 0; i < flvs.length; i++)
                    try {
                        File file = flvs[i].getFile();
                        long t3 = file.lastModified();
                        if ((this.t2 - t3 < 14400000L) ||
                                (!file.delete())) continue;
                        log.info("flv  Deleted");
                    } catch (Exception localException) {
                    }
                this.t1 = this.t2;
            }
        } catch (Exception localException1) {
        }
    }

    /**
     * Upload recorded FLV into given server.
     *
     * @param fileName
     * @param urlServer
     * @return
     */
    public String uploadFile(String fileName, String urlServer) {
        log.debug("Upload fileName=" + fileName);
        log.debug("Upload urlServer=" + urlServer);
        HttpURLConnection connection = null;
        DataOutputStream outputStream = null;
        DataInputStream inputStream = null;
        String pathToOurFile = "streams\\" + fileName;

        String lineEnd = "\r\n";
        String twoHyphens = "--";
        String boundary = "*****";

        int maxBufferSize = 1048576;
        try {
            Resource[] flvs = this.scope.getResources("streams/" + fileName);
            File file = flvs[0].getFile();
            FileInputStream fileInputStream = new FileInputStream(file);

            URL url = new URL(urlServer);
            connection = (HttpURLConnection)url.openConnection();

            connection.setDoInput(true);
            connection.setDoOutput(true);
            connection.setUseCaches(false);

            connection.setRequestMethod("POST");

            connection.setRequestProperty("Connection", "Keep-Alive");
            connection.setRequestProperty("Content-Type", "multipart/form-data;boundary=" + boundary);

            outputStream = new DataOutputStream(connection.getOutputStream());
            outputStream.writeBytes(twoHyphens + boundary + lineEnd);
            outputStream.writeBytes("Content-Disposition: form-data; name=\"uploadedfile\";filename=\"" + pathToOurFile + "\"" + lineEnd);
            outputStream.writeBytes(lineEnd);

            int bytesAvailable = fileInputStream.available();
            int bufferSize = Math.min(bytesAvailable, maxBufferSize);
            byte[] buffer = new byte[bufferSize];

            int bytesRead = fileInputStream.read(buffer, 0, bufferSize);

            while (bytesRead > 0) {
                outputStream.write(buffer, 0, bufferSize);
                bytesAvailable = fileInputStream.available();
                bufferSize = Math.min(bytesAvailable, maxBufferSize);
                bytesRead = fileInputStream.read(buffer, 0, bufferSize);
            }

            outputStream.writeBytes(lineEnd);
            outputStream.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);

            int serverResponseCode = connection.getResponseCode();
            String serverResponseMessage = connection.getResponseMessage();

            InputStream ins = connection.getInputStream();
            byte[] b = new byte[ins.available()];
            ins.read(b);

            fileInputStream.close();
            outputStream.flush();
            outputStream.close();
            log.debug("Server Response Code "+serverResponseCode);
            if ((serverResponseCode == 200) &&
                    (file.delete())) {
                log.debug("File uploaded successfully.");
            }
            return new String(b);
        } catch (Exception ex) {
            ex.printStackTrace();
            log.error("Error in file upload", ex);
            return ex.getLocalizedMessage();
        }
    }
}