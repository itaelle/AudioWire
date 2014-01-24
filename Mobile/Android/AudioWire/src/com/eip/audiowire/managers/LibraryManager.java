package com.eip.audiowire.managers;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import android.content.Context;
import android.provider.MediaStore;
import android.util.Log;
import android.database.Cursor;

public class LibraryManager
{
	private String AWfilenameLibrary = "libraryAudiowireFile";
    private static LibraryManager _instance;

	public LibraryManager()
	{
	}

    public static LibraryManager getInstance()
    {
        if (_instance == null)
            _instance = new LibraryManager();
        return _instance;
    }

	public ArrayList<HashMap<String, String>> scanForMusicFiles(Context context)
	{
		// scan files and return them in a list
		String selection = MediaStore.Audio.Media.IS_MUSIC + " != 0";

		String[] projection = {
		        MediaStore.Audio.Media._ID,
		        MediaStore.Audio.Media.ARTIST,
		        MediaStore.Audio.Media.TITLE,
		        MediaStore.Audio.Media.DATA,
		        MediaStore.Audio.Media.DISPLAY_NAME,
		        MediaStore.Audio.Media.DURATION,
		        MediaStore.Audio.Media.ALBUM
		};

		Cursor cursor = context.getContentResolver().query(
		        MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
		        projection,
		        selection,
		        null,
		        null);

		ArrayList<HashMap<String, String>> songs = new ArrayList<HashMap<String, String>>();
		while (cursor.moveToNext())
		{
			String fromCursor = cursor.getString(0) + "||" + cursor.getString(1) + "||" +   cursor.getString(2) + "||" +   cursor.getString(3) + "||" +  cursor.getString(4) + "||" +  cursor.getString(5);
			
			HashMap<String, String> track = new HashMap<String, String>();
			track.put("id", cursor.getString(0));
			track.put("artist", cursor.getString(1));
			track.put("title", cursor.getString(2));
			track.put("dataStream", cursor.getString(3));
			track.put("displayName", cursor.getString(4));
			track.put("duration", cursor.getString(5));
			track.put("album", cursor.getString(6));
			
			songs.add(track);
			//Log.i("IMPORT", fromCursor);
		}
		return songs;
	}

	public void importScannedTracksToFile(ArrayList<HashMap<String, String>> scannedFiles, Context context)
	{
		// store scanned files in a textFile (audiowireLibrary)
		FileOutputStream outputStream;

		try
		{
//		    File file = new File(AWfilenameLibrary);
//		    if (!file.exists())
//		    {
//		        if (!file.createNewFile())
//		        {
//		        	return ;
//		        }
//		    }
		  outputStream = context.openFileOutput(AWfilenameLibrary , Context.MODE_APPEND);
		  ObjectOutputStream out = new ObjectOutputStream(outputStream);
		  out.writeObject(scannedFiles);
		  outputStream.close();
		}
		catch (Exception e)
		{
		  e.printStackTrace();
		}
	}

	public ArrayList<HashMap<String, String>> getLocalLibrary(Context context)
	{
		// return musics from the textFile (audiowireLibrary)
		FileInputStream fis;

		try 
		{
//		    File file = new File(AWfilenameLibrary);
//		    if (!file.exists())
//		    {
//		        if (!file.createNewFile())
//		        {
//		        	return new ArrayList<HashMap<String, String>>();
//		        }
//		    }
		    fis = context.openFileInput(AWfilenameLibrary);
		    ObjectInputStream ois = new ObjectInputStream(fis);
		    ArrayList<HashMap<String, String>> returnlist = (ArrayList<HashMap<String, String>>) ois.readObject();
		    ois.close();
		    return returnlist;
		}
		catch (Exception e)
		{
		    e.printStackTrace();
		}
		return null;
	}

	public void deleteTracksInLibrary(ArrayList<HashMap<String, String>> tracksToDelete, Context context)
	{
		// delete tracks from local library
		ArrayList<HashMap<String, String>> library = this.getLocalLibrary(context);

		for (HashMap<String, String> element : tracksToDelete)
		{
			int index = -1;
			for (HashMap<String, String> track : library)
			{
				if (element.get("id").equals(track.get("id")))
					index = library.indexOf(track);
			}
			if (index != -1)
				library.remove(index);
		}
		this.importScannedTracksToFile(library, context);
	}
}
