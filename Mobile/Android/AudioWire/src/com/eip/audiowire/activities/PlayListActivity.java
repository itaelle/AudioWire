package com.eip.audiowire.activities;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ListActivity;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;


import com.eip.audiowire.R;
import com.eip.audiowire.managers.LibraryManager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

/**
 * Created by Augustin on 21/01/14.
 */
public class PlayListActivity extends Activity {
    ListView lvListe;
//    TextView item;
    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.manage_playlist);

        lvListe = (ListView)findViewById(R.id.lvListe);
        String[] listeStrings = {"Detente","Disney","Soirée qui bouge", "Mes Favoris", "90's"};
        lvListe.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1,listeStrings));

        Intent intent = getIntent();
        if (intent != null)
        {
        	this.setListItemsClick();
        }
        	this.setListItemsClickEmpty();
    }

	private void setListItemsClickEmpty()
	{
		this.lvListe.setOnItemClickListener(new AdapterView.OnItemClickListener() 
		{
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				// TODO Auto-generated method stub
	           	 Intent intent = new Intent(PlayListActivity.this, LibraryActivity.class);
                 startActivity(intent);	
			}
			
		});
	}
    
	private void setListItemsClick()
	{
		this.lvListe.setOnItemClickListener(new AdapterView.OnItemClickListener() 
		{
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3)
			{
            	 Intent intent = new Intent(PlayListActivity.this, LibraryActivity.class);
             	Toast.makeText(getApplicationContext(), "Successfully added music to playlist", Toast.LENGTH_SHORT).show();
                 startActivity(intent);

			}
		});
		}
}