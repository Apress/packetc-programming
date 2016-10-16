// ***************************************************************************
//  SortedList.ph -- provides a fast sorted list.
// ------------
// Author      : dWiGhT
// Date Created: 04/28/2011 
// Version     : 1.00
// ------------
//
//  This provides routines that will create a sorted list without the 
//  overhead of data movement associated with sorting, inserting, and deleting.  
//
//  A two dimensional array is used as a sort of singly linked list.  Entries
//  are inserted at the end and their "next node" set appropriately to 
//  keep the list sorted.  This saves having to move any data around for 
//  insertions or deletions.  Deletions are reused by tracking them in a 
//  stack that gets 
//
//  Iterators are provided to transverse the list in a sorted order and 
//  should be the only way to access the list.
//
// ***************************************************************************
#ifndef SORTEDLIST_PH_
#define SORTEDLIST_PH_

// ***************************************************************************
//  Define the 2D array that makes up the list.  If the size is not specified
//  we default to 0x7fff as the size.
// ***************************************************************************
#ifndef MAX_LIST_SIZE
#define MAX_LIST_SIZE 0x7fff
#endif
int  Node_[MAX_LIST_SIZE][2] = {{0xffffffff,0}};  // Init with END-NODE
const int NODE_VALUE = 0;   // Col 0 is the value stored in the list
const int NEXT_NODE = 1;    // Col 1 is the index/link to the next node 

// Stack used to recover deleted nodes saves having to compact the list.
// [0] stores the number of elements in the stack.  10% of the list size.
int  OpenSlots_[MAX_LIST_SIZE/10];

// ***************************************************************************
//  The HeadNode is the lowest value in the list.  
//  NumNodes is the current number of nodes in the list and the insertion idx.
// ***************************************************************************
int  NumNodes_ = 0;
int  HeadNode_ = 0;

// ***************************************************************************
// List iterators used to iterate through the list in a sorted fashion.
//
// NOTE:
//   you should only use iterators to correctly transverse a list
//   which will be returned in accending order. 
// ***************************************************************************
typedef const int ListIterator;

// ***************************************************************************
// Test the ListIterator against LIST_END to determine if at the end 
// of the list.
// ***************************************************************************
const ListIterator  LIST_END = 0; 

// ***************************************************************************
// Returns an iterator that points to the start of the list
// ***************************************************************************
ListIterator  listCreateIterator() {
  return (ListIterator)HeadNode_;
}

// Fast inlined version
#define LIST_CREATE_ITERATOR() (ListIterator)HeadNode_ 

// ***************************************************************************
// Returns the value stored at the current iterator
// ***************************************************************************
int  listGetValue( ListIterator  iter ) {
  return Node_[iter][NODE_VALUE];
}

// Fast inlined version
#define LIST_GET_VALUE(ITER)  Node_[ITER][NODE_VALUE]

// ***************************************************************************
//  Returns the next position after this node
// ***************************************************************************
ListIterator  listIncIterator( ListIterator  iter ) {
  return Node_[iter][NEXT_NODE];
}

// Fast inlined version
#define LIST_INC_ITERATOR(ITER) Node_[ITER][NEXT_NODE] 

// ***************************************************************************
//  Delete all the nodes in the list.  This effectively just resets pointers
//  that are tracked.  The end-node is the only node that is overwritten.
// ***************************************************************************
void  listInit() {
  // Simplily set the number of nodes to zero
  NumNodes_ = 0;
  
  // Point headNode to the END-NODE of the list
  HeadNode_ = 0;
  Node_[0][NODE_VALUE] = 0xffffffff;
  Node_[0][NEXT_NODE] = 0;
  
  // Clear out the open slots list
  OpenSlots_[0] = 0;

  return;
}

// Fast inlined version
#define LIST_INIT() \
{ \
  NumNodes_ = 0;                     \
  HeadNode_ = 0;                     \
  Node_[0][NODE_VALUE] = 0xffffffff; \
  Node_[0][NEXT_NODE] = 0;           \
  OpenSlots_[0] = 0;                 \
}

  
// ***************************************************************************
//  Inserts the value into the list so that the list stays sorted.  No
//  duplicates are entered in the list.  Returns an booleen indicating 
//  if the item was inserted, right now the only error that can occur is
//  a full table condition.
//
//  :HACK: Note the use of several exit points (return;) within this code.
//         This reduces the amount of code that is executed within the 
//         special case scenarios and avoids a numerious comparisons. 
// ***************************************************************************
bool  listInsert( int value ) {
  if ( NumNodes_ + 1 == MAX_LIST_SIZE ) 
    if ( OpenSlots_[0] == 0 ) {
      // We don't have anymore room to add a value
      return false;
  }
  
  // See if we have some open slots to use from previous deletes, 
  // use this node then, otherwise use one of the new ones.
  int  newSlot;
  if ( OpenSlots_[0] > 0 ) {
    // Reuse one of the open slots
    newSlot = OpenSlots_[OpenSlots_[0]--];
  } else {
    // Use a new slot at the end of the list
    newSlot = ++NumNodes_;
  }
  
  // Special case if we insert before the head
  if ( Node_[HeadNode_][NODE_VALUE] > value ) {
    // Add the node and repoint the head to it
    Node_[newSlot][NEXT_NODE] = HeadNode_;
    Node_[newSlot][NODE_VALUE] = value;
    HeadNode_ = newSlot;
    return true;
  }

  // Find out where to insert this value
  int  nodeValue;
  int  nextNode;
  int  testNode;
  testNode = HeadNode_;  

  ListIterator iter; 
  iter = LIST_CREATE_ITERATOR();
  while ( iter != LIST_END )  {
    
    nodeValue = Node_[testNode][NODE_VALUE];
    if ( nodeValue == value ) {
      // The value is already in our list so we ditch without adding
      
      // We have to recover the node back into the stack if we are
      // not going to use it
      if ( newSlot != NumNodes_ ) {
        OpenSlots_[++OpenSlots_[0]] = newSlot;
      } else {
        --NumNodes_;
      }
      return true;
    }

    nextNode = Node_[testNode][NEXT_NODE];
      
    // Test if we should insert this here
    nodeValue = Node_[nextNode][NODE_VALUE];
    if ( nodeValue > value ) {
      // Kick out to insert the node here
      break;
    }
      
    // Move on to the next node to test
    testNode = nextNode;
  }
  
  // Insert this node at the correct position
  Node_[newSlot][NEXT_NODE] = Node_[testNode][NEXT_NODE];
  Node_[newSlot][NODE_VALUE] = value;
  Node_[testNode][NEXT_NODE] = newSlot;
  
  return true;
}


