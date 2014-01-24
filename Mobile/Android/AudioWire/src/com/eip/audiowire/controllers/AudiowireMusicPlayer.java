package com.eip.audiowire.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import android.media.MediaPlayer;
import android.util.Log;

public class AudiowireMusicPlayer
{
	public boolean isShuffle = false;
	public boolean isRepeat = false;
	
	private int currentIndexPlaying;
	private ArrayList<HashMap<String, String>> listToPlay;
	private  MediaPlayer mp;
	
	private static AudiowireMusicPlayer _instance;
	public static AudiowireMusicPlayer getInstance()
	{
		if (_instance == null)
			_instance = new AudiowireMusicPlayer();
		return _instance;
	}

	public AudiowireMusicPlayer()
	{
		currentIndexPlaying = 0;
		mp = new MediaPlayer();
		mp.stop();
		mp.setOnCompletionListener(new MediaPlayer.OnCompletionListener()
		{
		    public void onCompletion(MediaPlayer mp)
		    {
		    	if (listToPlay == null)
		    	{
		    		Log.i("AUDIOWIRE", "EMPTY LIST IN PLAYER");
		    		return ;
		    	}
		    	if (AudiowireMusicPlayer.this.isRepeat)
		    	{
		    		HashMap<String, String> currentMusic = AudiowireMusicPlayer.this.getSongAtIndex(currentIndexPlaying);
		    		AudiowireMusicPlayer.this.playSong(currentMusic.get("dataStream"));
		    	}
		    	else if (AudiowireMusicPlayer.this.isShuffle)
		    	{
		    		if (listToPlay != null && listToPlay.size() > 0)
		    			AudiowireMusicPlayer.this.shuffle();
		    	}
		    	else
		    	{
		    		AudiowireMusicPlayer.this.next();
		    	}	
		    }
		});
	}
	
	public void setListToPlayAndPlayAtIndex(ArrayList<HashMap<String, String>> list, int index)
	{
		this.listToPlay = list;
		if (this.listToPlay != null && this.listToPlay.size() > index)
		{
			this.currentIndexPlaying = index;
    		HashMap<String, String> currentMusic = AudiowireMusicPlayer.this.getSongAtIndex(currentIndexPlaying);
    		AudiowireMusicPlayer.this.playSong(currentMusic.get("dataStream"));					
		}
	}
	
	private HashMap<String, String> getSongAtIndex(int index)
	{
		if (listToPlay.size() > index)
		{
			return listToPlay.get(index);
		}
		else
			return new HashMap<String, String>();
	}

	public String getCurrentTrackPlaying()
	{
		if (listToPlay != null && listToPlay.size() > currentIndexPlaying)
		{
			HashMap<String, String>musicPlaying = listToPlay.get(currentIndexPlaying);
			return musicPlaying.get("title");
		}
		return "";
	}
	
	public Boolean play()
	{
		if (this.canPlay())
		{
			mp.start();
			return true;
		}
		else
			return false;
	}
	
	public Boolean canPlay()
	{
		if (this.listToPlay == null || this.listToPlay.size() == 0)
			return false;
		else
			return true;
	}
	
	public void playSong(String dataStream)
	{
		try
		{
	    	mp.reset();
			mp.setDataSource(dataStream);
			mp.prepare();
		}
		catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		this.play();
	}
	
	public void pause()
	{
		mp.pause();
	}
	
	public void next()
	{
		if (currentIndexPlaying < (listToPlay.size() - 1))
		{
			currentIndexPlaying += 1;
    		HashMap<String, String> currentMusic = AudiowireMusicPlayer.this.getSongAtIndex(currentIndexPlaying);
    		AudiowireMusicPlayer.this.playSong(currentMusic.get("dataStream"));					
		}
		else
		{
			currentIndexPlaying = 0;
    		HashMap<String, String> currentMusic = AudiowireMusicPlayer.this.getSongAtIndex(currentIndexPlaying);
    		AudiowireMusicPlayer.this.playSong(currentMusic.get("dataStream"));					
		}
	}
	
	public void prev()
	{
		if (currentIndexPlaying > 0)
		{
			currentIndexPlaying -= 1;
    		HashMap<String, String> currentMusic = AudiowireMusicPlayer.this.getSongAtIndex(currentIndexPlaying);
    		AudiowireMusicPlayer.this.playSong(currentMusic.get("dataStream"));					
		}
		else
		{
			currentIndexPlaying = listToPlay.size() - 1;
    		HashMap<String, String> currentMusic = AudiowireMusicPlayer.this.getSongAtIndex(currentIndexPlaying);
    		AudiowireMusicPlayer.this.playSong(currentMusic.get("dataStream"));					
		}
	}

	public void shuffle()
	{
		Random rand = new Random();
		currentIndexPlaying = rand.nextInt((listToPlay.size() - 1) - 0 + 1) + 0;
		HashMap<String, String> currentMusic = AudiowireMusicPlayer.this.getSongAtIndex(currentIndexPlaying);
		AudiowireMusicPlayer.this.playSong(currentMusic.get("dataStream"));		    		
	}
	
	public void repeat()
	{
		
	}
	
	public int getDuration()
	{
		return mp.getDuration();
	}

	public int getCurrentPosition()
	{
		return mp.getCurrentPosition();
	}
	
	public void seekTo(int currentPosition)
	{
		mp.seekTo(currentPosition);
	}
	
	public Boolean isPlaying()
	{
		return mp.isPlaying();
	}
	
	public void finalize()
	{
		mp.release();
	}

}
