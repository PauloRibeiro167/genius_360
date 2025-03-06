#ifndef BUILTIN_H_INCLUDED
#define BUILTIN_H_INCLUDED

// invoke

struct rb_builtin_function {
    // for invocation
    const void * const func_ptr;
    const int argc;

    // for load
    const int index;
    const char * const name;
};

#define RB_BUILTIN_FUNCTION(_i, _name, _fname, _arity) {\
  .name = _i < 0 ? NULL : #_name, \
  .func_ptr = (void *)_fname, \
  .argc = _arity, \
  .index = _i, \
}

void rb_load_with_builtin_functions(const char *feature_name, const struct rb_builtin_function *table);

#ifndef rb_execution_context_t
typedef struct rb_execution_context_struct rb_execution_context_t;
#define rb_execution_context_t rb_execution_context_t
#endif

/* The following code is generated by the following Ruby script:

typedef = proc {|i, args|
  "typedef VALUE (*rb_builtin_arity#{i}_function_type)(rb_execution_context_t *ec, VALUE self#{args});"
}
puts typedef[0, ""]
(1..15).each {|i|
  puts typedef[i, ",\n        " + (0...i).map{"VALUE"}.join(", ")]
}
16.times{|i|
  puts "static inline void rb_builtin_function_check_arity#{i}(rb_builtin_arity#{i}_function_type f){}"
}
*/

typedef VALUE (*rb_builtin_arity0_function_type)(rb_execution_context_t *ec, VALUE self);
typedef VALUE (*rb_builtin_arity1_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE);
typedef VALUE (*rb_builtin_arity2_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE);
typedef VALUE (*rb_builtin_arity3_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity4_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity5_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity6_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity7_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity8_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity9_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity10_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity11_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity12_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity13_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity14_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE);
typedef VALUE (*rb_builtin_arity15_function_type)(rb_execution_context_t *ec, VALUE self,
        VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE, VALUE);
static inline void rb_builtin_function_check_arity0(rb_builtin_arity0_function_type f){}
static inline void rb_builtin_function_check_arity1(rb_builtin_arity1_function_type f){}
static inline void rb_builtin_function_check_arity2(rb_builtin_arity2_function_type f){}
static inline void rb_builtin_function_check_arity3(rb_builtin_arity3_function_type f){}
static inline void rb_builtin_function_check_arity4(rb_builtin_arity4_function_type f){}
static inline void rb_builtin_function_check_arity5(rb_builtin_arity5_function_type f){}
static inline void rb_builtin_function_check_arity6(rb_builtin_arity6_function_type f){}
static inline void rb_builtin_function_check_arity7(rb_builtin_arity7_function_type f){}
static inline void rb_builtin_function_check_arity8(rb_builtin_arity8_function_type f){}
static inline void rb_builtin_function_check_arity9(rb_builtin_arity9_function_type f){}
static inline void rb_builtin_function_check_arity10(rb_builtin_arity10_function_type f){}
static inline void rb_builtin_function_check_arity11(rb_builtin_arity11_function_type f){}
static inline void rb_builtin_function_check_arity12(rb_builtin_arity12_function_type f){}
static inline void rb_builtin_function_check_arity13(rb_builtin_arity13_function_type f){}
static inline void rb_builtin_function_check_arity14(rb_builtin_arity14_function_type f){}
static inline void rb_builtin_function_check_arity15(rb_builtin_arity15_function_type f){}

PUREFUNC(VALUE rb_vm_lvar_exposed(rb_execution_context_t *ec, int index));
VALUE rb_vm_lvar_exposed(rb_execution_context_t *ec, int index);

// __builtin_inline!

PUREFUNC(static inline VALUE rb_vm_lvar(rb_execution_context_t *ec, int index));

static inline VALUE
rb_vm_lvar(rb_execution_context_t *ec, int index)
{
#if defined(VM_CORE_H_EC_DEFINED) && VM_CORE_H_EC_DEFINED
    return ec->cfp->ep[index];
#else
    return rb_vm_lvar_exposed(ec, index);
#endif
}

// dump/load

struct builtin_binary {
    const char *feature;          // feature name
    const unsigned char *bin;     // binary by ISeq#to_binary
    size_t bin_size;
};

#endif // BUILTIN_H_INCLUDED
