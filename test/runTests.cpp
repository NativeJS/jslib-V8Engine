/**
 *
 **/


#include <string>
#include <iostream>
#include <stdexcept>
#include <v8.h>


void printLine(std::string string, int indentation = 0) {
	for (int i = 0; i < indentation; i += 1) {
		std::cout << "\t";
	}

	std::cout << string << std::endl;
}


std::string executeString(v8::Isolate* IsolatedMemoryState, std::string scriptString) {
	// Enter V8 namespace for this scope
	using namespace v8;

	// Enter the memory state tied to this v8 engine instance
	IsolatedMemoryState->Enter();
	HandleScope handleScope(IsolatedMemoryState);

	// Set execution scope context (global)
	Local<Context> context = Context::New(IsolatedMemoryState);
	Context::Scope contextScope(context);

	// Setup V8 exception handling object
	TryCatch tryCatch;

	// Create and execute compiled script object
	Local<String> source = String::NewFromUtf8(IsolatedMemoryState, scriptString.c_str());
	Local<Script> script = Script::Compile(source);
	Local<Value> result = (script.IsEmpty()) ? Local<Value>() : script->Run();

	// Check if there were any problems with compilation or execution
	if (script.IsEmpty() || result.IsEmpty()) {
		// Check if a stack is available
		Local<Value> stack = tryCatch.StackTrace();
		if (!stack.IsEmpty()) {
			String::Utf8Value stack_str(stack);
			IsolatedMemoryState->Exit();
			throw std::runtime_error(*stack_str);
		}

		// Then check if there is an exception message at least
		Local<Value> exception = tryCatch.Exception();
		if (!exception.IsEmpty()) {
			String::Utf8Value stack_str(exception);
			IsolatedMemoryState->Exit();
			throw std::runtime_error(*stack_str);
		}

		// Otherwise this is an unknown error
		IsolatedMemoryState->Exit();
		throw std::runtime_error("Unknown Error");
	}

	// Exit isolated state and print result
	std::string returnResult = *String::Utf8Value(result);
	IsolatedMemoryState->Exit();
	return returnResult;
}


int runTests() {
	//
	printLine("Setting up V8");
	v8::V8::Initialize();
	v8::Isolate* IsolatedMemoryState = v8::Isolate::New();

	//
	printLine("Testing hello world JS");
	printLine(executeString(IsolatedMemoryState, "var a = 'hello world!!!'; a"));

	return 0;
}