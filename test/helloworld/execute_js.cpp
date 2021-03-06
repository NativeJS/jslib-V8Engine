#include "execute_js.h"

#include <v8.h>
#include <libplatform/libplatform.h>


std::string execute_js(std::string scriptString)
{
	using namespace v8;
	std::string returnResult;

	// Initialize V8.
	V8::InitializeICU();
	Platform* platform = platform::CreateDefaultPlatform();
	V8::InitializePlatform(platform);
	V8::Initialize();

	// Create a new Isolate and make it the current one.
	Isolate* isolate = Isolate::New();
	{
		Isolate::Scope isolate_scope(isolate);

		// Create a stack-allocated handle scope.
		HandleScope handle_scope(isolate);

		// Create a new context.
		Local<Context> context = Context::New(isolate);

		// Enter the context for compiling and running the hello world script.
		Context::Scope context_scope(context);

		// Create a string containing the JavaScript source code.
		Local<String> source = String::NewFromUtf8(isolate, scriptString.c_str());

		// Compile the source code.
		Local<Script> script = Script::Compile(source);

		// Run the script to get the result.
		Local<Value> result = script->Run();

		// Convert the result to an UTF8 string.
		returnResult = *String::Utf8Value(result);
	}

	// Dispose the isolate and tear down V8.
	isolate->Dispose();
	V8::Dispose();
	V8::ShutdownPlatform();
	delete platform;

	// Return the resulting string
	return returnResult;
}