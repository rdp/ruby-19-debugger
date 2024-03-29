#!/usr/bin/env bash
# Patches Ruby source.

# usage patch-ruby.sh [combined|1.9.2|1.9.3|2.1.5]

# Environment variable PATCH can be set to specify which patch program
# to use. (For example, on Solaris "patch" might not be the right
# one).

#
function __FILE__ {
    echo ${BASH_SOURCE[0]}
}
patch=${PATCH:-patch}
file=$(__FILE__)
dirname=${file%/*}

patchfile=${1:-'combined'}
case $patchfile in
    2.2.0 | head | trunk )
	for file in \
	    000-config.patch \
	    000-error.patch \
	    000-pc-modify.patch \
	    000-testit.patch \
	    001-disable-cache.patch \
	    130-brkpt.patch \
	    210-iseq-field-access.patch # \
	    # 215-iseq-field-access.patch # \
	    # 220-iseq-eval-source-save.patch \
	    # 230-iseq-top-name.patch \
	    # 240-iseq-SCRIPT_ISEQS__.patch \
	    # 245-method-arity.patch \
	    # 310-os-startup.patch \
	    # 380-method-extra.patch \
	    # 390-proc-iseq.patch \
	    # 400-source-container-method-iseq.patch \
	    # 410-linecache-linetable.patch \
	    # 415-linecache-child-iseqs.patch \
	    # 420-disasm-insns.patch \
	    # 500-frame.patch \
	    # 510-seq-start-insn.patch \
	    # 520-frame-c-argc.patch \
	    # 530-tracepoint-frame.patch \
	    # 540-frame-trace-disable.patch
	do
	    patch_file=${dirname}/../2.2.0/$file
	    echo -- Applying patches in $patch_file ... | tee -a patches_applied.log
	    patch -p1 < $patch_file
	done
	;;
    2.1.5 )
	for file in \
	    0000-extern-access.patch \
	    000-config.patch \
	    000-error.patch \
	    000-pc-modify.patch \
	    000-program-suffix.patch \
	    000-testit.patch \
	    001-disable-cache.patch \
	    130-brkpt.patch \
	    210-iseq-field-access.patch \
	    215-iseq-field-access.patch \
	    220-iseq-eval-source-save.patch \
	    230-iseq-top-name.patch \
	    240-iseq-SCRIPT_ISEQS__.patch \
	    245-method-arity.patch \
	    310-os-startup.patch \
	    380-method-extra.patch \
	    390-proc-iseq.patch \
	    400-source-container-method-iseq.patch \
	    410-linecache-linetable.patch \
	    415-linecache-child-iseqs.patch \
	    420-disasm-insns.patch \
	    500-frame.patch \
	    510-seq-start-insn.patch \
	    520-frame-c-argc.patch \
	    530-tracepoint-frame.patch \
	    540-frame-trace-disable.patch \
	    550-iseq-opname.patch
	do
	    patch_file=${dirname}/../2.1.5/$file
	    echo -- Applying patches in $patch_file ... | tee -a patches_applied.log
	    patch -p1 < $patch_file
	done
	;;
    1.9.3  )
	for file in \
	    000-config.patch \
	    000-error.patch \
	    000-get-sourceline.patch \
	    000-pc-modify.patch \
	    000-testit.patch \
	    110-thread-tracing.patch \
	    120-frame-tracing.patch \
	    130-brkpt.patch \
	    210-iseq-field-access.patch \
	    215-iseq-field-access.patch \
	    220-iseq-eval-source-save.patch \
	    230-iseq-top-name.patch \
	    240-iseq-SCRIPT_ISEQS__.patch \
	    245-method-arity.patch \
	    246-frame.patch \
	    247-c-argc.patch \
	    310-os-startup.patch \
 	    320-disasm-insns.patch \
	    340-trace-func-mask.patch \
	    345-raise-msg.patch \
	    350-c-hook.patch \
	    360-save-compile-opts.patch \
	    370-proc-iseq.patch \
	    380-method-extra.patch \
	    390-trace-yield.patch \
	    400-trace-hook-extra.patch
	do
	    patch_file=${dirname}/../1.9.3/$file
	    echo -- Applying patches in $patch_file ... | tee -a patches_applied.log
	    patch -p1 < $patch_file
	done
	;;
    combined-2.1.5 | combined )
	file=ruby-2.1.5-combined.patch
	patch_file=${dirname}/../$file
	echo -- Applying patches in $patch_file
	$patch -p1 < $patch_file
	;;
    combined-1.9.3 )
	file=ruby-1.9.3-combined.patch
	patch_file=${dirname}/../$file
	echo -- Applying patches in $patch_file
	$patch -p1 < $patch_file
	;;
    1.9.2-single )
	# Up to 04-iseq-access.patch tested
	echo '*** Warning: these patches are not as complete as the 1.9.2 combined patches'
	for file in \
	    00-error.patch \
	    00-eval-source-save.patch \
	    00-extern-access.patch \
	    00-OS_ARGV_and_OS_STARTUP_DIR.patch \
	    00-pc-modify.patch \
	    00-typo.patch \
	    01-get-sourceline.patch \
	    02-frame-trace.patch \
	    03-disasm-insns.patch \
	    04-iseq-access.patch \
	    05-iseq-create.patch \
	    06-C-argc.patch \
	    07-brkpt.patch \
	    08-trace_func.patch \
	    09-raise-msg.patch \
	    10-iseq-top-name.patch \
	    11-binding-arity.patch \
	    12-insn-step.patch \
	    13-hook-error-recover.patch \
	    14-eval-iseq-name.patch \
	    15-send-yield-hook.patch
	do
	    patch_file=${dirname}/../1.9.2/$file
	    echo -- Applying patches in $patch_file ... | tee -a patches_applied.log
	    $patch -p0 < $patch_file
	done
	;;
    1.9.2 | 1.9.2-combined )
	file=ruby-1.9.2-combined.patch
	patch_file=${dirname}/../$file
	echo -- Applying patches in $patch_file
	$patch -p1 < $patch_file
	;;
    esac
