	.text
        .size   function,1
        .type   function,%function
function:
	.byte	0x0
        .size   indirect_function,1
        .type   indirect_function,%gnu_indirect_function
indirect_function:
	.byte	0x0
        .data
        .type   object,%object
        .size   object,1
object:
	.byte	0x0
        .type   tls_object,%tls_object
        .size   tls_object,1
tls_object:
	.byte	0x0
        .type   notype,%notype
        .size   notype,1
notype:
	.byte	0x0
	.type	gnu_unique_object,%gnu_unique_object
	.size	gnu_unique_object,1
gnu_unique_object:
	.byte	0x0
	.comm	common, 1
	.type   common,STT_COMMON
