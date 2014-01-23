package com.eip.audiowire.activities;

import android.app.Activity;
import android.graphics.Typeface;
import android.os.Bundle;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

import com.eip.audiowire.R;
import android.app.Activity;
import android.graphics.Typeface;
import android.os.Bundle;
import com.eip.audiowire.R;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

/**
 * Created by Augustin on 21/01/14.
 */

public class Subscribe extends Activity {
    private TextView or;
    private EditText email;
    private EditText pw;
    private Button go;
    private Button subscribe;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.subscribe);

        final CheckBox male = (CheckBox) findViewById(R.id.male);
        if (male.isChecked()) {
            male.setChecked(false);
        }

        final CheckBox female = (CheckBox) findViewById(R.id.female);
        if (female.isChecked()) {
            female.setChecked(false);
        }
    }

}
