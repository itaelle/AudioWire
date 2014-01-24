package com.eip.audiowire.activities;

import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.eip.audiowire.R;
import android.app.Activity;
import android.graphics.Typeface;
import android.os.Bundle;
import com.eip.audiowire.R;
import com.eip.audiowire.managers.UserManager;

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
    private ProgressBar spinner;
    private WebView myWebViewCGU;

    final String EXTRA_LOGIN = "user_login";
    final String EXTRA_PASSWORD = "user_password";
    final String EXTRA_FIRST_NAME = "user_first_name";
    final String EXTRA_LAST_NAME = "user_last_name";
    final String EXTRA_NICKNAME = "user_nickname";

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

        setContentView(R.layout.subscribe);
        termsText = (TextView) findViewById(R.id.termsString);
        pw = (EditText) findViewById(R.id.pw);
        email = (EditText) findViewById(R.id.email);
        first_name = (EditText) findViewById(R.id.first_name);
        last_name = (EditText) findViewById(R.id.last_name);
        nickname = (EditText) findViewById(R.id.nickname);
        spinner = (ProgressBar) findViewById(R.id.progressBar2);
        myWebViewCGU = (WebView) findViewById(R.id.webview);
        
        spinner.setVisibility(View.GONE);
        myWebViewCGU.setVisibility(View.GONE);
        
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
        
        final TextView termsString =  (TextView) findViewById(R.id.termsString);
        termsString.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v)
			{
				myWebViewCGU.setVisibility(View.VISIBLE);
				myWebViewCGU.loadUrl("https://audiowire.co/terms");
			}
		});

        subscribe = (ImageButton) findViewById(R.id.subscribe);
        subscribe.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v)
            {
            	String emailStr = email.getText().toString();
            	String pwdStr = pw.getText().toString();
            	String usernameStr = nickname.getText().toString();
            	String last_nameStr = last_name.getText().toString();
            	String first_nameStr = first_name.getText().toString();
            	
                Pattern p = Pattern.compile(".+@.+\\.[a-z]+");
                Matcher m = p.matcher(emailStr);

                if (emailStr.equals("") || pwdStr.equals("") || usernameStr.equals("")) {
                    Toast.makeText(getApplicationContext(), "Please fill all fields", Toast.LENGTH_SHORT).show();
                    return;
                }
                else if (!m.matches()) {
                    Toast.makeText(getApplicationContext(), "Please check your e-mail", Toast.LENGTH_SHORT).show();
                    return;
                }
                
                if (terms.isChecked() == false)
                {
                	Toast.makeText(getApplicationContext(), "Please read the terms and conditions", Toast.LENGTH_SHORT).show();
                    return;
                }

            	spinner.setVisibility(View.VISIBLE);
            	
            	HashMap<String, String> userToCreate = new HashMap<String, String>(); 
            	userToCreate.put("email", emailStr);
            	userToCreate.put("password", pwdStr);
            	userToCreate.put("username", usernameStr);
            	userToCreate.put("first_name", first_nameStr);
            	userToCreate.put("last_name", last_nameStr);
            	
            	UserManager.getInstance().subscribe(userToCreate, Subscribe.this);
            }
        });
    }
    
    public void didSubscribed(String messageToDisplay, Boolean success)
    {
    	spinner.setVisibility(View.GONE);

        if (success)
        {
            Toast.makeText(getApplicationContext(), "Congratulation! You've created your account within the AudioWire. Now enjoy the features our brain new music player.", Toast.LENGTH_LONG).show();

            Intent intent = new Intent(Subscribe.this, AudioWireMainActivity.class);
            intent.putExtra(EXTRA_LOGIN, email.getText().toString());
            intent.putExtra(EXTRA_PASSWORD, pw.getText().toString());
            intent.putExtra(EXTRA_FIRST_NAME, first_name.getText().toString());
            intent.putExtra(EXTRA_LAST_NAME, last_name.getText().toString());
            intent.putExtra(EXTRA_NICKNAME, nickname.getText().toString());
            startActivity(intent);
        }
        else
        {
        	 Toast.makeText(getApplicationContext(), messageToDisplay, Toast.LENGTH_LONG).show();
        }
    }

    @Override
    public void onBackPressed()
    {
    	if (myWebViewCGU.getVisibility() == View.VISIBLE)
    	{
    		myWebViewCGU.setVisibility(View.GONE);
    	}
    	else
    	{
    		super.onBackPressed();
    	}
    }
}
