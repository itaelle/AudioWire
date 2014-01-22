package com.eip.audiowire.activities;

import android.app.Activity;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.ImageButton;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import com.eip.audiowire.R;
import com.eip.audiowire.managers.LibraryManager;
import com.eip.audiowire.tools.Utilities;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import android.media.MediaPlayer.OnCompletionListener;


/**
 * Created by Augustin on 20/01/14.
 */
public class Home extends Activity implements OnCompletionListener, SeekBar.OnSeekBarChangeListener  {
    private ImageButton library;
    private ImageButton friends;
    private ImageButton playlist;
    private ImageButton options;


    private ImageButton btnPlay;
    private ImageButton btnForward;
    private ImageButton btnBackward;
    private ImageButton btnNext;
    private ImageButton btnPrevious;
    private ImageButton btnPlaylist;
    private ImageButton btnRepeat;
    private ImageButton btnShuffle;
    private SeekBar songProgressBar;
    private TextView songTitleLabel;
    private TextView songCurrentDurationLabel;
    private TextView songTotalDurationLabel;
    // Media Player
    private MediaPlayer mp;
    // Handler to update UI timer, progress bar etc,.
    private Handler mHandler = new Handler();;
    private LibraryManager songManager;
    private Utilities utils;
    private int seekForwardTime = 5000; // 5000 milliseconds
    private int seekBackwardTime = 5000; // 5000 milliseconds
    private int currentSongIndex = 0;
    private boolean isShuffle = false;
    private boolean isRepeat = false;
    private ArrayList<HashMap<String, String>> songsList = new ArrayList<HashMap<String, String>>();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.home);

        addListenerOnButton();


    }

    public void addListenerOnButton() {

        library = (ImageButton) findViewById(R.id.imageButton);
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


    @Override
    public void onCompletion(MediaPlayer mediaPlayer) {

    }

    @Override
    public void onProgressChanged(SeekBar seekBar, int i, boolean b) {

    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {

    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {

    }
}
