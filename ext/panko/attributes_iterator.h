#include <ruby.h>

#include "serialization_descriptor_backend.h"

typedef void (*EachAttributeFunc)(VALUE object,
                                  VALUE name,
                                  VALUE value,
                                  VALUE type_metadata,
                                  VALUE context);

extern VALUE panko_each_attribute(VALUE object,
                                  SerializationDescriptor descriptor,
                                  VALUE attributes,
                                  EachAttributeFunc func,
                                  VALUE context);

void panko_init_attributes_iterator(VALUE mPanko);
