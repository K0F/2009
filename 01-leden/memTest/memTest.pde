
void setup(){
// The amount of memory allocated so far (usually the -Xms setting)
long allocated = Runtime.getRuntime().totalMemory();

// Free memory out of the amount allocated (value above minus used)
long free = Runtime.getRuntime().freeMemory();

// The maximum amount of memory that can eventually be consumed
// by this application. This is the value set by the Preferences
// dialog box to increase the memory settings for an application.
long maximum = Runtime.getRuntime().maxMemory();

println("alloc : "+allocated);
println("free : "+free);
println("maximum : "+maximum);
}
