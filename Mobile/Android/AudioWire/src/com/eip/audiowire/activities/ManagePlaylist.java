package com.eip.audiowire.activities;

import android.app.Activity;
import android.app.ListActivity;
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
public class ManagePlaylist extends Activity {
    ListView lvListe;
//    TextView item;
    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.manage_playlist);

        lvListe = (ListView)findViewById(R.id.lvListe);

        String[] listeStrings = {"Playlist1","rock","Soirée"};
//
//        lvListe.setAdapter(new ArrayAdapter<String>(this,
//                R.layout.manage_playlist, R.id.item, new String[] { " First",  " Second", " Third", " Fourth", " Fifth", " Sixth"}));

//        Typeface font = Typeface.createFromAsset(getAssets(), "Futura-Bold.otf");
//        lvListe.setTypeface(font);

//        TextView item = (TextView) findViewById(R.id.item);
        lvListe.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1,listeStrings));

    }
}
