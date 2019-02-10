# 1 "service/sys_svc/region/src/regioninit_gcc.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "service/sys_svc/region/src/regioninit_gcc.S"
@
# 35 "service/sys_svc/region/src/regioninit_gcc.S"
@
@
# 485 "service/sys_svc/region/src/regioninit_gcc.S"
@**************************************************************
@* File: regioninit.s *
@* Purpose: Application Startup Code *
@**************************************************************
@
@ This file contains the macro and supporting subroutines to
@ copy RO code and RW data from ROM to RAM and zero-initialize
@ the ZI data areas in RAM.


@ All of this should be set as an assembler argument using the -pd option.
@ For example to set support for Angel it would be -pd "MT6218 SETL {TRUE}"
@ see also make\comp.mak

# 1 "interface/driver/sys_drv/asm_def.h" 1
# 500 "service/sys_svc/region/src/regioninit_gcc.S" 2


        .thumb
        .syntax unified
        .global INT_InitRegions
        .global INT_InitEMIInitCode
        .global INT_InitPreInitData
        .global INT_InitMMRegions
        .global SYS_InitRegions

        .type INT_InitRegions, STT_FUNC
        .type INT_InitEMIInitCode, STT_FUNC
        .type INT_InitPreInitData, STT_FUNC
        .type INT_InitMMRegions, STT_FUNC
        .type SYS_InitRegions, STT_FUNC
# 531 "service/sys_svc/region/src/regioninit_gcc.S"
        .macro macro_RegionInit areaname







@ The following symbols are generated by the linker. They are .externed
@ WEAKly because they may not all have defined values. Those which are
@ undefined will take the value zero.

   .equ copyloadsym, Load$$\areaname\($$Base)
   .weak Load$$\areaname\($$Base)
   .equ copybasesym, Image$$\areaname\($$Base)
   .weak Image$$\areaname\($$Base)
   .equ copylensym, Image$$\areaname\($$Length)
   .weak Image$$\areaname\($$Length)
   .equ zibasesym, Image$$\areaname\($$ZI$$Base)
   .weak Image$$\areaname\($$ZI$$Base)
   .equ zilensym, Image$$\areaname\($$ZI$$Length)
   .weak Image$$\areaname\($$ZI$$Length)

        LDR r0, =copyloadsym @ copyloadsym: load address of region
        LDR r1, =copybasesym @ copybasesym: execution address of region
        MOV r2, r1 @ copy execution address into r2
        LDR r4, =copylensym @ copylensym
        ADD r2, r2, r4 @ add region length to execution address to...
                                       @ ...calculate address of word beyond end...
                                       @ ... of execution region
        BL copy

        LDR r2, =zilensym @ zilensym: get length of ZI region
        LDR r0, =zibasesym @ zibasesym: load base address of ZI region
        MOV r1, r0 @ copy base address of ZI region into r1
        ADD r1, r1, r2 @ add region length to base address to...
                                       @ ...calculate address of word beyond end...
                                       @ ... of ZI region
        BL zi_init_32


        .endm

@ This macro:
@ a) fills with zero the ZI data in RAM at Image$$area$$ZI$$Base,
@ of length Image$$area$$ZI$$Length bytes.

        .macro macro_ZeroInit areaname







@ The following symbols are generated by the linker. They are .externed
@ WEAKly because they may not all have defined values. Those which are
@ undefined will take the value zero.

   .equ copyloadsym, Load$$\areaname\($$Base)
   .weak Load$$\areaname\($$Base)
   .equ copybasesym, Image$$\areaname\($$Base)
   .weak Image$$\areaname\($$Base)
   .equ copylensym, Image$$\areaname\($$Length)
   .weak Image$$\areaname\($$Length)
   .equ zibasesym, Image$$\areaname\($$ZI$$Base)
   .weak Image$$\areaname\($$ZI$$Base)
   .equ zilensym, Image$$\areaname\($$ZI$$Length)
   .weak Image$$\areaname\($$ZI$$Length)

        LDR r2, =zilensym @ zilensym: get length of ZI region
        LDR r0, =zibasesym @ zibasesym: load base address of ZI region
        MOV r1, r0 @ copy base address of ZI region into r1
        ADD r1, r1, r2 @ add region length to base address to...
                                       @ ...calculate address of word beyond end...
                                       @ ... of ZI region
        BL zi_init_32



        .endm

@ This macro:
@ a) copies RO code and/or RW data from ROM at Load$$area$$Base
@ to RAM at Image$$area$$Base, of length Image$$area$$Length bytes.

        .macro macro_CopyRW areaname







