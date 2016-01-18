	.file	"thttpd.c"
	.section	.text.unlikely,"ax",@progbits
.LCOLDB0:
	.text
.LHOTB0:
	.p2align 4,,15
	.type	handle_hup, @function
handle_hup:
.LASANPC2:
.LFB2:
	.cfi_startproc
	movl	$1, got_hup
	ret
	.cfi_endproc
.LFE2:
	.size	handle_hup, .-handle_hup
	.section	.text.unlikely
.LCOLDE0:
	.text
.LHOTE0:
	.section	.rodata
	.align 32
.LC1:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.zero	56
	.section	.text.unlikely
.LCOLDB3:
	.text
.LHOTB3:
	.p2align 4,,15
	.type	thttpd_logstats, @function
thttpd_logstats:
.LASANPC33:
.LFB33:
	.cfi_startproc
	subl	$28, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	jle	.L3
	movl	%eax, 12(%esp)
	subl	$4, %esp
	.cfi_def_cfa_offset 36
	movl	stats_bytes, %eax
	fildl	16(%esp)
	pushl	httpd_conn_count
	.cfi_def_cfa_offset 40
	fildl	stats_bytes
	subl	$8, %esp
	.cfi_def_cfa_offset 48
	cltd
	fdiv	%st(1), %st
	fstpl	(%esp)
	pushl	%edx
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	stats_simultaneous
	.cfi_def_cfa_offset 60
	fildl	stats_connections
	subl	$8, %esp
	.cfi_def_cfa_offset 68
	fdivp	%st, %st(1)
	fstpl	(%esp)
	pushl	stats_connections
	.cfi_def_cfa_offset 72
	pushl	$.LC1
	.cfi_def_cfa_offset 76
	pushl	$6
	.cfi_def_cfa_offset 80
	call	syslog
	addl	$48, %esp
	.cfi_def_cfa_offset 32
.L3:
	movl	$0, stats_connections
	movl	$0, stats_bytes
	movl	$0, stats_simultaneous
	addl	$28, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE33:
	.size	thttpd_logstats, .-thttpd_logstats
	.section	.text.unlikely
.LCOLDE3:
	.text
.LHOTE3:
	.section	.rodata
	.align 32
.LC4:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.zero	58
	.align 32
.LC5:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.zero	34
	.align 32
.LC6:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.zero	63
	.section	.text.unlikely
.LCOLDB7:
	.text
.LHOTB7:
	.p2align 4,,15
	.type	update_throttles, @function
update_throttles:
.LASANPC23:
.LFB23:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	xorl	%ebp, %ebp
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$44, %esp
	.cfi_def_cfa_offset 64
	movl	numthrottles, %eax
	testl	%eax, %eax
	jg	.L128
	jmp	.L26
	.p2align 4,,10
	.p2align 3
.L22:
	addl	$1, %ebp
	cmpl	%ebp, numthrottles
	jle	.L26
