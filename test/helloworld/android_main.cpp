#include <jni.h>
#include <android/log.h>
#include <string>

#include "execute_js.h"

#define LOG_TAG "helloworld"
#define LOGI(...) ((void)__android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__))
#define LOGW(...) ((void)__android_log_print(ANDROID_LOG_WARN, LOG_TAG, __VA_ARGS__))
#define LOGE(...) ((void)__android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__))


class TextView
{
private:
	JNIEnv * env;

	jclass parentClass;
	jclass textViewClass;

	jmethodID textViewClass_init;
	jmethodID textViewClass_setText;
	jmethodID textViewClass_getText;
	jmethodID textViewClass_append;
	jmethodID parentClass_setContentView;

	jobject parentInstance;
	jobject textViewInstance;

public:
	TextView(JNIEnv * _env, jobject parent)
	{
		// Set env
		env = _env;

		// Get required classes
		parentClass = env->GetObjectClass(parent);
        textViewClass = env->FindClass("android/widget/TextView");

        // Get required methods
        textViewClass_init = env->GetMethodID(textViewClass, "<init>", "(Landroid/content/Context;)V");
        textViewClass_setText = env->GetMethodID(textViewClass, "setText", "(Ljava/lang/CharSequence;)V");
        textViewClass_getText = env->GetMethodID(textViewClass, "getText", "()Ljava/lang/CharSequence;");
        textViewClass_append = env->GetMethodID(textViewClass, "append", "(Ljava/lang/CharSequence;)V");
        parentClass_setContentView = env->GetMethodID(parentClass, "setContentView", "(Landroid/view/View;)V");

        // Create TextView
        parentInstance = parent;
        textViewInstance = env->NewObject(textViewClass, textViewClass_init, parentInstance);

        // Attach new TextView to parent
        env->CallVoidMethod(parentInstance, parentClass_setContentView, textViewInstance);
	}

	void setText(std::string text)
	{
		env->CallVoidMethod(textViewInstance, textViewClass_setText, env->NewStringUTF(text.c_str()));
	}

	std::string getText()
	{
		//env->CallVoidMethod(textViewInstance, textViewClass_getText, env->NewStringUTF("HELLO WORLD!!!"));
	}

	void appendText(std::string text)
	{
		env->CallVoidMethod(textViewInstance, textViewClass_append, env->NewStringUTF(text.c_str()));
	}
};


extern "C" void Java_com_NativeJS_jslibV8Engine_HelloWorld_onCreateNative(JNIEnv * env, jobject thiz)
{
	// Create new text view and set initial text
	LOGI("onCreate: creating text view");
	TextView * consoleView = new TextView(env, thiz);

	// Begin running tests
	LOGI("onCreate: running tests");
	consoleView->appendText("RUNNING TESTS:\n");

	// Execute "'Hello' + ', World!'" string and print it
	consoleView->appendText("\t1: " + execute_js("'Hello' + ', World!'") + "\n");
}