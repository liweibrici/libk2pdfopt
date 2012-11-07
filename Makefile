MAJVER=  1
MINVER=  6
RELVER=  0

K2PDFOPT_SRC := $(wildcard *.c)

OBJS:=$(K2PDFOPT_SRC:%.c=%.o)
K2PDFOPT_O= $(OBJS)
K2PDFOPT_DYNO= $(OBJS:.o=_dyn.o)

K2PDFOPT_A= libk2pdfopt.a
K2PDFOPT_SO= libk2pdfopt.so

STATIC_CC = $(CC)
DYNAMIC_CC = $(CC) -fPIC
TARGET_CC= $(STATIC_CC)
TARGET_DYNCC= $(DYNAMIC_CC)
TARGET = $(K2PDFOPT_A)
ifeq (shared,$(BUILDMODE))
   TARGET = $(K2PDFOPT_SO)
endif
TARGET_SONAME= libk2pdfopt.so.$(MAJVER).$(MINVER).$(RELVER)
TARGET_DYLIBPATH=
TARGET_XSHLDFLAGS= -shared -fPIC -Wl,-soname,$(TARGET_SONAME)
TARGET_ASHLDFLAGS= $(TARGET_XSHLDFLAGS) $(TARGET_DYLIBPATH) $(TARGET_FLAGS) $(TARGET_SHLDFLAGS)
TARGET_XLIBS= -lm -ldjvulibre -lfitz
TARGET_ALIBS= $(TARGET_XLIBS) $(LIBS) $(TARGET_LIBS)

##############################################################################
# Object file rules.
##############################################################################

%.o: %.c
	$(TARGET_CC) $(CFLAGS) -c -o $@ $<
	$(TARGET_DYNCC) $(CFLAGS) -c -o $(@:.o=_dyn.o) $<
	
##############################################################################
# Target file rules.
##############################################################################
$(K2PDFOPT_A): $(K2PDFOPT_O)
	$(AR) rcs $@ $(K2PDFOPT_O)

$(K2PDFOPT_SO): $(K2PDFOPT_O)
	$(CC) $(TARGET_ASHLDFLAGS) -o $@ $(K2PDFOPT_DYNO) $(TARGET_ALIBS)

all: $(TARGET)

clean:
	rm -rf *.o
	rm -rf *.a
	rm -rf *.so

.PHONY: clean
