package com.eip.audiowire.activities;

import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;
import android.app.AlertDialog;






import com.eip.audiowire.R;
import com.eip.audiowire.managers.UserManager;

/**
 * Created by Augustin on 21/01/14.
 */
public class Option  extends Activity {

    private ImageButton signin;
    private ImageButton subscribe;
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.option);

        signin = (ImageButton) findViewById(R.id.signin);
        subscribe = (ImageButton) findViewById(R.id.subscribe);

        signin.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v)
            {
            	Intent intent = new Intent(Option.this, Friends.class);
                startActivity(intent);

            }
        });

        subscribe.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v)
            {
            	Intent intent = new Intent(Option.this, Friends.class);
                startActivity(intent);

            }
        });
    }
}
