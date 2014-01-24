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
import android.app.AlertDialog;
import android.app.ListActivity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
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
		this.listMusic.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() 
		{
			@Override
			public boolean onItemLongClick(AdapterView<?> arg0, View arg1,
					int arg2, long arg3)
			{		
		    	AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(LibraryActivity.this);
		    	 
				// set title
				alertDialogBuilder.setTitle("Add to playlist");
	 
				// set dialog message
				alertDialogBuilder
					.setMessage("Add song to playlist?")
					.setCancelable(true)
					.setNegativeButton("No",new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog,int id) {
							// if this button is clicked, just close
							// the dialog box and do nothing
							dialog.cancel();
						}
					})
					.setPositiveButton("Yes",new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog,int id) {
							// if this button is clicked, close
							// current activity
							LibraryActivity.this.finish();
						   Intent intent = new Intent(LibraryActivity.this, Option.class);
			                startActivity(intent);
						}
					  });

	 
					// create alert dialog
					AlertDialog alertDialog = alertDialogBuilder.create();
			    	alertDialog.setIcon(R.drawable.logo_audiowire_icon);

					// show it
					alertDialog.show();	
				return false;
			}
		});
		
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
