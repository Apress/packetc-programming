// **************************************************************************
// backgroundTask.ph -
// ------------
// Author(s)   : dW!GhT
// Date Created: 08/04/2011  
// Version     : 1.00
// **************************************************************************
// Description:  This provides a way to have a function be a background 
//               task that takes care of the machinery to execute the 
//               function.  It also provides the ability to have the 
//               function executed for a specified time (in seconds) calling
//               it multiple times till it excedes the allocated time.
//
// BGTASK_INIT
//    Function to call before the first time the background task is called. 
//
// BGTASK_FUNCTION_CALLBACK
//    Function to call that is the background task. 
//
// BGTASK_RUN_FOR_X_SECONDS
//    [Optional] Length of time in seconds to run the task.
//
// :NOTE:  There are other ways to make a background task but this one
//         has the advantage of self adjusting to the the throughput 
//         of the box since the driver of calling the callback function
//         is a replica packet that gets put at the end of the input queue
//         it naturally provides this.
//
// ***************************************************************************
#ifndef BACKGROUNDTASK_PH_
#define BACKGROUNDTASK_PH_

// ***************************************************************************
// :NOTE: This is prototyped here but you will have to supply a hardward
//        specific function call to return a timer value.
// ***************************************************************************
int getTimer();

// Make sure that we have the required define set up
#ifndef BGTASK_FUNCTION_CALLBACK
#error "You have to #define BGTASK_FUNCTION_CALLBACK."
#endif

// Global variables to keep 
bool  BgTaskStarted_ = false;
int   BgTaskLock_;

bool  runBackgroundTask() {
  bool  backgroundTaskExecuted = false;
  
  try {
    // Test if we have to kick start this process by floating a replica.
    // This is done only once when the first packet hits this code.
    if ( BgTaskStarted_ == false ) {
#ifdef BGTASK_INIT
      // Call the init function
      BGTASK_INIT;
#endif
      // Lock so that only one context is changing the 
      // control variable.
      lock(BgTaskLock_);
      BgTaskStarted_ = true;
      unlock(BgTaskLock_);
      pkt.replicate();
    }
    
    // Only if this is a replica do we call the callback function
    if ( pib.flags.replica == true ) {
      backgroundTaskExecuted = true;
      
      // To minimize the impact on the system of floating a replica
      // we try to adjust the size down to the smallest we can.
      // :NOTE: We could test and set but just setting it every time 
      //        reduces the number of instructions involved.
      pib.length = 4;

#ifdef BGTASK_RUN_FOR_X_SECONDS       
      // Init the time we are going to run this task 
      short  stopTime;
      stopTime = (short)getTimer() + BGTASK_RUN_FOR_X_SECONDS;
      
      // Run till the stop time is 
      while ( (short)getTimer() <= stopTime ) {
#else 
      // We just run the callback function once
      {
#endif 
        BGTASK_FUNCTION_CALLBACK;
      }
      
      // We drop this replica packet and replicate another one to 
      // continue this process.  
      pib.action = DROP_PACKET;
      pkt.replicate();
    }
    
  } 
  catch ( ERR_PKT_NOREPLICATE  ) {
    // We had an error occur when trying to create a replica, here
    // we try to restart this process by trying the next packet.
    BgTaskStarted_ = false;
  }

  return backgroundTaskExecuted;
}

#else 
#error "Multiple inclusion of backgroundTask.ph." 
#endif /*BACKGROUNDTASK_PH_*/