// ***************************************************************************
//  Deletes the value in the list.  The item is not removed but the next 
//  pointers rewritten to bypass this node.  This avoids having to move
//  the elements up in the list to compact it.
//
//  :HACK: Note the use of several exit points (return;) within this code.
//         This reduces the amount of code that is executed within the 
//         special case scenarios and avoids a numerious comparisons. 
// ***************************************************************************
bool  listDelete( int value ) {
  int val;
  
  // Create an iterator to the start of the list
  ListIterator iter; 
  iter = LIST_CREATE_ITERATOR();
  
  // We have to track the previous node to modify it
  ListIterator iterPrev;

  // Loop through it verifying that all is right
  while ( iter != LIST_END )  {
    
    // Get the value at this position
    if ( value == LIST_GET_VALUE( iter ) ) {
      // We found the node so reroute the node pointers around 
      // this node.  This saves having to collapse the list.

      // if this is the head we can just point head to the next node
      if ( iter == HeadNode_ ) {
        // First in the list, point to it
        HeadNode_ = Node_[HeadNode_][NEXT_NODE];
        
        // See if we deleted the last node in the list 
        if ( HeadNode_ == LIST_END ) {
          // Reinit the list
          LIST_INIT();
        } else {
          // Make sure we don't overflow the stack
          if ( OpenSlots_[0] < MAX_LIST_SIZE/10 ) {
            // Add the node that we deleted to the open slots list
            OpenSlots_[++OpenSlots_[0]] = iter;
          }
        }
        
        // We're done here
        return true;
      } else {
        // Route around this node
        Node_[iterPrev][NEXT_NODE] = Node_[iter][NEXT_NODE];
        
        // Make sure we don't overflow the stack
        if ( OpenSlots_[0] < MAX_LIST_SIZE/10 ) {
          // Add the node that we deleted to the open slots list
          OpenSlots_[++OpenSlots_[0]] = iter;
        }
        
        // We're done here
        return true;
      }      
    }
    
    // Move on to the next node
    iterPrev = iter;
    iter = LIST_INC_ITERATOR( iter );
  }
  
  // At this point we did not find the value in the list
  return false;
}


// ***************************************************************************
//  Returns if the value is already in the list.  The list is searched for
//  the value and a iterator is returned pointing to the location in the list.
//  LIST_END iterator is returned if the value is not in the list.
//
//  :HACK: Note the use of several exit points (return;) within this code.
//         This reduces the amount of code that is executed within the 
//         special case scenarios and avoids a numerious comparisons. 
// ***************************************************************************
ListIterator  listSearch( int value ) {
  // Find out where to insert this value
  int  nodeValue;
  int  nextNode;
  int  testNode;
  testNode = HeadNode_;  

  ListIterator iter; 
  iter = LIST_CREATE_ITERATOR();
  while ( iter != LIST_END )  {
    
    nodeValue = Node_[testNode][NODE_VALUE];
    if ( nodeValue == value ) {
      // The value is in the list so return an iterator pointing to it
      return testNode;
    }
      
    // Test if we should insert this here
    nextNode = Node_[testNode][NEXT_NODE];
    nodeValue = Node_[nextNode][NODE_VALUE];
    if ( nodeValue > value ) {
      // We are past were the value would me so it isn't in the list
      return LIST_END;
    }
      
    // Move on to the next node to test
    testNode = nextNode;
  }
  
  // If we get here it means that the value was not in the list
  return LIST_END;
}


// ***************************************************************************
//  Returns a bool if the value is in the list.
//
//  :HACK: Note the use of several exit points (return;) within this code.
//         This reduces the amount of code that is executed within the 
//         special case scenarios and avoids a numerious comparisons. 
// ***************************************************************************
bool  IsValueInList( int value ) {
  if ( listSearch(value) != LIST_END ) {
    return true;
  } 
  return false;
}

#endif /*SORTEDLIST_PH_*/
