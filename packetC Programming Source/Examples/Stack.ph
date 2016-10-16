// **************************************************************************
// stack.ph
// ------------
// Author(s)   : dW!GhT
// Date Created: 08/04/2011
// Version     : 1.00
// **************************************************************************
// Description:  packetC implementation of the STL container type stack.  
//               All methods are define macros so as to make these as fast 
//               possible.
//
// ***************************************************************************
#ifndef STACK_PH_
#define STACK_PH_

// If STACK_SIZE is not defined we default to 100 elements
#ifndef STACK_MAX_SIZE
#define STACK_MAX_SIZE  100
#endif

// Define the stack we are going to use for this.  The [0] contains the
// sizing information.
int stack_[STACK_MAX_SIZE] = {0};


// ***************************************************************************
// Test whether container is empty
// Returns whether the stack is empty, i.e. whether its size is 0.
// ***************************************************************************
#define  STACK_EMPTY() (stack_[0] == 0)

// ***************************************************************************
// Remove element
// Removes the element on top of the stack, effectively reducing its size
// by one. The value of this element can be retrieved before being popped
// by calling member stack::top.
// ***************************************************************************
#define  STACK_POP() \
  if ( stack_[0] > 0) { \
    --stack_[0];        \
  }

// ***************************************************************************
// Add element
// Adds a new element at the top of the stack, above its current top element.
// The content of this new element is initialized to a copy of x.
// ***************************************************************************
#define  STACK_PUSH(X) \
  if ( stack_[0] < STACK_MAX_SIZE ) { \
    stack_[++stack_[0]] = X;      \
  }

// ***************************************************************************
// Return size
// Returns the number of elements in the stack.
// ***************************************************************************
#define  STACK_SIZE()  stack_[0]

// ***************************************************************************
// Access next element
// Returns the next element in the stack. Since stacks are last-in first-out
// containers this is also the last element pushed into the stack.
// ***************************************************************************
#define  STACK_TOP()  stack_[stack_[0]]


#endif /*STACK_PH_*/
