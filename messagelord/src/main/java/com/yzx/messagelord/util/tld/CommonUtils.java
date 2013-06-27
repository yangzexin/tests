package com.yzx.messagelord.util.tld;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class CommonUtils {
	public static String urlEncode(String url) throws UnsupportedEncodingException{
		return URLEncoder.encode(url, "utf-8");
	}
}
