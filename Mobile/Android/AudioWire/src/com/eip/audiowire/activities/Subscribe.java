package com.eip.audiowire.activities;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;

import com.eip.audiowire.R;
import android.app.Activity;
import android.graphics.Typeface;
import android.os.Bundle;
import com.eip.audiowire.R;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

/**
 * Created by Augustin on 21/01/14.
*/

public class Subscribe extends Activity
{
    private TextView termsText;
    private EditText email;
    private EditText pw;
    private EditText nickname;
    private EditText first_name;
    private EditText last_name;
    private ImageButton subscribe;

    final String EXTRA_LOGIN = "user_login";
    final String EXTRA_PASSWORD = "user_password";
    final String EXTRA_FIRST_NAME = "user_first_name";
    final String EXTRA_LAST_NAME = "user_last_name";
    final String EXTRA_NICKNAME = "user_nickname";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

        setContentView(R.layout.subscribe);
        termsText = (TextView) findViewById(R.id.termsString);
        pw = (EditText) findViewById(R.id.pw);
        email = (EditText) findViewById(R.id.email);
        first_name = (EditText) findViewById(R.id.first_name);
        last_name = (EditText) findViewById(R.id.last_name);
        nickname = (EditText) findViewById(R.id.nickname);

        Typeface font = Typeface.createFromAsset(getAssets(), "Futura-Bold.otf");
        termsText.setTypeface(font);
        pw.setTypeface(font);
        email.setTypeface(font);
        first_name.setTypeface(font);
        nickname.setTypeface(font);
        last_name.setTypeface(font);


        final CheckBox terms = (CheckBox) findViewById(R.id.terms);
        if (terms.isChecked()) {
            terms.setChecked(false);
        }

        subscribe = (ImageButton) findViewById(R.id.subscribe);
        subscribe.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Subscribe.this, AudioWireMainActivity.class);
                intent.putExtra(EXTRA_LOGIN, email.getText().toString());
                intent.putExtra(EXTRA_PASSWORD, pw.getText().toString());
                intent.putExtra(EXTRA_FIRST_NAME, first_name.getText().toString());
                intent.putExtra(EXTRA_LAST_NAME, last_name.getText().toString());
                intent.putExtra(EXTRA_NICKNAME, nickname.getText().toString());
                Toast.makeText(getApplicationContext(), "Congratulation! You've created your account within the AudioWire. Now enjoy the features our brain new music player. ", Toast.LENGTH_LONG).show();
                startActivity(intent);
            }
        });

    }

}
