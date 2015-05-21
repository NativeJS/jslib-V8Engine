package com.NativeJS.jslibV8Engine;

import android.app.Activity;
import android.os.Bundle;


public class HelloWorld extends Activity
{
	// Native methods implemented inside 'helloworld' shared library
	public native void onCreateNative();


	// Called when the activity is first created.
	@Override public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		onCreateNative();
	}


	// Called when this class is first loaded into the JVM. We use it to load the 'helloworld' shared library
	static
	{
		System.loadLibrary("helloworld");
	}
}