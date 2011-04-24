//
//  CArray.h
//
//  Created by Tyler Neylon on 1/2/11.
//
//  Set of functions for working with a lightweight
//  array.  This is meant as a replacement for
//  NSMutableArray when speed is important.
//

#import <Foundation/Foundation.h>

typedef void (*Releaser)(void *element);

typedef struct CArray {
  int count;
  int capacity;
  size_t elementSize;
  Releaser releaser;
  char *elements;
} CArray;

// Constant-time operations.

CArray *CArrayInit(CArray *cArray, int capacity, size_t elementSize);
CArray *CArrayNew(int capacity, size_t elementSize);

// The next three methods are O(1) if there's no releaser; O(n) if there is.
void CArrayDelete(CArray *cArray);
void CArrayRelease(void *cArray);  // Doesn't free cArray as a pointer,  just its contents.
void CArrayClear(CArray *cArray);

void *CArrayElement(CArray *cArray, int index);
#define CArrayElementOfType(array, i, type) (*(type *)CArrayElement(array, i))

// Amortized constant-time operations (some are usually constant-time, sometimes linear).

void CArrayAppendContents(CArray *cArray, CArray *source);  // Expects cArray != source.
void CArrayAddElement(CArray *cArray, void *element);
void *CArrayNewElement(CArray *cArray);


// Possibly linear time operations.

// element is expected to be an object already within cArray, i.e.,
// the location of element should be in the cArray->elements memory buffer.
void CArrayRemoveElement(CArray *cArray, void *element);

// Tools for nice iterations.
// If you used sizeof(x) to set up the CArray, then the type for CArrayFor
// is expected to be "x *" (a pointer to x).

void *CArrayEnd(CArray *cArray);

#define CArrayFor(type, var, cArray) \
for (type var = CArrayElement(cArray, 0); var != CArrayEnd(cArray); ++var)

#define CArrayForBackwards(type, var, cArray) \
for (type var = CArrayElement(cArray, cArray->count - 1); var >= (type)cArray->elements; --var)

typedef int (*CompareFunction)(void *, const void *, const void *);
void CArraySort(CArray *cArray, CompareFunction compare, void *compareContext);

// Assumes the array is sorted in ascending memcmp order; does a memcmp of each element
// in the array, using a binary search.
void *CArrayFind(CArray *cArray, void *elt);

// This function sorts the array and removes all duplicates.
// See CArraySort to understand how the sorting works.
// Unfortunately, worst-case is now O(n^2).  But it will still be fast
// on lists with very few duplicates.
void CArrayRemoveDuplicates(CArray *cArray, CompareFunction compare, void *compareContext);
