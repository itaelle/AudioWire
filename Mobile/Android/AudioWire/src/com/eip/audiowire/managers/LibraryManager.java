package com.eip.audiowire.managers;

import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;
import java.util.HashMap;

public class LibraryManager
{
	public LibraryManager()
	{
		
	}

	/* public ArrayList<HashMap<String, String>> scanForMusicFiles()
	{
		// scan files and return them in a list
	}

	public void importScannedFilesArrayList(<HashMap<String, String>> scannedFiles)
	{
		// store scanned files in a textFile (audiowireLibrary)
	}

	public ArrayList<HashMap<String, String>> getLocalLibrary()
	{
		// return musics from the textFile (audiowireLibrary)
	}

	public void deleteTracksInLibrary(ArrayList<HashMap<String, String>> tracksToDelete)
	{
		// delete tracks from local library		
	}
	*/

	
	
	// SDCard Path
	final String MEDIA_PATH = new String("/sdcard/Music");
	private ArrayList<HashMap<String, String>> songsList = new ArrayList<HashMap<String, String>>();
	
	
	/**
	 * Function to read all mp3 files from sdcard
	 * and store the details in ArrayList
	 * */
	public ArrayList<HashMap<String, String>> getPlayList(){
		File home = new File(MEDIA_PATH);

		if (home.listFiles(new FileExtensionFilter()).length > 0) {
			for (File file : home.listFiles(new FileExtensionFilter())) {
				HashMap<String, String> song = new HashMap<String, String>();
				song.put("songTitle", file.getName().substring(0, (file.getName().length() - 4)));
				song.put("songPath", file.getPath());
				
				// Adding each song to SongList
				songsList.add(song);
			}
		}
		// return songs list array
		return songsList;
	}
	
	/**
	 * Class to filter files which are having .mp3 extension
	 * */
	class FileExtensionFilter implements FilenameFilter {
		public boolean accept(File dir, String name) {
			return (name.endsWith(".mp3") || name.endsWith(".MP3"));
		}
	}
}
