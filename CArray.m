//
//  CArray.m
//
//  Created by Tyler Neylon on 1/2/11.
//

#import "CArray.h"

CArray *CArrayInit(CArray *cArray, int capacity, size_t elementSize) {
  cArray->count = 0;
  cArray->capacity = capacity;
  cArray->elementSize = elementSize;
  cArray->releaser = NULL;
  if (capacity) {
    cArray->elements = malloc(elementSize * capacity);
  } else {
    cArray->elements = NULL;
  }
  return cArray;
}

CArray *CArrayNew(int capacity, size_t elementSize) {
  CArray *cArray = malloc(sizeof(CArray));
  return CArrayInit(cArray, capacity, elementSize);
}

void CArrayDelete(CArray *cArray) {
  CArrayRelease(cArray);
  free(cArray);
}

void CArrayRelease(void *cArray) {
  CArray *realArray = (CArray *)cArray;
  CArrayClear(realArray);
  free(realArray->elements);
}

void CArrayAddElement(CArray *cArray, void *element) {
  memcpy(CArrayNewElement(cArray), element, cArray->elementSize);
}

void *CArrayNewElement(CArray *cArray) {
  if (cArray->count == cArray->capacity) {
    cArray->capacity *= 2;
    if (cArray->capacity == 0) cArray->capacity = 1;
    cArray->elements = realloc(cArray->elements, cArray->capacity * cArray->elementSize);
  }
  cArray->count++;
  return CArrayElement(cArray, cArray->count - 1);
}

void CArrayClear(CArray *cArray) {
  if (cArray->releaser) {
    for (int i = 0; i < cArray->count; ++i) {
      cArray->releaser(CArrayElement(cArray, i));
    }
  }
  cArray->count = 0;
}

void *CArrayElement(CArray *cArray, int index) {
  return (void *)(cArray->elements + index * cArray->elementSize);
}

void CArrayAppendContents(CArray *cArray, CArray *source) {
  for (int i = 0; i < source->count; ++i) {
    void *elt = CArrayElement(source, i);
    CArrayAddElement(cArray, elt);
  }
}

void CArrayRemoveElement(CArray *cArray, void *element) {
  if (cArray->releaser) cArray->releaser(element);
  int numLeft = cArray->count--;
  char *eltByte = (char *)element;
  int byteDist = eltByte - cArray->elements;
  int index = byteDist / cArray->elementSize;
  if (index == numLeft) return;
  memmove(eltByte, eltByte + cArray->elementSize, (numLeft - index) * cArray->elementSize);
}

void *CArrayEnd(CArray *cArray) {
  return CArrayElement(cArray, cArray->count);
}

int CompareAsInts(void *eltSize, const void *elt1, const void *elt2) {
  size_t s = *(size_t *)eltSize;
  unsigned char *e1 = (unsigned char *)elt1;
  unsigned char *e2 = (unsigned char *)elt2;
  for (int i = 0; i < s; ++i) {
    int diff = *(e1 + i) - *(e2 + i);
    if (diff != 0) return diff;
  }
  return 0;
}

void CArraySort(CArray *cArray, CompareFunction compare, void *compareContext) {
  if (compare == NULL) {
    compare = &CompareAsInts;
    compareContext = &(cArray->elementSize);
  }
  qsort_r(cArray->elements, cArray->count, cArray->elementSize, compareContext, compare);
}

void *CArrayFind(CArray *cArray, void *elt) {
  return bsearch_b(elt, cArray->elements, cArray->count, cArray->elementSize,
                   ^(const void *a, const void *b){ return memcmp(a, b, cArray->elementSize); });
}

void CArrayRemoveDuplicates(CArray *cArray, CompareFunction compare, void *compareContext) {
  if (compare == NULL) {
    compare = &CompareAsInts;
    compareContext = &(cArray->elementSize);
  }
  CArraySort(cArray, compare, compareContext);
  for (int i = 0; i < (cArray->count - 1);) {
    // TODO Use double pointers instead of recomputing elt{1,2} each time.
    void *elt1 = CArrayElement(cArray, i);
    void *elt2 = CArrayElement(cArray, i + 1);
    if (compare(compareContext, elt1, elt2) == 0) {
      CArrayRemoveElement(cArray, elt1);
    } else {
      ++i;
    }
  }
}
