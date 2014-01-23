package com.eip.audiowire.managers;

import java.io.File;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.net.MailTo;
import android.util.Log;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.eip.audiowire.activities.AudioWireMainActivity;
import com.eip.audiowire.activities.Friends;
import com.eip.audiowire.tools.AWRequester;

public class UserManager
{
	private String AWfilenameUser = "audiowire_autologin";

	public String connectedUserToken;
	private String connectedUserID;
	private HashMap<String, String> userConnectedModel; 


	private static UserManager _instance;
	public static UserManager getInstance()
	{
		if (_instance == null)
			_instance = new UserManager();
		return _instance;
	}

	public UserManager()
	{ }

	public void logout(Context context)
	{
		if (this.connectedUserToken == null || this.connectedUserToken.length() == 0)
		{
			Log.i("AUDIOWIRE", "User not connected, bad token!");
			return ;
		}
		String url = "/api/users/logout?token=" + this.connectedUserToken;
		AWRequester.getInstance(context).deleteAWApi(url, new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject response)
			{
				Boolean success;
				try
				{
					success = response.getBoolean("success");
					if (success)
					{
						Log.i("AUDIOWIRE", "Logout success");
					}
					else
					{
						Log.i("AUDIOWIRE", "Logout failed");
					}
				}
				catch (JSONException e)
				{
					e.printStackTrace();
				}
			}
		}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) 
			{
				Log.i("AUDIOWIRE", "Logout failed");
			}
		});
	}
	
	public void subscribe(final HashMap<String, String> userToCreate, final Context context) throws JSONException
	{
		JSONObject toSend = new JSONObject();
		toSend.put("user", new JSONObject(userToCreate));
		String url = "/api/users";

		Log.i("AUDIOWIRE", "ABOUT TO SEND REQUEST : " + url);
		AWRequester.getInstance(context).postAWApi(url, toSend, new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject response)
			{
				Boolean success;
				try
				{
					success = response.getBoolean("success");
					if (success)
					{
						Log.i("AUDIOWIRE", "onSuccess LOGIN");
						UserManager.getInstance().connectedUserID = response.getString("id");
						UserManager.getInstance().connectedUserToken = response.getString("token");

						if (UserManager.getInstance().connectedUserToken.length() > 0)
						{
							// Write to file
							HashMap<String, String> userToWrite = new HashMap<String, String>();
							userToWrite.put("email", (String) userToCreate.get("email"));
							userToWrite.put("password", (String) userToCreate.get("password"));
							UserManager.getInstance().writeToFile(context, userToWrite);
							
							UserManager.getInstance().getUserConnected(context);
							Log.i("AUDIOWIRE", "Token :" + UserManager.getInstance().connectedUserToken);
						}
					}
					else
					{
						System.out.print("NO SUCESS SUBSCRIBE");
						// Pop up Something went wrong while attempting to retrieve data from the AudioWire - API
					}
				}
				catch (JSONException e)
				{
					e.printStackTrace();
				}
			}
		}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) 
			{
                String responseBody = null;
				Boolean success;
				JSONObject response = null;

				try {
					responseBody = new String(error.networkResponse.data, "utf-8" );
				} catch (UnsupportedEncodingException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try {
					response = new JSONObject(responseBody);
				} catch (JSONException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try
				{
					Log.i("AUDIOWIRE", "onFailure SUBSCRIBE");
					success = response.getBoolean("success");
					if (!success)
					{
						if (response.has("message"))
						{
							String message = response.getString("message");
							if (message.length() > 0)
							{
								// POP up message
								Log.i("AUDIOWIRE", "onFailure SUBSCRIBE = " + message);
							}
						}
						else if (response.has("error"))
						{
							String errorReturned = response.getString("error");

							if (errorReturned != null && errorReturned.length() > 0)
							{
								// POP up error
								Log.i("AUDIOWIRE", "onFailure SUBSCRIBE = " + errorReturned);
							}
						}
						else
						{
							Log.i("AUDIOWIRE", "onFailure SUBSCRIBE = " + "Something went wrong while attempting to retrieve data from the AudioWire - API");
							// POP up "Something went wrong while attempting to retrieve data from the AudioWire - API"
						}
					}
				}
				catch (JSONException e1)
				{
					e1.printStackTrace();
				}
			}
		});
	}

	public void login(final HashMap<String, String> userModel, final Friends activity)
	{
		JSONObject toSend = new JSONObject(userModel);
		String url = "/api/users/login";
		
		AWRequester.getInstance(activity.getApplicationContext()).postAWApi(url, toSend, new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject response)
			{
				Boolean success;
				try
				{
					success = response.getBoolean("success");
					if (success)
					{
						Log.i("AUDIOWIRE", "onSuccess LOGIN");
						UserManager.getInstance().connectedUserToken = response.getString("token");

						if (UserManager.getInstance().connectedUserToken.length() > 0)
						{
							// Write to file
							Log.i("AUDIOWIRE", "Token :" + UserManager.getInstance().connectedUserToken);
							UserManager.getInstance().writeToFile(activity.getApplicationContext(), userModel);
							UserManager.getInstance().getUserConnected(activity.getApplicationContext());
							activity.didLoggedIn("You are now connected!");
						}
					}
					else
					{
						activity.didLoggedIn("Something went wrong while attempting to retrieve data from the AudioWire - API");
						System.out.print("NO SUCESS LOGIN");
						// Pop up Something went wrong while attempting to retrieve data from the AudioWire - API
					}
				}
				catch (JSONException e)
				{
					e.printStackTrace();
				}
			}
			
		}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) 
			{
				String responseBody = null;
				Boolean success;
				JSONObject response = null;

				try {
					responseBody = new String(error.networkResponse.data, "utf-8" );
				} catch (UnsupportedEncodingException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try {
					response = new JSONObject(responseBody);
				} catch (JSONException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try
				{
					Log.i("AUDIOWIRE", "onFailure LOGIN");
					success = response.getBoolean("success");
					if (!success)
					{
						if (response.has("message"))
						{
							String message = response.getString("message");
							if (message.length() > 0)
							{
								// POP up message
								activity.didLoggedIn(message);
								Log.i("AUDIOWIRE", "onFailure LOGIN = " + message);
							}
						}
						else if (response.has("error"))
						{
							String errorReturned = response.getString("error");

							if (errorReturned != null && errorReturned.length() > 0)
							{
								// POP up error
								activity.didLoggedIn(errorReturned);
								Log.i("AUDIOWIRE", "onFailure LOGIN = " + errorReturned);
							}
						}
						else
						{
							activity.didLoggedIn("Something went wrong while attempting to retrieve data from the AudioWire - API");
							Log.i("AUDIOWIRE", "onFailure LOGIN = " + "Something went wrong while attempting to retrieve data from the AudioWire - API");
							// POP up "Something went wrong while attempting to retrieve data from the AudioWire - API"
						}
					}
				}
				catch (JSONException e1)
				{
					e1.printStackTrace();
				}
			}
		});
	}

	public void getUserConnected(Context context)
	{
		if (this.connectedUserToken == null || this.connectedUserToken.length() == 0)
		{
			Log.i("AUDIOWIRE", "User not connected, bad token!");
			return ;
		}
		String url = "/api/users/me?token=" + this.connectedUserToken;
		
		AWRequester.getInstance(context).getAWApi(url, new Response.Listener<JSONObject>() {
			
			@Override
			public void onResponse(JSONObject response)
			{
				Boolean success;
				try
				{
					Log.i("AUDIOWIRE", "onResponse GETUSERCONNECTED ");
					success = response.getBoolean("success");
					JSONObject user = (JSONObject) response.get("user");
					if (success && user != null)
					{
						HashMap<String, String> userHashMap = new HashMap<String, String>();

						if (user.has("email"))
							userHashMap.put("email", user.getString("email"));
						if (user.has("id"))
							userHashMap.put("id", user.getString("id"));
						if (user.has("first_name"))
							userHashMap.put("first_name", user.getString("first_name"));
						if (user.has("last_name"))
							userHashMap.put("last_name", user.getString("last_name"));
						if (user.has("username"))
							userHashMap.put("username", user.getString("username"));
						
						UserManager.getInstance().userConnectedModel = userHashMap;
						
						Log.i("AUDIOWIRE",userHashMap.toString());
					}
				}
				catch (JSONException e)
				{
					e.printStackTrace();
				}

			}
		}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) 
			{
				Log.i("AUDIOWIRE", "onFailure GETUSERCONNECTED = " + error.toString());

				String responseBody = null;
				Boolean success;
				JSONObject response = null;

				try {
					responseBody = new String(error.networkResponse.data, "utf-8" );
				} catch (UnsupportedEncodingException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try {
					response = new JSONObject(responseBody);
				} catch (JSONException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try
				{
					Log.i("AUDIOWIRE", "onFailure SUBSCRIBE");
					success = response.getBoolean("success");
					if (!success)
					{
					}
				}
				catch (JSONException e1)
				{
					e1.printStackTrace();
				}
			}
		});
	}

	private void writeToFile(Context context, HashMap<String,String> userToCreate)
	{
		FileOutputStream outputStream;
		try
		{
			/*File file = new File(AWfilenameUser);
			if (!file.exists())
			{
				if (!file.createNewFile())
				{
					return ;
				}
			}*/
			//context.getFilesDir().getPath()+ "/" + 
			outputStream = context.openFileOutput(this.AWfilenameUser, Context.MODE_PRIVATE);
			ObjectOutputStream out = new ObjectOutputStream(outputStream);
			out.writeObject(userToCreate);
			Log.i("AUDIOWIRE", "Write to file : " + userToCreate.toString());
			outputStream.close();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}		
	}
}
