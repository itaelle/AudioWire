package com.eip.audiowire.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TextView;

import com.eip.audiowire.R;

/**
 * Created by Augustin on 21/01/14.
 */
public class Option  extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.option);

        Intent intent = getIntent();
//        TextView loginDisplay = (TextView) findViewById(R.id.email_display);
//        TextView passwordDisplay = (TextView) findViewById(R.id.password_display);

    }
}
