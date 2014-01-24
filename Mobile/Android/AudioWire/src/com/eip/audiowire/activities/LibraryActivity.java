package com.eip.audiowire.activities;

import java.util.ArrayList;
import java.util.HashMap;

import com.eip.audiowire.R;
import com.eip.audiowire.R.id;
import com.eip.audiowire.R.layout;
import com.eip.audiowire.controllers.AudiowireMusicPlayer;
import com.eip.audiowire.managers.LibraryManager;
import com.eip.audiowire.views.MusicAdapter;

import android.app.Activity;
import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ImageButton;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.SimpleAdapter;

public class LibraryActivity extends Activity
{
	private AudiowireMusicPlayer AWMusicPlayer;
	private LibraryManager libManager;
	private ArrayList<HashMap<String, String>> musicsLibrary;
	
	private ListView listMusic;
	private ImageButton select;
	private ImageButton delete;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.music_list);
		
		AWMusicPlayer = AudiowireMusicPlayer.getInstance();
		libManager = LibraryManager.getInstance();
		musicsLibrary = libManager.scanForMusicFiles(this.getApplicationContext());
		
		this.listMusic = (ListView) this.findViewById(R.id.listMusic);
		this.listMusic.setAdapter(new MusicAdapter(this.getApplicationContext(), musicsLibrary));
		
		
        this.setTopButton();
        this.setListItemsClick();
	}
	
	private void setListItemsClick()
	{
		this.listMusic.setOnItemClickListener(new AdapterView.OnItemClickListener()
		{
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3)
			{
				Log.i("AUDIOWIRE", "Try to play at " + arg2);
				AWMusicPlayer.setListToPlayAndPlayAtIndex(LibraryActivity.this.musicsLibrary, arg2);
			}
		});
	}
	
	private void setTopButton()
	{
        delete = (ImageButton) findViewById(R.id.delete);
        select = (ImageButton) findViewById(R.id.select);
        select.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v) 
            {
            	
            }
        });
        delete.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v) 
            {
            	
            }
        });
	}
}
