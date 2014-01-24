package com.eip.audiowire.views;

import java.util.ArrayList;
import java.util.HashMap;

import com.eip.audiowire.R;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

public class MusicAdapter extends ArrayAdapter<HashMap<String, String>>
{
	private ArrayList<HashMap<String, String>> data_;
	private Context ctx;
	
	
	public MusicAdapter(Context ctx, ArrayList<HashMap<String, String>> data)
	{
		super(ctx, 0, data);
		this.ctx = ctx;
		this.data_ = data;
	}
	
	@Override
	public View getView(int pos, View conv_view, ViewGroup parent)
	{
		View temp = conv_view;
		
//		Log.i("AUDIOWIRE", "ALL DATA :" + this.data_.toString());
		HashMap<String, String> musicDataAtPos  = this.data_.get(pos);
		Log.i("AUDIOWIRE", "DATA ITEM :" + musicDataAtPos);
		
		LayoutInflater lay_inf = (LayoutInflater) this.ctx.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

		if (conv_view == null)
		{
			//temp = lay_inf.inflate(R.layout.item_music, null);
	      
			LayoutInflater vi;
	        vi = LayoutInflater.from(getContext());
	        temp = vi.inflate(R.layout.item_music, null);

		}
		
		TextView name = (TextView) temp.findViewById(R.id.nameMusic);
		name.setText(musicDataAtPos.get("title"));
		return temp;
	}
}