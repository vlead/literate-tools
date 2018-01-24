var Hooks = {}; //Hooks is dictionary where the keys are events. 
Hooks.addEvent = function(eventName) {
  if (!Hooks.hasOwnProperty(eventName)) {
	Hooks[eventName]= [];
  }
};

// Multiple hooks are added to an event
Hooks.addHook = function(event, f) {
  Hooks[event].push(f);
};

//Run all the hooks of a given event. 
Hooks.runHooks = function(event) {
  hooks = Hooks[event];  // hooks is an array
  hooks.forEach(function(f) { f(); });
};

// Provision to add hooks for the event 'documentReady'
Hooks.addEvent('documentReady');