@ The following symbols are generated by the linker. They are .externed
@ WEAKly because they may not all have defined values. Those which are
@ undefined will take the value zero.

   .equ copyloadsym, Load$$\areaname\($$Base)
   .weak Load$$\areaname\($$Base)
   .equ copybasesym, Image$$\areaname\($$Base)
   .weak Image$$\areaname\($$Base)
   .equ copylensym, Image$$\areaname\($$Length)
   .weak Image$$\areaname\($$Length)
   .equ zibasesym, Image$$\areaname\($$ZI$$Base)
   .weak Image$$\areaname\($$ZI$$Base)
   .equ zilensym, Image$$\areaname\($$ZI$$Length)
   .weak Image$$\areaname\($$ZI$$Length)

        LDR r0, =copyloadsym @ copyloadsym: load address of region
        LDR r1, =copybasesym @ copybasesym: execution address of region
        MOV r2, r1 @ copy execution address into r2
        LDR r4, =copylensym
        ADD r2, r2, r4 @ add region length to execution address to...
                                        @ ...calculate address of word beyond end...
                                        @ ... of execution region
        BL copy



        .endm


        .macro macro_BackwardCopyRW areaname







@ The following symbols are generated by the linker. They are .externed
@ WEAKly because they may not all have defined values. Those which are
@ undefined will take the value zero.

   .equ copyloadsym, Load$$\areaname\($$Base)
   .weak Load$$\areaname\($$Base)
   .equ copybasesym, Image$$\areaname\($$Base)
   .weak Image$$\areaname\($$Base)
   .equ copylensym, Image$$\areaname\($$Length)
   .weak Image$$\areaname\($$Length)
   .equ zibasesym, Image$$\areaname\($$ZI$$Base)
   .weak Image$$\areaname\($$ZI$$Base)
   .equ zilensym, Image$$\areaname\($$ZI$$Length)
   .weak Image$$\areaname\($$ZI$$Length)

        LDR r0, =copyloadsym @ copyloadsym: load address of region
        LDR r1, =copybasesym @ copybasesym: execution address of region
        MOV r2, r1 @ copy execution address into r2
        LDR r4, =copylensym @ copylensym
        SUB r4, r4, #4
        ADD r0, r0, r4
        ADD r1, r1, r4

        BL backward_copy



        .endm

@
@ NoteXXX: INT_InitXXXRegions is called from boot.s to initialize the specified execution regions.
@ The register r12 will be used in the bootarm.s. We should be careful not to
@ overwrite r12.
@

@
@
@
@
@
@
@
@
@
@
@
@
@
@
@
@ VOID INT_InitEMIInitCode(VOID)
@ {
@
    .thumb_func
.align 2
INT_InitEMIInitCode:

   MOV r7,lr

   macro_RegionInit EMIINIT_CODE
   macro_RegionInit SINGLE_BANK_CODE

   BX r7
.size INT_InitEMIInitCode, .-INT_InitEMIInitCode
@ }
@
# 742 "service/sys_svc/region/src/regioninit_gcc.S"
@ VOID INT_InitPreInitData(VOID)
@ {
@
    .thumb_func
INT_InitPreInitData:

   MOV r7,lr

   macro_ZeroInit CACHED_EXTSRAM_PREINIT_ZI

   BX r7
.size INT_InitPreInitData, .-INT_InitPreInitData
@ }
@

@
@
@
@
@
@
@
@
@
@
@
@
@
@
@
@ VOID INT_InitMMRegions(VOID)
@ {
@
INT_InitMMRegions:

   BX lr @ Return to caller
.size INT_InitMMRegions, .-INT_InitMMRegions
@ }
@


@
@
@
@
@
@
@
@
@
@
@
@
@
@
@
@ VOID INT_InitEXTSRAM_ZIwihoutInitDSP(VOID)
@ {
@
    .thumb_func
INT_InitEXTSRAM_ZIwihoutInitDSP:



        STMDB sp!, {lr} @ save lr

        LDR r0, =Load$$EXTSRAM$$Base @ copyloadsym: load address of region
        LDR r1, =Image$$EXTSRAM$$Base @ copybasesym: execution address of region
        MOV r2, r1 @ copy execution address into r2
        LDR r4, =Image$$EXTSRAM$$Length @ copylensym
        ADD r2, r2, r4 @ add region length to execution address to...
                                                       @ ...calculate address of word beyond end...
                                                       @ ... of execution region
        BL copy

        LDR r2, =Image$$EXTSRAM_ZI$$ZI$$Length @ zilensym: get length of ZI region
        LDR r1, =PHY_EXTSRAM_ZI_HEAD_NO_INIT$$Length @ we dont init dsp array
        SUB r2, r2, r1
        LDR r0, =Image$$EXTSRAM_ZI$$ZI$$Base @ zibasesym: load base address of ZI region
        ADD r0, r0, r1
        MOV r1, r0
        ADD r1, r1, r2


        BL zi_init_32

        LDMIA sp!, {lr} @ restore lr


        BX lr @ Return to caller

.size INT_InitEXTSRAM_ZIwihoutInitDSP, .-INT_InitEXTSRAM_ZIwihoutInitDSP
@ }
@