.L128:
	leal	0(%ebp,%ebp,2), %eax
	movl	throttles, %ecx
	leal	0(,%eax,8), %edi
	addl	%edi, %ecx
	leal	12(%ecx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L10
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%dl, %bl
	jge	.L177
.L10:
	movl	12(%ecx), %eax
	leal	16(%ecx), %edx
	addl	%eax, %eax
	movl	%eax, (%esp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L11
	movl	%edx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ebx
	cmpb	%al, %bl
	jge	.L178
.L11:
	movl	16(%ecx), %eax
	movl	(%esp), %ebx
	movl	$0, 16(%ecx)
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	addl	%eax, %ebx
	movl	$1431655766, %eax
	imull	%ebx
	leal	4(%ecx), %eax
	sarl	$31, %ebx
	subl	%ebx, %edx
	movl	%eax, %ebx
	shrl	$3, %ebx
	movl	%edx, (%esp)
	movl	%edx, 12(%ecx)
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L12
	movl	%eax, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %edx
	cmpb	%bl, %dl
	jge	.L179
.L12:
	movl	4(%ecx), %eax
	cmpl	%eax, (%esp)
	jle	.L13
	leal	20(%ecx), %ebx
	movl	%ebx, %esi
	movl	%ebx, 4(%esp)
	shrl	$3, %esi
	movzbl	536870912(%esi), %esi
	movl	%esi, %edx
	testb	%dl, %dl
	je	.L14
	andl	$7, %ebx
	leal	3(%ebx), %edx
	movl	%esi, %ebx
	cmpb	%bl, %dl
	jge	.L180
.L14:
	movl	20(%ecx), %esi
	testl	%esi, %esi
	movl	%esi, 4(%esp)
	je	.L13
	leal	(%eax,%eax), %esi
	cmpl	%esi, (%esp)
	movl	%ecx, %esi
	jle	.L15
	shrl	$3, %esi
	movzbl	536870912(%esi), %edx
	testb	%dl, %dl
	je	.L16
	movl	%ecx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ebx
	cmpb	%dl, %bl
	jge	.L181
.L16:
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	pushl	8(%esp)
	.cfi_def_cfa_offset 72
	pushl	%eax
	.cfi_def_cfa_offset 76
	pushl	12(%esp)
	.cfi_def_cfa_offset 80
	pushl	(%ecx)
	.cfi_def_cfa_offset 84
	pushl	%ebp
	.cfi_def_cfa_offset 88
	pushl	$.LC4
	.cfi_def_cfa_offset 92
	pushl	$5
	.cfi_def_cfa_offset 96
	call	syslog
	addl	throttles, %edi
	addl	$32, %esp
	.cfi_def_cfa_offset 64
	leal	12(%edi), %eax
	movl	%edi, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L19
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%dl, %bl
	jge	.L182
.L19:
	movl	12(%ecx), %eax
	movl	%eax, (%esp)
.L13:
	leal	8(%ecx), %eax
	movl	%eax, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L20
	movl	%eax, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %edx
	cmpb	%bl, %dl
	jge	.L183
.L20:
	movl	8(%ecx), %eax
	cmpl	(%esp), %eax
	jle	.L22
	leal	20(%ecx), %edi
	movl	%edi, %esi
	movl	%edi, 4(%esp)
	shrl	$3, %esi
	movzbl	536870912(%esi), %esi
	movl	%esi, %edx
	testb	%dl, %dl
	je	.L23
	andl	$7, %edi
	movl	%esi, %ebx
	addl	$3, %edi
	movl	%edi, %edx
	cmpb	%bl, %dl
	jge	.L184
.L23:
	movl	20(%ecx), %edi
	testl	%edi, %edi
	movl	%edi, 4(%esp)
	je	.L22
	movl	%ecx, %esi
	shrl	$3, %esi
	movzbl	536870912(%esi), %esi
	movl	%esi, %edx
	testb	%dl, %dl
	je	.L25
	movl	%ecx, %edi
	movl	%esi, %ebx
	andl	$7, %edi
	addl	$3, %edi
	movl	%edi, %edx
	cmpb	%bl, %dl
	jge	.L185
.L25:
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	pushl	8(%esp)
	.cfi_def_cfa_offset 72
	pushl	%eax
	.cfi_def_cfa_offset 76
	pushl	12(%esp)
	.cfi_def_cfa_offset 80
	pushl	(%ecx)
	.cfi_def_cfa_offset 84
	pushl	%ebp
	.cfi_def_cfa_offset 88
	pushl	$.LC6
	.cfi_def_cfa_offset 92
	addl	$1, %ebp
	pushl	$5
	.cfi_def_cfa_offset 96
	call	syslog
	addl	$32, %esp
	.cfi_def_cfa_offset 64
	cmpl	%ebp, numthrottles
	jg	.L128
	.p2align 4,,10
	.p2align 3
.L26:
	movl	max_connects, %eax
	movl	connects, %edi
	movl	$0, 12(%esp)
	addl	$56, %edi
	testl	%eax, %eax
	movl	%eax, 28(%esp)
	movl	%edi, %ebp
	jg	.L127
	jmp	.L6
	.p2align 4,,10
	.p2align 3
.L32:
	addl	$1, 12(%esp)
	addl	$96, %ebp
	movl	12(%esp), %eax
	cmpl	28(%esp), %eax
	je	.L6
.L127:
	leal	-56(%ebp), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L27
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L186
.L27:
	movl	-56(%ebp), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L32
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L30
	movl	%ebp, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L187
.L30:
	leal	-4(%ebp), %eax
	movl	$-1, 0(%ebp)
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L31
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L188
.L31:
	movl	-4(%ebp), %eax
	testl	%eax, %eax
	movl	%eax, 16(%esp)
	jle	.L32
	movl	throttles, %eax
	leal	-44(%ebp), %ebx
	movl	$-1, %ecx
	movl	$0, (%esp)
	movl	%eax, 20(%esp)
	movl	%ebp, %eax
	shrl	$3, %eax
	movl	%eax, 8(%esp)
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	movb	%al, 27(%esp)
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L36:
	movl	8(%esp), %esi
	cmpl	%eax, %ecx
	cmovle	%ecx, %eax
	movzbl	536870912(%esi), %edx
	testb	%dl, %dl
	je	.L39
	cmpb	%dl, 27(%esp)
	jge	.L189
.L39:
	addl	$1, (%esp)
	movl	%eax, 0(%ebp)
	addl	$4, %ebx
	movl	(%esp), %eax
	cmpl	16(%esp), %eax
	je	.L32
	movl	8(%esp), %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L40
	cmpb	%al, 27(%esp)
	jge	.L190
.L40:
	movl	0(%ebp), %ecx
.L41:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L33
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L191
.L33:
	movl	(%ebx), %eax
	movl	20(%esp), %edi
	leal	(%eax,%eax,2), %eax
	leal	(%edi,%eax,8), %edi
	leal	4(%edi), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L34
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L192
.L34:
	leal	20(%edi), %esi
	movl	4(%edi), %eax
	movl	%esi, %edx
	shrl	$3, %edx
	movl	%eax, 4(%esp)
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L35
	movl	%esi, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L193
.L35:
	movl	4(%esp), %eax
	cltd
	idivl	20(%edi)
	cmpl	$-1, %ecx
	jne	.L36
	movl	8(%esp), %esi
	movzbl	536870912(%esi), %edx
	testb	%dl, %dl
	je	.L39
	cmpb	%dl, 27(%esp)
	jl	.L39
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L15:
	.cfi_restore_state
	shrl	$3, %esi
	movzbl	536870912(%esi), %edx
	testb	%dl, %dl
	je	.L18
	movl	%ecx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ebx
	cmpb	%dl, %bl
	jge	.L194
.L18:
	subl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 68
	pushl	8(%esp)
	.cfi_def_cfa_offset 72
	pushl	%eax
	.cfi_def_cfa_offset 76
	pushl	12(%esp)
	.cfi_def_cfa_offset 80
	pushl	(%ecx)
	.cfi_def_cfa_offset 84
	pushl	%ebp
	.cfi_def_cfa_offset 88
	pushl	$.LC5
	.cfi_def_cfa_offset 92
	pushl	$6
	.cfi_def_cfa_offset 96
	call	syslog
	addl	throttles, %edi
	addl	$32, %esp
	.cfi_def_cfa_offset 64
	leal	12(%edi), %eax
	movl	%edi, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L19
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%dl, %bl
	jl	.L19
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L6:
	.cfi_restore_state
	addl	$44, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L190:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L189:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L193:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L192:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L191:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L188:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L187:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L186:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L194:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L185:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L184:
	.cfi_restore_state
	movl	4(%esp), %ebx
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L183:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L182:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L181:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L180:
	.cfi_restore_state
	movl	4(%esp), %ebx
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L179:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L178:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L177:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.cfi_endproc
.LFE23:
	.size	update_throttles, .-update_throttles
	.section	.text.unlikely
.LCOLDE7:
	.text
.LHOTE7:
	.section	.rodata
	.align 32
.LC8:
	.string	"%s: no value required for %s option\n"
	.zero	59
	.section	.text.unlikely
.LCOLDB9:
	.text
.LHOTB9:
	.p2align 4,,15
	.type	no_value_required, @function
no_value_required:
.LASANPC12:
.LFB12:
	.cfi_startproc
	testl	%edx, %edx
	jne	.L206
	rep; ret
.L206:
	movl	$stderr, %edx
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	movl	%edx, %ecx
	shrl	$3, %ecx
	subl	$8, %esp
	.cfi_def_cfa_offset 16
	movl	argv0, %ebx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L197
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jge	.L207
.L197:
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	pushl	%ebx
	.cfi_def_cfa_offset 24
	pushl	$.LC8
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L207:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$stderr
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE12:
	.size	no_value_required, .-no_value_required
	.section	.text.unlikely
.LCOLDE9:
	.text
.LHOTE9:
	.section	.rodata
	.align 32
.LC10:
	.string	"%s: value required for %s option\n"
	.zero	62
	.section	.text.unlikely
.LCOLDB11:
	.text
.LHOTB11:
	.p2align 4,,15
	.type	value_required, @function
value_required:
.LASANPC11:
.LFB11:
	.cfi_startproc
	testl	%edx, %edx
	je	.L219
	rep; ret
.L219:
	movl	$stderr, %edx
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	movl	%edx, %ecx
	shrl	$3, %ecx
	subl	$8, %esp
	.cfi_def_cfa_offset 16
	movl	argv0, %ebx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L210
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jge	.L220
.L210:
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	pushl	%ebx
	.cfi_def_cfa_offset 24
	pushl	$.LC10
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L220:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$stderr
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE11:
	.size	value_required, .-value_required
	.section	.text.unlikely
.LCOLDE11:
	.text
.LHOTE11:
	.section	.rodata
	.align 32
.LC12:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.zero	37
	.section	.text.unlikely
.LCOLDB13:
.LHOTB13:
	.type	usage, @function
usage:
.LASANPC9:
.LFB9:
	.cfi_startproc
	movl	$stderr, %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	movl	argv0, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movb	536870912(%edx), %dl
	testb	%dl, %dl
	je	.L222
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L222
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	$stderr
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
.L222:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	%ecx
	.cfi_def_cfa_offset 24
	pushl	$.LC12
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE9:
	.size	usage, .-usage
.LCOLDE13:
.LHOTE13:
.LCOLDB14:
	.text
.LHOTB14:
	.p2align 4,,15
	.type	wakeup_connection, @function
wakeup_connection:
.LASANPC28:
.LFB28:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	leal	16(%esp), %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L231
	leal	16(%esp), %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L275
.L231:
	movl	16(%esp), %eax
	leal	72(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L232
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L276
.L232:
	movl	%eax, %edx
	movl	$0, 72(%eax)
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L233
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L277
.L233:
	cmpl	$3, (%eax)
	je	.L278
	popl	%ebx
	.cfi_remember_state
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L278:
	.cfi_restore_state
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L235
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L279
.L235:
	leal	8(%eax), %edx
	movl	$2, (%eax)
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L236
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L280
.L236:
	movl	8(%eax), %edx
	leal	448(%edx), %edi
	movl	%edi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L237
	movl	%edi, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%bl, %cl
	jge	.L281
.L237:
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	pushl	$1
	.cfi_def_cfa_offset 24
	pushl	%eax
	.cfi_def_cfa_offset 28
	pushl	448(%edx)
	.cfi_def_cfa_offset 32
	call	fdwatch_add_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	popl	%ebx
	.cfi_remember_state
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
.L277:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
.L276:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%edx
	.cfi_def_cfa_offset 32
	call	__asan_report_store4
.L275:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	leal	28(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
.L281:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%edi
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
.L280:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%edx
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
.L279:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	__asan_report_store4
	.cfi_endproc
.LFE28:
	.size	wakeup_connection, .-wakeup_connection
	.section	.text.unlikely
.LCOLDE14:
	.text
.LHOTE14:
	.globl	__asan_stack_malloc_1
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC15:
	.string	"1 32 8 2 tv "
	.section	.rodata
	.align 32
.LC16:
	.string	"up %ld seconds, stats for %ld seconds:"
	.zero	57
	.section	.text.unlikely
.LCOLDB17:
	.text
.LHOTB17:
	.p2align 4,,15
	.type	logstats, @function
logstats:
.LASANPC32:
.LFB32:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %ebx
	subl	$108, %esp
	.cfi_def_cfa_offset 128
	movl	__asan_option_detect_stack_use_after_return, %edx
	movl	%esp, %esi
	movl	%esp, %ebp
	testl	%edx, %edx
	jne	.L296
.L282:
	movl	%esi, %edi
	movl	$1102416563, (%esi)
	movl	$.LC15, 4(%esi)
	shrl	$3, %edi
	testl	%ebx, %ebx
	movl	$.LASANPC32, 8(%esi)
	movl	$-235802127, 536870912(%edi)
	movl	$-185273344, 536870916(%edi)
	movl	$-202116109, 536870920(%edi)
	je	.L297
.L286:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L287
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L298
.L287:
	movl	(%ebx), %eax
	movl	$1, %ecx
	movl	%eax, %edx
	movl	%eax, %ebx
	subl	start_time, %edx
	subl	stats_time, %ebx
	movl	%eax, stats_time
	cmove	%ecx, %ebx
	pushl	%ebx
	.cfi_def_cfa_offset 132
	pushl	%edx
	.cfi_def_cfa_offset 136
	pushl	$.LC16
	.cfi_def_cfa_offset 140
	pushl	$6
	.cfi_def_cfa_offset 144
	call	syslog
	movl	%ebx, %eax
	call	thttpd_logstats
	movl	%ebx, (%esp)
	call	httpd_logstats
	movl	%ebx, (%esp)
	call	mmc_logstats
	movl	%ebx, (%esp)
	call	fdwatch_logstats
	movl	%ebx, (%esp)
	call	tmr_logstats
	addl	$16, %esp
	.cfi_def_cfa_offset 128
	cmpl	%esi, %ebp
	jne	.L299
	movl	$0, 536870912(%edi)
	movl	$0, 536870916(%edi)
	movl	$0, 536870920(%edi)
.L284:
	addl	$108, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L297:
	.cfi_restore_state
	leal	32(%esi), %ebx
	subl	$8, %esp
	.cfi_def_cfa_offset 136
	pushl	$0
	.cfi_def_cfa_offset 140
	pushl	%ebx
	.cfi_def_cfa_offset 144
	call	gettimeofday
	addl	$16, %esp
	.cfi_def_cfa_offset 128
	jmp	.L286
.L298:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 140
	pushl	%ebx
	.cfi_def_cfa_offset 144
	call	__asan_report_load4
.L296:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 132
	pushl	%eax
	.cfi_def_cfa_offset 136
	pushl	%esi
	.cfi_def_cfa_offset 140
	pushl	$96
	.cfi_def_cfa_offset 144
	call	__asan_stack_malloc_1
	addl	$16, %esp
	.cfi_def_cfa_offset 128
	movl	%eax, %esi
	jmp	.L282
.L299:
	movl	$1172321806, (%esi)
	movl	$-168430091, 536870912(%edi)
	movl	$-168430091, 536870916(%edi)
	movl	$-168430091, 536870920(%edi)
	jmp	.L284
	.cfi_endproc
.LFE32:
	.size	logstats, .-logstats
	.section	.text.unlikely
.LCOLDE17:
	.text
.LHOTE17:
	.section	.text.unlikely
.LCOLDB18:
	.text
.LHOTB18:
	.p2align 4,,15
	.type	show_stats, @function
show_stats:
.LASANPC31:
.LFB31:
	.cfi_startproc
	movl	8(%esp), %eax
	jmp	logstats
	.cfi_endproc
.LFE31:
	.size	show_stats, .-show_stats
	.section	.text.unlikely
.LCOLDE18:
	.text
.LHOTE18:
	.section	.text.unlikely
.LCOLDB19:
	.text
.LHOTB19:
	.p2align 4,,15
	.type	handle_usr2, @function
handle_usr2:
.LASANPC4:
.LFB4:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	call	__errno_location
	movl	%eax, %ebx
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L302
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L317
.L302:
	xorl	%eax, %eax
	movl	(%ebx), %esi
	call	logstats
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L303
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L318
.L303:
	movl	%esi, (%ebx)
	addl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
.L318:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%ebx
	.cfi_def_cfa_offset 32
	call	__asan_report_store4
.L317:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%ebx
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE4:
	.size	handle_usr2, .-handle_usr2
	.section	.text.unlikely
.LCOLDE19:
	.text
.LHOTE19:
	.section	.text.unlikely
.LCOLDB20:
	.text
.LHOTB20:
	.p2align 4,,15
	.type	occasional, @function
occasional:
.LASANPC30:
.LFB30:
	.cfi_startproc
	subl	$24, %esp
	.cfi_def_cfa_offset 28
	pushl	32(%esp)
	.cfi_def_cfa_offset 32
	call	mmc_cleanup
	call	tmr_cleanup
	movl	$1, watchdog_flag
	addl	$28, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE30:
	.size	occasional, .-occasional
	.section	.text.unlikely
.LCOLDE20:
	.text
.LHOTE20:
	.section	.rodata
	.align 32
.LC21:
	.string	"/tmp"
	.zero	59
	.section	.text.unlikely
.LCOLDB22:
	.text
.LHOTB22:
	.p2align 4,,15
	.type	handle_alrm, @function
handle_alrm:
.LASANPC5:
.LFB5:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	call	__errno_location
	movl	%eax, %ebx
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L322
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L338
.L322:
	movl	watchdog_flag, %eax
	movl	(%ebx), %esi
	testl	%eax, %eax
	je	.L339
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	movl	$0, watchdog_flag
	pushl	$360
	.cfi_def_cfa_offset 32
	call	alarm
	movl	%ebx, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L324
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L340
.L324:
	movl	%esi, (%ebx)
	addl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
.L340:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%ebx
	.cfi_def_cfa_offset 32
	call	__asan_report_store4
.L338:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%ebx
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
.L339:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$.LC21
	.cfi_def_cfa_offset 32
	call	chdir
	call	__asan_handle_no_return
	call	abort
	.cfi_endproc
.LFE5:
	.size	handle_alrm, .-handle_alrm
	.section	.text.unlikely
.LCOLDE22:
	.text
.LHOTE22:
	.section	.rodata.str1.1
.LC23:
	.string	"1 32 4 6 status "
	.section	.rodata
	.align 32
.LC24:
	.string	"child wait - %m"
	.zero	48
	.section	.text.unlikely
.LCOLDB25:
	.text
.LHOTB25:
	.p2align 4,,15
	.type	handle_chld, @function
handle_chld:
.LASANPC1:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$124, %esp
	.cfi_def_cfa_offset 144
	movl	__asan_option_detect_stack_use_after_return, %eax
	leal	16(%esp), %esi
	testl	%eax, %eax
	jne	.L398
.L341:
	movl	%esi, %ebp
	movl	$1102416563, (%esi)
	movl	$.LC23, 4(%esi)
	shrl	$3, %ebp
	movl	$.LASANPC1, 8(%esi)
	leal	96(%esi), %edi
	movl	$-235802127, 536870912(%ebp)
	movl	$-185273340, 536870916(%ebp)
	movl	$-202116109, 536870920(%ebp)
	call	__errno_location
	movl	%eax, %ebx
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L345
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L399
.L345:
	movl	(%ebx), %eax
	subl	$64, %edi
	movl	%ebx, 4(%esp)
	movl	%eax, 8(%esp)
	movl	%ebx, %eax
	andl	$7, %eax
	addl	$3, %eax
	movb	%al, 15(%esp)
	.p2align 4,,10
	.p2align 3
.L346:
	subl	$4, %esp
	.cfi_def_cfa_offset 148
	pushl	$1
	.cfi_def_cfa_offset 152
	pushl	%edi
	.cfi_def_cfa_offset 156
	pushl	$-1
	.cfi_def_cfa_offset 160
	call	waitpid
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	testl	%eax, %eax
	je	.L396
	js	.L400
	movl	hs, %edx
	testl	%edx, %edx
	je	.L346
	leal	20(%edx), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L352
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L401
.L352:
	movl	20(%edx), %ecx
	subl	$1, %ecx
	js	.L353
	movl	%ecx, 20(%edx)
	jmp	.L346
	.p2align 4,,10
	.p2align 3
.L400:
	movl	4(%esp), %eax
	movl	4(%esp), %ebx
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L349
	cmpb	%al, 15(%esp)
	jge	.L402
.L349:
	movl	(%ebx), %eax
	cmpl	$11, %eax
	je	.L346
	cmpl	$4, %eax
	je	.L346
	cmpl	$10, %eax
	je	.L351
	subl	$8, %esp
	.cfi_def_cfa_offset 152
	pushl	$.LC24
	.cfi_def_cfa_offset 156
	pushl	$3
	.cfi_def_cfa_offset 160
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 144
.L351:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L356
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L403
.L356:
	movl	8(%esp), %eax
	movl	%eax, (%ebx)
	leal	16(%esp), %eax
	cmpl	%esi, %eax
	jne	.L404
	movl	$0, 536870912(%ebp)
	movl	$0, 536870916(%ebp)
	movl	$0, 536870920(%ebp)
.L343:
	addl	$124, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L353:
	.cfi_restore_state
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L354
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L405
.L354:
	movl	$0, 20(%edx)
	jmp	.L346
	.p2align 4,,10
	.p2align 3
.L396:
	movl	4(%esp), %ebx
	jmp	.L351
.L405:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L404:
	.cfi_restore_state
	movl	$1172321806, (%esi)
	movl	$-168430091, 536870912(%ebp)
	movl	$-168430091, 536870916(%ebp)
	movl	$-168430091, 536870920(%ebp)
	jmp	.L343
.L398:
	subl	$8, %esp
	.cfi_def_cfa_offset 152
	pushl	%esi
	.cfi_def_cfa_offset 156
	pushl	$96
	.cfi_def_cfa_offset 160
	call	__asan_stack_malloc_1
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	movl	%eax, %esi
	jmp	.L341
.L403:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ebx
	.cfi_def_cfa_offset 160
	call	__asan_report_store4
.L399:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ebx
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L402:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ebx
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L401:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
	.cfi_endproc
.LFE1:
	.size	handle_chld, .-handle_chld
	.section	.text.unlikely
.LCOLDE25:
	.text
.LHOTE25:
	.section	.rodata
	.align 32
.LC26:
	.string	"out of memory copying a string"
	.zero	33
	.align 32
.LC27:
	.string	"%s: out of memory copying a string\n"
	.zero	60
	.section	.text.unlikely
.LCOLDB28:
	.text
.LHOTB28:
	.p2align 4,,15
	.type	e_strdup, @function
e_strdup:
.LASANPC13:
.LFB13:
	.cfi_startproc
	subl	$24, %esp
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	strdup
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	testl	%eax, %eax
	je	.L416
	addl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4
	ret
.L416:
	.cfi_restore_state
	pushl	%edx
	.cfi_def_cfa_offset 20
	pushl	%edx
	.cfi_def_cfa_offset 24
	pushl	$.LC26
	.cfi_def_cfa_offset 28
	pushl	$2
	.cfi_def_cfa_offset 32
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	movl	argv0, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L408
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L417
.L408:
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	pushl	%ecx
	.cfi_def_cfa_offset 24
	pushl	$.LC27
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L417:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$stderr
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE13:
	.size	e_strdup, .-e_strdup
	.section	.text.unlikely
.LCOLDE28:
	.text
.LHOTE28:
	.globl	__asan_stack_malloc_2
	.section	.rodata.str1.1
.LC29:
	.string	"1 32 100 4 line "
	.section	.rodata
	.align 32
.LC30:
	.string	"r"
	.zero	62
	.align 32
.LC31:
	.string	" \t\n\r"
	.zero	59
	.align 32
.LC32:
	.string	"debug"
	.zero	58
	.align 32
.LC33:
	.string	"port"
	.zero	59
	.align 32
.LC34:
	.string	"dir"
	.zero	60
	.align 32
.LC35:
	.string	"chroot"
	.zero	57
	.align 32
.LC36:
	.string	"nochroot"
	.zero	55
	.align 32
.LC37:
	.string	"data_dir"
	.zero	55
	.align 32
.LC38:
	.string	"symlink"
	.zero	56
	.align 32
.LC39:
	.string	"nosymlink"
	.zero	54
	.align 32
.LC40:
	.string	"symlinks"
	.zero	55
	.align 32
.LC41:
	.string	"nosymlinks"
	.zero	53
	.align 32
.LC42:
	.string	"user"
	.zero	59
	.align 32
.LC43:
	.string	"cgipat"
	.zero	57
	.align 32
.LC44:
	.string	"cgilimit"
	.zero	55
	.align 32
.LC45:
	.string	"urlpat"
	.zero	57
	.align 32
.LC46:
	.string	"noemptyreferers"
	.zero	48
	.align 32
.LC47:
	.string	"localpat"
	.zero	55
	.align 32
.LC48:
	.string	"throttles"
	.zero	54
	.align 32
.LC49:
	.string	"host"
	.zero	59
	.align 32
.LC50:
	.string	"logfile"
	.zero	56
	.align 32
.LC51:
	.string	"vhost"
	.zero	58
	.align 32
.LC52:
	.string	"novhost"
	.zero	56
	.align 32
.LC53:
	.string	"globalpasswd"
	.zero	51
	.align 32
.LC54:
	.string	"noglobalpasswd"
	.zero	49
	.align 32
.LC55:
	.string	"pidfile"
	.zero	56
	.align 32
.LC56:
	.string	"charset"
	.zero	56
	.align 32
.LC57:
	.string	"p3p"
	.zero	60
	.align 32
.LC58:
	.string	"max_age"
	.zero	56
	.align 32
.LC59:
	.string	"%s: unknown config option '%s'\n"
	.zero	32
	.section	.text.unlikely
.LCOLDB60:
	.text
.LHOTB60:
	.p2align 4,,15
	.type	read_config, @function
read_config:
.LASANPC10:
.LFB10:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %ebx
	subl	$220, %esp
	.cfi_def_cfa_offset 240
	leal	16(%esp), %eax
	movl	%eax, 4(%esp)
	movl	__asan_option_detect_stack_use_after_return, %eax
	testl	%eax, %eax
	jne	.L531
.L418:
	movl	4(%esp), %esi
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	movl	%esi, %edi
	movl	$1102416563, (%esi)
	movl	$.LC29, 4(%esi)
	shrl	$3, %edi
	movl	$.LASANPC10, 8(%esi)
	movl	$-235802127, 536870912(%edi)
	movl	$-185273340, 536870928(%edi)
	movl	$-202116109, 536870932(%edi)
	pushl	$.LC30
	.cfi_def_cfa_offset 252
	pushl	%ebx
	.cfi_def_cfa_offset 256
	call	fopen
	movl	%eax, 28(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L526
	movl	%esi, %eax
	addl	$32, %eax
	movl	%eax, 8(%esp)
.L422:
	subl	$4, %esp
	.cfi_def_cfa_offset 244
	pushl	16(%esp)
	.cfi_def_cfa_offset 248
	pushl	$1000
	.cfi_def_cfa_offset 252
	pushl	20(%esp)
	.cfi_def_cfa_offset 256
	call	fgets
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L532
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$35
	.cfi_def_cfa_offset 252
	pushl	20(%esp)
	.cfi_def_cfa_offset 256
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L423
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L424
	movl	%eax, %ecx
	andl	$7, %ecx
	cmpb	%cl, %dl
	jle	.L533
.L424:
	movb	$0, (%eax)
.L423:
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC31
	.cfi_def_cfa_offset 252
	movl	20(%esp), %esi
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strspn
	addl	%eax, %esi
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L425
	movl	%esi, %edx
	andl	$7, %edx
	cmpb	%dl, %al
	jle	.L534
	.p2align 4,,10
	.p2align 3
.L425:
	cmpb	$0, (%esi)
	je	.L422
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC31
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcspn
	addl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L427
	movl	%eax, %ecx
	andl	$7, %ecx
	cmpb	%cl, %dl
	jle	.L535
.L427:
	movzbl	(%eax), %edx
	cmpb	$13, %dl
	sete	%bl
	cmpb	$32, %dl
	sete	%cl
	orb	%cl, %bl
	jne	.L527
	subl	$9, %edx
	cmpb	$1, %dl
	ja	.L468
.L527:
	movl	%eax, (%esp)
	.p2align 4,,10
	.p2align 3
.L508:
	movl	(%esp), %eax
	movl	%eax, %edx
	leal	1(%eax), %ebx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L430
	movl	%eax, %ecx
	andl	$7, %ecx
	cmpb	%cl, %dl
	jle	.L536
.L430:
	movl	%ebx, %eax
	movb	$0, -1(%ebx)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L431
	movl	%ebx, %edx
	andl	$7, %edx
	cmpb	%dl, %al
	jle	.L537
.L431:
	movzbl	(%ebx), %edx
	movl	%ebx, (%esp)
	cmpb	$13, %dl
	sete	%cl
	cmpb	$32, %dl
	movl	%ecx, %ebp
	sete	%cl
	movl	%ebp, %eax
	orb	%cl, %al
	jne	.L508
	subl	$9, %edx
	cmpb	$1, %dl
	jbe	.L508
.L428:
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$61
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L469
	movl	%eax, %edx
	leal	1(%eax), %ebp
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L434
	movl	%eax, %ecx
	andl	$7, %ecx
	cmpb	%cl, %dl
	jle	.L538
.L434:
	movb	$0, (%eax)
.L433:
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC32
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L539
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC33
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L540
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC34
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L541
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC35
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L542
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC36
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L543
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC37
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L544
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC38
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L529
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC39
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L530
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC40
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L529
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC41
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L530
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC42
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L545
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC43
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L546
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC44
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L547
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC45
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L548
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC46
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L549
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC47
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L550
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC48
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L551
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC49
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L552
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC50
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L553
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC51
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L554
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC52
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L555
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC53
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L556
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC54
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L557
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC55
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L558
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC56
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L559
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC57
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	je	.L560
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	$.LC58
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	testl	%eax, %eax
	jne	.L462
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	%ebp
	.cfi_def_cfa_offset 256
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movl	%eax, max_age
	.p2align 4,,10
	.p2align 3
.L436:
	subl	$8, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 248
	pushl	$.LC31
	.cfi_def_cfa_offset 252
	pushl	%ebx
	.cfi_def_cfa_offset 256
	call	strspn
	leal	(%ebx,%eax), %esi
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L425
	movl	%esi, %edx
	andl	$7, %edx
	cmpb	%dl, %al
	jg	.L425
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	__asan_report_load1
	.p2align 4,,10
	.p2align 3
.L539:
	.cfi_restore_state
	movl	%ebp, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, debug
	jmp	.L436
.L540:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	%ebp
	.cfi_def_cfa_offset 256
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movw	%ax, port
	jmp	.L436
.L469:
	xorl	%ebp, %ebp
	jmp	.L433
.L541:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, dir
	jmp	.L436
.L542:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, do_chroot
	movl	$1, no_symlink_check
	jmp	.L436
.L468:
	movl	%eax, %ebx
	jmp	.L428
.L543:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L436
.L529:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$0, no_symlink_check
	jmp	.L436
.L544:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, data_dir
	jmp	.L436
.L530:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, no_symlink_check
	jmp	.L436
.L545:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, user
	jmp	.L436
.L547:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	%ebp
	.cfi_def_cfa_offset 256
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movl	%eax, cgi_limit
	jmp	.L436
.L546:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, cgi_pattern
	jmp	.L436
.L549:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, no_empty_referers
	jmp	.L436
.L548:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, url_pattern
	jmp	.L436
.L550:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, local_pattern
	jmp	.L436
.L532:
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	24(%esp)
	.cfi_def_cfa_offset 256
	call	fclose
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	leal	16(%esp), %eax
	cmpl	4(%esp), %eax
	jne	.L561
	movl	$0, 536870912(%edi)
	movl	$0, 536870928(%edi)
	movl	$0, 536870932(%edi)
	addl	$220, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L534:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%esi
	.cfi_def_cfa_offset 256
	call	__asan_report_load1
.L553:
	.cfi_restore_state
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, logfile
	jmp	.L436
.L552:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, hostname
	jmp	.L436
.L535:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%eax
	.cfi_def_cfa_offset 256
	call	__asan_report_load1
.L561:
	.cfi_restore_state
	movl	4(%esp), %eax
	movl	$1172321806, (%eax)
	movl	$-168430091, 536870912(%edi)
	movl	$-168430091, 536870916(%edi)
	movl	$-168430091, 536870920(%edi)
	movl	$-168430091, 536870924(%edi)
	movl	$-168430091, 536870928(%edi)
	movl	$-168430091, 536870932(%edi)
	addl	$220, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L551:
	.cfi_restore_state
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, throttlefile
	jmp	.L436
.L526:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%ebx
	.cfi_def_cfa_offset 256
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L531:
	.cfi_restore_state
	subl	$8, %esp
	.cfi_def_cfa_offset 248
	pushl	12(%esp)
	.cfi_def_cfa_offset 252
	pushl	$192
	.cfi_def_cfa_offset 256
	call	__asan_stack_malloc_2
	addl	$16, %esp
	.cfi_def_cfa_offset 240
	movl	%eax, 4(%esp)
	jmp	.L418
.L533:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%eax
	.cfi_def_cfa_offset 256
	call	__asan_report_store1
.L536:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%eax
	.cfi_def_cfa_offset 256
	call	__asan_report_store1
.L537:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%ebx
	.cfi_def_cfa_offset 256
	call	__asan_report_load1
.L538:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 252
	pushl	%eax
	.cfi_def_cfa_offset 256
	call	__asan_report_store1
.L462:
	.cfi_restore_state
	movl	$stderr, %eax
	movl	argv0, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L463
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L562
.L463:
	pushl	%esi
	.cfi_remember_state
	.cfi_def_cfa_offset 244
	pushl	%ecx
	.cfi_def_cfa_offset 248
	pushl	$.LC59
	.cfi_def_cfa_offset 252
	pushl	stderr
	.cfi_def_cfa_offset 256
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L557:
	.cfi_restore_state
	movl	%ebp, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$0, do_global_passwd
	jmp	.L436
.L556:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, do_global_passwd
	jmp	.L436
.L555:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$0, do_vhost
	jmp	.L436
.L554:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	no_value_required
	movl	$1, do_vhost
	jmp	.L436
.L559:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, charset
	jmp	.L436
.L558:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, pidfile
	jmp	.L436
.L560:
	movl	%ebp, %edx
	movl	%esi, %eax
	call	value_required
	movl	%ebp, %eax
	call	e_strdup
	movl	%eax, p3p
	jmp	.L436
.L562:
	subl	$12, %esp
	.cfi_def_cfa_offset 252
	pushl	$stderr
	.cfi_def_cfa_offset 256
	call	__asan_report_load4
	.cfi_endproc
.LFE10:
	.size	read_config, .-read_config
	.section	.text.unlikely
.LCOLDE60:
	.text
.LHOTE60:
	.section	.rodata
	.align 32
.LC61:
	.string	"nobody"
	.zero	57
	.align 32
.LC62:
	.string	"iso-8859-1"
	.zero	53
	.align 32
.LC63:
	.string	""
	.zero	63
	.align 32
.LC64:
	.string	"-V"
	.zero	61
	.align 32
.LC65:
	.string	"thttpd/2.27.0 Oct 3, 2014"
	.zero	38
	.align 32
.LC66:
	.string	"-C"
	.zero	61
	.align 32
.LC67:
	.string	"-p"
	.zero	61
	.align 32
.LC68:
	.string	"-d"
	.zero	61
	.align 32
.LC69:
	.string	"-r"
	.zero	61
	.align 32
.LC70:
	.string	"-nor"
	.zero	59
	.align 32
.LC71:
	.string	"-dd"
	.zero	60
	.align 32
.LC72:
	.string	"-s"
	.zero	61
	.align 32
.LC73:
	.string	"-nos"
	.zero	59
	.align 32
.LC74:
	.string	"-u"
	.zero	61
	.align 32
.LC75:
	.string	"-c"
	.zero	61
	.align 32
.LC76:
	.string	"-t"
	.zero	61
	.align 32
.LC77:
	.string	"-h"
	.zero	61
	.align 32
.LC78:
	.string	"-l"
	.zero	61
	.align 32
.LC79:
	.string	"-v"
	.zero	61
	.align 32
.LC80:
	.string	"-nov"
	.zero	59
	.align 32
.LC81:
	.string	"-g"
	.zero	61
	.align 32
.LC82:
	.string	"-nog"
	.zero	59
	.align 32
.LC83:
	.string	"-i"
	.zero	61
	.align 32
.LC84:
	.string	"-T"
	.zero	61
	.align 32
.LC85:
	.string	"-P"
	.zero	61
	.align 32
.LC86:
	.string	"-M"
	.zero	61
	.align 32
.LC87:
	.string	"-D"
	.zero	61
	.section	.text.unlikely
.LCOLDB88:
	.text
.LHOTB88:
	.p2align 4,,15
	.type	parse_args, @function
parse_args:
.LASANPC8:
.LFB8:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	$80, %ecx
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	cmpl	$1, %eax
	movl	$0, debug
	movl	%eax, 4(%esp)
	movl	%edx, 8(%esp)
	movw	%cx, port
	movl	$0, dir
	movl	$0, data_dir
	movl	$0, do_chroot
	movl	$0, no_log
	movl	$0, no_symlink_check
	movl	$0, do_vhost
	movl	$0, do_global_passwd
	movl	$0, cgi_pattern
	movl	$0, cgi_limit
	movl	$0, url_pattern
	movl	$0, no_empty_referers
	movl	$0, local_pattern
	movl	$0, throttlefile
	movl	$0, hostname
	movl	$0, logfile
	movl	$0, pidfile
	movl	$.LC61, user
	movl	$.LC62, charset
	movl	$.LC63, p3p
	movl	$-1, max_age
	jle	.L611
	movl	%edx, %eax
	addl	$4, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L565
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L727
.L565:
	movl	8(%esp), %eax
	movl	4(%eax), %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L566
	movl	%ebx, %edx
	andl	$7, %edx
	cmpb	%dl, %al
	jle	.L728
.L566:
	cmpb	$45, (%ebx)
	jne	.L607
	movl	$1, %ebp
	movl	$3, %edx
	jmp	.L610
	.p2align 4,,10
	.p2align 3
.L733:
	leal	1(%ebp), %esi
	cmpl	%esi, 4(%esp)
	jg	.L729
.L570:
	movl	$.LC69, %edi
	movl	%ebx, %esi
	movl	%edx, %ecx
	repz; cmpsb
	jne	.L576
	movl	$1, do_chroot
	movl	$1, no_symlink_check
.L572:
	addl	$1, %ebp
	cmpl	%ebp, 4(%esp)
	jle	.L564
.L735:
	movl	8(%esp), %eax
	leal	(%eax,%ebp,4), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L608
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L730
.L608:
	movl	(%eax), %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L609
	movl	%ebx, %ecx
	andl	$7, %ecx
	cmpb	%cl, %al
	jle	.L731
.L609:
	cmpb	$45, (%ebx)
	jne	.L607
.L610:
	movl	%ebx, %esi
	movl	$.LC64, %edi
	movl	%edx, %ecx
	repz; cmpsb
	je	.L732
	movl	$.LC66, %edi
	movl	%ebx, %esi
	movl	%edx, %ecx
	repz; cmpsb
	je	.L733
	movl	$.LC67, %edi
	movl	%ebx, %esi
	movl	%edx, %ecx
	repz; cmpsb
	jne	.L573
	leal	1(%ebp), %esi
	cmpl	%esi, 4(%esp)
	jle	.L570
	movl	8(%esp), %eax
	leal	(%eax,%esi,4), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L574
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L734
.L574:
	movl	%edx, 12(%esp)
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	(%eax)
	.cfi_def_cfa_offset 64
	movl	%esi, %ebp
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	addl	$1, %ebp
	movw	%ax, port
	cmpl	%ebp, 4(%esp)
	movl	12(%esp), %edx
	jg	.L735
.L564:
	cmpl	4(%esp), %ebp
	jne	.L607
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L573:
	.cfi_restore_state
	movl	$.LC68, %edi
	movl	%ebx, %esi
	movl	%edx, %ecx
	repz; cmpsb
	jne	.L570
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L570
	movl	8(%esp), %edi
	leal	(%edi,%eax,4), %edi
	movl	%edi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L575
	movl	%edi, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%bl, %cl
	jge	.L736
.L575:
	movl	(%edi), %ecx
	movl	%eax, %ebp
	movl	%ecx, dir
	jmp	.L572
	.p2align 4,,10
	.p2align 3
.L576:
	movl	$.LC70, %edi
	movl	%ebx, %esi
	movl	$5, %ecx
	repz; cmpsb
	jne	.L577
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L572
	.p2align 4,,10
	.p2align 3
.L729:
	movl	8(%esp), %eax
	leal	(%eax,%esi,4), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L571
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L737
.L571:
	movl	(%eax), %eax
	movl	%edx, 12(%esp)
	movl	%esi, %ebp
	call	read_config
	movl	12(%esp), %edx
	jmp	.L572
	.p2align 4,,10
	.p2align 3
.L577:
	movl	$.LC71, %edi
	movl	$4, %ecx
	movl	%ebx, %esi
	repz; cmpsb
	jne	.L578
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L578
	movl	8(%esp), %edi
	leal	(%edi,%eax,4), %edi
	movl	%edi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L579
	movl	%edi, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%bl, %cl
	jge	.L738
.L579:
	movl	(%edi), %ecx
	movl	%eax, %ebp
	movl	%ecx, data_dir
	jmp	.L572
	.p2align 4,,10
	.p2align 3
.L578:
	movl	$.LC72, %edi
	movl	%ebx, %esi
	movl	%edx, %ecx
	repz; cmpsb
	jne	.L580
	movl	$0, no_symlink_check
	jmp	.L572
	.p2align 4,,10
	.p2align 3
.L580:
	movl	$.LC73, %edi
	movl	%ebx, %esi
	movl	$5, %ecx
	repz; cmpsb
	je	.L739
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC74
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L582
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L583
	movl	8(%esp), %edi
	leal	(%edi,%eax,4), %edi
	movl	%edi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L584
	movl	%edi, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%bl, %cl
	jge	.L740
.L584:
	movl	(%edi), %ecx
	movl	%eax, %ebp
	movl	%ecx, user
	jmp	.L572
.L739:
	movl	$1, no_symlink_check
	jmp	.L572
.L582:
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC75
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L585
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L586
	movl	8(%esp), %edi
	leal	(%edi,%eax,4), %edi
	movl	%edi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L587
	movl	%edi, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%bl, %cl
	jl	.L587
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L585:
	.cfi_restore_state
	movl	%edx, 12(%esp)
	pushl	%edi
	.cfi_remember_state
	.cfi_def_cfa_offset 52
	pushl	%edi
	.cfi_def_cfa_offset 56
	pushl	$.LC76
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L588
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L589
	movl	8(%esp), %edi
	leal	(%edi,%eax,4), %edi
	movl	%edi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L590
	movl	%edi, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%bl, %cl
	jl	.L590
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L588:
	.cfi_restore_state
	movl	%edx, 12(%esp)
	pushl	%esi
	.cfi_remember_state
	.cfi_def_cfa_offset 52
	pushl	%esi
	.cfi_def_cfa_offset 56
	pushl	$.LC77
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L591
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L589
	movl	8(%esp), %edi
	leal	(%edi,%eax,4), %edi
	movl	%edi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L592
	movl	%edi, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%bl, %cl
	jl	.L592
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L583:
	.cfi_restore_state
	movl	%edx, 12(%esp)
	pushl	%ecx
	.cfi_def_cfa_offset 52
	pushl	%ecx
	.cfi_def_cfa_offset 56
	pushl	$.LC76
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L588
.L591:
	movl	%edx, 12(%esp)
	pushl	%ecx
	.cfi_def_cfa_offset 52
	pushl	%ecx
	.cfi_def_cfa_offset 56
	pushl	$.LC78
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L589
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L589
	movl	8(%esp), %edi
	leal	(%edi,%eax,4), %edi
	movl	%edi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %esi
	movl	%esi, %ebx
	testb	%bl, %bl
	je	.L593
	movl	%edi, %ebx
	movl	%esi, %ecx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L741
.L593:
	movl	(%edi), %ecx
	movl	%eax, %ebp
	movl	%ecx, logfile
	jmp	.L572
.L587:
	movl	(%edi), %ecx
	movl	%eax, %ebp
	movl	%ecx, cgi_pattern
	jmp	.L572
.L586:
	movl	%edx, 12(%esp)
	pushl	%edx
	.cfi_def_cfa_offset 52
	pushl	%edx
	.cfi_def_cfa_offset 56
	pushl	$.LC77
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L591
.L589:
	movl	%edx, 12(%esp)
	pushl	%edx
	.cfi_def_cfa_offset 52
	pushl	%edx
	.cfi_def_cfa_offset 56
	pushl	$.LC79
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L594
	movl	$1, do_vhost
	jmp	.L572
.L590:
	movl	(%edi), %ecx
	movl	%eax, %ebp
	movl	%ecx, throttlefile
	jmp	.L572
.L592:
	movl	(%edi), %ecx
	movl	%eax, %ebp
	movl	%ecx, hostname
	jmp	.L572
.L594:
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC80
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	je	.L742
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC81
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L596
	movl	$1, do_global_passwd
	jmp	.L572
.L742:
	movl	$0, do_vhost
	jmp	.L572
.L611:
	movl	$1, %ebp
	jmp	.L564
.L596:
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC82
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L597
	movl	$0, do_global_passwd
	jmp	.L572
.L732:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	$.LC65
	.cfi_def_cfa_offset 64
	call	puts
	call	__asan_handle_no_return
	movl	$0, (%esp)
	call	exit
.L597:
	.cfi_restore_state
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC83
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L598
	leal	1(%ebp), %edi
	cmpl	%edi, 4(%esp)
	jle	.L599
	movl	8(%esp), %eax
	leal	(%eax,%edi,4), %eax
	movl	%eax, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %esi
	movl	%esi, %ebx
	testb	%bl, %bl
	je	.L600
	movl	%eax, %ebx
	movl	%esi, %ecx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L743
.L600:
	movl	(%eax), %eax
	movl	%edi, %ebp
	movl	%eax, pidfile
	jmp	.L572
.L598:
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC84
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L601
	leal	1(%ebp), %edi
	cmpl	%edi, 4(%esp)
	jle	.L602
	movl	8(%esp), %eax
	leal	(%eax,%edi,4), %eax
	movl	%eax, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %esi
	movl	%esi, %ebx
	testb	%bl, %bl
	je	.L603
	movl	%eax, %ebx
	movl	%esi, %ecx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L744
.L603:
	movl	(%eax), %eax
	movl	%edi, %ebp
	movl	%eax, charset
	jmp	.L572
.L601:
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC85
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L604
	leal	1(%ebp), %edi
	cmpl	%edi, 4(%esp)
	jle	.L602
	movl	8(%esp), %eax
	leal	(%eax,%edi,4), %eax
	movl	%eax, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %esi
	movl	%esi, %ebx
	testb	%bl, %bl
	je	.L605
	movl	%eax, %ebx
	movl	%esi, %ecx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L745
.L605:
	movl	(%eax), %eax
	movl	%edi, %ebp
	movl	%eax, p3p
	jmp	.L572
.L604:
	movl	%edx, 12(%esp)
	pushl	%edi
	.cfi_def_cfa_offset 52
	pushl	%edi
	.cfi_def_cfa_offset 56
	pushl	$.LC86
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L602
	leal	1(%ebp), %esi
	cmpl	%esi, 4(%esp)
	jle	.L602
	movl	8(%esp), %eax
	leal	(%eax,%esi,4), %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	testb	%bl, %bl
	je	.L606
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%bl, %cl
	jge	.L746
.L606:
	movl	%edx, 12(%esp)
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	(%eax)
	.cfi_def_cfa_offset 64
	movl	%esi, %ebp
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	%eax, max_age
	movl	12(%esp), %edx
	jmp	.L572
.L599:
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC85
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L604
.L602:
	movl	%edx, 12(%esp)
	pushl	%esi
	.cfi_def_cfa_offset 52
	pushl	%esi
	.cfi_def_cfa_offset 56
	pushl	$.LC87
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L607
	movl	$1, debug
	movl	12(%esp), %edx
	jmp	.L572
.L745:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L746:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L744:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L741:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L607:
	.cfi_restore_state
	call	__asan_handle_no_return
	call	usage
.L740:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L743:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L731:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load1
.L730:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L728:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load1
.L734:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L737:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L727:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L738:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L736:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
	.cfi_endproc
.LFE8:
	.size	parse_args, .-parse_args
	.section	.text.unlikely
.LCOLDE88:
	.text
.LHOTE88:
	.globl	__asan_stack_malloc_8
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC89:
	.string	"5 32 4 9 max_limit 96 4 9 min_limit 160 8 2 tv 224 5000 3 buf 5280 5000 7 pattern "
	.globl	__asan_stack_free_8
	.section	.rodata
	.align 32
.LC90:
	.string	"%.80s - %m"
	.zero	53
	.align 32
.LC91:
	.string	" %4900[^ \t] %ld-%ld"
	.zero	44
	.align 32
.LC92:
	.string	" %4900[^ \t] %ld"
	.zero	48
	.align 32
.LC93:
	.string	"unparsable line in %.80s - %.80s"
	.zero	63
	.align 32
.LC94:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.zero	58
	.align 32
.LC95:
	.string	"|/"
	.zero	61
	.align 32
.LC96:
	.string	"out of memory allocating a throttletab"
	.zero	57
	.align 32
.LC97:
	.string	"%s: out of memory allocating a throttletab\n"
	.zero	52
	.section	.text.unlikely
.LCOLDB98:
	.text
.LHOTB98:
	.p2align 4,,15
	.type	read_throttlefile, @function
read_throttlefile:
.LASANPC15:
.LFB15:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$10380, %esp
	.cfi_def_cfa_offset 10400
	movl	%eax, 16(%esp)
	leal	32(%esp), %eax
	movl	%eax, 20(%esp)
	movl	__asan_option_detect_stack_use_after_return, %eax
	testl	%eax, %eax
	jne	.L890
.L747:
	movl	20(%esp), %eax
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	leal	10336(%eax), %esi
	movl	%esi, 16(%esp)
	movl	$1102416563, (%eax)
	movl	$.LC89, 4(%eax)
	movl	$.LASANPC15, 8(%eax)
	shrl	$3, %eax
	movl	%eax, 36(%esp)
	movl	$-235802127, 536870912(%eax)
	movl	$-185273340, 536870916(%eax)
	movl	$-218959118, 536870920(%eax)
	movl	$-185273340, 536870924(%eax)
	movl	$-218959118, 536870928(%eax)
	movl	$-185273344, 536870932(%eax)
	movl	$-218959118, 536870936(%eax)
	movl	$-185273344, 536871564(%eax)
	movl	$-218959118, 536871568(%eax)
	movl	$-185273344, 536872196(%eax)
	movl	$-202116109, 536872200(%eax)
	pushl	$.LC30
	.cfi_def_cfa_offset 10412
	pushl	28(%esp)
	.cfi_def_cfa_offset 10416
	call	fopen
	movl	%eax, 28(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	testl	%eax, %eax
	je	.L891
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	pushl	$0
	.cfi_def_cfa_offset 10412
	movl	32(%esp), %esi
	movl	%esi, %eax
	leal	224(%esi), %edi
	addl	$160, %eax
	pushl	%eax
	.cfi_def_cfa_offset 10416
	call	gettimeofday
	movl	$stderr, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	shrl	$3, %eax
	movl	%eax, 24(%esp)
	.p2align 4,,10
	.p2align 3
.L754:
	movl	%edi, %eax
	movl	%edi, %esi
	andl	$7, %eax
	shrl	$3, %esi
	movl	%eax, %ebp
.L770:
	subl	$4, %esp
	.cfi_def_cfa_offset 10404
	pushl	16(%esp)
	.cfi_def_cfa_offset 10408
	pushl	$5000
	.cfi_def_cfa_offset 10412
	pushl	%edi
	.cfi_def_cfa_offset 10416
	call	fgets
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	testl	%eax, %eax
	je	.L892
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	pushl	$35
	.cfi_def_cfa_offset 10412
	pushl	%edi
	.cfi_def_cfa_offset 10416
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	testl	%eax, %eax
	je	.L755
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L756
	movl	%eax, %ecx
	andl	$7, %ecx
	cmpb	%cl, %dl
	jle	.L893
.L756:
	movb	$0, (%eax)
.L755:
	movl	%edi, %eax
.L757:
	movl	(%eax), %ecx
	addl	$4, %eax
	leal	-16843009(%ecx), %edx
	notl	%ecx
	andl	%ecx, %edx
	andl	$-2139062144, %edx
	je	.L757
	movl	%edx, %ecx
	shrl	$16, %ecx
	testl	$32896, %edx
	cmove	%ecx, %edx
	leal	2(%eax), %ecx
	cmove	%ecx, %eax
	addb	%dl, %dl
	movzbl	536870912(%esi), %edx
	sbbl	$3, %eax
	subl	%edi, %eax
	testb	%dl, %dl
	je	.L759
	movl	%ebp, %ebx
	cmpb	%bl, %dl
	jle	.L894
.L759:
	leal	(%edi,%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L760
	movl	%edx, %ebx
	andl	$7, %ebx
	cmpb	%bl, %cl
	jle	.L895
.L760:
	testl	%eax, %eax
	movl	%eax, %ecx
	jle	.L761
	subl	$1, %eax
	leal	(%edi,%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L762
	movl	%edx, %ebx
	andl	$7, %ebx
	cmpb	%bl, %cl
	jle	.L896
.L762:
	movl	8(%esp), %ebx
	movzbl	-10112(%eax,%ebx), %edx
	cmpb	$13, %dl
	sete	%bl
	cmpb	$32, %dl
	sete	%cl
	orb	%cl, %bl
	jne	.L763
	subl	$9, %edx
	cmpb	$1, %dl
	ja	.L769
.L763:
	addl	%edi, %eax
	.p2align 4,,10
	.p2align 3
.L853:
	movl	%eax, %edx
	movl	%eax, %ecx
	shrl	$3, %edx
	subl	%edi, %ecx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L766
	movl	%eax, %ebx
	andl	$7, %ebx
	cmpb	%bl, %dl
	jle	.L897
.L766:
	cmpl	%edi, %eax
	movb	$0, (%eax)
	je	.L761
	leal	-1(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L767
	movl	%ecx, %ebx
	andl	$7, %ebx
	cmpb	%bl, %dl
	jle	.L898
.L767:
	movzbl	-1(%eax), %edx
	movl	%ecx, %eax
	cmpb	$13, %dl
	sete	%bl
	cmpb	$32, %dl
	sete	%cl
	orb	%cl, %bl
	jne	.L853
	subl	$9, %edx
	cmpb	$1, %dl
	jbe	.L853
.L769:
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	movl	20(%esp), %ebx
	movl	%ebx, %eax
	leal	-10304(%ebx), %esi
	leal	-5056(%ebx), %ebp
	subl	$10240, %eax
	pushl	%esi
	.cfi_def_cfa_offset 10416
	pushl	%eax
	.cfi_def_cfa_offset 10420
	pushl	%ebp
	.cfi_def_cfa_offset 10424
	pushl	$.LC91
	.cfi_def_cfa_offset 10428
	pushl	%edi
	.cfi_def_cfa_offset 10432
	call	__isoc99_sscanf
	addl	$32, %esp
	.cfi_def_cfa_offset 10400
	cmpl	$3, %eax
	je	.L764
	pushl	%esi
	.cfi_def_cfa_offset 10404
	pushl	%ebp
	.cfi_def_cfa_offset 10408
	pushl	$.LC92
	.cfi_def_cfa_offset 10412
	pushl	%edi
	.cfi_def_cfa_offset 10416
	call	__isoc99_sscanf
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	cmpl	$2, %eax
	jne	.L771
	movl	8(%esp), %eax
	movl	$0, -10240(%eax)
	.p2align 4,,10
	.p2align 3
.L764:
	movl	8(%esp), %eax
	cmpb	$47, -5056(%eax)
	jne	.L775
	jmp	.L899
	.p2align 4,,10
	.p2align 3
.L776:
	leal	2(%eax), %edx
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	addl	$1, %eax
	pushl	%edx
	.cfi_def_cfa_offset 10412
	pushl	%eax
	.cfi_def_cfa_offset 10416
	call	strcpy
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
.L775:
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	pushl	$.LC95
	.cfi_def_cfa_offset 10412
	pushl	%ebp
	.cfi_def_cfa_offset 10416
	call	strstr
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	testl	%eax, %eax
	jne	.L776
	movl	numthrottles, %edx
	movl	maxthrottles, %eax
	cmpl	%eax, %edx
	jl	.L777
	testl	%eax, %eax
	jne	.L778
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	movl	$100, maxthrottles
	pushl	$2400
	.cfi_def_cfa_offset 10416
	call	malloc
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	movl	%eax, throttles
.L779:
	testl	%eax, %eax
	je	.L780
	movl	numthrottles, %edx
.L781:
	leal	(%edx,%edx,2), %edx
	leal	(%eax,%edx,8), %esi
	movl	%ebp, %eax
	call	e_strdup
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L783
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L900
.L783:
	movl	numthrottles, %ebp
	movl	%eax, (%esi)
	movl	throttles, %eax
	movl	8(%esp), %esi
	leal	0(%ebp,%ebp,2), %edx
	movl	-10304(%esi), %esi
	leal	(%eax,%edx,8), %eax
	leal	4(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L784
	movl	%ecx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%dl, %bl
	jge	.L901
.L784:
	leal	8(%eax), %ecx
	movl	%esi, 4(%eax)
	movl	8(%esp), %esi
	movl	%ecx, %edx
	shrl	$3, %edx
	movl	-10240(%esi), %esi
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L785
	movl	%ecx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%dl, %bl
	jge	.L902
.L785:
	leal	12(%eax), %ecx
	movl	%esi, 8(%eax)
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L786
	movl	%ecx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ebx
	cmpb	%dl, %bl
	jge	.L903
.L786:
	leal	16(%eax), %ecx
	movl	$0, 12(%eax)
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L787
	movl	%ecx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ebx
	cmpb	%dl, %bl
	jge	.L904
.L787:
	leal	20(%eax), %ecx
	movl	$0, 16(%eax)
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L788
	movl	%ecx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ebx
	cmpb	%dl, %bl
	jge	.L905
.L788:
	movl	$0, 20(%eax)
	leal	1(%ebp), %eax
	movl	%eax, numthrottles
	jmp	.L754
	.p2align 4,,10
	.p2align 3
.L761:
	testl	%ecx, %ecx
	je	.L770
	jmp	.L769
.L778:
	leal	(%eax,%eax), %edx
	subl	$8, %esp
	.cfi_def_cfa_offset 10408
	leal	(%edx,%eax,4), %eax
	movl	%edx, maxthrottles
	sall	$3, %eax
	pushl	%eax
	.cfi_def_cfa_offset 10412
	pushl	throttles
	.cfi_def_cfa_offset 10416
	call	realloc
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	movl	%eax, throttles
	jmp	.L779
.L771:
	pushl	%edi
	.cfi_def_cfa_offset 10404
	pushl	20(%esp)
	.cfi_def_cfa_offset 10408
	pushl	$.LC93
	.cfi_def_cfa_offset 10412
	pushl	$2
	.cfi_def_cfa_offset 10416
	call	syslog
	movl	40(%esp), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	movl	argv0, %edx
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L772
	movl	$stderr, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L906
.L772:
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	pushl	%edi
	.cfi_def_cfa_offset 10416
	pushl	32(%esp)
	.cfi_def_cfa_offset 10420
	pushl	%edx
	.cfi_def_cfa_offset 10424
	pushl	$.LC94
	.cfi_def_cfa_offset 10428
	pushl	stderr
	.cfi_def_cfa_offset 10432
	call	fprintf
	addl	$32, %esp
	.cfi_def_cfa_offset 10400
	jmp	.L754
.L777:
	movl	throttles, %eax
	jmp	.L781
.L892:
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	pushl	24(%esp)
	.cfi_def_cfa_offset 10416
	call	fclose
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	leal	32(%esp), %eax
	cmpl	20(%esp), %eax
	jne	.L907
	movl	28(%esp), %esi
	xorl	%edx, %edx
	leal	536870916(%esi), %ecx
	movl	%esi, %eax
	movl	$0, 536870912(%esi)
	addl	$536870912, %eax
	movl	$0, 536870936(%esi)
	andl	$-4, %ecx
	subl	%ecx, %eax
	addl	$28, %eax
	andl	$-4, %eax
.L750:
	movl	$0, (%ecx,%edx)
	addl	$4, %edx
	cmpl	%eax, %edx
	jb	.L750
	movl	28(%esp), %eax
	movl	$0, 536871564(%eax)
	movl	$0, 536871568(%eax)
	movl	$0, 536872196(%eax)
	movl	$0, 536872200(%eax)
.L749:
	addl	$10380, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L899:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 10404
	pushl	%eax
	.cfi_def_cfa_offset 10408
	movl	16(%esp), %eax
	subl	$5055, %eax
	pushl	%eax
	.cfi_def_cfa_offset 10412
	pushl	%ebp
	.cfi_def_cfa_offset 10416
	call	strcpy
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	jmp	.L775
.L890:
	pushl	%eax
	.cfi_def_cfa_offset 10404
	pushl	%eax
	.cfi_def_cfa_offset 10408
	pushl	28(%esp)
	.cfi_def_cfa_offset 10412
	pushl	$10336
	.cfi_def_cfa_offset 10416
	call	__asan_stack_malloc_8
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	movl	%eax, 20(%esp)
	jmp	.L747
.L907:
	movl	20(%esp), %eax
	movl	$1172321806, (%eax)
	pushl	%edx
	.cfi_def_cfa_offset 10404
	leal	36(%esp), %esi
	pushl	%esi
	.cfi_def_cfa_offset 10408
	pushl	$10336
	.cfi_def_cfa_offset 10412
	pushl	%eax
	.cfi_def_cfa_offset 10416
	call	__asan_stack_free_8
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	jmp	.L749
.L906:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	$stderr
	.cfi_def_cfa_offset 10416
	call	__asan_report_load4
.L905:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%ecx
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L904:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%ecx
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L903:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%ecx
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L902:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%ecx
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L901:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%ecx
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L900:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%esi
	.cfi_def_cfa_offset 10416
	call	__asan_report_store4
.L780:
	.cfi_restore_state
	pushl	%esi
	.cfi_def_cfa_offset 10404
	pushl	%esi
	.cfi_def_cfa_offset 10408
	pushl	$.LC96
	.cfi_def_cfa_offset 10412
	pushl	$2
	.cfi_def_cfa_offset 10416
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 10400
	movl	argv0, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L782
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L908
.L782:
	pushl	%ebx
	.cfi_remember_state
	.cfi_def_cfa_offset 10404
	pushl	%ecx
	.cfi_def_cfa_offset 10408
	pushl	$.LC97
	.cfi_def_cfa_offset 10412
	pushl	stderr
	.cfi_def_cfa_offset 10416
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L895:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%edx
	.cfi_def_cfa_offset 10416
	call	__asan_report_load1
.L894:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%edi
	.cfi_def_cfa_offset 10416
	call	__asan_report_load1
.L893:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%eax
	.cfi_def_cfa_offset 10416
	call	__asan_report_store1
.L891:
	.cfi_restore_state
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 10404
	movl	20(%esp), %esi
	pushl	%esi
	.cfi_def_cfa_offset 10408
	pushl	$.LC90
	.cfi_def_cfa_offset 10412
	pushl	$2
	.cfi_def_cfa_offset 10416
	call	syslog
	movl	%esi, (%esp)
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L897:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%eax
	.cfi_def_cfa_offset 10416
	call	__asan_report_store1
.L896:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%edx
	.cfi_def_cfa_offset 10416
	call	__asan_report_load1
.L898:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 10412
	pushl	%ecx
	.cfi_def_cfa_offset 10416
	call	__asan_report_load1
.L908:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 10412
	pushl	$stderr
	.cfi_def_cfa_offset 10416
	call	__asan_report_load4
	.cfi_endproc
.LFE15:
	.size	read_throttlefile, .-read_throttlefile
	.section	.text.unlikely
.LCOLDE98:
	.text
.LHOTE98:
	.section	.rodata
	.align 32
.LC99:
	.string	"-"
	.zero	62
	.align 32
.LC100:
	.string	"re-opening logfile"
	.zero	45
	.align 32
.LC101:
	.string	"a"
	.zero	62
	.align 32
.LC102:
	.string	"re-opening %.80s - %m"
	.zero	42
	.section	.text.unlikely
.LCOLDB103:
	.text
.LHOTB103:
	.p2align 4,,15
	.type	re_open_logfile, @function
re_open_logfile:
.LASANPC6:
.LFB6:
	.cfi_startproc
	movl	no_log, %eax
	testl	%eax, %eax
	jne	.L922
	movl	hs, %eax
	testl	%eax, %eax
	je	.L922
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	movl	logfile, %esi
	testl	%esi, %esi
	je	.L909
	movl	$.LC99, %edi
	movl	$2, %ecx
	repz; cmpsb
	jne	.L923
.L909:
	addl	$4, %esp
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
.L922:
	rep; ret
	.p2align 4,,10
	.p2align 3
.L923:
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -12
	.cfi_offset 7, -8
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	pushl	$.LC100
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	popl	%ecx
	.cfi_def_cfa_offset 28
	popl	%esi
	.cfi_def_cfa_offset 24
	pushl	$.LC101
	.cfi_def_cfa_offset 28
	pushl	logfile
	.cfi_def_cfa_offset 32
	call	fopen
	popl	%edi
	.cfi_def_cfa_offset 28
	movl	%eax, %esi
	popl	%eax
	.cfi_def_cfa_offset 24
	pushl	$384
	.cfi_def_cfa_offset 28
	pushl	logfile
	.cfi_def_cfa_offset 32
	call	chmod
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	testl	%eax, %eax
	jne	.L913
	testl	%esi, %esi
	je	.L913
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%esi
	.cfi_def_cfa_offset 32
	call	fileno
	addl	$12, %esp
	.cfi_def_cfa_offset 20
	pushl	$1
	.cfi_def_cfa_offset 24
	pushl	$2
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	fcntl
	popl	%eax
	.cfi_def_cfa_offset 28
	popl	%edx
	.cfi_def_cfa_offset 24
	pushl	%esi
	.cfi_def_cfa_offset 28
	pushl	hs
	.cfi_def_cfa_offset 32
	call	httpd_set_logfp
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	addl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	jmp	.L922
	.p2align 4,,10
	.p2align 3
.L913:
	.cfi_restore_state
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	pushl	logfile
	.cfi_def_cfa_offset 24
	pushl	$.LC102
	.cfi_def_cfa_offset 28
	pushl	$2
	.cfi_def_cfa_offset 32
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	jmp	.L909
	.cfi_endproc
.LFE6:
	.size	re_open_logfile, .-re_open_logfile
	.section	.text.unlikely
.LCOLDE103:
	.text
.LHOTE103:
	.section	.rodata
	.align 32
.LC104:
	.string	"too many connections!"
	.zero	42
	.align 32
.LC105:
	.string	"the connects free list is messed up"
	.zero	60
	.align 32
.LC106:
	.string	"out of memory allocating an httpd_conn"
	.zero	57
	.section	.text.unlikely
.LCOLDB107:
	.text
.LHOTB107:
	.p2align 4,,15
	.type	handle_newconnect, @function
handle_newconnect:
.LASANPC17:
.LFB17:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%eax, %edi
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	%edx, %ebp
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%edi, %edx
	andl	$7, %edx
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	movl	num_connects, %eax
	leal	3(%edx), %ecx
	movb	%cl, 8(%esp)
.L949:
	cmpl	%eax, max_connects
	jle	.L1053
	movl	first_free_connect, %eax
	cmpl	$-1, %eax
	je	.L929
	leal	(%eax,%eax,2), %ebx
	sall	$5, %ebx
	addl	connects, %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L928
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1054
.L928:
	movl	(%ebx), %edx
	testl	%edx, %edx
	jne	.L929
	leal	8(%ebx), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L930
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1055
.L930:
	movl	8(%ebx), %eax
	testl	%eax, %eax
	je	.L1056
.L931:
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	%ebp
	.cfi_def_cfa_offset 60
	pushl	hs
	.cfi_def_cfa_offset 64
	call	httpd_get_conn
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L936
	cmpl	$2, %eax
	je	.L951
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L937
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1057
.L937:
	leal	4(%ebx), %eax
	movl	$1, (%ebx)
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L938
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1058
.L938:
	movl	4(%ebx), %eax
	addl	$1, num_connects
	movl	$-1, 4(%ebx)
	movl	%eax, first_free_connect
	movl	%edi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L939
	cmpb	%al, 8(%esp)
	jge	.L1059
.L939:
	movl	(%edi), %eax
	movl	%eax, 12(%esp)
	leal	68(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L940
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1060
.L940:
	movl	12(%esp), %eax
	movl	%eax, 68(%ebx)
	leal	72(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L941
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1061
.L941:
	leal	76(%ebx), %eax
	movl	$0, 72(%ebx)
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L942
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1062
.L942:
	leal	92(%ebx), %eax
	movl	$0, 76(%ebx)
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L943
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1063
.L943:
	leal	52(%ebx), %eax
	movl	$0, 92(%ebx)
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L944
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1064
.L944:
	movl	%esi, %eax
	movl	$0, 52(%ebx)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L945
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1065
.L945:
	movl	8(%ebx), %eax
	leal	448(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	movb	%dl, 12(%esp)
	je	.L946
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	12(%esp), %dl
	jge	.L1066
.L946:
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	448(%eax)
	.cfi_def_cfa_offset 64
	call	httpd_set_ndelay
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L947
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1067
.L947:
	movl	8(%ebx), %eax
	leal	448(%eax), %esi
	movl	%esi, %ecx
	movl	%esi, 12(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L948
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %edx
	cmpb	%cl, %dl
	jge	.L1068
.L948:
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	pushl	$0
	.cfi_def_cfa_offset 56
	pushl	%ebx
	.cfi_def_cfa_offset 60
	pushl	448(%eax)
	.cfi_def_cfa_offset 64
	call	fdwatch_add_fd
	addl	$1, stats_connections
	movl	num_connects, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	cmpl	stats_simultaneous, %eax
	jle	.L949
	movl	%eax, stats_simultaneous
	jmp	.L949
	.p2align 4,,10
	.p2align 3
.L951:
	movl	$1, %eax
.L926:
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L936:
	.cfi_restore_state
	movl	%eax, 8(%esp)
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	tmr_run
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	8(%esp), %eax
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L1056:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	$456
	.cfi_def_cfa_offset 64
	call	malloc
	movl	%esi, %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L932
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1069
.L932:
	testl	%eax, %eax
	movl	%eax, 8(%ebx)
	je	.L1070
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L934
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1071
.L934:
	movl	$0, (%eax)
	addl	$1, httpd_conn_count
	jmp	.L931
.L1071:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1069:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L1053:
	.cfi_restore_state
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC104
	.cfi_def_cfa_offset 60
	pushl	$4
	.cfi_def_cfa_offset 64
	call	syslog
	movl	%edi, (%esp)
	call	tmr_run
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	xorl	%eax, %eax
	jmp	.L926
.L929:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC105
	.cfi_def_cfa_offset 60
.L1051:
	pushl	$2
	.cfi_def_cfa_offset 64
	call	syslog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L1070:
	.cfi_def_cfa_offset 48
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC106
	.cfi_def_cfa_offset 60
	jmp	.L1051
.L1059:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1068:
	.cfi_restore_state
	movl	12(%esp), %edx
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1054:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1057:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1058:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1067:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1060:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1061:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1062:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1063:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1064:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1065:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1066:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ecx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1055:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
	.cfi_endproc
.LFE17:
	.size	handle_newconnect, .-handle_newconnect
	.section	.text.unlikely
.LCOLDE107:
	.text
.LHOTE107:
	.section	.rodata
	.align 32
.LC108:
	.string	"throttle sending count was negative - shouldn't happen!"
	.zero	40
	.section	.text.unlikely
.LCOLDB109:
	.text
.LHOTB109:
	.p2align 4,,15
	.type	check_throttles, @function
check_throttles:
.LASANPC21:
.LFB21:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%eax, %ebp
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	leal	52(%eax), %eax
	subl	$60, %esp
	.cfi_def_cfa_offset 80
	movl	%eax, %edx
	movl	%eax, 12(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1073
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1239
.L1073:
	leal	60(%ebp), %eax
	movl	$0, 52(%ebp)
	movl	%eax, %edx
	movl	%eax, 36(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1074
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1240
.L1074:
	leal	56(%ebp), %eax
	movl	$-1, 60(%ebp)
	movl	%eax, %edx
	movl	%eax, 32(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1075
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1241
.L1075:
	leal	8(%ebp), %eax
	xorl	%esi, %esi
	xorl	%edi, %edi
	movl	$-1, 56(%ebp)
	movl	%eax, 16(%esp)
	andl	$7, %eax
	addl	$3, %eax
	movb	%al, 43(%esp)
	movl	numthrottles, %eax
	testl	%eax, %eax
	jg	.L1192
	jmp	.L1101
	.p2align 4,,10
	.p2align 3
.L1099:
	movl	24(%esp), %ebx
	movl	36(%esp), %ecx
	cmpl	%eax, %ebx
	movl	%ecx, %edx
	cmovge	%ebx, %eax
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1100
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1242
.L1100:
	movl	%eax, 60(%ebp)
.L1081:
	addl	$1, %edi
	cmpl	%edi, numthrottles
	jle	.L1101
.L1257:
	movl	12(%esp), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1102
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1243
.L1102:
	addl	$24, %esi
	cmpl	$9, 52(%ebp)
	jg	.L1101
.L1192:
	movl	16(%esp), %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1078
	cmpb	%al, 43(%esp)
	jge	.L1244
.L1078:
	movl	8(%ebp), %eax
	leal	188(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1079
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L1245
.L1079:
	movl	188(%eax), %ecx
	movl	throttles, %eax
	addl	%esi, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1080
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%dl, %bl
	jge	.L1246
.L1080:
	subl	$8, %esp
	.cfi_def_cfa_offset 88
	pushl	%ecx
	.cfi_def_cfa_offset 92
	pushl	(%eax)
	.cfi_def_cfa_offset 96
	call	match
	addl	$16, %esp
	.cfi_def_cfa_offset 80
	testl	%eax, %eax
	je	.L1081
	movl	throttles, %edx
	addl	%esi, %edx
	movl	%edx, %eax
	movl	%edx, 8(%esp)
	addl	$12, %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1082
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L1247
.L1082:
	movl	8(%esp), %eax
	movl	12(%eax), %ebx
	addl	$4, %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1083
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jge	.L1248
.L1083:
	movl	8(%esp), %ecx
	movl	4(%ecx), %eax
	movl	%eax, 20(%esp)
	addl	%eax, %eax
	cmpl	%eax, %ebx
	jg	.L1105
	leal	8(%ecx), %ecx
	movl	%ecx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1084
	movl	%ecx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1249
.L1084:
	movl	8(%esp), %ecx
	movl	8(%ecx), %eax
	cmpl	%eax, %ebx
	movl	%eax, 24(%esp)
	jl	.L1105
	movl	%ecx, %eax
	addl	$20, %eax
	movl	%eax, %ecx
	movl	%eax, 28(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1085
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L1250
.L1085:
	movl	8(%esp), %eax
	movl	20(%eax), %ecx
	testl	%ecx, %ecx
	js	.L1086
	addl	$1, %ecx
.L1087:
	movl	12(%esp), %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1091
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%al, %bl
	jge	.L1251
.L1091:
	movl	52(%ebp), %eax
	leal	1(%eax), %ebx
	movl	%ebx, 52(%ebp)
	leal	12(%ebp,%eax,4), %ebx
	movl	%ebx, %edx
	movl	%ebx, 44(%esp)
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L1092
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jge	.L1252
.L1092:
	movl	28(%esp), %ebx
	movl	%edi, 12(%ebp,%eax,4)
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1093
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%al, %bl
	jge	.L1253
.L1093:
	movl	8(%esp), %eax
	movl	%ecx, 20(%eax)
	movl	20(%esp), %eax
	cltd
	idivl	%ecx
	movl	32(%esp), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1094
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1254
.L1094:
	movl	56(%ebp), %edx
	cmpl	$-1, %edx
	je	.L1097
	movl	32(%esp), %ecx
	cmpl	%edx, %eax
	cmovg	%edx, %eax
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1097
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1255
.L1097:
	movl	36(%esp), %edx
	movl	%eax, 56(%ebp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1098
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1256
.L1098:
	movl	60(%ebp), %eax
	cmpl	$-1, %eax
	jne	.L1099
	addl	$1, %edi
	cmpl	%edi, numthrottles
	movl	24(%esp), %eax
	movl	%eax, 60(%ebp)
	jg	.L1257
	.p2align 4,,10
	.p2align 3
.L1101:
	addl	$60, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	movl	$1, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L1086:
	.cfi_restore_state
	subl	$8, %esp
	.cfi_def_cfa_offset 88
	pushl	$.LC108
	.cfi_def_cfa_offset 92
	pushl	$3
	.cfi_def_cfa_offset 96
	call	syslog
	movl	throttles, %edx
	addl	%esi, %edx
	movl	%edx, %eax
	movl	%edx, 24(%esp)
	addl	$20, %eax
	movl	%eax, 44(%esp)
	movl	%eax, %ecx
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 80
	testb	%al, %al
	je	.L1088
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L1258
.L1088:
	movl	8(%esp), %eax
	movl	$0, 20(%eax)
	addl	$4, %eax
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1089
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L1259
.L1089:
	movl	8(%esp), %ebx
	movl	4(%ebx), %eax
	leal	8(%ebx), %ecx
	movl	%eax, 20(%esp)
	movl	%ecx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1090
	movl	%ecx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%al, %bl
	jge	.L1260
.L1090:
	movl	8(%esp), %eax
	movl	$1, %ecx
	movl	8(%eax), %eax
	movl	%eax, 24(%esp)
	jmp	.L1087
	.p2align 4,,10
	.p2align 3
.L1105:
	addl	$60, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	xorl	%eax, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L1260:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%ecx
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1259:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%eax
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1258:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	40(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1242:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	48(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1256:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	48(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1243:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	24(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1249:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%ecx
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1251:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	24(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1250:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	40(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1255:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	44(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1254:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	44(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1253:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	40(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1252:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	56(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1248:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%eax
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1247:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%eax
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1246:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%eax
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1245:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	%edx
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1244:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	28(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_load4
.L1241:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	44(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1240:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	48(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
.L1239:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 92
	pushl	24(%esp)
	.cfi_def_cfa_offset 96
	call	__asan_report_store4
	.cfi_endproc
.LFE21:
	.size	check_throttles, .-check_throttles
	.section	.text.unlikely
.LCOLDE109:
	.text
.LHOTE109:
	.section	.text.unlikely
.LCOLDB110:
	.text
.LHOTB110:
	.p2align 4,,15
	.type	shut_down, @function
shut_down:
.LASANPC16:
.LFB16:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$124, %esp
	.cfi_def_cfa_offset 144
	movl	__asan_option_detect_stack_use_after_return, %ebx
	leal	16(%esp), %edi
	testl	%ebx, %ebx
	jne	.L1340
.L1261:
	movl	%edi, %eax
	leal	32(%edi), %ebx
	movl	$1102416563, (%edi)
	shrl	$3, %eax
	movl	$.LC15, 4(%edi)
	movl	$.LASANPC16, 8(%edi)
	subl	$8, %esp
	.cfi_def_cfa_offset 152
	movl	%eax, 16(%esp)
	movl	$-235802127, 536870912(%eax)
	movl	$-185273344, 536870916(%eax)
	movl	$-202116109, 536870920(%eax)
	xorl	%esi, %esi
	pushl	$0
	.cfi_def_cfa_offset 156
	pushl	%ebx
	.cfi_def_cfa_offset 160
	call	gettimeofday
	movl	%ebx, %eax
	call	logstats
	movl	max_connects, %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	testl	%edx, %edx
	jle	.L1275
	movl	%edi, 12(%esp)
	movl	%ebx, %edi
	jmp	.L1318
	.p2align 4,,10
	.p2align 3
.L1269:
	leal	8(%edx), %eax
	movl	%eax, %ecx
	movl	%eax, 4(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1271
	movl	%eax, %ebp
	andl	$7, %ebp
	addl	$3, %ebp
	movl	%ebp, %eax
	cmpb	%cl, %al
	jge	.L1341
.L1271:
	movl	8(%edx), %eax
	testl	%eax, %eax
	je	.L1272
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	httpd_destroy_conn
	addl	connects, %ebx
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	leal	8(%ebx), %ebp
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1273
	movl	%ebp, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1342
.L1273:
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	8(%ebx)
	.cfi_def_cfa_offset 160
	call	free
	movl	%ebp, %eax
	subl	$1, httpd_conn_count
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1274
	movl	%ebp, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1343
.L1274:
	movl	$0, 8(%ebx)
.L1272:
	addl	$1, %esi
	cmpl	%esi, max_connects
	jle	.L1344
.L1318:
	leal	(%esi,%esi,2), %ebx
	movl	connects, %edx
	sall	$5, %ebx
	addl	%ebx, %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1268
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L1345
.L1268:
	movl	(%edx), %eax
	testl	%eax, %eax
	je	.L1269
	leal	8(%edx), %eax
	movl	%eax, %ecx
	movl	%eax, 4(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1270
	movl	%eax, %ebp
	andl	$7, %ebp
	addl	$3, %ebp
	movl	%ebp, %eax
	cmpb	%cl, %al
	jge	.L1346
.L1270:
	subl	$8, %esp
	.cfi_def_cfa_offset 152
	pushl	%edi
	.cfi_def_cfa_offset 156
	pushl	8(%edx)
	.cfi_def_cfa_offset 160
	call	httpd_close_conn
	movl	connects, %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	addl	%ebx, %edx
	jmp	.L1269
	.p2align 4,,10
	.p2align 3
.L1344:
	movl	12(%esp), %edi
.L1275:
	movl	hs, %ebx
	testl	%ebx, %ebx
	je	.L1267
	leal	40(%ebx), %eax
	movl	$0, hs
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1276
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1347
.L1276:
	movl	40(%ebx), %eax
	cmpl	$-1, %eax
	je	.L1277
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	fdwatch_del_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 144
.L1277:
	leal	44(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1278
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1348
.L1278:
	movl	44(%ebx), %eax
	cmpl	$-1, %eax
	je	.L1279
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	fdwatch_del_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 144
.L1279:
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%ebx
	.cfi_def_cfa_offset 160
	call	httpd_terminate
	addl	$16, %esp
	.cfi_def_cfa_offset 144
.L1267:
	call	mmc_destroy
	call	tmr_destroy
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	connects
	.cfi_def_cfa_offset 160
	call	free
	movl	throttles, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	testl	%eax, %eax
	je	.L1264
	subl	$12, %esp
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	free
	addl	$16, %esp
	.cfi_def_cfa_offset 144
.L1264:
	leal	16(%esp), %eax
	cmpl	%edi, %eax
	jne	.L1349
	movl	8(%esp), %eax
	movl	$0, 536870912(%eax)
	movl	$0, 536870916(%eax)
	movl	$0, 536870920(%eax)
.L1263:
	addl	$124, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L1348:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1347:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1346:
	.cfi_restore_state
	movl	4(%esp), %eax
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1343:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ebp
	.cfi_def_cfa_offset 160
	call	__asan_report_store4
.L1342:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%ebp
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1341:
	.cfi_restore_state
	movl	4(%esp), %eax
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%eax
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1345:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 156
	pushl	%edx
	.cfi_def_cfa_offset 160
	call	__asan_report_load4
.L1340:
	.cfi_restore_state
	pushl	%ecx
	.cfi_def_cfa_offset 148
	pushl	%ecx
	.cfi_def_cfa_offset 152
	pushl	%edi
	.cfi_def_cfa_offset 156
	pushl	$96
	.cfi_def_cfa_offset 160
	call	__asan_stack_malloc_1
	addl	$16, %esp
	.cfi_def_cfa_offset 144
	movl	%eax, %edi
	jmp	.L1261
.L1349:
	movl	$1172321806, (%edi)
	movl	8(%esp), %eax
	movl	$-168430091, 536870912(%eax)
	movl	$-168430091, 536870916(%eax)
	movl	$-168430091, 536870920(%eax)
	jmp	.L1263
	.cfi_endproc
.LFE16:
	.size	shut_down, .-shut_down
	.section	.text.unlikely
.LCOLDE110:
	.text
.LHOTE110:
	.section	.rodata
	.align 32
.LC111:
	.string	"exiting"
	.zero	56
	.section	.text.unlikely
.LCOLDB112:
	.text
.LHOTB112:
	.p2align 4,,15
	.type	handle_usr1, @function
handle_usr1:
.LASANPC3:
.LFB3:
	.cfi_startproc
	movl	num_connects, %edx
	testl	%edx, %edx
	je	.L1353
	movl	$1, got_usr1
	ret
.L1353:
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	call	shut_down
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	%eax
	.cfi_def_cfa_offset 24
	pushl	$.LC111
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	movl	$0, (%esp)
	call	exit
	.cfi_endproc
.LFE3:
	.size	handle_usr1, .-handle_usr1
	.section	.text.unlikely
.LCOLDE112:
	.text
.LHOTE112:
	.section	.rodata
	.align 32
.LC113:
	.string	"exiting due to signal %d"
	.zero	39
	.section	.text.unlikely
.LCOLDB114:
	.text
.LHOTB114:
	.p2align 4,,15
	.type	handle_term, @function
handle_term:
.LASANPC0:
.LFB0:
	.cfi_startproc
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	call	shut_down
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	pushl	20(%esp)
	.cfi_def_cfa_offset 24
	pushl	$.LC113
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE0:
	.size	handle_term, .-handle_term
	.section	.text.unlikely
.LCOLDE114:
	.text
.LHOTE114:
	.section	.text.unlikely
.LCOLDB115:
	.text
.LHOTB115:
	.p2align 4,,15
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LASANPC34:
.LFB34:
	.cfi_startproc
	leal	52(%eax), %edx
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%edx, %ecx
	shrl	$3, %ecx
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1357
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L1384
.L1357:
	movl	52(%eax), %ecx
	addl	$12, %eax
	movl	throttles, %ebp
	movl	%ecx, %ebx
	movl	%ecx, 8(%esp)
	xorl	%ecx, %ecx
	testl	%ebx, %ebx
	jle	.L1356
	movl	%ecx, 4(%esp)
	.p2align 4,,10
	.p2align 3
.L1375:
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1359
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%dl, %bl
	jge	.L1385
.L1359:
	movl	(%eax), %edx
	leal	(%edx,%edx,2), %edx
	leal	0(%ebp,%edx,8), %edx
	leal	20(%edx), %ecx
	movl	%ecx, %esi
	movl	%ecx, %ebx
	movl	%ecx, 12(%esp)
	shrl	$3, %esi
	movzbl	536870912(%esi), %esi
	movl	%esi, %ecx
	testb	%cl, %cl
	je	.L1360
	movl	%ebx, %edi
	movl	%esi, %ebx
	andl	$7, %edi
	addl	$3, %edi
	movl	%edi, %ecx
	cmpb	%bl, %cl
	jge	.L1386
.L1360:
	addl	$1, 4(%esp)
	movl	8(%esp), %esi
	addl	$4, %eax
	movl	4(%esp), %edi
	subl	$1, 20(%edx)
	cmpl	%esi, %edi
	jne	.L1375
.L1356:
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L1384:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1386:
	.cfi_restore_state
	movl	12(%esp), %ebx
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1385:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
	.cfi_endproc
.LFE34:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.section	.text.unlikely
.LCOLDE115:
	.text
.LHOTE115:
	.section	.text.unlikely
.LCOLDB116:
	.text
.LHOTB116:
	.p2align 4,,15
	.type	really_clear_connection, @function
really_clear_connection:
.LASANPC26:
.LFB26:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%edx, %edi
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leal	8(%eax), %esi
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %ebx
	movl	%esi, %eax
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1388
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1457
.L1388:
	movl	8(%ebx), %eax
	leal	168(%eax), %ecx
	movl	%ecx, %edx
	movl	%ecx, 12(%esp)
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1389
	movl	%ecx, %ebp
	andl	$7, %ebp
	addl	$3, %ebp
	movl	%ebp, %ecx
	cmpb	%dl, %cl
	jge	.L1458
.L1389:
	movl	168(%eax), %edx
	addl	%edx, stats_bytes
	movl	%ebx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	testb	%cl, %cl
	je	.L1390
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jge	.L1459
.L1390:
	cmpl	$3, (%ebx)
	je	.L1391
	leal	448(%eax), %ecx
	movl	%ecx, %edx
	movl	%ecx, 12(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1392
	movl	%edx, %ebp
	andl	$7, %ebp
	addl	$3, %ebp
	movl	%ebp, %edx
	cmpb	%cl, %dl
	jge	.L1460
.L1392:
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	448(%eax)
	.cfi_def_cfa_offset 64
	call	fdwatch_del_fd
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1393
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1461
.L1393:
	movl	8(%ebx), %eax
.L1391:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	leal	76(%ebx), %esi
	pushl	%edi
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	httpd_close_conn
	movl	%ebx, %eax
	call	clear_throttles.isra.0
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1394
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1462
.L1394:
	movl	76(%ebx), %eax
	testl	%eax, %eax
	je	.L1395
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	tmr_cancel
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1396
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1463
.L1396:
	movl	$0, 76(%ebx)
.L1395:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1397
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1464
.L1397:
	leal	4(%ebx), %eax
	movl	$0, (%ebx)
	movl	first_free_connect, %edi
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1398
	movl	%eax, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%dl, %cl
	jge	.L1465
.L1398:
	movl	%edi, 4(%ebx)
	subl	connects, %ebx
	subl	$1, num_connects
	sarl	$5, %ebx
	imull	$-1431655765, %ebx, %ebx
	movl	%ebx, first_free_connect
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L1462:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1459:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1458:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	24(%esp)
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1457:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1465:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1464:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1463:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1461:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1460:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	24(%esp)
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
	.cfi_endproc
.LFE26:
	.size	really_clear_connection, .-really_clear_connection
	.section	.text.unlikely
.LCOLDE116:
	.text
.LHOTE116:
	.section	.rodata
	.align 32
.LC117:
	.string	"replacing non-null linger_timer!"
	.zero	63
	.align 32
.LC118:
	.string	"tmr_create(linger_clear_connection) failed"
	.zero	53
	.section	.text.unlikely
.LCOLDB119:
	.text
.LHOTB119:
	.p2align 4,,15
	.type	clear_connection, @function
clear_connection:
.LASANPC25:
.LFB25:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%edx, %edi
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leal	72(%eax), %esi
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %ebx
	movl	%esi, %eax
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1467
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1604
.L1467:
	movl	72(%ebx), %eax
	testl	%eax, %eax
	je	.L1468
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	tmr_cancel
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1469
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1605
.L1469:
	movl	$0, 72(%ebx)
.L1468:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1470
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1606
.L1470:
	cmpl	$4, (%ebx)
	je	.L1471
	leal	8(%ebx), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1472
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1607
.L1472:
	movl	8(%ebx), %eax
	leal	356(%eax), %ecx
	movl	%ecx, %edx
	movl	%ecx, 12(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1473
	movl	%edx, %ebp
	andl	$7, %ebp
	addl	$3, %ebp
	movl	%ebp, %edx
	cmpb	%cl, %dl
	jge	.L1608
.L1473:
	movl	356(%eax), %ecx
	testl	%ecx, %ecx
	je	.L1475
	movl	%ebx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1480
	movl	%ebx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1609
.L1480:
	cmpl	$3, (%ebx)
	je	.L1481
	leal	448(%eax), %ecx
	movl	%ecx, %edx
	movl	%ecx, 12(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1482
	movl	%edx, %ebp
	andl	$7, %ebp
	addl	$3, %ebp
	movl	%ebp, %edx
	cmpb	%cl, %dl
	jge	.L1610
.L1482:
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	448(%eax)
	.cfi_def_cfa_offset 64
	call	fdwatch_del_fd
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1483
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1611
.L1483:
	movl	8(%ebx), %eax
.L1481:
	movl	%ebx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1484
	movl	%ebx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1612
.L1484:
	leal	448(%eax), %ecx
	movl	$4, (%ebx)
	movl	%ecx, %edx
	movl	%ecx, 12(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1485
	movl	%edx, %ebp
	andl	$7, %ebp
	addl	$3, %ebp
	movl	%ebp, %edx
	cmpb	%cl, %dl
	jge	.L1613
.L1485:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$1
	.cfi_def_cfa_offset 60
	pushl	448(%eax)
	.cfi_def_cfa_offset 64
	call	shutdown
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1486
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1614
.L1486:
	movl	8(%ebx), %eax
	leal	448(%eax), %ebp
	movl	%ebp, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1487
	movl	%ebp, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %edx
	cmpb	%cl, %dl
	jge	.L1615
.L1487:
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	leal	76(%ebx), %esi
	pushl	$0
	.cfi_def_cfa_offset 56
	pushl	%ebx
	.cfi_def_cfa_offset 60
	pushl	448(%eax)
	.cfi_def_cfa_offset 64
	call	fdwatch_add_fd
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1488
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1616
.L1488:
	movl	76(%ebx), %edx
	testl	%edx, %edx
	je	.L1489
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC117
	.cfi_def_cfa_offset 60
	pushl	$3
	.cfi_def_cfa_offset 64
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 48
.L1489:
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	$0
	.cfi_def_cfa_offset 64
	pushl	$500
	.cfi_def_cfa_offset 68
	pushl	%ebx
	.cfi_def_cfa_offset 72
	pushl	$linger_clear_connection
	.cfi_def_cfa_offset 76
	pushl	%edi
	.cfi_def_cfa_offset 80
	call	tmr_create
	movl	%esi, %edx
	addl	$32, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1490
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1617
.L1490:
	testl	%eax, %eax
	movl	%eax, 76(%ebx)
	je	.L1618
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L1471:
	.cfi_restore_state
	leal	76(%ebx), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1476
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1619
.L1476:
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	76(%ebx)
	.cfi_def_cfa_offset 64
	call	tmr_cancel
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1477
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1620
.L1477:
	leal	8(%ebx), %eax
	movl	$0, 76(%ebx)
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1478
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1621
.L1478:
	movl	8(%ebx), %eax
	leal	356(%eax), %ebp
	movl	%ebp, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1479
	movl	%ebp, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %edx
	cmpb	%cl, %dl
	jge	.L1622
.L1479:
	movl	$0, 356(%eax)
.L1475:
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	movl	%edi, %edx
	movl	%ebx, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	jmp	really_clear_connection
.L1604:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1606:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1615:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebp
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1609:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1616:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1605:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1614:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1613:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	24(%esp)
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1617:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1608:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	24(%esp)
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1607:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1612:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1610:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	24(%esp)
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1611:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1618:
	.cfi_restore_state
	pushl	%eax
	.cfi_remember_state
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC118
	.cfi_def_cfa_offset 60
	pushl	$2
	.cfi_def_cfa_offset 64
	call	syslog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L1619:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1622:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebp
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
.L1621:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L1620:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%esi
	.cfi_def_cfa_offset 64
	call	__asan_report_store4
	.cfi_endproc
.LFE25:
	.size	clear_connection, .-clear_connection
	.section	.text.unlikely
.LCOLDE119:
	.text
.LHOTE119:
	.section	.text.unlikely
.LCOLDB120:
	.text
.LHOTB120:
	.p2align 4,,15
	.type	finish_connection, @function
finish_connection:
.LASANPC24:
.LFB24:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	movl	%eax, %ebx
	leal	8(%eax), %eax
	movl	%edx, %esi
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	testb	%cl, %cl
	je	.L1624
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jge	.L1632
.L1624:
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	8(%ebx)
	.cfi_def_cfa_offset 32
	call	httpd_write_response
	addl	$20, %esp
	.cfi_def_cfa_offset 12
	movl	%esi, %edx
	movl	%ebx, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	jmp	clear_connection
.L1632:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -12
	.cfi_offset 6, -8
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE24:
	.size	finish_connection, .-finish_connection
	.section	.text.unlikely
.LCOLDE120:
	.text
.LHOTE120:
	.section	.text.unlikely
.LCOLDB121:
	.text
.LHOTB121:
	.p2align 4,,15
	.type	handle_read, @function
handle_read:
.LASANPC18:
.LFB18:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%eax, %edi
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	leal	8(%eax), %eax
	subl	$44, %esp
	.cfi_def_cfa_offset 64
	movl	%edx, 12(%esp)
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1634
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1977
.L1634:
	movl	8(%edi), %ebx
	leal	144(%ebx), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1635
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1978
.L1635:
	leal	140(%ebx), %ebp
	movl	144(%ebx), %edx
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1636
	movl	%ebp, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L1979
.L1636:
	movl	140(%ebx), %eax
	cmpl	%eax, %edx
	jb	.L1980
	cmpl	$5000, %eax
	jbe	.L1638
	movl	$httpd_err400form, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1639
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L1981
.L1639:
	movl	$httpd_err400title, %eax
	movl	httpd_err400form, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1659
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L1982
.L1659:
	subl	$8, %esp
	.cfi_def_cfa_offset 72
	pushl	$.LC63
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	pushl	$.LC63
	.cfi_def_cfa_offset 84
	pushl	httpd_err400title
	.cfi_def_cfa_offset 88
	pushl	$400
	.cfi_def_cfa_offset 92
.L1976:
	pushl	%ebx
	.cfi_def_cfa_offset 96
	call	httpd_send_err
	movl	44(%esp), %edx
	movl	%edi, %eax
	addl	$76, %esp
	.cfi_def_cfa_offset 20
.L1974:
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L1638:
	.cfi_def_cfa_offset 64
	.cfi_offset 3, -20
	.cfi_offset 5, -8
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	addl	$1000, %eax
	pushl	%eax
	.cfi_def_cfa_offset 72
	leal	136(%ebx), %eax
	pushl	%ebp
	.cfi_def_cfa_offset 76
	movl	%eax, 28(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	httpd_realloc_str
	movl	%ebp, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1641
	movl	%ebp, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1983
.L1641:
	movl	%esi, %edx
	movl	140(%ebx), %eax
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1642
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1984
.L1642:
	movl	144(%ebx), %edx
.L1637:
	movl	16(%esp), %ebp
	subl	%edx, %eax
	movl	%eax, 20(%esp)
	movl	%ebp, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1643
	andl	$7, %ebp
	addl	$3, %ebp
	movl	%ebp, %eax
	cmpb	%cl, %al
	jge	.L1985
.L1643:
	leal	448(%ebx), %ebp
	addl	136(%ebx), %edx
	movl	%ebp, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L1644
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jge	.L1986
.L1644:
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	pushl	24(%esp)
	.cfi_def_cfa_offset 72
	pushl	%edx
	.cfi_def_cfa_offset 76
	pushl	448(%ebx)
	.cfi_def_cfa_offset 80
	call	read
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	testl	%eax, %eax
	je	.L1987
	js	.L1988
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1653
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1989
.L1653:
	movl	12(%esp), %edx
	addl	%eax, 144(%ebx)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1654
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1990
.L1654:
	movl	12(%esp), %eax
	movl	(%eax), %eax
	movl	%eax, 16(%esp)
	leal	68(%edi), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1655
	movl	%eax, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%dl, %cl
	jge	.L1991
.L1655:
	movl	16(%esp), %eax
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	movl	%eax, 68(%edi)
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	httpd_got_request
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	testl	%eax, %eax
	je	.L1633
	cmpl	$2, %eax
	jne	.L1972
	movl	$httpd_err400form, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1658
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1658
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400form
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2010:
	.cfi_restore_state
	movl	%edi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1690
	movl	%edi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1992
.L1690:
	movl	12(%esp), %edx
	movl	$2, (%edi)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1691
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1993
.L1691:
	movl	12(%esp), %eax
	movl	(%eax), %eax
	movl	%eax, 12(%esp)
	leal	64(%edi), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1692
	movl	%eax, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%dl, %cl
	jge	.L1994
.L1692:
	movl	12(%esp), %eax
	movl	%eax, 64(%edi)
	leal	80(%edi), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1693
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1995
.L1693:
	movl	%ebp, %eax
	movl	$0, 80(%edi)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1694
	movl	%ebp, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1996
.L1694:
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	448(%ebx)
	.cfi_def_cfa_offset 80
	call	fdwatch_del_fd
	movl	%ebp, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1695
	movl	%ebp, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L1997
.L1695:
	subl	$4, %esp
	.cfi_def_cfa_offset 68
	pushl	$1
	.cfi_def_cfa_offset 72
	pushl	%edi
	.cfi_def_cfa_offset 76
	pushl	448(%ebx)
	.cfi_def_cfa_offset 80
	call	fdwatch_add_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	.p2align 4,,10
	.p2align 3
.L1633:
	addl	$44, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L1980:
	.cfi_restore_state
	leal	136(%ebx), %ecx
	movl	%ecx, 16(%esp)
	jmp	.L1637
	.p2align 4,,10
	.p2align 3
.L1988:
	call	__errno_location
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1649
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L1998
.L1649:
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L1633
	cmpl	$4, %eax
	je	.L1633
	movl	$httpd_err400form, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1651
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1651
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400form
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1658:
	.cfi_restore_state
	movl	$httpd_err400title, %eax
	movl	httpd_err400form, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1659
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1659
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400title
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1651:
	.cfi_restore_state
	movl	$httpd_err400title, %eax
	movl	httpd_err400form, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1659
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1659
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400title
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1987:
	.cfi_restore_state
	movl	$httpd_err400form, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1646
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L1999
.L1646:
	movl	$httpd_err400title, %eax
	movl	httpd_err400form, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1659
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jl	.L1659
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400title
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1972:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	httpd_parse_request
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	testl	%eax, %eax
	js	.L1975
	movl	%edi, %eax
	call	check_throttles
	testl	%eax, %eax
	je	.L2000
	subl	$8, %esp
	.cfi_def_cfa_offset 72
	pushl	20(%esp)
	.cfi_def_cfa_offset 76
	pushl	%ebx
	.cfi_def_cfa_offset 80
	call	httpd_start_request
	addl	$16, %esp
	.cfi_def_cfa_offset 64
	testl	%eax, %eax
	js	.L1975
	leal	336(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1666
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2001
.L1666:
	movl	336(%ebx), %edx
	testl	%edx, %edx
	je	.L1667
	leal	344(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1668
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2002
.L1668:
	movl	344(%ebx), %eax
	movl	%eax, 16(%esp)
	leal	92(%edi), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1669
	movl	%eax, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%dl, %cl
	jge	.L2003
.L1669:
	movl	16(%esp), %eax
	movl	%eax, 92(%edi)
	leal	348(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1670
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2004
.L1670:
	leal	88(%edi), %esi
	movl	348(%ebx), %eax
	movl	%esi, %edx
	shrl	$3, %edx
	addl	$1, %eax
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1676
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2005
.L1676:
	movl	%eax, 88(%edi)
.L1672:
	leal	452(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1677
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2006
.L1677:
	movl	452(%ebx), %eax
	testl	%eax, %eax
	je	.L2007
	leal	92(%edi), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1688
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2008
.L1688:
	movl	%esi, %eax
	movl	92(%edi), %edx
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1689
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L2009
.L1689:
	cmpl	88(%edi), %edx
	jl	.L2010
.L1975:
	movl	12(%esp), %edx
	movl	%edi, %eax
	addl	$44, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	jmp	.L1974
	.p2align 4,,10
	.p2align 3
.L2000:
	.cfi_restore_state
	leal	172(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1662
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2011
.L1662:
	movl	$httpd_err503form, %eax
	movl	172(%ebx), %esi
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1663
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L2012
.L1663:
	movl	$httpd_err503title, %eax
	movl	httpd_err503form, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1664
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L2013
.L1664:
	subl	$8, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 72
	pushl	%esi
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	pushl	$.LC63
	.cfi_def_cfa_offset 84
	pushl	httpd_err503title
	.cfi_def_cfa_offset 88
	pushl	$503
	.cfi_def_cfa_offset 92
	jmp	.L1976
.L1979:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1978:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1977:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1983:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1981:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400form
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1982:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400title
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1998:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1989:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1990:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	24(%esp)
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1991:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1984:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L1667:
	.cfi_restore_state
	leal	164(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1673
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2014
.L1673:
	movl	164(%ebx), %eax
	leal	88(%edi), %esi
	testl	%eax, %eax
	js	.L2015
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1676
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jl	.L1676
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L2007:
	.cfi_restore_state
	leal	52(%edi), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1679
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2016
.L1679:
	movl	52(%edi), %eax
	testl	%eax, %eax
	movl	%eax, 20(%esp)
	jle	.L2017
	movl	throttles, %eax
	movl	%eax, %esi
	leal	168(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1683
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2018
.L1683:
	movl	168(%ebx), %eax
	movl	%edi, 28(%esp)
	xorl	%ebp, %ebp
	movl	%eax, 16(%esp)
	leal	12(%edi), %eax
	movl	%esi, %edi
	.p2align 4,,10
	.p2align 3
.L1686:
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1684
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2019
.L1684:
	movl	(%eax), %edx
	leal	(%edx,%edx,2), %edx
	leal	(%edi,%edx,8), %edx
	leal	16(%edx), %esi
	movl	%esi, %ebx
	movl	%esi, 24(%esp)
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L1685
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ecx
	cmpb	%bl, %cl
	jge	.L2020
.L1685:
	movl	16(%esp), %esi
	addl	$1, %ebp
	addl	%esi, 16(%edx)
	addl	$4, %eax
	cmpl	20(%esp), %ebp
	jne	.L1686
	movl	28(%esp), %edi
.L1682:
	leal	92(%edi), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L1687
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2021
.L1687:
	movl	16(%esp), %eax
	movl	%eax, 92(%edi)
	jmp	.L1975
.L2015:
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L1675
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2022
.L1675:
	movl	$0, 88(%edi)
	jmp	.L1672
.L2017:
	leal	168(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ecx
	testb	%cl, %cl
	je	.L1681
	movl	%eax, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jge	.L2023
.L1681:
	movl	168(%ebx), %eax
	movl	%eax, 16(%esp)
	jmp	.L1682
.L2020:
	movl	24(%esp), %ecx
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ecx
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2021:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L2019:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2023:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2014:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1992:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%edi
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1993:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	24(%esp)
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1994:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1995:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1996:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2016:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2018:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2013:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err503title
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1999:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err400form
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2009:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2022:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L1997:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2008:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2005:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%esi
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L2006:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1985:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	28(%esp)
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2002:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2003:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_store4
.L2004:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2011:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2012:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	$httpd_err503form
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L1986:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 76
	pushl	%ebp
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
.L2001:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 76
	pushl	%eax
	.cfi_def_cfa_offset 80
	call	__asan_report_load4
	.cfi_endproc
.LFE18:
	.size	handle_read, .-handle_read
	.section	.text.unlikely
.LCOLDE121:
	.text
.LHOTE121:
	.section	.rodata
	.align 32
.LC122:
	.string	"%.80s connection timed out reading"
	.zero	61
	.align 32
.LC123:
	.string	"%.80s connection timed out sending"
	.zero	61
	.section	.text.unlikely
.LCOLDB124:
	.text
.LHOTB124:
	.p2align 4,,15
	.type	idle, @function
idle:
.LASANPC27:
.LFB27:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	xorl	%edi, %edi
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	xorl	%esi, %esi
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	movl	52(%esp), %ebp
	movl	%ebp, %eax
	andl	$7, %eax
	addl	$3, %eax
	movb	%al, 11(%esp)
	movl	max_connects, %eax
	testl	%eax, %eax
	jg	.L2083
	jmp	.L2024
	.p2align 4,,10
	.p2align 3
.L2111:
	jl	.L2027
	cmpl	$3, %eax
	jg	.L2027
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2037
	cmpb	%al, 11(%esp)
	jge	.L2107
.L2037:
	leal	68(%ebx), %edx
	movl	0(%ebp), %eax
	movl	%edx, %ecx
	shrl	$3, %ecx
	movl	%eax, 4(%esp)
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2038
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jge	.L2108
.L2038:
	movl	4(%esp), %eax
	subl	68(%ebx), %eax
	cmpl	$299, %eax
	jg	.L2109
.L2027:
	addl	$1, %edi
	addl	$96, %esi
	cmpl	%edi, max_connects
	jle	.L2024
.L2083:
	movl	connects, %ebx
	addl	%esi, %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2026
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2110
.L2026:
	movl	(%ebx), %eax
	cmpl	$1, %eax
	jne	.L2111
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2030
	cmpb	%al, 11(%esp)
	jge	.L2112
.L2030:
	leal	68(%ebx), %edx
	movl	0(%ebp), %eax
	movl	%edx, %ecx
	shrl	$3, %ecx
	movl	%eax, 4(%esp)
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2031
	movl	%edx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%cl, %al
	jge	.L2113
.L2031:
	movl	4(%esp), %eax
	subl	68(%ebx), %eax
	cmpl	$59, %eax
	jle	.L2027
	leal	8(%ebx), %eax
	movl	%eax, %edx
	movl	%eax, 4(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2033
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2114
.L2033:
	movl	8(%ebx), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	addl	$8, %eax
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	httpd_ntoa
	addl	$12, %esp
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC122
	.cfi_def_cfa_offset 60
	pushl	$6
	.cfi_def_cfa_offset 64
	call	syslog
	movl	$httpd_err408form, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2034
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L2115
.L2034:
	movl	$httpd_err408title, %eax
	movl	httpd_err408form, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2035
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L2116
.L2035:
	movl	httpd_err408title, %eax
	movl	4(%esp), %edx
	movl	%eax, 12(%esp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2036
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2117
.L2036:
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	addl	$1, %edi
	addl	$96, %esi
	pushl	$.LC63
	.cfi_def_cfa_offset 60
	pushl	%ecx
	.cfi_def_cfa_offset 64
	pushl	$.LC63
	.cfi_def_cfa_offset 68
	pushl	32(%esp)
	.cfi_def_cfa_offset 72
	pushl	$408
	.cfi_def_cfa_offset 76
	pushl	8(%ebx)
	.cfi_def_cfa_offset 80
	call	httpd_send_err
	addl	$32, %esp
	.cfi_def_cfa_offset 48
	movl	%ebp, %edx
	movl	%ebx, %eax
	call	finish_connection
	cmpl	%edi, max_connects
	jg	.L2083
	.p2align 4,,10
	.p2align 3
.L2024:
	addl	$28, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L2109:
	.cfi_restore_state
	leal	8(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2040
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2118
.L2040:
	movl	8(%ebx), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	addl	$8, %eax
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	httpd_ntoa
	addl	$12, %esp
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC123
	.cfi_def_cfa_offset 60
	pushl	$6
	.cfi_def_cfa_offset 64
	call	syslog
	movl	%ebp, %edx
	movl	%ebx, %eax
	call	clear_connection
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	jmp	.L2027
.L2118:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%eax
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2117:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	16(%esp)
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2116:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	$httpd_err408title
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2115:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	$httpd_err408form
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2114:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	16(%esp)
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2113:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2112:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebp
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2108:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2107:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	%ebp
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
.L2110:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	__asan_report_load4
	.cfi_endproc
.LFE27:
	.size	idle, .-idle
	.section	.text.unlikely
.LCOLDE124:
	.text
.LHOTE124:
	.section	.rodata.str1.1
.LC125:
	.string	"1 32 16 2 iv "
	.section	.rodata
	.align 32
.LC126:
	.string	"replacing non-null wakeup_timer!"
	.zero	63
	.align 32
.LC127:
	.string	"tmr_create(wakeup_connection) failed"
	.zero	59
	.align 32
.LC128:
	.string	"write - %m sending %.80s"
	.zero	39
	.section	.text.unlikely
.LCOLDB129:
	.text
.LHOTB129:
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LASANPC19:
.LFB19:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%eax, %ebp
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$172, %esp
	.cfi_def_cfa_offset 192
	leal	64(%esp), %eax
	movl	%edx, 20(%esp)
	movl	%eax, 24(%esp)
	movl	__asan_option_detect_stack_use_after_return, %eax
	testl	%eax, %eax
	jne	.L2509
.L2119:
	movl	24(%esp), %eax
	leal	96(%eax), %edi
	movl	%edi, 4(%esp)
	movl	$1102416563, (%eax)
	movl	$.LC125, 4(%eax)
	movl	$.LASANPC19, 8(%eax)
	shrl	$3, %eax
	movl	%eax, 28(%esp)
	movl	$-235802127, 536870912(%eax)
	movl	$-185335808, 536870916(%eax)
	movl	$-202116109, 536870920(%eax)
	leal	8(%ebp), %eax
	movl	%eax, %ecx
	movl	%eax, 32(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2123
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L2510
.L2123:
	leal	56(%ebp), %eax
	movl	8(%ebp), %edi
	movl	%eax, %ecx
	movl	%eax, 44(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2124
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L2511
.L2124:
	movl	56(%ebp), %ecx
	movl	$1000000000, %eax
	cmpl	$-1, %ecx
	je	.L2125
	leal	3(%ecx), %eax
	testl	%ecx, %ecx
	cmovns	%ecx, %eax
	sarl	$2, %eax
.L2125:
	leal	304(%edi), %ebx
	movl	%ebx, %ecx
	movl	%ebx, 12(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2126
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L2512
.L2126:
	movl	304(%edi), %ecx
	testl	%ecx, %ecx
	jne	.L2127
	leal	88(%ebp), %esi
	movl	%esi, %edx
	movl	%esi, 36(%esp)
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2128
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2513
.L2128:
	leal	92(%ebp), %esi
	movl	88(%ebp), %ecx
	movl	%esi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2129
	movl	%esi, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%dl, %bl
	jge	.L2514
.L2129:
	movl	92(%ebp), %edx
	subl	%edx, %ecx
	cmpl	%ecx, %eax
	cmovbe	%eax, %ecx
	movl	%ecx, 4(%esp)
	leal	452(%edi), %ecx
	movl	%ecx, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L2130
	movl	%ecx, %eax
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%bl, %al
	jge	.L2515
.L2130:
	leal	448(%edi), %eax
	addl	452(%edi), %edx
	movl	%eax, %ecx
	movl	%eax, 40(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2131
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L2516
.L2131:
	subl	$4, %esp
	.cfi_def_cfa_offset 196
	pushl	8(%esp)
	.cfi_def_cfa_offset 200
	pushl	%edx
	.cfi_def_cfa_offset 204
	pushl	448(%edi)
	.cfi_def_cfa_offset 208
	call	write
	movl	%eax, 24(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	movl	8(%esp), %eax
	testl	%eax, %eax
	js	.L2517
.L2138:
	je	.L2149
	movl	20(%esp), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2156
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2518
.L2156:
	movl	20(%esp), %eax
	movl	(%eax), %ecx
	leal	68(%ebp), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2157
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%dl, %bl
	jge	.L2519
.L2157:
	movl	12(%esp), %edx
	movl	%ecx, 68(%ebp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2158
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2520
.L2158:
	movl	304(%edi), %eax
	testl	%eax, %eax
	je	.L2159
	cmpl	8(%esp), %eax
	ja	.L2521
	movl	12(%esp), %edx
	subl	%eax, 8(%esp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2167
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2522
.L2167:
	movl	$0, 304(%edi)
.L2159:
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2168
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2523
.L2168:
	movl	8(%esp), %eax
	addl	92(%ebp), %eax
	movl	32(%esp), %edx
	movl	%eax, 48(%esp)
	movl	%eax, 92(%ebp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2169
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2524
.L2169:
	movl	8(%ebp), %eax
	leal	168(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2170
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L2525
.L2170:
	movl	8(%esp), %esi
	addl	168(%eax), %esi
	movl	%esi, 168(%eax)
	leal	52(%ebp), %eax
	movl	%esi, 60(%esp)
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2171
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2526
.L2171:
	movl	52(%ebp), %eax
	xorl	%ecx, %ecx
	movl	%eax, %esi
	movl	%eax, 12(%esp)
	movl	throttles, %eax
	testl	%esi, %esi
	movl	%eax, %ebx
	leal	12(%ebp), %eax
	jle	.L2179
	movl	%ebp, 56(%esp)
	movl	%edi, 52(%esp)
	movl	%ebx, %ebp
	movl	%ecx, 4(%esp)
	.p2align 4,,10
	.p2align 3
.L2401:
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2176
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%dl, %bl
	jge	.L2527
.L2176:
	movl	(%eax), %edx
	leal	(%edx,%edx,2), %edx
	leal	0(%ebp,%edx,8), %edx
	leal	16(%edx), %esi
	movl	%esi, %ebx
	movl	%esi, 16(%esp)
	shrl	$3, %esi
	movzbl	536870912(%esi), %esi
	movl	%esi, %ecx
	testb	%cl, %cl
	je	.L2177
	movl	%ebx, %edi
	movl	%esi, %ebx
	andl	$7, %edi
	addl	$3, %edi
	movl	%edi, %ecx
	cmpb	%bl, %cl
	jge	.L2528
.L2177:
	addl	$1, 4(%esp)
	movl	8(%esp), %edi
	addl	$4, %eax
	addl	%edi, 16(%edx)
	movl	12(%esp), %ebx
	movl	4(%esp), %edi
	cmpl	%ebx, %edi
	jne	.L2401
	movl	52(%esp), %edi
	movl	56(%esp), %ebp
.L2179:
	movl	36(%esp), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2173
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2529
.L2173:
	movl	48(%esp), %eax
	cmpl	88(%ebp), %eax
	jge	.L2530
	leal	80(%ebp), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2180
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L2531
.L2180:
	movl	80(%ebp), %eax
	cmpl	$100, %eax
	jle	.L2181
	movl	%edx, %ecx
	subl	$100, %eax
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2182
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L2532
.L2182:
	movl	%eax, 80(%ebp)
.L2181:
	movl	44(%esp), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2183
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2533
.L2183:
	movl	56(%ebp), %ecx
	cmpl	$-1, %ecx
	je	.L2122
	movl	20(%esp), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2185
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2534
.L2185:
	leal	64(%ebp), %edx
	movl	20(%esp), %eax
	movl	%edx, %ebx
	shrl	$3, %ebx
	movl	(%eax), %eax
	movzbl	536870912(%ebx), %ebx
	movl	%eax, 4(%esp)
	testb	%bl, %bl
	je	.L2186
	movl	%edx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %eax
	cmpb	%bl, %al
	jge	.L2535
.L2186:
	movl	4(%esp), %eax
	subl	64(%ebp), %eax
	movl	%eax, %ebx
	movl	$1, %eax
	cmove	%eax, %ebx
	movl	60(%esp), %eax
	cltd
	idivl	%ebx
	cmpl	%eax, %ecx
	jge	.L2122
	movl	%ebp, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2188
	movl	%ebp, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jl	.L2188
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebp
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L2127:
	.cfi_restore_state
	leal	252(%edi), %esi
	movl	%esi, %ebx
	movl	%esi, 8(%esp)
	shrl	$3, %esi
	movzbl	536870912(%esi), %esi
	movl	%esi, %edx
	testb	%dl, %dl
	je	.L2133
	andl	$7, %ebx
	leal	3(%ebx), %edx
	movl	%esi, %ebx
	cmpb	%bl, %dl
	jge	.L2536
.L2133:
	movl	4(%esp), %esi
	movl	252(%edi), %ebx
	movl	%ecx, -60(%esi)
	leal	452(%edi), %ecx
	movl	%ebx, -64(%esi)
	movl	%ecx, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L2134
	movl	%ecx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %edx
	cmpb	%bl, %dl
	jge	.L2537
.L2134:
	leal	92(%ebp), %esi
	movl	452(%edi), %ecx
	movl	%esi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L2135
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%bl, %dl
	jge	.L2538
.L2135:
	movl	92(%ebp), %ebx
	movl	4(%esp), %edx
	addl	%ebx, %ecx
	movl	%ecx, -56(%edx)
	leal	88(%ebp), %ecx
	movl	%ecx, %edx
	movl	%ecx, 36(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2136
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jge	.L2539
.L2136:
	movl	88(%ebp), %ecx
	subl	%ebx, %ecx
	movl	4(%esp), %ebx
	cmpl	%ecx, %eax
	cmova	%ecx, %eax
	movl	%eax, -52(%ebx)
	leal	448(%edi), %eax
	movl	%eax, %ecx
	movl	%eax, 40(%esp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2137
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L2540
.L2137:
	subl	$4, %esp
	.cfi_def_cfa_offset 196
	pushl	$2
	.cfi_def_cfa_offset 200
	movl	12(%esp), %edx
	subl	$64, %edx
	pushl	%edx
	.cfi_def_cfa_offset 204
	pushl	448(%edi)
	.cfi_def_cfa_offset 208
	call	writev
	movl	%eax, 24(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	movl	8(%esp), %eax
	testl	%eax, %eax
	jns	.L2138
.L2517:
	call	__errno_location
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2139
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2541
.L2139:
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L2122
	cmpl	$11, %eax
	je	.L2149
	cmpl	$22, %eax
	setne	%cl
	cmpl	$32, %eax
	setne	%dl
	testb	%dl, %cl
	je	.L2153
	cmpl	$104, %eax
	je	.L2153
	leal	172(%edi), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2154
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jl	.L2154
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%eax
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2149:
	.cfi_restore_state
	leal	80(%ebp), %ebx
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2143
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2542
.L2143:
	movl	%ebp, %eax
	addl	$100, 80(%ebp)
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2144
	movl	%ebp, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2543
.L2144:
	movl	40(%esp), %edx
	movl	$3, 0(%ebp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2145
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2544
.L2145:
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	leal	72(%ebp), %esi
	pushl	448(%edi)
	.cfi_def_cfa_offset 208
	call	fdwatch_del_fd
	movl	%esi, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2146
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2545
.L2146:
	movl	72(%ebp), %edi
	testl	%edi, %edi
	je	.L2148
	subl	$8, %esp
	.cfi_def_cfa_offset 200
	pushl	$.LC126
	.cfi_def_cfa_offset 204
	pushl	$3
	.cfi_def_cfa_offset 208
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 192
.L2148:
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2151
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2546
.L2151:
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	pushl	$0
	.cfi_def_cfa_offset 208
	pushl	80(%ebp)
	.cfi_def_cfa_offset 212
	pushl	%ebp
	.cfi_def_cfa_offset 216
	pushl	$wakeup_connection
	.cfi_def_cfa_offset 220
	pushl	48(%esp)
	.cfi_def_cfa_offset 224
	call	tmr_create
	movl	%esi, %edx
	addl	$32, %esp
	.cfi_def_cfa_offset 192
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2152
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2547
.L2152:
	testl	%eax, %eax
	movl	%eax, 72(%ebp)
	je	.L2548
.L2122:
	leal	64(%esp), %eax
	cmpl	24(%esp), %eax
	jne	.L2549
	movl	28(%esp), %eax
	movl	$0, 536870912(%eax)
	movl	$0, 536870916(%eax)
	movl	$0, 536870920(%eax)
.L2121:
	addl	$172, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L2521:
	.cfi_restore_state
	subl	8(%esp), %eax
	movl	%eax, 4(%esp)
	leal	252(%edi), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2161
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jl	.L2161
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%eax
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2188:
	.cfi_restore_state
	movl	40(%esp), %edx
	movl	$3, 0(%ebp)
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2189
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jl	.L2189
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	52(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2189:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	448(%edi)
	.cfi_def_cfa_offset 208
	call	fdwatch_del_fd
	movl	48(%esp), %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2190
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jl	.L2190
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	pushl	44(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2190:
	.cfi_restore_state
	movl	8(%ebp), %eax
	leal	168(%eax), %edi
	movl	%edi, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2191
	movl	%edi, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %edx
	cmpb	%cl, %dl
	jl	.L2191
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%edi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2191:
	.cfi_restore_state
	movl	44(%esp), %ecx
	movl	168(%eax), %eax
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2192
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jl	.L2192
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	56(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2192:
	.cfi_restore_state
	cltd
	idivl	56(%ebp)
	subl	%ebx, %eax
	leal	72(%ebp), %ebx
	movl	%eax, %esi
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2193
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jl	.L2193
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.p2align 4,,10
	.p2align 3
.L2193:
	.cfi_restore_state
	movl	72(%ebp), %eax
	testl	%eax, %eax
	je	.L2194
	subl	$8, %esp
	.cfi_def_cfa_offset 200
	pushl	$.LC126
	.cfi_def_cfa_offset 204
	pushl	$3
	.cfi_def_cfa_offset 208
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 192
.L2194:
	imull	$1000, %esi, %edx
	movl	$500, %eax
	testl	%esi, %esi
	cmovg	%edx, %eax
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	$0
	.cfi_def_cfa_offset 208
	pushl	%eax
	.cfi_def_cfa_offset 212
	pushl	%ebp
	.cfi_def_cfa_offset 216
	pushl	$wakeup_connection
	.cfi_def_cfa_offset 220
	pushl	48(%esp)
	.cfi_def_cfa_offset 224
	call	tmr_create
	movl	%ebx, %edx
	addl	$32, %esp
	.cfi_def_cfa_offset 192
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2152
	movl	%ebx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jl	.L2152
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	pushl	%ebx
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L2161:
	.cfi_restore_state
	movl	8(%esp), %eax
	movl	252(%edi), %ecx
	movl	4(%esp), %edx
	addl	%ecx, %eax
	testl	%edx, %edx
	movl	%eax, 8(%esp)
	je	.L2164
	movl	%eax, %ebx
	leal	-1(%edx), %edx
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	leal	(%ebx,%edx), %ebx
	movl	%ebx, 52(%esp)
	shrl	$3, %ebx
	movb	%al, 48(%esp)
	movzbl	536870912(%ebx), %eax
	movzbl	48(%esp), %ebx
	movb	%al, 16(%esp)
	movl	8(%esp), %eax
	testb	%bl, %bl
	setne	48(%esp)
	andl	$7, %eax
	cmpb	%al, %bl
	setle	%al
	testb	%al, 48(%esp)
	jne	.L2201
	cmpb	$0, 16(%esp)
	movl	52(%esp), %ebx
	setne	48(%esp)
	andl	$7, %ebx
	cmpb	%bl, 16(%esp)
	setle	%al
	testb	%al, 48(%esp)
	jne	.L2201
	movl	%ecx, %eax
	addl	%ecx, %edx
	movl	%ecx, %ebx
	shrl	$3, %eax
	movl	%edx, 16(%esp)
	shrl	$3, %edx
	movzbl	536870912(%eax), %eax
	movzbl	536870912(%edx), %edx
	testb	%al, %al
	movb	%dl, 48(%esp)
	setne	%dl
	andl	$7, %ebx
	cmpb	%bl, %al
	setle	%al
	testb	%al, %dl
	jne	.L2202
	movzbl	48(%esp), %ebx
	movl	16(%esp), %eax
	testb	%bl, %bl
	setne	%dl
	andl	$7, %eax
	cmpb	%al, %bl
	setle	%al
	testb	%al, %dl
	je	.L2164
.L2202:
	pushl	%edx
	.cfi_remember_state
	.cfi_def_cfa_offset 196
	pushl	%edx
	.cfi_def_cfa_offset 200
	pushl	12(%esp)
	.cfi_def_cfa_offset 204
	pushl	%ecx
	.cfi_def_cfa_offset 208
	call	__asan_report_store_n
	.p2align 4,,10
	.p2align 3
.L2154:
	.cfi_restore_state
	subl	$4, %esp
	.cfi_def_cfa_offset 196
	pushl	172(%edi)
	.cfi_def_cfa_offset 200
	pushl	$.LC128
	.cfi_def_cfa_offset 204
	pushl	$3
	.cfi_def_cfa_offset 208
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 192
.L2153:
	movl	20(%esp), %edx
	movl	%ebp, %eax
	call	clear_connection
	jmp	.L2122
	.p2align 4,,10
	.p2align 3
.L2530:
	movl	20(%esp), %edx
	movl	%ebp, %eax
	call	finish_connection
	jmp	.L2122
.L2164:
	subl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 196
	pushl	8(%esp)
	.cfi_def_cfa_offset 200
	pushl	16(%esp)
	.cfi_def_cfa_offset 204
	pushl	%ecx
	.cfi_def_cfa_offset 208
	call	memmove
	movl	28(%esp), %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2166
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jl	.L2166
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	pushl	24(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
	.p2align 4,,10
	.p2align 3
.L2166:
	.cfi_restore_state
	movl	4(%esp), %eax
	movl	$0, 8(%esp)
	movl	%eax, 304(%edi)
	jmp	.L2159
.L2510:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	44(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2512:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	24(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2511:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	56(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2509:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 196
	pushl	%eax
	.cfi_def_cfa_offset 200
	pushl	32(%esp)
	.cfi_def_cfa_offset 204
	pushl	$96
	.cfi_def_cfa_offset 208
	call	__asan_stack_malloc_1
	addl	$16, %esp
	.cfi_def_cfa_offset 192
	movl	%eax, 24(%esp)
	jmp	.L2119
.L2549:
	movl	24(%esp), %eax
	movl	$1172321806, (%eax)
	movl	28(%esp), %eax
	movl	$-168430091, 536870912(%eax)
	movl	$-168430091, 536870916(%eax)
	movl	$-168430091, 536870920(%eax)
	jmp	.L2121
.L2535:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%edx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2201:
	.cfi_restore_state
	pushl	%ecx
	.cfi_remember_state
	.cfi_def_cfa_offset 196
	pushl	%ecx
	.cfi_def_cfa_offset 200
	pushl	12(%esp)
	.cfi_def_cfa_offset 204
	pushl	20(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load_n
.L2522:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	24(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
.L2531:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%edx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2532:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%edx
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
.L2533:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	56(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2543:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebp
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
.L2544:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	52(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2545:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2546:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2519:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%eax
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
.L2520:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	24(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2518:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	32(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2529:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	48(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2525:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%edx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2526:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%eax
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2527:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%eax
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2528:
	.cfi_restore_state
	movl	16(%esp), %ebx
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2534:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	32(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2541:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%eax
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2542:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ebx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2547:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_store4
.L2515:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ecx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2514:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2513:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	48(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2540:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	52(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2539:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	48(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2538:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2537:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%ecx
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2536:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	20(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2548:
	.cfi_restore_state
	pushl	%ebx
	.cfi_remember_state
	.cfi_def_cfa_offset 196
	pushl	%ebx
	.cfi_def_cfa_offset 200
	pushl	$.LC127
	.cfi_def_cfa_offset 204
	pushl	$2
	.cfi_def_cfa_offset 208
	call	syslog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L2516:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	52(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2523:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 204
	pushl	%esi
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
.L2524:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 204
	pushl	44(%esp)
	.cfi_def_cfa_offset 208
	call	__asan_report_load4
	.cfi_endproc
.LFE19:
	.size	handle_send, .-handle_send
	.section	.text.unlikely
.LCOLDE129:
	.text
.LHOTE129:
	.section	.text.unlikely
.LCOLDB130:
	.text
.LHOTB130:
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LASANPC29:
.LFB29:
	.cfi_startproc
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	subl	$8, %esp
	.cfi_def_cfa_offset 16
	leal	16(%esp), %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2551
	leal	16(%esp), %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2566
.L2551:
	movl	16(%esp), %eax
	leal	76(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2552
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L2567
.L2552:
	movl	20(%esp), %edx
	movl	$0, 76(%eax)
	call	really_clear_connection
	addl	$8, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
.L2567:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 28
	pushl	%edx
	.cfi_def_cfa_offset 32
	call	__asan_report_store4
.L2566:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	leal	28(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	__asan_report_load4
	.cfi_endproc
.LFE29:
	.size	linger_clear_connection, .-linger_clear_connection
	.section	.text.unlikely
.LCOLDE130:
	.text
.LHOTE130:
	.globl	__asan_stack_malloc_7
	.section	.rodata.str1.1
.LC131:
	.string	"1 32 4096 3 buf "
	.globl	__asan_stack_free_7
	.section	.text.unlikely
.LCOLDB132:
	.text
.LHOTB132:
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LASANPC20:
.LFB20:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%eax, %edi
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$4188, %esp
	.cfi_def_cfa_offset 4208
	movl	__asan_option_detect_stack_use_after_return, %ecx
	leal	16(%esp), %ebx
	movl	%edx, 12(%esp)
	testl	%ecx, %ecx
	movl	%ebx, %ebp
	jne	.L2602
.L2568:
	leal	4160(%ebx), %eax
	movl	%ebx, %esi
	shrl	$3, %esi
	movl	%eax, 4(%esp)
	leal	8(%edi), %eax
	movl	$1102416563, (%ebx)
	movl	$.LC131, 4(%ebx)
	movl	$.LASANPC20, 8(%ebx)
	movl	%eax, %edx
	movl	$-235802127, 536870912(%esi)
	movl	$-202116109, 536871428(%esi)
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2572
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2603
.L2572:
	movl	8(%edi), %eax
	leal	448(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	movb	%cl, 11(%esp)
	je	.L2573
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	11(%esp), %cl
	jge	.L2604
.L2573:
	subl	$4, %esp
	.cfi_def_cfa_offset 4212
	pushl	$4096
	.cfi_def_cfa_offset 4216
	movl	12(%esp), %edx
	subl	$4128, %edx
	pushl	%edx
	.cfi_def_cfa_offset 4220
	pushl	448(%eax)
	.cfi_def_cfa_offset 4224
	call	read
	addl	$16, %esp
	.cfi_def_cfa_offset 4208
	testl	%eax, %eax
	js	.L2605
	je	.L2578
.L2571:
	cmpl	%ebx, %ebp
	jne	.L2606
	movl	$0, 536870912(%esi)
	movl	$0, 536871428(%esi)
.L2570:
	addl	$4188, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L2605:
	.cfi_restore_state
	call	__errno_location
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2575
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2607
.L2575:
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L2571
	cmpl	$4, %eax
	je	.L2571
.L2578:
	movl	12(%esp), %edx
	movl	%edi, %eax
	call	really_clear_connection
	jmp	.L2571
.L2603:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4220
	pushl	%eax
	.cfi_def_cfa_offset 4224
	call	__asan_report_load4
.L2604:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4220
	pushl	%edx
	.cfi_def_cfa_offset 4224
	call	__asan_report_load4
.L2607:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4220
	pushl	%eax
	.cfi_def_cfa_offset 4224
	call	__asan_report_load4
.L2606:
	.cfi_restore_state
	movl	$1172321806, (%ebx)
	pushl	%eax
	.cfi_def_cfa_offset 4212
	pushl	%ebp
	.cfi_def_cfa_offset 4216
	pushl	$4160
	.cfi_def_cfa_offset 4220
	pushl	%ebx
	.cfi_def_cfa_offset 4224
	call	__asan_stack_free_7
	addl	$16, %esp
	.cfi_def_cfa_offset 4208
	jmp	.L2570
.L2602:
	pushl	%edx
	.cfi_def_cfa_offset 4212
	pushl	%edx
	.cfi_def_cfa_offset 4216
	pushl	%ebx
	.cfi_def_cfa_offset 4220
	pushl	$4160
	.cfi_def_cfa_offset 4224
	call	__asan_stack_malloc_7
	addl	$16, %esp
	.cfi_def_cfa_offset 4208
	movl	%eax, %ebx
	jmp	.L2568
	.cfi_endproc
.LFE20:
	.size	handle_linger, .-handle_linger
	.section	.text.unlikely
.LCOLDE132:
	.text
.LHOTE132:
	.section	.rodata.str1.4
	.align 4
.LC133:
	.string	"3 32 4 2 ai 96 10 7 portstr 160 32 5 hints "
	.section	.rodata
	.align 32
.LC134:
	.string	"%d"
	.zero	61
	.align 32
.LC135:
	.string	"getaddrinfo %.80s - %.80s"
	.zero	38
	.align 32
.LC136:
	.string	"%s: getaddrinfo %s - %s\n"
	.zero	39
	.align 32
.LC137:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.zero	57
	.section	.text.unlikely
.LCOLDB138:
	.text
.LHOTB138:
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LASANPC35:
.LFB35:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	subl	$268, %esp
	.cfi_def_cfa_offset 288
	movl	__asan_option_detect_stack_use_after_return, %edi
	movl	%eax, 4(%esp)
	leal	32(%esp), %eax
	movl	%edx, 20(%esp)
	movl	%ecx, 8(%esp)
	testl	%edi, %edi
	movl	%eax, 16(%esp)
	jne	.L2760
.L2608:
	movl	16(%esp), %eax
	leal	224(%eax), %esi
	leal	160(%eax), %edx
	movl	%eax, %ebp
	shrl	$3, %ebp
	movl	%esi, 12(%esp)
	movl	$1102416563, (%eax)
	movl	%eax, %esi
	movl	$.LC133, 4(%eax)
	movl	$.LASANPC35, 8(%eax)
	movl	%edx, %eax
	shrl	$3, %eax
	movl	$-235802127, 536870912(%ebp)
	movl	$-185273340, 536870916(%ebp)
	movl	$-218959118, 536870920(%ebp)
	movl	$-185335296, 536870924(%ebp)
	movl	%edx, %edi
	movl	$-218959118, 536870928(%ebp)
	movl	$-202116109, 536870936(%ebp)
	movzbl	536870912(%eax), %ebx
	movl	%esi, %eax
	addl	$191, %eax
	movl	%eax, %ecx
	movl	%eax, (%esp)
	shrl	$3, %ecx
	testb	%bl, %bl
	movzbl	536870912(%ecx), %ecx
	setne	%al
	andl	$7, %edi
	movl	%eax, %esi
	movl	%edi, %eax
	cmpb	%al, %bl
	movl	%esi, %eax
	setle	%bl
	testb	%bl, %al
	jne	.L2651
	movl	(%esp), %eax
	testb	%cl, %cl
	setne	%bl
	andl	$7, %eax
	cmpb	%al, %cl
	setle	%al
	testb	%al, %bl
	jne	.L2651
	xorl	%eax, %eax
.L2614:
	movl	$0, (%edx,%eax)
	addl	$4, %eax
	cmpl	$32, %eax
	jb	.L2614
	movl	12(%esp), %esi
	movzwl	port, %eax
	leal	-128(%esi), %ebx
	movl	$1, -64(%esi)
	movl	$1, -56(%esi)
	pushl	%eax
	.cfi_def_cfa_offset 292
	pushl	$.LC134
	.cfi_def_cfa_offset 296
	pushl	$10
	.cfi_def_cfa_offset 300
	pushl	%ebx
	.cfi_def_cfa_offset 304
	call	snprintf
	movl	%esi, %eax
	subl	$192, %eax
	pushl	%eax
	.cfi_def_cfa_offset 308
	movl	%esi, %eax
	subl	$64, %eax
	pushl	%eax
	.cfi_def_cfa_offset 312
	pushl	%ebx
	.cfi_def_cfa_offset 316
	pushl	hostname
	.cfi_def_cfa_offset 320
	call	getaddrinfo
	addl	$32, %esp
	.cfi_def_cfa_offset 288
	testl	%eax, %eax
	movl	%eax, %ebx
	jne	.L2761
	movl	12(%esp), %eax
	movl	-192(%eax), %eax
	testl	%eax, %eax
	je	.L2618
	xorl	%edx, %edx
	movl	$0, (%esp)
	movl	%edx, %esi
	jmp	.L2624
	.p2align 4,,10
	.p2align 3
.L2765:
	cmpl	$10, %ecx
	jne	.L2620
	testl	%esi, %esi
	cmove	%eax, %esi
.L2620:
	leal	28(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2623
	movl	%ecx, %edi
	andl	$7, %edi
	addl	$3, %edi
	movl	%edi, %ebx
	cmpb	%dl, %bl
	jge	.L2762
.L2623:
	movl	28(%eax), %eax
	testl	%eax, %eax
	je	.L2763
.L2624:
	leal	4(%eax), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2619
	movl	%ecx, %edi
	andl	$7, %edi
	addl	$3, %edi
	movl	%edi, %ebx
	cmpb	%dl, %bl
	jge	.L2764
.L2619:
	movl	4(%eax), %ecx
	cmpl	$2, %ecx
	jne	.L2765
	movl	(%esp), %ebx
	testl	%ebx, %ebx
	cmove	%eax, %ebx
	movl	%ebx, (%esp)
	jmp	.L2620
	.p2align 4,,10
	.p2align 3
.L2763:
	testl	%esi, %esi
	movl	%esi, %edx
	je	.L2766
	leal	16(%esi), %esi
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2628
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L2767
.L2628:
	movl	16(%edx), %eax
	cmpl	$128, %eax
	ja	.L2759
	movl	8(%esp), %edi
	movl	%edi, %ebx
	movl	%edi, %eax
	addl	$127, %ebx
	shrl	$3, %eax
	movl	%ebx, %ecx
	movzbl	536870912(%eax), %eax
	movl	%ebx, 24(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	testb	%al, %al
	setne	31(%esp)
	andl	$7, %edi
	movb	%bl, 30(%esp)
	movzbl	31(%esp), %ebx
	movl	%edi, %ecx
	cmpb	%cl, %al
	setle	%al
	testb	%al, %bl
	jne	.L2652
	movzbl	30(%esp), %ebx
	testb	%bl, %bl
	setne	%al
	movl	%eax, %edi
	movl	24(%esp), %eax
	andl	$7, %eax
	cmpb	%al, %bl
	movl	%edi, %ebx
	setle	%al
	testb	%al, %bl
	jne	.L2652
	movl	8(%esp), %eax
	leal	4(%eax), %edi
	movl	%eax, %ecx
	movl	$0, (%eax)
	movl	$0, 124(%eax)
	xorl	%eax, %eax
	andl	$-4, %edi
	subl	%edi, %ecx
	subl	$-128, %ecx
	shrl	$2, %ecx
	rep; stosl
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2632
	movl	%esi, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L2768
.L2632:
	leal	20(%edx), %esi
	movl	16(%edx), %eax
	movl	%esi, %edi
	movl	%esi, 24(%esp)
	shrl	$3, %esi
	movzbl	536870912(%esi), %esi
	movl	%esi, %ebx
	testb	%bl, %bl
	je	.L2633
	andl	$7, %edi
	movl	%esi, %ecx
	addl	$3, %edi
	movl	%edi, %ebx
	cmpb	%cl, %bl
	jge	.L2769
.L2633:
	testl	%eax, %eax
	movl	20(%edx), %ecx
	je	.L2636
	leal	-1(%eax), %esi
	movl	%ecx, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	leal	(%ecx,%esi), %edi
	movl	%esi, 24(%esp)
	movl	%edi, %esi
	shrl	$3, %esi
	movl	%ebx, %edx
	movzbl	536870912(%esi), %ebx
	movl	%ecx, %esi
	testb	%dl, %dl
	setne	31(%esp)
	andl	$7, %esi
	movb	%bl, 30(%esp)
	movl	%edx, %ebx
	movl	%esi, %edx
	cmpb	%dl, %bl
	setle	%dl
	testb	%dl, 31(%esp)
	jne	.L2653
	movzbl	30(%esp), %ebx
	movl	%edi, %esi
	testb	%bl, %bl
	setne	30(%esp)
	andl	$7, %esi
	movl	%esi, %edx
	cmpb	%dl, %bl
	setle	%bl
	testb	%bl, 30(%esp)
	jne	.L2653
	movl	24(%esp), %edx
	addl	8(%esp), %edx
	movl	%edx, %esi
	shrl	$3, %esi
	movzbl	536870912(%esi), %esi
	movl	%esi, %ebx
	testb	%bl, %bl
	je	.L2636
	andl	$7, %edx
	cmpb	%dl, %bl
	jg	.L2636
	pushl	%ebp
	.cfi_remember_state
	.cfi_def_cfa_offset 292
	pushl	%ebp
	.cfi_def_cfa_offset 296
	pushl	%eax
	.cfi_def_cfa_offset 300
	pushl	20(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store_n
	.p2align 4,,10
	.p2align 3
.L2636:
	.cfi_restore_state
	subl	$4, %esp
	.cfi_def_cfa_offset 292
	pushl	%eax
	.cfi_def_cfa_offset 296
	pushl	%ecx
	.cfi_def_cfa_offset 300
	pushl	20(%esp)
	.cfi_def_cfa_offset 304
	call	memmove
	movl	304(%esp), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2637
	movl	288(%esp), %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2770
.L2637:
	movl	288(%esp), %eax
	movl	$1, (%eax)
.L2627:
	movl	(%esp), %edi
	testl	%edi, %edi
	je	.L2771
	movl	(%esp), %eax
	leal	16(%eax), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2641
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L2772
.L2641:
	movl	(%esp), %eax
	movl	16(%eax), %eax
	cmpl	$128, %eax
	ja	.L2759
	movl	4(%esp), %edi
	movl	%edi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %esi
	movl	%edi, %eax
	addl	$127, %eax
	movl	%eax, %ecx
	movl	%eax, 8(%esp)
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ebx
	movl	%esi, %eax
	movb	%bl, 24(%esp)
	movl	%esi, %ebx
	testb	%bl, %bl
	setne	30(%esp)
	andl	$7, %edi
	movzbl	30(%esp), %ebx
	movl	%edi, %ecx
	cmpb	%cl, %al
	setle	%al
	testb	%al, %bl
	jne	.L2654
	movzbl	24(%esp), %ebx
	testb	%bl, %bl
	setne	%al
	movl	%eax, %esi
	movl	8(%esp), %eax
	andl	$7, %eax
	cmpb	%al, %bl
	movl	%esi, %ebx
	setle	%al
	testb	%al, %bl
	jne	.L2654
	movl	4(%esp), %eax
	leal	4(%eax), %edi
	movl	%eax, %ecx
	movl	$0, (%eax)
	movl	$0, 124(%eax)
	xorl	%eax, %eax
	andl	$-4, %edi
	subl	%edi, %ecx
	subl	$-128, %ecx
	shrl	$2, %ecx
	rep; stosl
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2645
	movl	%edx, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%al, %cl
	jge	.L2773
.L2645:
	movl	(%esp), %esi
	leal	20(%esi), %edx
	movl	16(%esi), %eax
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2646
	movl	%edx, %esi
	andl	$7, %esi
	addl	$3, %esi
	movl	%esi, %ebx
	cmpb	%cl, %bl
	jge	.L2774
.L2646:
	movl	(%esp), %esi
	testl	%eax, %eax
	movl	20(%esi), %ecx
	je	.L2649
	leal	-1(%eax), %ebx
	movl	%ecx, %edx
	shrl	$3, %edx
	leal	(%ecx,%ebx), %edi
	movl	%ebx, (%esp)
	movzbl	536870912(%edx), %esi
	movl	%ecx, %edx
	movl	%edi, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	movb	%bl, 8(%esp)
	movl	%esi, %ebx
	testb	%bl, %bl
	setne	24(%esp)
	andl	$7, %edx
	movl	%edx, %ebx
	movl	%esi, %edx
	cmpb	%bl, %dl
	setle	%bl
	testb	%bl, 24(%esp)
	jne	.L2655
	cmpb	$0, 8(%esp)
	setne	%dl
	andl	$7, %edi
	movl	%edi, %ebx
	cmpb	%bl, 8(%esp)
	setle	%bl
	testb	%bl, %dl
	jne	.L2655
	movl	(%esp), %edx
	addl	4(%esp), %edx
	movl	%edx, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L2649
	andl	$7, %edx
	cmpb	%dl, %bl
	jg	.L2649
	pushl	%edx
	.cfi_remember_state
	.cfi_def_cfa_offset 292
	pushl	%edx
	.cfi_def_cfa_offset 296
	pushl	%eax
	.cfi_def_cfa_offset 300
	pushl	16(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store_n
	.p2align 4,,10
	.p2align 3
.L2649:
	.cfi_restore_state
	subl	$4, %esp
	.cfi_def_cfa_offset 292
	pushl	%eax
	.cfi_def_cfa_offset 296
	pushl	%ecx
	.cfi_def_cfa_offset 300
	pushl	16(%esp)
	.cfi_def_cfa_offset 304
	call	memmove
	movl	36(%esp), %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2650
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2775
.L2650:
	movl	20(%esp), %eax
	movl	$1, (%eax)
.L2640:
	subl	$12, %esp
	.cfi_def_cfa_offset 300
	movl	24(%esp), %eax
	pushl	-192(%eax)
	.cfi_def_cfa_offset 304
	call	freeaddrinfo
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	leal	32(%esp), %eax
	cmpl	16(%esp), %eax
	jne	.L2776
	movl	$0, 536870912(%ebp)
	movl	$0, 536870916(%ebp)
	movl	$0, 536870920(%ebp)
	movl	$0, 536870924(%ebp)
	movl	$0, 536870928(%ebp)
	movl	$0, 536870936(%ebp)
.L2610:
	addl	$268, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 12
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 8
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa_offset 4
	ret
.L2766:
	.cfi_restore_state
	movl	(%esp), %eax
.L2618:
	movl	288(%esp), %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2626
	movl	288(%esp), %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L2777
.L2626:
	movl	288(%esp), %esi
	movl	%eax, (%esp)
	movl	$0, (%esi)
	jmp	.L2627
.L2771:
	movl	20(%esp), %edx
	movl	%edx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2639
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L2778
.L2639:
	movl	20(%esp), %eax
	movl	$0, (%eax)
	jmp	.L2640
.L2761:
	subl	$12, %esp
	.cfi_def_cfa_offset 300
	pushl	%eax
	.cfi_def_cfa_offset 304
	call	gai_strerror
	pushl	%eax
	.cfi_def_cfa_offset 308
	pushl	hostname
	.cfi_def_cfa_offset 312
	pushl	$.LC135
	.cfi_def_cfa_offset 316
	pushl	$2
	.cfi_def_cfa_offset 320
	call	syslog
	addl	$20, %esp
	.cfi_def_cfa_offset 300
	pushl	%ebx
	.cfi_def_cfa_offset 304
	call	gai_strerror
	movl	$stderr, %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	movl	hostname, %esi
	movl	%edx, %ecx
	movl	argv0, %ebx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2617
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%cl, %dl
	jge	.L2779
.L2617:
	subl	$12, %esp
	.cfi_def_cfa_offset 300
	pushl	%eax
	.cfi_def_cfa_offset 304
	pushl	%esi
	.cfi_def_cfa_offset 308
	pushl	%ebx
	.cfi_def_cfa_offset 312
	pushl	$.LC136
	.cfi_def_cfa_offset 316
	pushl	stderr
	.cfi_def_cfa_offset 320
	call	fprintf
.L2758:
	addl	$32, %esp
	.cfi_def_cfa_offset 288
	call	__asan_handle_no_return
	subl	$12, %esp
	.cfi_def_cfa_offset 300
	pushl	$1
	.cfi_def_cfa_offset 304
	call	exit
.L2779:
	.cfi_def_cfa_offset 288
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	$stderr
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2651:
	.cfi_restore_state
	pushl	%ebx
	.cfi_remember_state
	.cfi_def_cfa_offset 292
	pushl	%ebx
	.cfi_def_cfa_offset 296
	pushl	$32
	.cfi_def_cfa_offset 300
	pushl	%edx
	.cfi_def_cfa_offset 304
	call	__asan_report_store_n
.L2760:
	.cfi_restore_state
	pushl	%esi
	.cfi_def_cfa_offset 292
	pushl	%esi
	.cfi_def_cfa_offset 296
	pushl	24(%esp)
	.cfi_def_cfa_offset 300
	pushl	$224
	.cfi_def_cfa_offset 304
	call	__asan_stack_malloc_2
	addl	$16, %esp
	.cfi_def_cfa_offset 288
	movl	%eax, 16(%esp)
	jmp	.L2608
.L2778:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	32(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store4
.L2777:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	300(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store4
.L2776:
	.cfi_restore_state
	movl	16(%esp), %eax
	movl	$1172321806, (%eax)
	movl	$-168430091, 536870912(%ebp)
	movl	$-168430091, 536870916(%ebp)
	movl	$-168430091, 536870920(%ebp)
	movl	$-168430091, 536870924(%ebp)
	movl	$-168430091, 536870928(%ebp)
	movl	$-168430091, 536870932(%ebp)
	movl	$-168430091, 536870936(%ebp)
	jmp	.L2610
.L2775:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	32(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store4
.L2655:
	.cfi_restore_state
	pushl	%ebx
	.cfi_remember_state
	.cfi_def_cfa_offset 292
	pushl	%ebx
	.cfi_def_cfa_offset 296
	pushl	%eax
	.cfi_def_cfa_offset 300
	pushl	%ecx
	.cfi_def_cfa_offset 304
	call	__asan_report_load_n
.L2774:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%edx
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2773:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%edx
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2654:
	.cfi_restore_state
	pushl	%esi
	.cfi_remember_state
	.cfi_def_cfa_offset 292
	pushl	%esi
	.cfi_def_cfa_offset 296
	pushl	$128
	.cfi_def_cfa_offset 300
	pushl	16(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store_n
.L2772:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%edx
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2770:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	300(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store4
.L2653:
	.cfi_restore_state
	pushl	%edx
	.cfi_remember_state
	.cfi_def_cfa_offset 292
	pushl	%edx
	.cfi_def_cfa_offset 296
	pushl	%eax
	.cfi_def_cfa_offset 300
	pushl	%ecx
	.cfi_def_cfa_offset 304
	call	__asan_report_load_n
.L2769:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	36(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2768:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%esi
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2652:
	.cfi_restore_state
	pushl	%ecx
	.cfi_remember_state
	.cfi_def_cfa_offset 292
	pushl	%ecx
	.cfi_def_cfa_offset 296
	pushl	$128
	.cfi_def_cfa_offset 300
	pushl	20(%esp)
	.cfi_def_cfa_offset 304
	call	__asan_report_store_n
.L2759:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%eax
	.cfi_def_cfa_offset 304
	pushl	$128
	.cfi_def_cfa_offset 308
	pushl	hostname
	.cfi_def_cfa_offset 312
	pushl	$.LC137
	.cfi_def_cfa_offset 316
	pushl	$2
	.cfi_def_cfa_offset 320
	call	syslog
	jmp	.L2758
.L2767:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%esi
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2762:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 300
	pushl	%ecx
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
.L2764:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 300
	pushl	%ecx
	.cfi_def_cfa_offset 304
	call	__asan_report_load4
	.cfi_endproc
.LFE35:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.text.unlikely
.LCOLDE138:
	.text
.LHOTE138:
	.section	.rodata.str1.4
	.align 4
.LC139:
	.string	"6 32 4 5 gotv4 96 4 5 gotv6 160 8 2 tv 224 128 3 sa4 384 128 3 sa6 544 4097 3 cwd "
	.section	.rodata
	.align 32
.LC140:
	.string	"can't find any valid address"
	.zero	35
	.align 32
.LC141:
	.string	"%s: can't find any valid address\n"
	.zero	62
	.align 32
.LC142:
	.string	"unknown user - '%.80s'"
	.zero	41
	.align 32
.LC143:
	.string	"%s: unknown user - '%s'\n"
	.zero	39
	.align 32
.LC144:
	.string	"/dev/null"
	.zero	54
	.align 32
.LC145:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.zero	61
	.align 32
.LC146:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.zero	56
	.align 32
.LC147:
	.string	"fchown logfile - %m"
	.zero	44
	.align 32
.LC148:
	.string	"fchown logfile"
	.zero	49
	.align 32
.LC149:
	.string	"chdir - %m"
	.zero	53
	.align 32
.LC150:
	.string	"chdir"
	.zero	58
	.align 32
.LC151:
	.string	"/"
	.zero	62
	.align 32
.LC152:
	.string	"daemon - %m"
	.zero	52
	.align 32
.LC153:
	.string	"w"
	.zero	62
	.align 32
.LC154:
	.string	"%d\n"
	.zero	60
	.align 32
.LC155:
	.string	"fdwatch initialization failure"
	.zero	33
	.align 32
.LC156:
	.string	"chroot - %m"
	.zero	52
	.align 32
.LC157:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.zero	54
	.align 32
.LC158:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.zero	49
	.align 32
.LC159:
	.string	"chroot chdir - %m"
	.zero	46
	.align 32
.LC160:
	.string	"chroot chdir"
	.zero	51
	.align 32
.LC161:
	.string	"data_dir chdir - %m"
	.zero	44
	.align 32
.LC162:
	.string	"data_dir chdir"
	.zero	49
	.align 32
.LC163:
	.string	"tmr_create(occasional) failed"
	.zero	34
	.align 32
.LC164:
	.string	"tmr_create(idle) failed"
	.zero	40
	.align 32
.LC165:
	.string	"tmr_create(update_throttles) failed"
	.zero	60
	.align 32
.LC166:
	.string	"tmr_create(show_stats) failed"
	.zero	34
	.align 32
.LC167:
	.string	"setgroups - %m"
	.zero	49
	.align 32
.LC168:
	.string	"setgid - %m"
	.zero	52
	.align 32
.LC169:
	.string	"initgroups - %m"
	.zero	48
	.align 32
.LC170:
	.string	"setuid - %m"
	.zero	52
	.align 32
.LC171:
	.string	"started as root without requesting chroot(), warning only"
	.zero	38
	.align 32
.LC172:
	.string	"out of memory allocating a connecttab"
	.zero	58
	.align 32
.LC173:
	.string	"fdwatch - %m"
	.zero	51
	.section	.text.unlikely
.LCOLDB174:
	.section	.text.startup,"ax",@progbits
.LHOTB174:
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LASANPC7:
.LFB7:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x70,0x6
	.cfi_escape 0x10,0x7,0x2,0x75,0x7c
	.cfi_escape 0x10,0x6,0x2,0x75,0x78
	.cfi_escape 0x10,0x3,0x2,0x75,0x74
	leal	-4728(%ebp), %eax
	subl	$4760, %esp
	movl	(%ecx), %ebx
	movl	4(%ecx), %esi
	movl	__asan_option_detect_stack_use_after_return, %ecx
	testl	%ecx, %ecx
	jne	.L3166
.L2780:
	leal	4704(%eax), %edi
	movl	%edi, -4736(%ebp)
	movl	$1102416563, (%eax)
	movl	$.LC139, 4(%eax)
	movl	$.LASANPC7, 8(%eax)
	shrl	$3, %eax
	movl	$-235802127, 536870912(%eax)
	movl	$-185273340, 536870916(%eax)
	movl	$-218959118, 536870920(%eax)
	movl	$-185273340, 536870924(%eax)
	movl	$-218959118, 536870928(%eax)
	movl	$-185273344, 536870932(%eax)
	movl	$-218959118, 536870936(%eax)
	movl	$-218959118, 536870956(%eax)
	movl	$-218959118, 536870976(%eax)
	movl	$-185273343, 536871492(%eax)
	movl	$-202116109, 536871496(%eax)
	movl	%esi, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2786
	movl	%esi, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L3167
.L2786:
	movl	(%esi), %edi
	subl	$8, %esp
	pushl	$47
	pushl	%edi
	movl	%edi, argv0
	call	strrchr
	leal	1(%eax), %edx
	addl	$12, %esp
	testl	%eax, %eax
	pushl	$24
	pushl	$9
	cmovne	%edx, %edi
	pushl	%edi
	call	openlog
	movl	%esi, %edx
	movl	%ebx, %eax
	call	parse_args
	call	tzset
	movl	-4736(%ebp), %esi
	movl	%esi, %eax
	leal	-4320(%esi), %edi
	leal	-4672(%esi), %edx
	subl	$4480, %eax
	movl	%eax, %ebx
	movl	%eax, -4744(%ebp)
	leal	-4608(%esi), %eax
	movl	%edi, %ecx
	movl	%edi, -4740(%ebp)
	movl	%eax, (%esp)
	movl	%ebx, %eax
	call	lookup_hostname.constprop.1
	movl	-4672(%esi), %eax
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L2788
	movl	-4736(%ebp), %eax
	cmpl	$0, -4608(%eax)
	je	.L3168
.L2788:
	movl	throttlefile, %eax
	movl	$0, numthrottles
	movl	$0, maxthrottles
	movl	$0, throttles
	testl	%eax, %eax
	je	.L2790
	call	read_throttlefile
.L2790:
	call	getuid
	testl	%eax, %eax
	movl	$32767, -4748(%ebp)
	movl	$32767, -4752(%ebp)
	je	.L3169
.L2791:
	movl	logfile, %ebx
	testl	%ebx, %ebx
	je	.L2900
	movl	$.LC144, %edi
	movl	$10, %ecx
	movl	%ebx, %esi
	repz; cmpsb
	jne	.L2797
	movl	$1, no_log
	movl	$0, -4732(%ebp)
.L2796:
	movl	dir, %eax
	testl	%eax, %eax
	je	.L2805
	subl	$12, %esp
	pushl	%eax
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3170
.L2805:
	movl	-4736(%ebp), %eax
	subl	$8, %esp
	pushl	$4096
	leal	-4160(%eax), %esi
	pushl	%esi
	call	getcwd
	movl	%esi, %eax
.L2806:
	movl	(%eax), %ecx
	addl	$4, %eax
	leal	-16843009(%ecx), %edx
	notl	%ecx
	andl	%ecx, %edx
	andl	$-2139062144, %edx
	je	.L2806
	movl	%edx, %ecx
	shrl	$16, %ecx
	testl	$32896, %edx
	cmove	%ecx, %edx
	leal	2(%eax), %ecx
	cmove	%ecx, %eax
	addb	%dl, %dl
	movl	%esi, %edx
	sbbl	$3, %eax
	shrl	$3, %edx
	addl	$16, %esp
	movzbl	536870912(%edx), %edx
	subl	%esi, %eax
	testb	%dl, %dl
	je	.L2808
	movl	%esi, %ecx
	andl	$7, %ecx
	cmpb	%cl, %dl
	jle	.L3171
.L2808:
	leal	(%esi,%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2809
	movl	%edx, %ebx
	andl	$7, %ebx
	cmpb	%bl, %cl
	jle	.L3172
.L2809:
	leal	-1(%eax), %edx
	leal	(%esi,%edx), %edi
	movl	%edi, %ebx
	movl	%edi, -4756(%ebp)
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L2810
	andl	$7, %edi
	movl	%edi, %ecx
	cmpb	%cl, %bl
	jle	.L3173
.L2810:
	movl	-4736(%ebp), %edi
	cmpb	$47, -4160(%edx,%edi)
	je	.L2811
	movl	$.LC151, %ecx
	addl	%esi, %eax
	movl	$.LC151+1, %ebx
	movl	%ecx, %edx
	movl	%eax, -4756(%ebp)
	shrl	$3, %ebx
	shrl	$3, %edx
	movzbl	536870912(%ebx), %ebx
	movzbl	536870912(%edx), %edi
	movl	%edi, %eax
	movl	%edi, %edx
	testb	%al, %al
	setne	-4760(%ebp)
	movzbl	-4760(%ebp), %eax
	andl	$7, %ecx
	cmpb	%cl, %dl
	setle	%cl
	testb	%cl, %al
	jne	.L2904
	testb	%bl, %bl
	movl	$.LC151+1, %edx
	setne	%cl
	andl	$7, %edx
	cmpb	%dl, %bl
	setle	%dl
	testb	%dl, %cl
	jne	.L2904
	movl	-4756(%ebp), %edi
	movl	%edi, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %ebx
	leal	1(%edi), %edx
	movl	%edx, %ecx
	movl	%edx, -4760(%ebp)
	shrl	$3, %ecx
	testb	%bl, %bl
	movzbl	536870912(%ecx), %ecx
	setne	-4761(%ebp)
	andl	$7, %edi
	movzbl	-4761(%ebp), %eax
	movl	%edi, %edx
	cmpb	%dl, %bl
	setle	%bl
	testb	%bl, %al
	jne	.L2905
	movl	-4760(%ebp), %edx
	testb	%cl, %cl
	setne	%bl
	andl	$7, %edx
	cmpb	%dl, %cl
	setle	%dl
	testb	%dl, %bl
	jne	.L2905
	movl	-4756(%ebp), %eax
	movw	$47, (%eax)
.L2811:
	movl	debug, %eax
	testl	%eax, %eax
	jne	.L2816
	movl	$stdin, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2817
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L3174
.L2817:
	subl	$12, %esp
	pushl	stdin
	call	fclose
	movl	$stdout, %eax
	addl	$16, %esp
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2818
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L3175
.L2818:
	movl	stdout, %eax
	cmpl	%eax, -4732(%ebp)
	je	.L2819
	subl	$12, %esp
	pushl	%eax
	call	fclose
	addl	$16, %esp
.L2819:
	movl	$stderr, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2820
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L3176
.L2820:
	subl	$12, %esp
	pushl	stderr
	call	fclose
	popl	%edi
	popl	%eax
	pushl	$1
	pushl	$1
	call	daemon
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3177
.L2821:
	movl	pidfile, %eax
	testl	%eax, %eax
	je	.L2822
	pushl	%ebx
	pushl	%ebx
	pushl	$.LC153
	pushl	%eax
	call	fopen
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, %ebx
	je	.L3178
	call	getpid
	pushl	%edx
	pushl	%eax
	pushl	$.LC154
	pushl	%ebx
	call	fprintf
	movl	%ebx, (%esp)
	call	fclose
	addl	$16, %esp
.L2822:
	call	fdwatch_get_nfiles
	testl	%eax, %eax
	movl	%eax, max_connects
	js	.L3179
	subl	$10, %eax
	cmpl	$0, do_chroot
	movl	%eax, max_connects
	jne	.L3180
.L2825:
	movl	data_dir, %eax
	testl	%eax, %eax
	je	.L2836
	subl	$12, %esp
	pushl	%eax
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3181
.L2836:
	pushl	%eax
	pushl	%eax
	pushl	$handle_term
	pushl	$15
	call	sigset
	popl	%eax
	popl	%edx
	pushl	$handle_term
	pushl	$2
	call	sigset
	popl	%ecx
	popl	%ebx
	pushl	$handle_chld
	pushl	$17
	call	sigset
	popl	%edi
	popl	%eax
	pushl	$1
	pushl	$13
	call	sigset
	popl	%eax
	popl	%edx
	pushl	$handle_hup
	pushl	$1
	call	sigset
	popl	%ecx
	popl	%ebx
	pushl	$handle_usr1
	pushl	$10
	call	sigset
	popl	%edi
	popl	%eax
	pushl	$handle_usr2
	pushl	$12
	call	sigset
	popl	%eax
	popl	%edx
	pushl	$handle_alrm
	pushl	$14
	call	sigset
	movl	$360, (%esp)
	movl	$0, got_hup
	movl	$0, got_usr1
	movl	$0, watchdog_flag
	call	alarm
	call	tmr_init
	popl	%ebx
	popl	%edi
	movl	-4736(%ebp), %edi
	xorl	%eax, %eax
	movl	-4740(%ebp), %edx
	movzwl	port, %ecx
	cmpl	$0, -4608(%edi)
	cmove	%eax, %edx
	cmpl	$0, -4672(%edi)
	pushl	no_empty_referers
	cmovne	-4744(%ebp), %eax
	pushl	local_pattern
	pushl	url_pattern
	pushl	do_global_passwd
	pushl	do_vhost
	pushl	no_symlink_check
	pushl	-4732(%ebp)
	pushl	no_log
	pushl	%esi
	pushl	max_age
	pushl	p3p
	pushl	charset
	pushl	cgi_limit
	pushl	cgi_pattern
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	pushl	hostname
	call	httpd_initialize
	addl	$80, %esp
	testl	%eax, %eax
	movl	%eax, hs
	je	.L3182
	subl	$12, %esp
	pushl	$1
	pushl	$120000
	pushl	JunkClientData
	pushl	$occasional
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L3183
	subl	$12, %esp
	pushl	$1
	pushl	$5000
	pushl	JunkClientData
	pushl	$idle
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L3184
	cmpl	$0, numthrottles
	jle	.L2842
	subl	$12, %esp
	pushl	$1
	pushl	$2000
	pushl	JunkClientData
	pushl	$update_throttles
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L3185
.L2842:
	subl	$12, %esp
	pushl	$1
	pushl	$3600000
	pushl	JunkClientData
	pushl	$show_stats
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L3186
	subl	$12, %esp
	pushl	$0
	call	time
	movl	$0, stats_connections
	movl	%eax, stats_time
	movl	%eax, start_time
	movl	$0, stats_bytes
	movl	$0, stats_simultaneous
	call	getuid
	addl	$16, %esp
	testl	%eax, %eax
	je	.L3187
.L2845:
	movl	max_connects, %eax
	subl	$12, %esp
	movl	%eax, %esi
	imull	$96, %eax, %eax
	pushl	%eax
	movl	%eax, -4740(%ebp)
	call	malloc
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, -4744(%ebp)
	movl	%eax, connects
	je	.L2851
	xorl	%edx, %edx
	testl	%esi, %esi
	jle	.L2860
	movl	%edx, -4732(%ebp)
	.p2align 4,,10
	.p2align 3
.L3076:
	movl	%eax, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2856
	movl	%eax, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L3188
.L2856:
	leal	4(%eax), %ecx
	addl	$1, -4732(%ebp)
	movl	$0, (%eax)
	movl	%ecx, %ebx
	shrl	$3, %ebx
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L2857
	movl	%ecx, %edi
	andl	$7, %edi
	addl	$3, %edi
	movl	%edi, %edx
	cmpb	%bl, %dl
	jge	.L3189
.L2857:
	leal	8(%eax), %ecx
	movl	-4732(%ebp), %edi
	movl	%ecx, %ebx
	shrl	$3, %ebx
	movl	%edi, 4(%eax)
	movzbl	536870912(%ebx), %ebx
	testb	%bl, %bl
	je	.L2858
	movl	%ecx, %edi
	andl	$7, %edi
	addl	$3, %edi
	movl	%edi, %edx
	cmpb	%bl, %dl
	jge	.L3190
.L2858:
	movl	$0, 8(%eax)
	addl	$96, %eax
	cmpl	%esi, -4732(%ebp)
	jne	.L3076
.L2860:
	movl	-4744(%ebp), %eax
	movl	-4740(%ebp), %esi
	leal	-96(%eax,%esi), %eax
	leal	4(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2853
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L3191
.L2853:
	movl	$-1, 4(%eax)
	movl	hs, %eax
	movl	$0, first_free_connect
	movl	$0, num_connects
	movl	$0, httpd_conn_count
	testl	%eax, %eax
	je	.L2861
	leal	40(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2862
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L3192
.L2862:
	movl	40(%eax), %edx
	cmpl	$-1, %edx
	je	.L2863
	pushl	%esi
	pushl	$0
	pushl	$0
	pushl	%edx
	call	fdwatch_add_fd
	movl	hs, %eax
	addl	$16, %esp
.L2863:
	leal	44(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2864
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L3193
.L2864:
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L2861
	pushl	%ebx
	pushl	$0
	pushl	$0
	pushl	%eax
	call	fdwatch_add_fd
	addl	$16, %esp
.L2861:
	movl	-4736(%ebp), %esi
	subl	$12, %esp
	subl	$4544, %esi
	pushl	%esi
	call	tmr_prepare_timeval
	addl	$16, %esp
	.p2align 4,,10
	.p2align 3
.L2865:
	movl	terminate, %edx
	testl	%edx, %edx
	je	.L2898
	cmpl	$0, num_connects
	jle	.L3194
.L2898:
	movl	got_hup, %eax
	testl	%eax, %eax
	jne	.L3195
.L2866:
	subl	$12, %esp
	pushl	%esi
	call	tmr_mstimeout
	movl	%eax, (%esp)
	call	fdwatch
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, %ebx
	js	.L3196
	subl	$12, %esp
	pushl	%esi
	call	tmr_prepare_timeval
	addl	$16, %esp
	testl	%ebx, %ebx
	je	.L3197
	movl	hs, %eax
	testl	%eax, %eax
	je	.L2884
	leal	44(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2875
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L3198
.L2875:
	movl	44(%eax), %edx
	cmpl	$-1, %edx
	je	.L2876
	subl	$12, %esp
	pushl	%edx
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L2877
.L2881:
	movl	hs, %eax
	testl	%eax, %eax
	je	.L2884
.L2876:
	leal	40(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2882
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L3199
.L2882:
	movl	40(%eax), %eax
	cmpl	$-1, %eax
	je	.L2884
	subl	$12, %esp
	pushl	%eax
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L3200
	.p2align 4,,10
	.p2align 3
.L2884:
	call	fdwatch_get_next_client_data
	cmpl	$-1, %eax
	movl	%eax, %ebx
	je	.L3201
	testl	%ebx, %ebx
	je	.L2884
	leal	8(%ebx), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2885
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L3202
.L2885:
	movl	8(%ebx), %ecx
	leal	448(%ecx), %eax
	movl	%eax, %edx
	movl	%eax, -4732(%ebp)
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2886
	movl	%eax, %edi
	andl	$7, %edi
	addl	$3, %edi
	movl	%edi, %eax
	cmpb	%dl, %al
	jge	.L3203
.L2886:
	subl	$12, %esp
	pushl	448(%ecx)
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	je	.L3204
	movl	%ebx, %eax
	shrl	$3, %eax
	movzbl	536870912(%eax), %eax
	testb	%al, %al
	je	.L2889
	movl	%ebx, %edx
	andl	$7, %edx
	addl	$3, %edx
	cmpb	%al, %dl
	jge	.L3205
.L2889:
	movl	(%ebx), %eax
	cmpl	$2, %eax
	je	.L2890
	cmpl	$4, %eax
	je	.L2891
	cmpl	$1, %eax
	jne	.L2884
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_read
	jmp	.L2884
.L2797:
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC99
	pushl	%ebx
	call	strcmp
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L2798
	movl	$stdout, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2799
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L3206
.L2799:
	movl	stdout, %eax
	movl	%eax, -4732(%ebp)
	jmp	.L2796
.L2816:
	call	setsid
	jmp	.L2821
.L3169:
	subl	$12, %esp
	pushl	user
	call	getpwnam
	addl	$16, %esp
	testl	%eax, %eax
	je	.L3207
	leal	8(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2794
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L3208
.L2794:
	leal	12(%eax), %edx
	movl	8(%eax), %esi
	movl	%edx, %ecx
	shrl	$3, %ecx
	movl	%esi, -4752(%ebp)
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2795
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L3209
.L2795:
	movl	12(%eax), %eax
	movl	%eax, -4748(%ebp)
	jmp	.L2791
.L3168:
	pushl	%edi
	pushl	%edi
	pushl	$.LC140
	pushl	$3
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	movl	argv0, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2789
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L3210
.L2789:
	pushl	%esi
	pushl	%ecx
	pushl	$.LC141
.L3164:
	pushl	stderr
	call	fprintf
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L3187:
	pushl	%edx
	pushl	%edx
	pushl	$0
	pushl	$0
	call	setgroups
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3211
	subl	$12, %esp
	pushl	-4748(%ebp)
	call	setgid
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3212
	pushl	%eax
	pushl	%eax
	pushl	-4748(%ebp)
	pushl	user
	call	initgroups
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3213
.L2848:
	subl	$12, %esp
	pushl	-4752(%ebp)
	call	setuid
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3214
	cmpl	$0, do_chroot
	jne	.L2845
	pushl	%eax
	pushl	%eax
	pushl	$.LC171
	pushl	$4
	call	syslog
	addl	$16, %esp
	jmp	.L2845
.L3204:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	clear_connection
	jmp	.L2884
.L3196:
	call	__errno_location
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2868
	movl	%eax, %ecx
	andl	$7, %ecx
	addl	$3, %ecx
	cmpb	%dl, %cl
	jge	.L3215
.L2868:
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L2865
	cmpl	$4, %eax
	je	.L2865
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC173
	pushl	$3
	call	syslog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L2891:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_linger
	jmp	.L2884
.L2890:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_send
	jmp	.L2884
.L3201:
	subl	$12, %esp
	pushl	%esi
	call	tmr_run
	movl	got_usr1, %eax
	addl	$16, %esp
	testl	%eax, %eax
	je	.L2865
	cmpl	$0, terminate
	jne	.L2865
	movl	hs, %eax
	movl	$1, terminate
	testl	%eax, %eax
	je	.L2865
	leal	40(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2894
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jl	.L2894
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L2894:
	movl	40(%eax), %edx
	cmpl	$-1, %edx
	je	.L2895
	subl	$12, %esp
	pushl	%edx
	call	fdwatch_del_fd
	movl	hs, %eax
	addl	$16, %esp
.L2895:
	leal	44(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2896
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jl	.L2896
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L2896:
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L2897
	subl	$12, %esp
	pushl	%eax
	call	fdwatch_del_fd
	addl	$16, %esp
.L2897:
	subl	$12, %esp
	pushl	hs
	call	httpd_unlisten
	addl	$16, %esp
	jmp	.L2865
.L3195:
	call	re_open_logfile
	movl	$0, got_hup
	jmp	.L2866
.L3197:
	subl	$12, %esp
	pushl	%esi
	call	tmr_run
	addl	$16, %esp
	jmp	.L2865
.L3180:
	subl	$12, %esp
	pushl	%esi
	call	chroot
	addl	$16, %esp
	testl	%eax, %eax
	js	.L3216
	movl	logfile, %ebx
	testl	%ebx, %ebx
	je	.L2827
	pushl	%edi
	pushl	%edi
	pushl	$.LC99
	pushl	%ebx
	call	strcmp
	addl	$16, %esp
	testl	%eax, %eax
	je	.L2827
	xorl	%eax, %eax
	orl	$-1, %ecx
	movl	%esi, %edi
	repnz; scasb
	movl	%esi, %eax
	shrl	$3, %eax
	notl	%ecx
	movzbl	536870912(%eax), %eax
	leal	-1(%ecx), %edi
	testb	%al, %al
	je	.L2828
	movl	%esi, %edx
	andl	$7, %edx
	cmpb	%dl, %al
	jg	.L2828
	subl	$12, %esp
	pushl	%esi
	call	__asan_report_load1
.L2828:
	leal	(%esi,%edi), %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2829
	movl	%eax, %ecx
	andl	$7, %ecx
	cmpb	%cl, %dl
	jg	.L2829
	subl	$12, %esp
	pushl	%eax
	call	__asan_report_load1
.L2829:
	pushl	%ecx
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	call	strncmp
	addl	$16, %esp
	testl	%eax, %eax
	je	.L3217
	pushl	%eax
	pushl	%eax
	pushl	$.LC157
	pushl	$4
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	movl	argv0, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2831
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L3218
.L2831:
	pushl	%eax
	pushl	%ecx
	pushl	$.LC158
	pushl	stderr
	call	fprintf
	addl	$16, %esp
.L2827:
	movl	$.LC151, %edx
	movl	$.LC151+1, %ecx
	movl	%edx, %eax
	shrl	$3, %ecx
	shrl	$3, %eax
	movzbl	536870912(%ecx), %ecx
	movzbl	536870912(%eax), %ebx
	testb	%bl, %bl
	setne	%al
	andl	$7, %edx
	cmpb	%dl, %bl
	setle	%dl
	testb	%dl, %al
	jne	.L2906
	testb	%cl, %cl
	movl	$.LC151+1, %eax
	setne	%dl
	andl	$7, %eax
	cmpb	%al, %cl
	setle	%al
	testb	%al, %dl
	jne	.L2906
	movl	%esi, %eax
	movl	%esi, %edi
	shrl	$3, %eax
	movzbl	536870912(%eax), %ecx
	movl	-4736(%ebp), %eax
	subl	$4159, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	testb	%cl, %cl
	setne	-4756(%ebp)
	andl	$7, %edi
	movzbl	536870912(%edx), %edx
	movl	%edi, %ebx
	cmpb	%bl, %cl
	setle	%cl
	testb	%cl, -4756(%ebp)
	jne	.L2907
	testb	%dl, %dl
	setne	%cl
	andl	$7, %eax
	cmpb	%al, %dl
	setle	%al
	testb	%al, %cl
	jne	.L2907
	movl	-4736(%ebp), %eax
	subl	$12, %esp
	movw	$47, -4160(%eax)
	pushl	%esi
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	jns	.L2825
	pushl	%eax
	pushl	%eax
	pushl	$.LC159
	pushl	$2
	call	syslog
	movl	$.LC160, (%esp)
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L2900:
	movl	$0, -4732(%ebp)
	jmp	.L2796
.L2798:
	pushl	%edi
	pushl	%edi
	pushl	$.LC101
	pushl	%ebx
	call	fopen
	movl	%eax, -4732(%ebp)
	movl	%eax, %esi
	popl	%eax
	popl	%edx
	pushl	$384
	pushl	logfile
	call	chmod
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L2903
	testl	%esi, %esi
	je	.L2903
	movl	logfile, %eax
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2802
	movl	%eax, %ecx
	andl	$7, %ecx
	cmpb	%cl, %dl
	jg	.L2802
	subl	$12, %esp
	pushl	%eax
	call	__asan_report_load1
.L2802:
	cmpb	$47, (%eax)
	je	.L2803
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC145
	pushl	$4
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	movl	argv0, %ecx
	movl	%eax, %edx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2804
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L3219
.L2804:
	pushl	%edx
	pushl	%ecx
	pushl	$.LC146
	pushl	stderr
	call	fprintf
	addl	$16, %esp
.L2803:
	subl	$12, %esp
	pushl	-4732(%ebp)
	call	fileno
	addl	$12, %esp
	pushl	$1
	pushl	$2
	pushl	%eax
	call	fcntl
	call	getuid
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L2796
	subl	$12, %esp
	pushl	-4732(%ebp)
	call	fileno
	addl	$12, %esp
	pushl	-4748(%ebp)
	pushl	-4752(%ebp)
	pushl	%eax
	call	fchown
	addl	$16, %esp
	testl	%eax, %eax
	jns	.L2796
	pushl	%eax
	pushl	%eax
	pushl	$.LC147
	pushl	$4
	call	syslog
	movl	$.LC148, (%esp)
	call	perror
	addl	$16, %esp
	jmp	.L2796
.L3170:
	pushl	%eax
	pushl	%eax
	pushl	$.LC149
	pushl	$2
	call	syslog
	movl	$.LC150, (%esp)
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L3178:
	pushl	%ecx
	pushl	pidfile
	pushl	$.LC90
.L3165:
	pushl	$2
	call	syslog
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L3179:
	pushl	%eax
	pushl	%eax
	pushl	$.LC155
	jmp	.L3165
.L3182:
	call	__asan_handle_no_return
	subl	$12, %esp
	pushl	$1
	call	exit
.L3183:
	pushl	%edi
	pushl	%edi
	pushl	$.LC163
	jmp	.L3165
.L3181:
	pushl	%eax
	pushl	%eax
	pushl	$.LC161
	pushl	$2
	call	syslog
	movl	$.LC162, (%esp)
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L3217:
	leal	-1(%ebx,%edi), %eax
	pushl	%edx
	pushl	%edx
	pushl	%eax
	pushl	%ebx
	call	strcpy
	addl	$16, %esp
	jmp	.L2827
.L3185:
	pushl	%ebx
	pushl	%ebx
	pushl	$.LC165
	jmp	.L3165
.L3177:
	pushl	%esi
	pushl	%esi
	pushl	$.LC152
	jmp	.L3165
.L2877:
	movl	hs, %eax
	leal	44(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2879
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L3220
.L2879:
	movl	44(%eax), %edx
	movl	%esi, %eax
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L2865
	jmp	.L2881
.L3200:
	movl	hs, %eax
	leal	40(%eax), %edx
	movl	%edx, %ecx
	shrl	$3, %ecx
	movzbl	536870912(%ecx), %ecx
	testb	%cl, %cl
	je	.L2883
	movl	%edx, %ebx
	andl	$7, %ebx
	addl	$3, %ebx
	cmpb	%cl, %bl
	jge	.L3221
.L2883:
	movl	40(%eax), %edx
	movl	%esi, %eax
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L2865
	jmp	.L2884
.L3186:
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC166
	jmp	.L3165
.L3211:
	pushl	%eax
	pushl	%eax
	pushl	$.LC167
	jmp	.L3165
.L2903:
	pushl	%ebx
	pushl	logfile
	pushl	$.LC90
	pushl	$2
	call	syslog
	popl	%esi
	pushl	logfile
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L3212:
	pushl	%eax
	pushl	%eax
	pushl	$.LC168
	jmp	.L3165
.L3194:
	call	shut_down
	pushl	%eax
	pushl	%eax
	pushl	$.LC111
	pushl	$5
	call	syslog
	call	closelog
	call	__asan_handle_no_return
	movl	$0, (%esp)
	call	exit
.L3184:
	pushl	%esi
	pushl	%esi
	pushl	$.LC164
	jmp	.L3165
.L3216:
	pushl	%eax
	pushl	%eax
	pushl	$.LC156
	pushl	$2
	call	syslog
	movl	$.LC35, (%esp)
	call	perror
	call	__asan_handle_no_return
	movl	$1, (%esp)
	call	exit
.L3207:
	pushl	%ebx
	pushl	user
	pushl	$.LC142
	pushl	$2
	call	syslog
	movl	$stderr, %eax
	addl	$16, %esp
	movl	user, %ebx
	movl	%eax, %edx
	movl	argv0, %ecx
	shrl	$3, %edx
	movzbl	536870912(%edx), %edx
	testb	%dl, %dl
	je	.L2793
	andl	$7, %eax
	addl	$3, %eax
	cmpb	%dl, %al
	jge	.L3222
.L2793:
	pushl	%ebx
	pushl	%ecx
	pushl	$.LC143
	jmp	.L3164
.L2851:
	pushl	%edi
	pushl	%edi
	pushl	$.LC172
	jmp	.L3165
.L3214:
	pushl	%eax
	pushl	%eax
	pushl	$.LC170
	jmp	.L3165
.L3213:
	pushl	%eax
	pushl	%eax
	pushl	$.LC169
	pushl	$4
	call	syslog
	addl	$16, %esp
	jmp	.L2848
.L3166:
	pushl	%edx
	pushl	%edx
	pushl	%eax
	pushl	$4704
	call	__asan_stack_malloc_7
	addl	$16, %esp
	jmp	.L2780
.L3208:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L3222:
	subl	$12, %esp
	pushl	$stderr
	call	__asan_report_load4
.L2905:
	pushl	%eax
	pushl	%eax
	pushl	$2
	pushl	-4756(%ebp)
	call	__asan_report_store_n
.L3167:
	subl	$12, %esp
	pushl	%esi
	call	__asan_report_load4
.L3191:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_store4
.L3190:
	subl	$12, %esp
	pushl	%ecx
	call	__asan_report_store4
.L3189:
	subl	$12, %esp
	pushl	%ecx
	call	__asan_report_store4
.L3188:
	subl	$12, %esp
	pushl	%eax
	call	__asan_report_store4
.L3210:
	subl	$12, %esp
	pushl	$stderr
	call	__asan_report_load4
.L3174:
	subl	$12, %esp
	pushl	$stdin
	call	__asan_report_load4
.L3175:
	subl	$12, %esp
	pushl	$stdout
	call	__asan_report_load4
.L3176:
	subl	$12, %esp
	pushl	$stderr
	call	__asan_report_load4
.L3171:
	subl	$12, %esp
	pushl	%esi
	call	__asan_report_load1
.L3172:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load1
.L3173:
	subl	$12, %esp
	pushl	-4756(%ebp)
	call	__asan_report_load1
.L2904:
	pushl	%eax
	pushl	%eax
	pushl	$2
	pushl	$.LC151
	call	__asan_report_load_n
.L3209:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L3206:
	subl	$12, %esp
	pushl	$stdout
	call	__asan_report_load4
.L3220:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L3202:
	subl	$12, %esp
	pushl	%eax
	call	__asan_report_load4
.L3221:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L3219:
	subl	$12, %esp
	pushl	$stderr
	call	__asan_report_load4
.L3205:
	subl	$12, %esp
	pushl	%ebx
	call	__asan_report_load4
.L3203:
	movl	-4732(%ebp), %eax
	subl	$12, %esp
	pushl	%eax
	call	__asan_report_load4
.L3199:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L3198:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L3193:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L3192:
	subl	$12, %esp
	pushl	%edx
	call	__asan_report_load4
.L3218:
	subl	$12, %esp
	pushl	$stderr
	call	__asan_report_load4
.L3215:
	subl	$12, %esp
	pushl	%eax
	call	__asan_report_load4
.L2907:
	pushl	%eax
	pushl	%eax
	pushl	$2
	pushl	%esi
	call	__asan_report_store_n
.L2906:
	pushl	%eax
	pushl	%eax
	pushl	$2
	pushl	$.LC151
	call	__asan_report_load_n
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.section	.text.unlikely
.LCOLDE174:
	.section	.text.startup
.LHOTE174:
	.bss
	.align 32
	.type	watchdog_flag, @object
	.size	watchdog_flag, 4
watchdog_flag:
	.zero	64
	.align 32
	.type	got_usr1, @object
	.size	got_usr1, 4
got_usr1:
	.zero	64
	.align 32
	.type	got_hup, @object
	.size	got_hup, 4
got_hup:
	.zero	64
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,4,4
	.comm	stats_connections,4,4
	.comm	stats_time,4,4
	.comm	start_time,4,4
	.globl	terminate
	.align 32
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	64
	.align 32
	.type	hs, @object
	.size	hs, 4
hs:
	.zero	64
	.align 32
	.type	httpd_conn_count, @object
	.size	httpd_conn_count, 4
httpd_conn_count:
	.zero	64
	.align 32
	.type	first_free_connect, @object
	.size	first_free_connect, 4
first_free_connect:
	.zero	64
	.align 32
	.type	max_connects, @object
	.size	max_connects, 4
max_connects:
	.zero	64
	.align 32
	.type	num_connects, @object
	.size	num_connects, 4
num_connects:
	.zero	64
	.align 32
	.type	connects, @object
	.size	connects, 4
connects:
	.zero	64
	.align 32
	.type	maxthrottles, @object
	.size	maxthrottles, 4
maxthrottles:
	.zero	64
	.align 32
	.type	numthrottles, @object
	.size	numthrottles, 4
numthrottles:
	.zero	64
	.align 32
	.type	throttles, @object
	.size	throttles, 4
throttles:
	.zero	64
	.align 32
	.type	max_age, @object
	.size	max_age, 4
max_age:
	.zero	64
	.align 32
	.type	p3p, @object
	.size	p3p, 4
p3p:
	.zero	64
	.align 32
	.type	charset, @object
	.size	charset, 4
charset:
	.zero	64
	.align 32
	.type	user, @object
	.size	user, 4
user:
	.zero	64
	.align 32
	.type	pidfile, @object
	.size	pidfile, 4
pidfile:
	.zero	64
	.align 32
	.type	hostname, @object
	.size	hostname, 4
hostname:
	.zero	64
	.align 32
	.type	throttlefile, @object
	.size	throttlefile, 4
throttlefile:
	.zero	64
	.align 32
	.type	logfile, @object
	.size	logfile, 4
logfile:
	.zero	64
	.align 32
	.type	local_pattern, @object
	.size	local_pattern, 4
local_pattern:
	.zero	64
	.align 32
	.type	no_empty_referers, @object
	.size	no_empty_referers, 4
no_empty_referers:
	.zero	64
	.align 32
	.type	url_pattern, @object
	.size	url_pattern, 4
url_pattern:
	.zero	64
	.align 32
	.type	cgi_limit, @object
	.size	cgi_limit, 4
cgi_limit:
	.zero	64
	.align 32
	.type	cgi_pattern, @object
	.size	cgi_pattern, 4
cgi_pattern:
	.zero	64
	.align 32
	.type	do_global_passwd, @object
	.size	do_global_passwd, 4
do_global_passwd:
	.zero	64
	.align 32
	.type	do_vhost, @object
	.size	do_vhost, 4
do_vhost:
	.zero	64
	.align 32
	.type	no_symlink_check, @object
	.size	no_symlink_check, 4
no_symlink_check:
	.zero	64
	.align 32
	.type	no_log, @object
	.size	no_log, 4
no_log:
	.zero	64
	.align 32
	.type	do_chroot, @object
	.size	do_chroot, 4
do_chroot:
	.zero	64
	.align 32
	.type	data_dir, @object
	.size	data_dir, 4
data_dir:
	.zero	64
	.align 32
	.type	dir, @object
	.size	dir, 4
dir:
	.zero	64
	.align 32
	.type	port, @object
	.size	port, 2
port:
	.zero	64
	.align 32
	.type	debug, @object
	.size	debug, 4
debug:
	.zero	64
	.align 32
	.type	argv0, @object
	.size	argv0, 4
argv0:
	.zero	64
	.section	.rodata.str1.1
.LC175:
	.string	"watchdog_flag"
.LC176:
	.string	"thttpd.c"
.LC177:
	.string	"got_usr1"
.LC178:
	.string	"got_hup"
.LC179:
	.string	"terminate"
.LC180:
	.string	"hs"
.LC181:
	.string	"httpd_conn_count"
.LC182:
	.string	"first_free_connect"
.LC183:
	.string	"max_connects"
.LC184:
	.string	"num_connects"
.LC185:
	.string	"connects"
.LC186:
	.string	"maxthrottles"
.LC187:
	.string	"numthrottles"
.LC188:
	.string	"hostname"
.LC189:
	.string	"throttlefile"
.LC190:
	.string	"local_pattern"
.LC191:
	.string	"no_empty_referers"
.LC192:
	.string	"url_pattern"
.LC193:
	.string	"cgi_limit"
.LC194:
	.string	"cgi_pattern"
.LC195:
	.string	"do_global_passwd"
.LC196:
	.string	"do_vhost"
.LC197:
	.string	"no_symlink_check"
.LC198:
	.string	"no_log"
.LC199:
	.string	"do_chroot"
.LC200:
	.string	"argv0"
.LC201:
	.string	"*.LC123"
.LC202:
	.string	"*.LC149"
.LC203:
	.string	"*.LC53"
.LC204:
	.string	"*.LC100"
.LC205:
	.string	"*.LC169"
.LC206:
	.string	"*.LC95"
.LC207:
	.string	"*.LC96"
.LC208:
	.string	"*.LC4"
.LC209:
	.string	"*.LC161"
.LC210:
	.string	"*.LC164"
.LC211:
	.string	"*.LC84"
.LC212:
	.string	"*.LC49"
.LC213:
	.string	"*.LC75"
.LC214:
	.string	"*.LC92"
.LC215:
	.string	"*.LC77"
.LC216:
	.string	"*.LC99"
.LC217:
	.string	"*.LC69"
.LC218:
	.string	"*.LC156"
.LC219:
	.string	"*.LC162"
.LC220:
	.string	"*.LC50"
.LC221:
	.string	"*.LC35"
.LC222:
	.string	"*.LC46"
.LC223:
	.string	"*.LC168"
.LC224:
	.string	"*.LC70"
.LC225:
	.string	"*.LC59"
.LC226:
	.string	"*.LC135"
.LC227:
	.string	"*.LC43"
.LC228:
	.string	"*.LC12"
.LC229:
	.string	"*.LC6"
.LC230:
	.string	"*.LC140"
.LC231:
	.string	"*.LC137"
.LC232:
	.string	"*.LC91"
.LC233:
	.string	"*.LC93"
.LC234:
	.string	"*.LC148"
.LC235:
	.string	"*.LC45"
.LC236:
	.string	"*.LC54"
.LC237:
	.string	"*.LC64"
.LC238:
	.string	"*.LC71"
.LC239:
	.string	"*.LC55"
.LC240:
	.string	"*.LC151"
.LC241:
	.string	"*.LC76"
.LC242:
	.string	"*.LC44"
.LC243:
	.string	"*.LC1"
.LC244:
	.string	"*.LC101"
.LC245:
	.string	"*.LC170"
.LC246:
	.string	"*.LC154"
.LC247:
	.string	"*.LC24"
.LC248:
	.string	"*.LC167"
.LC249:
	.string	"*.LC61"
.LC250:
	.string	"*.LC62"
.LC251:
	.string	"*.LC134"
.LC252:
	.string	"*.LC160"
.LC253:
	.string	"*.LC57"
.LC254:
	.string	"*.LC127"
.LC255:
	.string	"*.LC33"
.LC256:
	.string	"*.LC39"
.LC257:
	.string	"*.LC159"
.LC258:
	.string	"*.LC142"
.LC259:
	.string	"*.LC143"
.LC260:
	.string	"*.LC173"
.LC261:
	.string	"*.LC34"
.LC262:
	.string	"*.LC65"
.LC263:
	.string	"*.LC87"
.LC264:
	.string	"*.LC106"
.LC265:
	.string	"*.LC81"
.LC266:
	.string	"*.LC78"
.LC267:
	.string	"*.LC79"
.LC268:
	.string	"*.LC146"
.LC269:
	.string	"*.LC30"
.LC270:
	.string	"*.LC153"
.LC271:
	.string	"*.LC152"
.LC272:
	.string	"*.LC94"
.LC273:
	.string	"*.LC155"
.LC274:
	.string	"*.LC8"
.LC275:
	.string	"*.LC157"
.LC276:
	.string	"*.LC31"
.LC277:
	.string	"*.LC82"
.LC278:
	.string	"*.LC36"
.LC279:
	.string	"*.LC56"
.LC280:
	.string	"*.LC80"
.LC281:
	.string	"*.LC40"
.LC282:
	.string	"*.LC102"
.LC283:
	.string	"*.LC47"
.LC284:
	.string	"*.LC63"
.LC285:
	.string	"*.LC150"
.LC286:
	.string	"*.LC158"
.LC287:
	.string	"*.LC136"
.LC288:
	.string	"*.LC128"
.LC289:
	.string	"*.LC171"
.LC290:
	.string	"*.LC122"
.LC291:
	.string	"*.LC90"
.LC292:
	.string	"*.LC16"
.LC293:
	.string	"*.LC166"
.LC294:
	.string	"*.LC85"
.LC295:
	.string	"*.LC97"
.LC296:
	.string	"*.LC68"
.LC297:
	.string	"*.LC83"
.LC298:
	.string	"*.LC72"
.LC299:
	.string	"*.LC108"
.LC300:
	.string	"*.LC172"
.LC301:
	.string	"*.LC5"
.LC302:
	.string	"*.LC117"
.LC303:
	.string	"*.LC10"
.LC304:
	.string	"*.LC118"
.LC305:
	.string	"*.LC165"
.LC306:
	.string	"*.LC126"
.LC307:
	.string	"*.LC111"
.LC308:
	.string	"*.LC37"
.LC309:
	.string	"*.LC73"
.LC310:
	.string	"*.LC21"
.LC311:
	.string	"*.LC147"
.LC312:
	.string	"*.LC144"
.LC313:
	.string	"*.LC104"
.LC314:
	.string	"*.LC48"
.LC315:
	.string	"*.LC163"
.LC316:
	.string	"*.LC58"
.LC317:
	.string	"*.LC41"
.LC318:
	.string	"*.LC105"
.LC319:
	.string	"*.LC113"
.LC320:
	.string	"*.LC66"
.LC321:
	.string	"*.LC86"
.LC322:
	.string	"*.LC52"
.LC323:
	.string	"*.LC67"
.LC324:
	.string	"*.LC74"
.LC325:
	.string	"*.LC51"
.LC326:
	.string	"*.LC42"
.LC327:
	.string	"*.LC26"
.LC328:
	.string	"*.LC27"
.LC329:
	.string	"*.LC141"
.LC330:
	.string	"*.LC38"
.LC331:
	.string	"*.LC145"
.LC332:
	.string	"*.LC32"
	.data
	.align 64
	.type	.LASAN0, @object
	.size	.LASAN0, 4032
.LASAN0:
	.long	watchdog_flag
	.long	4
	.long	64
	.long	.LC175
	.long	.LC176
	.long	0
	.long	got_usr1
	.long	4
	.long	64
	.long	.LC177
	.long	.LC176
	.long	0
	.long	got_hup
	.long	4
	.long	64
	.long	.LC178
	.long	.LC176
	.long	0
	.long	terminate
	.long	4
	.long	64
	.long	.LC179
	.long	.LC176
	.long	0
	.long	hs
	.long	4
	.long	64
	.long	.LC180
	.long	.LC176
	.long	0
	.long	httpd_conn_count
	.long	4
	.long	64
	.long	.LC181
	.long	.LC176
	.long	0
	.long	first_free_connect
	.long	4
	.long	64
	.long	.LC182
	.long	.LC176
	.long	0
	.long	max_connects
	.long	4
	.long	64
	.long	.LC183
	.long	.LC176
	.long	0
	.long	num_connects
	.long	4
	.long	64
	.long	.LC184
	.long	.LC176
	.long	0
	.long	connects
	.long	4
	.long	64
	.long	.LC185
	.long	.LC176
	.long	0
	.long	maxthrottles
	.long	4
	.long	64
	.long	.LC186
	.long	.LC176
	.long	0
	.long	numthrottles
	.long	4
	.long	64
	.long	.LC187
	.long	.LC176
	.long	0
	.long	throttles
	.long	4
	.long	64
	.long	.LC48
	.long	.LC176
	.long	0
	.long	max_age
	.long	4
	.long	64
	.long	.LC58
	.long	.LC176
	.long	0
	.long	p3p
	.long	4
	.long	64
	.long	.LC57
	.long	.LC176
	.long	0
	.long	charset
	.long	4
	.long	64
	.long	.LC56
	.long	.LC176
	.long	0
	.long	user
	.long	4
	.long	64
	.long	.LC42
	.long	.LC176
	.long	0
	.long	pidfile
	.long	4
	.long	64
	.long	.LC55
	.long	.LC176
	.long	0
	.long	hostname
	.long	4
	.long	64
	.long	.LC188
	.long	.LC176
	.long	0
	.long	throttlefile
	.long	4
	.long	64
	.long	.LC189
	.long	.LC176
	.long	0
	.long	logfile
	.long	4
	.long	64
	.long	.LC50
	.long	.LC176
	.long	0
	.long	local_pattern
	.long	4
	.long	64
	.long	.LC190
	.long	.LC176
	.long	0
	.long	no_empty_referers
	.long	4
	.long	64
	.long	.LC191
	.long	.LC176
	.long	0
	.long	url_pattern
	.long	4
	.long	64
	.long	.LC192
	.long	.LC176
	.long	0
	.long	cgi_limit
	.long	4
	.long	64
	.long	.LC193
	.long	.LC176
	.long	0
	.long	cgi_pattern
	.long	4
	.long	64
	.long	.LC194
	.long	.LC176
	.long	0
	.long	do_global_passwd
	.long	4
	.long	64
	.long	.LC195
	.long	.LC176
	.long	0
	.long	do_vhost
	.long	4
	.long	64
	.long	.LC196
	.long	.LC176
	.long	0
	.long	no_symlink_check
	.long	4
	.long	64
	.long	.LC197
	.long	.LC176
	.long	0
	.long	no_log
	.long	4
	.long	64
	.long	.LC198
	.long	.LC176
	.long	0
	.long	do_chroot
	.long	4
	.long	64
	.long	.LC199
	.long	.LC176
	.long	0
	.long	data_dir
	.long	4
	.long	64
	.long	.LC37
	.long	.LC176
	.long	0
	.long	dir
	.long	4
	.long	64
	.long	.LC34
	.long	.LC176
	.long	0
	.long	port
	.long	2
	.long	64
	.long	.LC33
	.long	.LC176
	.long	0
	.long	debug
	.long	4
	.long	64
	.long	.LC32
	.long	.LC176
	.long	0
	.long	argv0
	.long	4
	.long	64
	.long	.LC200
	.long	.LC176
	.long	0
	.long	.LC123
	.long	35
	.long	96
	.long	.LC201
	.long	.LC176
	.long	0
	.long	.LC149
	.long	11
	.long	64
	.long	.LC202
	.long	.LC176
	.long	0
	.long	.LC53
	.long	13
	.long	64
	.long	.LC203
	.long	.LC176
	.long	0
	.long	.LC100
	.long	19
	.long	64
	.long	.LC204
	.long	.LC176
	.long	0
	.long	.LC169
	.long	16
	.long	64
	.long	.LC205
	.long	.LC176
	.long	0
	.long	.LC95
	.long	3
	.long	64
	.long	.LC206
	.long	.LC176
	.long	0
	.long	.LC96
	.long	39
	.long	96
	.long	.LC207
	.long	.LC176
	.long	0
	.long	.LC4
	.long	70
	.long	128
	.long	.LC208
	.long	.LC176
	.long	0
	.long	.LC161
	.long	20
	.long	64
	.long	.LC209
	.long	.LC176
	.long	0
	.long	.LC164
	.long	24
	.long	64
	.long	.LC210
	.long	.LC176
	.long	0
	.long	.LC84
	.long	3
	.long	64
	.long	.LC211
	.long	.LC176
	.long	0
	.long	.LC49
	.long	5
	.long	64
	.long	.LC212
	.long	.LC176
	.long	0
	.long	.LC75
	.long	3
	.long	64
	.long	.LC213
	.long	.LC176
	.long	0
	.long	.LC92
	.long	16
	.long	64
	.long	.LC214
	.long	.LC176
	.long	0
	.long	.LC77
	.long	3
	.long	64
	.long	.LC215
	.long	.LC176
	.long	0
	.long	.LC99
	.long	2
	.long	64
	.long	.LC216
	.long	.LC176
	.long	0
	.long	.LC69
	.long	3
	.long	64
	.long	.LC217
	.long	.LC176
	.long	0
	.long	.LC156
	.long	12
	.long	64
	.long	.LC218
	.long	.LC176
	.long	0
	.long	.LC162
	.long	15
	.long	64
	.long	.LC219
	.long	.LC176
	.long	0
	.long	.LC50
	.long	8
	.long	64
	.long	.LC220
	.long	.LC176
	.long	0
	.long	.LC35
	.long	7
	.long	64
	.long	.LC221
	.long	.LC176
	.long	0
	.long	.LC46
	.long	16
	.long	64
	.long	.LC222
	.long	.LC176
	.long	0
	.long	.LC168
	.long	12
	.long	64
	.long	.LC223
	.long	.LC176
	.long	0
	.long	.LC70
	.long	5
	.long	64
	.long	.LC224
	.long	.LC176
	.long	0
	.long	.LC59
	.long	32
	.long	64
	.long	.LC225
	.long	.LC176
	.long	0
	.long	.LC135
	.long	26
	.long	64
	.long	.LC226
	.long	.LC176
	.long	0
	.long	.LC43
	.long	7
	.long	64
	.long	.LC227
	.long	.LC176
	.long	0
	.long	.LC12
	.long	219
	.long	256
	.long	.LC228
	.long	.LC176
	.long	0
	.long	.LC6
	.long	65
	.long	128
	.long	.LC229
	.long	.LC176
	.long	0
	.long	.LC140
	.long	29
	.long	64
	.long	.LC230
	.long	.LC176
	.long	0
	.long	.LC137
	.long	39
	.long	96
	.long	.LC231
	.long	.LC176
	.long	0
	.long	.LC91
	.long	20
	.long	64
	.long	.LC232
	.long	.LC176
	.long	0
	.long	.LC93
	.long	33
	.long	96
	.long	.LC233
	.long	.LC176
	.long	0
	.long	.LC148
	.long	15
	.long	64
	.long	.LC234
	.long	.LC176
	.long	0
	.long	.LC45
	.long	7
	.long	64
	.long	.LC235
	.long	.LC176
	.long	0
	.long	.LC54
	.long	15
	.long	64
	.long	.LC236
	.long	.LC176
	.long	0
	.long	.LC64
	.long	3
	.long	64
	.long	.LC237
	.long	.LC176
	.long	0
	.long	.LC71
	.long	4
	.long	64
	.long	.LC238
	.long	.LC176
	.long	0
	.long	.LC55
	.long	8
	.long	64
	.long	.LC239
	.long	.LC176
	.long	0
	.long	.LC151
	.long	2
	.long	64
	.long	.LC240
	.long	.LC176
	.long	0
	.long	.LC76
	.long	3
	.long	64
	.long	.LC241
	.long	.LC176
	.long	0
	.long	.LC44
	.long	9
	.long	64
	.long	.LC242
	.long	.LC176
	.long	0
	.long	.LC1
	.long	104
	.long	160
	.long	.LC243
	.long	.LC176
	.long	0
	.long	.LC101
	.long	2
	.long	64
	.long	.LC244
	.long	.LC176
	.long	0
	.long	.LC170
	.long	12
	.long	64
	.long	.LC245
	.long	.LC176
	.long	0
	.long	.LC154
	.long	4
	.long	64
	.long	.LC246
	.long	.LC176
	.long	0
	.long	.LC24
	.long	16
	.long	64
	.long	.LC247
	.long	.LC176
	.long	0
	.long	.LC167
	.long	15
	.long	64
	.long	.LC248
	.long	.LC176
	.long	0
	.long	.LC61
	.long	7
	.long	64
	.long	.LC249
	.long	.LC176
	.long	0
	.long	.LC62
	.long	11
	.long	64
	.long	.LC250
	.long	.LC176
	.long	0
	.long	.LC134
	.long	3
	.long	64
	.long	.LC251
	.long	.LC176
	.long	0
	.long	.LC160
	.long	13
	.long	64
	.long	.LC252
	.long	.LC176
	.long	0
	.long	.LC57
	.long	4
	.long	64
	.long	.LC253
	.long	.LC176
	.long	0
	.long	.LC127
	.long	37
	.long	96
	.long	.LC254
	.long	.LC176
	.long	0
	.long	.LC33
	.long	5
	.long	64
	.long	.LC255
	.long	.LC176
	.long	0
	.long	.LC39
	.long	10
	.long	64
	.long	.LC256
	.long	.LC176
	.long	0
	.long	.LC159
	.long	18
	.long	64
	.long	.LC257
	.long	.LC176
	.long	0
	.long	.LC142
	.long	23
	.long	64
	.long	.LC258
	.long	.LC176
	.long	0
	.long	.LC143
	.long	25
	.long	64
	.long	.LC259
	.long	.LC176
	.long	0
	.long	.LC173
	.long	13
	.long	64
	.long	.LC260
	.long	.LC176
	.long	0
	.long	.LC34
	.long	4
	.long	64
	.long	.LC261
	.long	.LC176
	.long	0
	.long	.LC65
	.long	26
	.long	64
	.long	.LC262
	.long	.LC176
	.long	0
	.long	.LC87
	.long	3
	.long	64
	.long	.LC263
	.long	.LC176
	.long	0
	.long	.LC106
	.long	39
	.long	96
	.long	.LC264
	.long	.LC176
	.long	0
	.long	.LC81
	.long	3
	.long	64
	.long	.LC265
	.long	.LC176
	.long	0
	.long	.LC78
	.long	3
	.long	64
	.long	.LC266
	.long	.LC176
	.long	0
	.long	.LC79
	.long	3
	.long	64
	.long	.LC267
	.long	.LC176
	.long	0
	.long	.LC146
	.long	72
	.long	128
	.long	.LC268
	.long	.LC176
	.long	0
	.long	.LC30
	.long	2
	.long	64
	.long	.LC269
	.long	.LC176
	.long	0
	.long	.LC153
	.long	2
	.long	64
	.long	.LC270
	.long	.LC176
	.long	0
	.long	.LC152
	.long	12
	.long	64
	.long	.LC271
	.long	.LC176
	.long	0
	.long	.LC94
	.long	38
	.long	96
	.long	.LC272
	.long	.LC176
	.long	0
	.long	.LC155
	.long	31
	.long	64
	.long	.LC273
	.long	.LC176
	.long	0
	.long	.LC8
	.long	37
	.long	96
	.long	.LC274
	.long	.LC176
	.long	0
	.long	.LC157
	.long	74
	.long	128
	.long	.LC275
	.long	.LC176
	.long	0
	.long	.LC31
	.long	5
	.long	64
	.long	.LC276
	.long	.LC176
	.long	0
	.long	.LC82
	.long	5
	.long	64
	.long	.LC277
	.long	.LC176
	.long	0
	.long	.LC36
	.long	9
	.long	64
	.long	.LC278
	.long	.LC176
	.long	0
	.long	.LC56
	.long	8
	.long	64
	.long	.LC279
	.long	.LC176
	.long	0
	.long	.LC80
	.long	5
	.long	64
	.long	.LC280
	.long	.LC176
	.long	0
	.long	.LC40
	.long	9
	.long	64
	.long	.LC281
	.long	.LC176
	.long	0
	.long	.LC102
	.long	22
	.long	64
	.long	.LC282
	.long	.LC176
	.long	0
	.long	.LC47
	.long	9
	.long	64
	.long	.LC283
	.long	.LC176
	.long	0
	.long	.LC63
	.long	1
	.long	64
	.long	.LC284
	.long	.LC176
	.long	0
	.long	.LC150
	.long	6
	.long	64
	.long	.LC285
	.long	.LC176
	.long	0
	.long	.LC158
	.long	79
	.long	128
	.long	.LC286
	.long	.LC176
	.long	0
	.long	.LC136
	.long	25
	.long	64
	.long	.LC287
	.long	.LC176
	.long	0
	.long	.LC128
	.long	25
	.long	64
	.long	.LC288
	.long	.LC176
	.long	0
	.long	.LC171
	.long	58
	.long	96
	.long	.LC289
	.long	.LC176
	.long	0
	.long	.LC122
	.long	35
	.long	96
	.long	.LC290
	.long	.LC176
	.long	0
	.long	.LC90
	.long	11
	.long	64
	.long	.LC291
	.long	.LC176
	.long	0
	.long	.LC16
	.long	39
	.long	96
	.long	.LC292
	.long	.LC176
	.long	0
	.long	.LC166
	.long	30
	.long	64
	.long	.LC293
	.long	.LC176
	.long	0
	.long	.LC85
	.long	3
	.long	64
	.long	.LC294
	.long	.LC176
	.long	0
	.long	.LC97
	.long	44
	.long	96
	.long	.LC295
	.long	.LC176
	.long	0
	.long	.LC68
	.long	3
	.long	64
	.long	.LC296
	.long	.LC176
	.long	0
	.long	.LC83
	.long	3
	.long	64
	.long	.LC297
	.long	.LC176
	.long	0
	.long	.LC72
	.long	3
	.long	64
	.long	.LC298
	.long	.LC176
	.long	0
	.long	.LC108
	.long	56
	.long	96
	.long	.LC299
	.long	.LC176
	.long	0
	.long	.LC172
	.long	38
	.long	96
	.long	.LC300
	.long	.LC176
	.long	0
	.long	.LC5
	.long	62
	.long	96
	.long	.LC301
	.long	.LC176
	.long	0
	.long	.LC117
	.long	33
	.long	96
	.long	.LC302
	.long	.LC176
	.long	0
	.long	.LC10
	.long	34
	.long	96
	.long	.LC303
	.long	.LC176
	.long	0
	.long	.LC118
	.long	43
	.long	96
	.long	.LC304
	.long	.LC176
	.long	0
	.long	.LC165
	.long	36
	.long	96
	.long	.LC305
	.long	.LC176
	.long	0
	.long	.LC126
	.long	33
	.long	96
	.long	.LC306
	.long	.LC176
	.long	0
	.long	.LC111
	.long	8
	.long	64
	.long	.LC307
	.long	.LC176
	.long	0
	.long	.LC37
	.long	9
	.long	64
	.long	.LC308
	.long	.LC176
	.long	0
	.long	.LC73
	.long	5
	.long	64
	.long	.LC309
	.long	.LC176
	.long	0
	.long	.LC21
	.long	5
	.long	64
	.long	.LC310
	.long	.LC176
	.long	0
	.long	.LC147
	.long	20
	.long	64
	.long	.LC311
	.long	.LC176
	.long	0
	.long	.LC144
	.long	10
	.long	64
	.long	.LC312
	.long	.LC176
	.long	0
	.long	.LC104
	.long	22
	.long	64
	.long	.LC313
	.long	.LC176
	.long	0
	.long	.LC48
	.long	10
	.long	64
	.long	.LC314
	.long	.LC176
	.long	0
	.long	.LC163
	.long	30
	.long	64
	.long	.LC315
	.long	.LC176
	.long	0
	.long	.LC58
	.long	8
	.long	64
	.long	.LC316
	.long	.LC176
	.long	0
	.long	.LC41
	.long	11
	.long	64
	.long	.LC317
	.long	.LC176
	.long	0
	.long	.LC105
	.long	36
	.long	96
	.long	.LC318
	.long	.LC176
	.long	0
	.long	.LC113
	.long	25
	.long	64
	.long	.LC319
	.long	.LC176
	.long	0
	.long	.LC66
	.long	3
	.long	64
	.long	.LC320
	.long	.LC176
	.long	0
	.long	.LC86
	.long	3
	.long	64
	.long	.LC321
	.long	.LC176
	.long	0
	.long	.LC52
	.long	8
	.long	64
	.long	.LC322
	.long	.LC176
	.long	0
	.long	.LC67
	.long	3
	.long	64
	.long	.LC323
	.long	.LC176
	.long	0
	.long	.LC74
	.long	3
	.long	64
	.long	.LC324
	.long	.LC176
	.long	0
	.long	.LC51
	.long	6
	.long	64
	.long	.LC325
	.long	.LC176
	.long	0
	.long	.LC42
	.long	5
	.long	64
	.long	.LC326
	.long	.LC176
	.long	0
	.long	.LC26
	.long	31
	.long	64
	.long	.LC327
	.long	.LC176
	.long	0
	.long	.LC27
	.long	36
	.long	96
	.long	.LC328
	.long	.LC176
	.long	0
	.long	.LC141
	.long	34
	.long	96
	.long	.LC329
	.long	.LC176
	.long	0
	.long	.LC38
	.long	8
	.long	64
	.long	.LC330
	.long	.LC176
	.long	0
	.long	.LC145
	.long	67
	.long	128
	.long	.LC331
	.long	.LC176
	.long	0
	.long	.LC32
	.long	6
	.long	64
	.long	.LC332
	.long	.LC176
	.long	0
	.section	.text.unlikely
.LCOLDB333:
	.section	.text.exit,"ax",@progbits
.LHOTB333:
	.p2align 4,,15
	.type	_GLOBAL__sub_D_00099_0_terminate, @function
_GLOBAL__sub_D_00099_0_terminate:
.LFB36:
	.cfi_startproc
	subl	$20, %esp
	.cfi_def_cfa_offset 24
	pushl	$168
	.cfi_def_cfa_offset 28
	pushl	$.LASAN0
	.cfi_def_cfa_offset 32
	call	__asan_unregister_globals
	addl	$28, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE36:
	.size	_GLOBAL__sub_D_00099_0_terminate, .-_GLOBAL__sub_D_00099_0_terminate
	.section	.text.unlikely
.LCOLDE333:
	.section	.text.exit
.LHOTE333:
	.section	.dtors.65436,"aw",@progbits
	.align 4
	.long	_GLOBAL__sub_D_00099_0_terminate
	.section	.text.unlikely
.LCOLDB334:
	.section	.text.startup
.LHOTB334:
	.p2align 4,,15
	.type	_GLOBAL__sub_I_00099_1_terminate, @function
_GLOBAL__sub_I_00099_1_terminate:
.LFB37:
	.cfi_startproc
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	call	__asan_init_v3
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	pushl	$168
	.cfi_def_cfa_offset 28
	pushl	$.LASAN0
	.cfi_def_cfa_offset 32
	call	__asan_register_globals
	addl	$28, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE37:
	.size	_GLOBAL__sub_I_00099_1_terminate, .-_GLOBAL__sub_I_00099_1_terminate
	.section	.text.unlikely
.LCOLDE334:
	.section	.text.startup
.LHOTE334:
	.section	.ctors.65436,"aw",@progbits
	.align 4
	.long	_GLOBAL__sub_I_00099_1_terminate
	.ident	"GCC: (GNU) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
