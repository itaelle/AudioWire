package com.eip.audiowire.activities;

import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import com.eip.audiowire.R;
import com.eip.audiowire.managers.UserManager;

import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

/**
 * Created by Augustin on 21/01/14.
 */

public class Friends extends Activity
{
    private TextView or;
    private TextView lost;
    private EditText email;
    private EditText pw;
    private ImageButton go;
    private ImageButton subscribe;
    private ProgressBar spinner;

    final String EXTRA_LOGIN = "user_login";
    final String EXTRA_PASSWORD = "user_password";

    @Override
    public void onCreate(Bundle savedInstanceState) 
   {
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.friends);
        or = (TextView) findViewById(R.id.or);
        lost = (TextView) findViewById(R.id.lost);
        email = (EditText) findViewById(R.id.login);
        pw = (EditText) findViewById(R.id.pw);
        spinner = (ProgressBar) findViewById(R.id.progressBar1);
        
        spinner.setVisibility(View.GONE);
        
        Typeface font = Typeface.createFromAsset(getAssets(), "Futura-Bold.otf");
        or.setTypeface(font);
        lost.setTypeface(font);
        email.setTypeface(font);
        pw.setTypeface(font);

        lost.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v)
			{
				// LOST PASSWORD
            	String emailStr = email.getText().toString();
            	
                Pattern p = Pattern.compile(".+@.+\\.[a-z]+");
                Matcher m = p.matcher(emailStr);
                if (!m.matches()) {
                	Toast.makeText(getApplicationContext(), "Please check your e-mail", Toast.LENGTH_SHORT).show();
                	return ;
                }
            	spinner.setVisibility(View.VISIBLE);
                UserManager.getInstance().lostPassword(emailStr, Friends.this);
			}
		});
        
        go = (ImageButton) findViewById(R.id.go);
        go.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v)
            {
            	String emailStr = email.getText().toString();
            	String pwdStr = pw.getText().toString();

                Pattern p = Pattern.compile(".+@.+\\.[a-z]+");
                Matcher m = p.matcher(emailStr);
                if (!m.matches()) {
                	Toast.makeText(getApplicationContext(), "Please check your e-mail", Toast.LENGTH_SHORT).show();
                	return ;
                }

            	// LOGIN
            	spinner.setVisibility(View.VISIBLE);
            	
            	if (emailStr != null && emailStr.length() > 0 && 
            			pwdStr != null && pwdStr.length() > 0)
            	{
            		HashMap<String, String> userModel = new HashMap<String, String>();
            		userModel.put("email", emailStr);
            		userModel.put("password", pwdStr);
            		
            		UserManager userManger = UserManager.getInstance();
            		userManger.login(userModel, Friends.this);
            	}
            }
        });

        subscribe = (ImageButton) findViewById(R.id.subscribe);

        subscribe.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v)  {
                Intent intent = new Intent(Friends.this, Subscribe.class);
                startActivity(intent);
            }
        });
    }
    
    public void didPasswordNotificationSent(String messageToDisplay, Boolean success)
    {
    	spinner.setVisibility(View.GONE);
        Toast.makeText(getApplicationContext(), messageToDisplay, Toast.LENGTH_SHORT).show();
    }
    
    public void didLoggedIn(String messageToDisplay, Boolean success)
    {
    	spinner.setVisibility(View.GONE);
        Toast.makeText(getApplicationContext(), messageToDisplay, Toast.LENGTH_SHORT).show();
        
        if (success)
        {
            Intent intent = new Intent(Friends.this, AudioWireMainActivity.class);
            intent.putExtra(EXTRA_LOGIN, email.getText().toString());
            intent.putExtra(EXTRA_PASSWORD, pw.getText().toString());
            startActivity(intent);
        }
    }
}
