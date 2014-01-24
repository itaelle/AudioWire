package com.eip.audiowire.activities;

import java.util.ArrayList;
import java.util.HashMap;

import com.eip.audiowire.R;
import com.eip.audiowire.R.layout;
import com.eip.audiowire.controllers.AudiowireMusicPlayer;
import com.eip.audiowire.tools.Utilities;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;
import android.widget.SeekBar;
import android.widget.TextView;

public class AudioWireMainActivity extends Activity implements SeekBar.OnSeekBarChangeListener {

	private ImageButton library;
    private ImageButton friends;
    private ImageButton playlist;
    private ImageButton options;
    
    private ImageButton btnPlay;
	private ImageButton btnNext;
	private ImageButton btnPrevious;
	private ImageButton btnRepeat;
	private ImageButton btnShuffle;
	private SeekBar songProgressBar;
	private TextView songTitleLabel;
	private TextView songCurrentDurationLabel;
	private TextView songTotalDurationLabel;
	 
	// Media Player
	// private  MediaPlayer mp;
	
	// NEW
	private AudiowireMusicPlayer AWmusicPlayer;
	
	private Handler mHandler = new Handler();;
	// private LibraryManager songManager;
	private Utilities utils;
//	private int seekForwardTime = 5000; // 5000 milliseconds
//	private int seekBackwardTime = 5000; // 5000 milliseconds
//	private int currentSongIndex = 0; 
	private ArrayList<HashMap<String, String>> songsList = new ArrayList<HashMap<String, String>>();
	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(layout.home);

		btnPlay = (ImageButton) findViewById(R.id.btnPlay);
		btnNext = (ImageButton) findViewById(R.id.btnNext);
		btnPrevious = (ImageButton) findViewById(R.id.btnPrevious);
		// btnPlaylist = (ImageButton) findViewById(R.id.btnPlaylist);
		btnRepeat = (ImageButton) findViewById(R.id.btnRepeat);
		btnShuffle = (ImageButton) findViewById(R.id.btnShuffle);
		songProgressBar = (SeekBar) findViewById(R.id.songProgressBar);
		songTitleLabel = (TextView) findViewById(R.id.songTitle);
		songCurrentDurationLabel = (TextView) findViewById(R.id.songCurrentDurationLabel);
		songTotalDurationLabel = (TextView) findViewById(R.id.songTotalDurationLabel);

		AWmusicPlayer = AudiowireMusicPlayer.getInstance(); 
		this.addListenerOnButton();

        Typeface font = Typeface.createFromAsset(getAssets(), "Futura-Bold.otf");
        songTitleLabel.setTypeface(font);
        songCurrentDurationLabel.setTypeface(font);
        songTotalDurationLabel.setTypeface(font);

//		songManager = new LibraryManager();

        // NEEDED FOR VIEWS
        utils = new Utilities();
        songProgressBar.setOnSeekBarChangeListener(this);

//		songsList = songManager.getPlayList();
//		
//        // By default play first song
////		playSong(0);
		songProgressBar.setProgress(0);
		btnPlay.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View arg0)
			{
				if (AWmusicPlayer.isPlaying())
				{
					AWmusicPlayer.pause();
					btnPlay.setImageResource(R.drawable.btn_play);
				}
				else
				{
					if (AWmusicPlayer.play() == true)
					{
						songProgressBar.setVisibility(View.VISIBLE);
						songTitleLabel.setVisibility(View.VISIBLE);
						songTotalDurationLabel.setVisibility(View.VISIBLE);
						songCurrentDurationLabel.setVisibility(View.VISIBLE);
						
						btnPlay.setImageResource(R.drawable.btn_pause);
						AudioWireMainActivity.this.didStartPlaying(AWmusicPlayer.getCurrentTrackPlaying());
					}
				}
			}
		});
		btnNext.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View arg0)
			{
				AWmusicPlayer.next();
				AudioWireMainActivity.this.didStartPlaying(AWmusicPlayer.getCurrentTrackPlaying());
			}
		});
		btnPrevious.setOnClickListener(new View.OnClickListener()
		{			
			@Override
			public void onClick(View arg0)
			{
				AWmusicPlayer.prev();
				AudioWireMainActivity.this.didStartPlaying(AWmusicPlayer.getCurrentTrackPlaying());
			}
		});
		btnRepeat.setOnClickListener(new View.OnClickListener()
		{
			@Override
			public void onClick(View arg0)
			{
				if (AWmusicPlayer.isRepeat)
				{
					AWmusicPlayer.isRepeat = false;
					btnRepeat.setImageResource(R.drawable.btn_repeat);
				}
				else
				{
					AWmusicPlayer.isRepeat = true;
					AWmusicPlayer.isShuffle = false;
					btnRepeat.setImageResource(R.drawable.btn_repeat_focused);
					btnShuffle.setImageResource(R.drawable.btn_shuffle);
				}	
			}
		});
		btnShuffle.setOnClickListener(new View.OnClickListener()
		{
			@Override
			public void onClick(View arg0)
			{
				if (AWmusicPlayer.isShuffle)
				{
					AWmusicPlayer.isShuffle = false;
					btnShuffle.setImageResource(R.drawable.btn_shuffle);
				}
				else
				{
					AWmusicPlayer.isShuffle= true;
					AWmusicPlayer.isRepeat = false;
					btnShuffle.setImageResource(R.drawable.btn_shuffle_focused);
					btnRepeat.setImageResource(R.drawable.btn_repeat);
				}	
			}
		});
