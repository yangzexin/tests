package com.yzx.server;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class CommonSocketServer {
	public static void main(String[] args){
		try {
			ServerSocket server = new ServerSocket(1222);
			System.out.println("server listenning at port:" + server.getLocalPort());
			while(true){
				final Socket clientSocket = server.accept();
				System.out.println("client:" + clientSocket.getInetAddress().getHostAddress());
				new Thread(){
					public void run(){
						try {
							while(true){
								System.out.println("waiting for client command");
								InputStream is = clientSocket.getInputStream();
								System.out.println("\navailable:" + is.available());
								byte[] tempBuff = new byte[4];
								is.read(tempBuff);
								System.out.println(tempBuff[0] + "," + tempBuff[1] + "," + tempBuff[2] + "," + tempBuff[3]);
								int contentLength = ((tempBuff[0] << 24) & 0xff000000) + ((tempBuff[1] << 16) & 0xff0000) + ((tempBuff[2] >> 8)  & 0xff00) + (tempBuff[3] & 0xff);
								System.out.println("contentLength:" + contentLength);
								byte[] buff = new byte[contentLength];
								int readedLength = is.read(buff);
								if(readedLength == contentLength){
									System.out.println("data no error");
								}
								String string = new String(buff, "UTF-8").trim();
								System.out.println("command:" + string);
								if(string.toLowerCase().startsWith("exit")){
									break;
								}else{
									System.out.println("callback:" + string);
									OutputStream os = clientSocket.getOutputStream();
									buff = ("command:" + string).getBytes("UTF-8");
									byte []lengthBuff = new byte[4];
									lengthBuff[0] = (byte)((buff.length & 0xff0000) >> 24);
									lengthBuff[1] = (byte)((buff.length & 0xff0000) >> 16);
									lengthBuff[2] = (byte)((buff.length & 0xff00) >> 8);
									lengthBuff[3] = (byte) (buff.length & 0xff);
									os.write(lengthBuff);
									os.write(buff);
									os.flush();
								}
							}
							clientSocket.close();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}.start();
			}
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
