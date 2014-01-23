package com.eip.audiowire.tools;

import java.io.IOException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.util.Log;

//import com.loopj.android.http.*;
import com.android.volley.*;
import com.android.volley.Response.ErrorListener;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

public class AWRequester
{
	//private static AsyncHttpClient client = new AsyncHttpClient();
	private RequestQueue queue;
	private static final String BASEURL_API = "https://audiowire.co";

	// Singleton
	private static AWRequester _instance;
    public static AWRequester getInstance(Context context)
    {
        if (_instance == null)
            _instance = new AWRequester(context);
        return _instance;
    }

	public AWRequester(Context context)
	{
		queue = Volley.newRequestQueue(context);
	}

	private String getAbsoluteUrl(String relativeUrl)
	{
	      return BASEURL_API + relativeUrl;
	}
	
	public void postAWApi(String urlController, JSONObject toSend, Response.Listener<JSONObject> successListener, Response.ErrorListener errorListener)
	{
		JsonObjectRequest jsobjrequest = new JsonObjectRequest(Request.Method.POST, this.getAbsoluteUrl(urlController), toSend, successListener, errorListener);
		queue.add(jsobjrequest);
	}

	public void getAWApi(String urlController, Response.Listener<JSONObject> successListener, Response.ErrorListener errorListener)
	{
		JsonObjectRequest jsobjrequest = new JsonObjectRequest(Request.Method.GET, this.getAbsoluteUrl(urlController), null, successListener, errorListener);
		queue.add(jsobjrequest);
	}
	
	public void deleteAWApi(String urlController, Response.Listener<JSONObject> successListener, Response.ErrorListener errorListener)
	{
		JsonObjectRequest jsobjrequest = new JsonObjectRequest(Request.Method.DELETE, this.getAbsoluteUrl(urlController), null, successListener, errorListener);
		queue.add(jsobjrequest);
	}
}