//		
//		/**
//		 * Button Click event for Play list click event
//		 * Launches list activity which displays list of songs
//		 * */
//		btnPlaylist.setOnClickListener(new View.OnClickListener() {
//			
//			@Override
//			public void onClick(View arg0) {
//				Intent i = new Intent(getApplicationContext(), PlayListActivity.class);
//				startActivityForResult(i, 100);			
//			}
//		});
		
	}
	
	@Override
	public void onResume()
	{
		super.onResume();
		if (AWmusicPlayer.isPlaying())
		{
			songProgressBar.setVisibility(View.VISIBLE);
			songTitleLabel.setVisibility(View.VISIBLE);
			songTotalDurationLabel.setVisibility(View.VISIBLE);
			songCurrentDurationLabel.setVisibility(View.VISIBLE);
			
			
			Log.w("AUDIOWIRE", "RESUME is playing");
			AudioWireMainActivity.this.didStartPlaying(AWmusicPlayer.getCurrentTrackPlaying());
			btnPlay.setImageResource(R.drawable.btn_pause);
		}
		else
		{
			songTitleLabel.setVisibility(View.GONE);
			songTotalDurationLabel.setVisibility(View.GONE);
			songCurrentDurationLabel.setVisibility(View.GONE);
			songProgressBar.setVisibility(View.GONE);
			
			Log.w("AUDIOWIRE", "RESUME is not playing");
			btnPlay.setImageResource(R.drawable.btn_play);
		}
	}

	
//	@Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        if(resultCode == 100){
//         	 currentSongIndex = data.getExtras().getInt("songIndex");
//         	 // play selected song
//             playSong(currentSongIndex);
//        }
//    }
	
	public void  didStartPlaying(String songToPlay)
	{
		songTitleLabel.setText(songToPlay);
		btnPlay.setImageResource(R.drawable.btn_pause);
		songProgressBar.setMax(100);
		updateProgressBar();
	}
	
	public void updateProgressBar()
	{
        mHandler.postDelayed(mUpdateTimeTask, 100);        
    }

	private Runnable mUpdateTimeTask = new Runnable()
	{
		   public void run()
		   {
			   long totalDuration = AWmusicPlayer.getDuration();
			   long currentDuration = AWmusicPlayer.getCurrentPosition();
			  
			   songTotalDurationLabel.setText("" + utils.milliSecondsToTimer(totalDuration));
			   songCurrentDurationLabel.setText("" + utils.milliSecondsToTimer(currentDuration));
			   
			   int progress = (int)(utils.getProgressPercentage(currentDuration, totalDuration));
			   songProgressBar.setProgress(progress);
		       mHandler.postDelayed(this, 100);
		   }
		};
		
	@Override
	public void onProgressChanged(SeekBar seekBar, int progress, boolean fromTouch)
	{
		Log.i("PROGRESSBAR", "progressChanged " + progress);
	}

	@Override
	public void onStartTrackingTouch(SeekBar seekBar)
	{
		mHandler.removeCallbacks(mUpdateTimeTask);
    }
	
	@Override
    public void onStopTrackingTouch(SeekBar seekBar)
	{
		mHandler.removeCallbacks(mUpdateTimeTask);
		int totalDuration = AWmusicPlayer.getDuration();
		int currentPosition = utils.progressToTimer(seekBar.getProgress(), totalDuration);
		AWmusicPlayer.seekTo(currentPosition);
		updateProgressBar();
    }

    public void addListenerOnButton()
    {
    	library = (ImageButton) findViewById(R.id.imageButton);
        friends = (ImageButton) findViewById(R.id.imageButton2);
        playlist = (ImageButton) findViewById(R.id.imageButton3);
        options = (ImageButton) findViewById(R.id.imageButton4);

        library.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View arg0) {

                Intent intent = new Intent(AudioWireMainActivity.this, LibraryActivity.class);
                startActivity(intent);
            }

        });
        friends.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View arg0) {

                Intent intent = new Intent(AudioWireMainActivity.this, Friends.class);
                startActivity(intent);
            }

        });
        playlist.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View arg0) {

                Intent intent = new Intent(AudioWireMainActivity.this, LibraryActivity.class);
                startActivity(intent);
            }

        });
        options.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View arg0) {

                Intent intent = new Intent(AudioWireMainActivity.this, Option.class);
                startActivity(intent);
            }
        });
    }

    @Override
    public void onBackPressed()
    {

    	AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
 
			// set title
			alertDialogBuilder.setTitle("Quit?");
 
			// set dialog message
			alertDialogBuilder
				.setMessage("Really quit AudioWire?")
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
						AudioWireMainActivity.this.finish();
					}
				  });

 
				// create alert dialog
				AlertDialog alertDialog = alertDialogBuilder.create();
		    	alertDialog.setIcon(R.drawable.logo_audiowire_icon);

				// show it
				alertDialog.show();
    }				
}