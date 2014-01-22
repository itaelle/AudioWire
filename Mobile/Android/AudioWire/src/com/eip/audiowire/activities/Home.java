package com.eip.audiowire.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.ImageButton;
import android.widget.Toast;

import com.eip.audiowire.R;


/**
 * Created by Augustin on 20/01/14.
 */
public class Home extends Activity {
    private ImageButton library;
    private ImageButton friends;
    private ImageButton playlist;
    private ImageButton options;


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.home);

        addListenerOnButton();

    }

    public void addListenerOnButton() {

//        library = (ImageButton) findViewById(R.id.imageButton);
        friends = (ImageButton) findViewById(R.id.imageButton2);
        playlist = (ImageButton) findViewById(R.id.imageButton3);
        options = (ImageButton) findViewById(R.id.imageButton4);

        library.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View arg0) {

                Intent intent = new Intent(Home.this, PlayListActivity.class);
                startActivity(intent);
                Toast.makeText(Home.this,
                        "ImageButton is clicked! library", Toast.LENGTH_SHORT).show();
            }

        });

        friends.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View arg0) {

                Intent intent = new Intent(Home.this, Friends.class);
                startActivity(intent);
                Toast.makeText(Home.this,
                        "ImageButton is clicked! friends", Toast.LENGTH_SHORT).show();
            }

        });

        playlist.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View arg0) {

                Intent intent = new Intent(Home.this, ManagePlaylist.class);
                startActivity(intent);
                Toast.makeText(Home.this,
                        "ImageButton is clicked! playlist", Toast.LENGTH_SHORT).show();
            }

        });

        options.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View arg0) {

                Intent intent = new Intent(Home.this, Option.class);
                startActivity(intent);
                Toast.makeText(Home.this,
                        "ImageButton is clicked option!", Toast.LENGTH_SHORT).show();
            }

        });

    }

}