@
@
@
@
@
@
@
@
@
@
@
@
@
@
@
@
@ VOID INT_InitRegions(VOID)
@ {
@
    .thumb_func
INT_InitRegions:

   MOV r7,lr
# 873 "service/sys_svc/region/src/regioninit_gcc.S"
      macro_RegionInit INTSRAM_CODE
      macro_RegionInit INTSRAM_DATA
      macro_RegionInit INTSRAM_DATA_B1

      macro_RegionInit CACHED_EXTSRAM
      macro_RegionInit CACHED_EXTSRAM_NVRAM_LTABLE
      macro_RegionInit DYNAMIC_CACHEABLE_EXTSRAM_DEFAULT_CACHEABLE_RW
      macro_RegionInit DYNAMIC_CACHEABLE_EXTSRAM_DEFAULT_NONCACHEABLE_RW
      macro_ZeroInit DYNAMIC_CACHEABLE_EXTSRAM_DEFAULT_NONCACHEABLE_ZI
      macro_ZeroInit DYNAMIC_CACHEABLE_EXTSRAM_DEFAULT_CACHEABLE_ZI




      STMDB sp!, {r7} @ save lr
      BL INT_InitEXTSRAM_ZIwihoutInitDSP
      LDMIA sp!, {r7} @ restore lr


      macro_RegionInit EXTSRAM_DSP_TX
      macro_RegionInit EXTSRAM_DSP_RX



   BX r7 @ Return to caller
.size INT_InitRegions, .-INT_InitRegions
@ }
@

@
@
@
@
@
@
@
@
@
@
@
@
@
@
@
@ VOID SYS_InitRegions(VOID)
@ {
@
    .thumb_func
SYS_InitRegions:

   @
   BX lr @ Return to caller
.size SYS_InitRegions, .-SYS_InitRegions
@ }
@


@ --- copy and zi_init subroutines

@ copy is a subroutine which copies a region, from an address given by
@ r0 to an address given by r1. The address of the word beyond the end
@ of this region is held in r2. r3 is used to hold the word being copied.
.global copy
@copy:
@ .word _copy

    .thumb_func
copy:
        CMP r0, r1
        BEQ copy_exit
copy_loop:
        CMP r1, r2 @ loop whilst r1 < r2
        LDRLO r3, [r0], #4
        STRLO r3, [r1], #4
        BLO copy_loop
copy_exit:
        MOV pc, lr @ return from subroutine copy
.size copy, .-copy

@ backward_copy is a subroutine which copies a region, from an address given by
@ r0 to an address given by r1. The address of the word beyond the end
@ of this region is held in r2. r3 is used to hold the word being copied.
.global backward_copy
@backward_copy:
@ .word _backward_copy

    .thumb_func
backward_copy:
        CMP r0, r1
        BEQ backward_copy_exit
backward_copy_loop:
        CMP r1, r2 @ loop whilst r1 < r2
        LDRGE r3, [r0], #-4
        STRGE r3, [r1], #-4
        BGE backward_copy_loop
backward_copy_exit:
        MOV pc, lr @ return from subroutine copy
.size backward_copy, .-backward_copy

@ zi_init is a subroutine which zero-initialises a region,
@ starting at the address in r0. The address of the word
@ beyond the end of this region is held in r1.
.global zi_init
@zi_init:
@ .word _zi_init
    .thumb_func
zi_init:
        MOV r2, #0
        CMP r0, r1 @ loop whilst r0 < r1
        STRLO r2, [r0], #4
        BLO zi_init
        MOV pc, lr @ return from subroutine zi_init
.size zi_init, .-zi_init

@ zi_init_32 is a subroutine which zero-initialises a region,
@ starting at the address in r0. The length is held in r2.
@ the address of the 4-byte beyound the end of this region is
@ held in r1. set 32 bytes zero per loop.
.global zi_init_32
@zi_init_32:
@ .word _zi_init_32

    .thumb_func
zi_init_32:
        STMDB sp!, {r8-r10} @ save extra working register
        MOV r3, #0
        MOV r8, #0
        MOV r9, #0
        MOV r10, #0
        SUBS r2, r2, #0x20 @ loop while r2 > 32

.global zi_init_32_loop
@zi_init_32_loop:
   @.word _zi_init_32_loop

    .thumb_func
zi_init_32_loop:
        STMCSIA r0!, {r3,r8-r10}
        STMCSIA r0!, {r3,r8-r10}
        SUBCSS r2, r2, #0x20 @ loop while r2 > 32
        BCS zi_init_32_loop
        LDMIA sp!, {r8-r10} @ restore extra working register
        B zi_init
        MOV pc, lr @ return from subroutine zi_init
.size zi_init_32_loop, .-zi_init_32_loop
   .end