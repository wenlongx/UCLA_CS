	.file	"thttpd.c"
	.section	.text.unlikely,"ax",@progbits
.LCOLDB0:
	.text
.LHOTB0:
	.p2align 4,,15
	.type	handle_hup, @function
handle_hup:
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
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC1:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.section	.text.unlikely
.LCOLDB3:
	.text
.LHOTB3:
	.p2align 4,,15
	.type	thttpd_logstats, @function
thttpd_logstats:
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
	.section	.rodata.str1.4
	.align 4
.LC4:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.align 4
.LC5:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.align 4
.LC6:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.section	.text.unlikely
.LCOLDB7:
	.text
.LHOTB7:
	.p2align 4,,15
	.type	update_throttles, @function
update_throttles:
.LFB23:
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
	xorl	%ebx, %ebx
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	movl	numthrottles, %eax
	testl	%eax, %eax
	jg	.L25
	jmp	.L13
	.p2align 4,,10
	.p2align 3
.L11:
	addl	$1, %ebx
	cmpl	%ebx, numthrottles
	jle	.L13
.L25:
	leal	(%ebx,%ebx,2), %esi
	movl	throttles, %ecx
	sall	$3, %esi
	addl	%esi, %ecx
	movl	16(%ecx), %eax
	movl	12(%ecx), %edx
	movl	$0, 16(%ecx)
	movl	%eax, %edi
	shrl	$31, %edi
	addl	%edi, %eax
	sarl	%eax
	leal	(%eax,%edx,2), %edi
	movl	$1431655766, %edx
	movl	%edi, %eax
	sarl	$31, %edi
	imull	%edx
	movl	4(%ecx), %eax
	subl	%edi, %edx
	cmpl	%eax, %edx
	movl	%edx, 12(%ecx)
	jle	.L10
	movl	20(%ecx), %edi
	testl	%edi, %edi
	je	.L11
	leal	(%eax,%eax), %ebp
	cmpl	%ebp, %edx
	jle	.L12
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	pushl	%edi
	.cfi_def_cfa_offset 56
	pushl	%eax
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	pushl	(%ecx)
	.cfi_def_cfa_offset 68
	pushl	%ebx
	.cfi_def_cfa_offset 72
	pushl	$.LC4
	.cfi_def_cfa_offset 76
	pushl	$5
	.cfi_def_cfa_offset 80
.L33:
	call	syslog
	addl	throttles, %esi
	addl	$32, %esp
	.cfi_def_cfa_offset 48
	movl	12(%esi), %edx
	movl	%esi, %ecx
.L10:
	movl	8(%ecx), %eax
	cmpl	%edx, %eax
	jle	.L11
	movl	20(%ecx), %esi
	testl	%esi, %esi
	je	.L11
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	pushl	%esi
	.cfi_def_cfa_offset 56
	pushl	%eax
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	pushl	(%ecx)
	.cfi_def_cfa_offset 68
	pushl	%ebx
	.cfi_def_cfa_offset 72
	pushl	$.LC6
	.cfi_def_cfa_offset 76
	addl	$1, %ebx
	pushl	$5
	.cfi_def_cfa_offset 80
	call	syslog
	addl	$32, %esp
	.cfi_def_cfa_offset 48
	cmpl	%ebx, numthrottles
	jg	.L25
	.p2align 4,,10
	.p2align 3
.L13:
	movl	max_connects, %eax
	testl	%eax, %eax
	jle	.L6
	movl	connects, %esi
	leal	(%eax,%eax,2), %eax
	movl	throttles, %ebp
	sall	$5, %eax
	addl	%esi, %eax
	movl	%eax, 12(%esp)
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L16:
	addl	$96, %esi
	cmpl	12(%esp), %esi
	je	.L6
.L15:
	movl	(%esi), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L16
	movl	52(%esi), %eax
	movl	$-1, 56(%esi)
	testl	%eax, %eax
	jle	.L16
	leal	12(%esi,%eax,4), %edi
	leal	12(%esi), %ebx
	movl	$-1, %ecx
	movl	%edi, 8(%esp)
	jmp	.L19
	.p2align 4,,10
	.p2align 3
.L36:
	movl	56(%esi), %ecx
.L19:
	movl	(%ebx), %eax
	leal	(%eax,%eax,2), %eax
	leal	0(%ebp,%eax,8), %edi
	movl	4(%edi), %eax
	cltd
	idivl	20(%edi)
	cmpl	$-1, %ecx
	je	.L34
	cmpl	%eax, %ecx
	cmovle	%ecx, %eax
.L34:
	addl	$4, %ebx
	cmpl	8(%esp), %ebx
	movl	%eax, 56(%esi)
	jne	.L36
	addl	$96, %esi
	cmpl	12(%esp), %esi
	jne	.L15
.L6:
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
.L12:
	.cfi_restore_state
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	pushl	%edi
	.cfi_def_cfa_offset 56
	pushl	%eax
	.cfi_def_cfa_offset 60
	pushl	%edx
	.cfi_def_cfa_offset 64
	pushl	(%ecx)
	.cfi_def_cfa_offset 68
	pushl	%ebx
	.cfi_def_cfa_offset 72
	pushl	$.LC5
	.cfi_def_cfa_offset 76
	pushl	$6
	.cfi_def_cfa_offset 80
	jmp	.L33
	.cfi_endproc
.LFE23:
	.size	update_throttles, .-update_throttles
	.section	.text.unlikely
.LCOLDE7:
	.text
.LHOTE7:
	.section	.rodata.str1.4
	.align 4
.LC8:
	.string	"%s: no value required for %s option\n"
	.section	.text.unlikely
.LCOLDB9:
	.text
.LHOTB9:
	.p2align 4,,15
	.type	no_value_required, @function
no_value_required:
.LFB12:
	.cfi_startproc
	testl	%edx, %edx
	jne	.L41
	rep; ret
.L41:
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	argv0
	.cfi_def_cfa_offset 24
	pushl	$.LC8
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE12:
	.size	no_value_required, .-no_value_required
	.section	.text.unlikely
.LCOLDE9:
	.text
.LHOTE9:
	.section	.rodata.str1.4
	.align 4
.LC10:
	.string	"%s: value required for %s option\n"
	.section	.text.unlikely
.LCOLDB11:
	.text
.LHOTB11:
	.p2align 4,,15
	.type	value_required, @function
value_required:
.LFB11:
	.cfi_startproc
	testl	%edx, %edx
	je	.L46
	rep; ret
.L46:
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	argv0
	.cfi_def_cfa_offset 24
	pushl	$.LC10
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE11:
	.size	value_required, .-value_required
	.section	.text.unlikely
.LCOLDE11:
	.text
.LHOTE11:
	.section	.rodata.str1.4
	.align 4
.LC12:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.section	.text.unlikely
.LCOLDB13:
.LHOTB13:
	.type	usage, @function
usage:
.LFB9:
	.cfi_startproc
	subl	$16, %esp
	.cfi_def_cfa_offset 20
	pushl	argv0
	.cfi_def_cfa_offset 24
	pushl	$.LC12
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
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
.LFB28:
	.cfi_startproc
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	movl	16(%esp), %eax
	cmpl	$3, (%eax)
	movl	$0, 72(%eax)
	je	.L52
	addl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L52:
	.cfi_restore_state
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	movl	$2, (%eax)
	pushl	$1
	.cfi_def_cfa_offset 24
	pushl	%eax
	.cfi_def_cfa_offset 28
	movl	8(%eax), %eax
	pushl	448(%eax)
	.cfi_def_cfa_offset 32
	call	fdwatch_add_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	addl	$12, %esp
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE28:
	.size	wakeup_connection, .-wakeup_connection
	.section	.text.unlikely
.LCOLDE14:
	.text
.LHOTE14:
	.section	.rodata.str1.4
	.align 4
.LC15:
	.string	"up %ld seconds, stats for %ld seconds:"
	.section	.text.unlikely
.LCOLDB16:
	.text
.LHOTB16:
	.p2align 4,,15
	.type	logstats, @function
logstats:
.LFB32:
	.cfi_startproc
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	subl	$24, %esp
	.cfi_def_cfa_offset 32
	movl	%gs:20, %ecx
	movl	%ecx, 12(%esp)
	xorl	%ecx, %ecx
	testl	%eax, %eax
	je	.L58
.L54:
	movl	(%eax), %eax
	movl	$1, %ecx
	movl	%eax, %edx
	movl	%eax, %ebx
	subl	start_time, %edx
	subl	stats_time, %ebx
	movl	%eax, stats_time
	cmove	%ecx, %ebx
	pushl	%ebx
	.cfi_def_cfa_offset 36
	pushl	%edx
	.cfi_def_cfa_offset 40
	pushl	$.LC15
	.cfi_def_cfa_offset 44
	pushl	$6
	.cfi_def_cfa_offset 48
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
	.cfi_def_cfa_offset 32
	movl	12(%esp), %eax
	xorl	%gs:20, %eax
	jne	.L59
	addl	$24, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L58:
	.cfi_restore_state
	subl	$8, %esp
	.cfi_def_cfa_offset 40
	pushl	$0
	.cfi_def_cfa_offset 44
	leal	16(%esp), %ebx
	pushl	%ebx
	.cfi_def_cfa_offset 48
	call	gettimeofday
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	movl	%ebx, %eax
	jmp	.L54
.L59:
	call	__stack_chk_fail
	.cfi_endproc
.LFE32:
	.size	logstats, .-logstats
	.section	.text.unlikely
.LCOLDE16:
	.text
.LHOTE16:
	.section	.text.unlikely
.LCOLDB17:
	.text
.LHOTB17:
	.p2align 4,,15
	.type	show_stats, @function
show_stats:
.LFB31:
	.cfi_startproc
	movl	8(%esp), %eax
	jmp	logstats
	.cfi_endproc
.LFE31:
	.size	show_stats, .-show_stats
	.section	.text.unlikely
.LCOLDE17:
	.text
.LHOTE17:
	.section	.text.unlikely
.LCOLDB18:
	.text
.LHOTB18:
	.p2align 4,,15
	.type	handle_usr2, @function
handle_usr2:
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
	movl	(%eax), %esi
	movl	%eax, %ebx
	xorl	%eax, %eax
	call	logstats
	movl	%esi, (%ebx)
	addl	$4, %esp
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE4:
	.size	handle_usr2, .-handle_usr2
	.section	.text.unlikely
.LCOLDE18:
	.text
.LHOTE18:
	.section	.text.unlikely
.LCOLDB19:
	.text
.LHOTB19:
	.p2align 4,,15
	.type	occasional, @function
occasional:
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
.LCOLDE19:
	.text
.LHOTE19:
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC20:
	.string	"/tmp"
	.section	.text.unlikely
.LCOLDB21:
	.text
.LHOTB21:
	.p2align 4,,15
	.type	handle_alrm, @function
handle_alrm:
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
	movl	(%eax), %esi
	movl	watchdog_flag, %eax
	testl	%eax, %eax
	je	.L68
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	movl	$0, watchdog_flag
	pushl	$360
	.cfi_def_cfa_offset 32
	call	alarm
	movl	%esi, (%ebx)
	addl	$20, %esp
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
.L68:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -12
	.cfi_offset 6, -8
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$.LC20
	.cfi_def_cfa_offset 32
	call	chdir
	call	abort
	.cfi_endproc
.LFE5:
	.size	handle_alrm, .-handle_alrm
	.section	.text.unlikely
.LCOLDE21:
	.text
.LHOTE21:
	.section	.rodata.str1.1
.LC22:
	.string	"child wait - %m"
	.section	.text.unlikely
.LCOLDB23:
	.text
.LHOTB23:
	.p2align 4,,15
	.type	handle_chld, @function
handle_chld:
.LFB1:
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
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	movl	%gs:20, %eax
	movl	%eax, 12(%esp)
	xorl	%eax, %eax
	call	__errno_location
	movl	(%eax), %ebp
	leal	8(%esp), %ebx
	movl	%eax, %esi
	.p2align 4,,10
	.p2align 3
.L70:
	subl	$4, %esp
	.cfi_def_cfa_offset 52
	pushl	$1
	.cfi_def_cfa_offset 56
	pushl	%ebx
	.cfi_def_cfa_offset 60
	pushl	$-1
	.cfi_def_cfa_offset 64
	call	waitpid
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L71
	js	.L87
	movl	hs, %edx
	testl	%edx, %edx
	je	.L70
	movl	20(%edx), %eax
	subl	$1, %eax
	cmovs	%edi, %eax
	movl	%eax, 20(%edx)
	jmp	.L70
	.p2align 4,,10
	.p2align 3
.L87:
	movl	(%esi), %eax
	cmpl	$11, %eax
	je	.L70
	cmpl	$4, %eax
	je	.L70
	cmpl	$10, %eax
	je	.L71
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC22
	.cfi_def_cfa_offset 60
	pushl	$3
	.cfi_def_cfa_offset 64
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 48
.L71:
	movl	12(%esp), %eax
	xorl	%gs:20, %eax
	movl	%ebp, (%esi)
	jne	.L88
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
.L88:
	.cfi_restore_state
	call	__stack_chk_fail
	.cfi_endproc
.LFE1:
	.size	handle_chld, .-handle_chld
	.section	.text.unlikely
.LCOLDE23:
	.text
.LHOTE23:
	.section	.rodata.str1.4
	.align 4
.LC24:
	.string	"out of memory copying a string"
	.align 4
.LC25:
	.string	"%s: out of memory copying a string\n"
	.section	.text.unlikely
.LCOLDB26:
	.text
.LHOTB26:
	.p2align 4,,15
	.type	e_strdup, @function
e_strdup:
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
	je	.L92
	addl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 4
	ret
.L92:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	%eax
	.cfi_def_cfa_offset 24
	pushl	$.LC24
	.cfi_def_cfa_offset 28
	pushl	$2
	.cfi_def_cfa_offset 32
	call	syslog
	addl	$12, %esp
	.cfi_def_cfa_offset 20
	pushl	argv0
	.cfi_def_cfa_offset 24
	pushl	$.LC25
	.cfi_def_cfa_offset 28
	pushl	stderr
	.cfi_def_cfa_offset 32
	call	fprintf
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE13:
	.size	e_strdup, .-e_strdup
	.section	.text.unlikely
.LCOLDE26:
	.text
.LHOTE26:
	.section	.rodata.str1.1
.LC27:
	.string	"r"
.LC28:
	.string	" \t\n\r"
.LC29:
	.string	"debug"
.LC30:
	.string	"port"
.LC31:
	.string	"dir"
.LC32:
	.string	"chroot"
.LC33:
	.string	"nochroot"
.LC34:
	.string	"data_dir"
.LC35:
	.string	"symlink"
.LC36:
	.string	"nosymlink"
.LC37:
	.string	"symlinks"
.LC38:
	.string	"nosymlinks"
.LC39:
	.string	"user"
.LC40:
	.string	"cgipat"
.LC41:
	.string	"cgilimit"
.LC42:
	.string	"urlpat"
.LC43:
	.string	"noemptyreferers"
.LC44:
	.string	"localpat"
.LC45:
	.string	"throttles"
.LC46:
	.string	"host"
.LC47:
	.string	"logfile"
.LC48:
	.string	"vhost"
.LC49:
	.string	"novhost"
.LC50:
	.string	"globalpasswd"
.LC51:
	.string	"noglobalpasswd"
.LC52:
	.string	"pidfile"
.LC53:
	.string	"charset"
.LC54:
	.string	"p3p"
.LC55:
	.string	"max_age"
	.section	.rodata.str1.4
	.align 4
.LC56:
	.string	"%s: unknown config option '%s'\n"
	.section	.text.unlikely
.LCOLDB57:
	.text
.LHOTB57:
	.p2align 4,,15
	.type	read_config, @function
read_config:
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
	subl	$148, %esp
	.cfi_def_cfa_offset 168
	movl	%gs:20, %eax
	movl	%eax, 132(%esp)
	xorl	%eax, %eax
	pushl	$.LC27
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	fopen
	movl	%eax, 28(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L145
	leal	24(%esp), %edi
.L94:
	subl	$4, %esp
	.cfi_def_cfa_offset 164
	pushl	16(%esp)
	.cfi_def_cfa_offset 168
	pushl	$1000
	.cfi_def_cfa_offset 172
	pushl	%edi
	.cfi_def_cfa_offset 176
	call	fgets
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L152
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$35
	.cfi_def_cfa_offset 172
	pushl	%edi
	.cfi_def_cfa_offset 176
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L95
	movb	$0, (%eax)
.L95:
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC28
	.cfi_def_cfa_offset 172
	pushl	%edi
	.cfi_def_cfa_offset 176
	call	strspn
	leal	(%edi,%eax), %ebx
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	cmpb	$0, (%ebx)
	je	.L94
	.p2align 4,,10
	.p2align 3
.L140:
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC28
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcspn
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	leal	(%ebx,%eax), %ebp
	jmp	.L148
	.p2align 4,,10
	.p2align 3
.L142:
	addl	$1, %ebp
	movb	$0, -1(%ebp)
.L148:
	movzbl	0(%ebp), %eax
	cmpb	$13, %al
	sete	%cl
	cmpb	$32, %al
	sete	%dl
	orb	%dl, %cl
	jne	.L142
	subl	$9, %eax
	cmpb	$1, %al
	jbe	.L142
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$61
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L133
	leal	1(%eax), %esi
	movb	$0, (%eax)
.L100:
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC29
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L153
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC30
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L154
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC31
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L155
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC32
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L156
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC33
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L157
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC34
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L158
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC35
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L149
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC36
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L150
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC37
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L149
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC38
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L150
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC39
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L159
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC40
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L160
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC41
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L161
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC42
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L162
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC43
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L163
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC44
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L164
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC45
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L165
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC46
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L166
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC47
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L167
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC48
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L168
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC49
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L169
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC50
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L170
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC51
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L171
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC52
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L172
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC53
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L173
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC54
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	je	.L174
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC55
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	strcasecmp
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	testl	%eax, %eax
	jne	.L128
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	movl	%eax, max_age
	.p2align 4,,10
	.p2align 3
.L102:
	subl	$8, %esp
	.cfi_def_cfa_offset 168
	pushl	$.LC28
	.cfi_def_cfa_offset 172
	pushl	%ebp
	.cfi_def_cfa_offset 176
	call	strspn
	leal	0(%ebp,%eax), %ebx
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	cmpb	$0, (%ebx)
	jne	.L140
	jmp	.L94
.L153:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	no_value_required
	movl	$1, debug
	jmp	.L102
.L154:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	movw	%ax, port
	jmp	.L102
.L133:
	xorl	%esi, %esi
	jmp	.L100
.L155:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, dir
	jmp	.L102
.L156:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	no_value_required
	movl	$1, do_chroot
	movl	$1, no_symlink_check
	jmp	.L102
.L157:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	no_value_required
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L102
.L149:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	no_value_required
	movl	$0, no_symlink_check
	jmp	.L102
.L158:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, data_dir
	jmp	.L102
.L150:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	no_value_required
	movl	$1, no_symlink_check
	jmp	.L102
.L159:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, user
	jmp	.L102
.L161:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	subl	$12, %esp
	.cfi_def_cfa_offset 172
	pushl	%esi
	.cfi_def_cfa_offset 176
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	movl	%eax, cgi_limit
	jmp	.L102
.L160:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, cgi_pattern
	jmp	.L102
.L152:
	subl	$12, %esp
	.cfi_def_cfa_offset 172
	pushl	24(%esp)
	.cfi_def_cfa_offset 176
	call	fclose
	addl	$16, %esp
	.cfi_def_cfa_offset 160
	movl	124(%esp), %eax
	xorl	%gs:20, %eax
	jne	.L175
	addl	$140, %esp
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
.L163:
	.cfi_restore_state
	movl	%esi, %edx
	movl	%ebx, %eax
	call	no_value_required
	movl	$1, no_empty_referers
	jmp	.L102
.L162:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, url_pattern
	jmp	.L102
.L164:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, local_pattern
	jmp	.L102
.L165:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, throttlefile
	jmp	.L102
.L145:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 172
	pushl	%ebx
	.cfi_def_cfa_offset 176
	call	perror
	movl	$1, (%esp)
	call	exit
.L175:
	.cfi_restore_state
	call	__stack_chk_fail
.L167:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, logfile
	jmp	.L102
.L166:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, hostname
	jmp	.L102
.L128:
	pushl	%ebx
	.cfi_remember_state
	.cfi_def_cfa_offset 164
	pushl	argv0
	.cfi_def_cfa_offset 168
	pushl	$.LC56
	.cfi_def_cfa_offset 172
	pushl	stderr
	.cfi_def_cfa_offset 176
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L174:
	.cfi_restore_state
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, p3p
	jmp	.L102
.L173:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, charset
	jmp	.L102
.L172:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	value_required
	movl	%esi, %eax
	call	e_strdup
	movl	%eax, pidfile
	jmp	.L102
.L171:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	no_value_required
	movl	$0, do_global_passwd
	jmp	.L102
.L170:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	no_value_required
	movl	$1, do_global_passwd
	jmp	.L102
.L169:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	no_value_required
	movl	$0, do_vhost
	jmp	.L102
.L168:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	no_value_required
	movl	$1, do_vhost
	jmp	.L102
	.cfi_endproc
.LFE10:
	.size	read_config, .-read_config
	.section	.text.unlikely
.LCOLDE57:
	.text
.LHOTE57:
	.section	.rodata.str1.1
.LC58:
	.string	"nobody"
.LC59:
	.string	"iso-8859-1"
.LC60:
	.string	""
.LC61:
	.string	"-V"
.LC62:
	.string	"thttpd/2.27.0 Oct 3, 2014"
.LC63:
	.string	"-C"
.LC64:
	.string	"-p"
.LC65:
	.string	"-d"
.LC66:
	.string	"-r"
.LC67:
	.string	"-nor"
.LC68:
	.string	"-dd"
.LC69:
	.string	"-s"
.LC70:
	.string	"-nos"
.LC71:
	.string	"-u"
.LC72:
	.string	"-c"
.LC73:
	.string	"-t"
.LC74:
	.string	"-h"
.LC75:
	.string	"-l"
.LC76:
	.string	"-v"
.LC77:
	.string	"-nov"
.LC78:
	.string	"-g"
.LC79:
	.string	"-nog"
.LC80:
	.string	"-i"
.LC81:
	.string	"-T"
.LC82:
	.string	"-P"
.LC83:
	.string	"-M"
.LC84:
	.string	"-D"
	.section	.text.unlikely
.LCOLDB85:
	.text
.LHOTB85:
	.p2align 4,,15
	.type	parse_args, @function
parse_args:
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
	movl	$.LC58, user
	movl	$.LC59, charset
	movl	$.LC60, p3p
	movl	$-1, max_age
	jle	.L207
	movl	4(%edx), %ebx
	cmpb	$45, (%ebx)
	jne	.L205
	movl	$1, %ebp
	movl	$3, %edx
	jmp	.L206
	.p2align 4,,10
	.p2align 3
.L223:
	leal	1(%ebp), %esi
	cmpl	%esi, 4(%esp)
	jg	.L221
.L181:
	movl	$.LC66, %edi
	movl	%ebx, %esi
	movl	%edx, %ecx
	repz; cmpsb
	jne	.L184
	movl	$1, do_chroot
	movl	$1, no_symlink_check
.L182:
	addl	$1, %ebp
	cmpl	%ebp, 4(%esp)
	jle	.L177
.L224:
	movl	8(%esp), %eax
	movl	(%eax,%ebp,4), %ebx
	cmpb	$45, (%ebx)
	jne	.L205
.L206:
	movl	%ebx, %esi
	movl	$.LC61, %edi
	movl	%edx, %ecx
	repz; cmpsb
	je	.L222
	movl	$.LC63, %edi
	movl	%ebx, %esi
	movl	%edx, %ecx
	repz; cmpsb
	je	.L223
	movl	$.LC64, %edi
	movl	%ebx, %esi
	movl	%edx, %ecx
	repz; cmpsb
	jne	.L183
	leal	1(%ebp), %esi
	cmpl	%esi, 4(%esp)
	jle	.L181
	movl	%edx, 12(%esp)
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	movl	%esi, %ebp
	movl	20(%esp), %eax
	addl	$1, %ebp
	pushl	(%eax,%esi,4)
	.cfi_def_cfa_offset 64
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movw	%ax, port
	movl	12(%esp), %edx
	cmpl	%ebp, 4(%esp)
	jg	.L224
.L177:
	cmpl	4(%esp), %ebp
	jne	.L205
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
.L183:
	.cfi_restore_state
	movl	$.LC65, %edi
	movl	%ebx, %esi
	movl	%edx, %ecx
	repz; cmpsb
	jne	.L181
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L181
	movl	8(%esp), %ebx
	movl	%eax, %ebp
	movl	(%ebx,%eax,4), %ecx
	movl	%ecx, dir
	jmp	.L182
	.p2align 4,,10
	.p2align 3
.L184:
	movl	$.LC67, %edi
	movl	%ebx, %esi
	movl	$5, %ecx
	repz; cmpsb
	jne	.L185
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L182
	.p2align 4,,10
	.p2align 3
.L221:
	movl	8(%esp), %eax
	movl	%edx, 12(%esp)
	movl	%esi, %ebp
	movl	(%eax,%esi,4), %eax
	call	read_config
	movl	12(%esp), %edx
	jmp	.L182
	.p2align 4,,10
	.p2align 3
.L185:
	movl	$.LC68, %edi
	movl	$4, %ecx
	movl	%ebx, %esi
	repz; cmpsb
	jne	.L186
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L186
	movl	8(%esp), %ebx
	movl	%eax, %ebp
	movl	(%ebx,%eax,4), %ecx
	movl	%ecx, data_dir
	jmp	.L182
	.p2align 4,,10
	.p2align 3
.L186:
	movl	$.LC69, %edi
	movl	%ebx, %esi
	movl	%edx, %ecx
	repz; cmpsb
	jne	.L187
	movl	$0, no_symlink_check
	jmp	.L182
	.p2align 4,,10
	.p2align 3
.L187:
	movl	$.LC70, %edi
	movl	%ebx, %esi
	movl	$5, %ecx
	repz; cmpsb
	je	.L225
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC71
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L189
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jg	.L226
	movl	%edx, 12(%esp)
	pushl	%ecx
	.cfi_def_cfa_offset 52
	pushl	%ecx
	.cfi_def_cfa_offset 56
	pushl	$.LC73
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L193
.L195:
	movl	%edx, 12(%esp)
	pushl	%ecx
	.cfi_def_cfa_offset 52
	pushl	%ecx
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
	jne	.L194
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jg	.L227
.L194:
	movl	%edx, 12(%esp)
	pushl	%edx
	.cfi_def_cfa_offset 52
	pushl	%edx
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
	jne	.L196
	movl	$1, do_vhost
	jmp	.L182
.L225:
	movl	$1, no_symlink_check
	jmp	.L182
.L189:
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
	.cfi_def_cfa_offset 56
	pushl	$.LC72
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L191
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L192
	movl	8(%esp), %ebx
	movl	%eax, %ebp
	movl	(%ebx,%eax,4), %ecx
	movl	%ecx, cgi_pattern
	jmp	.L182
.L191:
	movl	%edx, 12(%esp)
	pushl	%edi
	.cfi_def_cfa_offset 52
	pushl	%edi
	.cfi_def_cfa_offset 56
	pushl	$.LC73
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	movl	12(%esp), %edx
	jne	.L193
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L194
	movl	8(%esp), %ebx
	movl	%eax, %ebp
	movl	(%ebx,%eax,4), %ecx
	movl	%ecx, throttlefile
	jmp	.L182
.L193:
	movl	%edx, 12(%esp)
	pushl	%esi
	.cfi_def_cfa_offset 52
	pushl	%esi
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
	jne	.L195
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L194
	movl	8(%esp), %ebx
	movl	%eax, %ebp
	movl	(%ebx,%eax,4), %ecx
	movl	%ecx, hostname
	jmp	.L182
.L226:
	movl	8(%esp), %ebx
	movl	%eax, %ebp
	movl	(%ebx,%eax,4), %ecx
	movl	%ecx, user
	jmp	.L182
.L192:
	movl	%edx, 12(%esp)
	pushl	%edx
	.cfi_def_cfa_offset 52
	pushl	%edx
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
	je	.L194
	jmp	.L195
.L196:
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
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
	je	.L228
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
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
	jne	.L198
	movl	$1, do_global_passwd
	jmp	.L182
.L227:
	movl	8(%esp), %ebx
	movl	%eax, %ebp
	movl	(%ebx,%eax,4), %ecx
	movl	%ecx, logfile
	jmp	.L182
.L228:
	movl	$0, do_vhost
	jmp	.L182
.L207:
	movl	$1, %ebp
	jmp	.L177
.L198:
	movl	%edx, 12(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 52
	pushl	%eax
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
	jne	.L199
	movl	$0, do_global_passwd
	jmp	.L182
.L222:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 60
	pushl	$.LC62
	.cfi_def_cfa_offset 64
	call	puts
	movl	$0, (%esp)
	call	exit
.L199:
	.cfi_restore_state
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
	jne	.L200
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L201
	movl	8(%esp), %ebx
	movl	%eax, %ebp
	movl	(%ebx,%eax,4), %ecx
	movl	%ecx, pidfile
	jmp	.L182
.L200:
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
	jne	.L202
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L203
	movl	8(%esp), %ebx
	movl	%eax, %ebp
	movl	(%ebx,%eax,4), %ecx
	movl	%ecx, charset
	jmp	.L182
.L202:
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
	jne	.L204
	leal	1(%ebp), %eax
	cmpl	%eax, 4(%esp)
	jle	.L203
	movl	8(%esp), %ebx
	movl	%eax, %ebp
	movl	(%ebx,%eax,4), %ecx
	movl	%ecx, p3p
	jmp	.L182
.L201:
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
	jne	.L204
.L203:
	movl	%edx, 12(%esp)
	pushl	%esi
	.cfi_def_cfa_offset 52
	pushl	%esi
	.cfi_def_cfa_offset 56
	pushl	$.LC84
	.cfi_def_cfa_offset 60
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	strcmp
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	jne	.L205
	movl	$1, debug
	movl	12(%esp), %edx
	jmp	.L182
.L204:
	movl	%edx, 12(%esp)
	pushl	%edi
	.cfi_def_cfa_offset 52
	pushl	%edi
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
	jne	.L203
	leal	1(%ebp), %esi
	cmpl	%esi, 4(%esp)
	jle	.L203
	subl	$12, %esp
	.cfi_def_cfa_offset 60
	movl	%esi, %ebp
	movl	20(%esp), %eax
	pushl	(%eax,%esi,4)
	.cfi_def_cfa_offset 64
	call	atoi
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	%eax, max_age
	movl	12(%esp), %edx
	jmp	.L182
.L205:
	call	usage
	.cfi_endproc
.LFE8:
	.size	parse_args, .-parse_args
	.section	.text.unlikely
.LCOLDE85:
	.text
.LHOTE85:
	.section	.rodata.str1.1
.LC86:
	.string	"%.80s - %m"
.LC87:
	.string	" %4900[^ \t] %ld-%ld"
.LC88:
	.string	" %4900[^ \t] %ld"
	.section	.rodata.str1.4
	.align 4
.LC89:
	.string	"unparsable line in %.80s - %.80s"
	.align 4
.LC90:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.section	.rodata.str1.1
.LC91:
	.string	"|/"
	.section	.rodata.str1.4
	.align 4
.LC92:
	.string	"out of memory allocating a throttletab"
	.align 4
.LC93:
	.string	"%s: out of memory allocating a throttletab\n"
	.section	.text.unlikely
.LCOLDB94:
	.text
.LHOTB94:
	.p2align 4,,15
	.type	read_throttlefile, @function
read_throttlefile:
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
	subl	$10068, %esp
	.cfi_def_cfa_offset 10088
	movl	%gs:20, %esi
	movl	%esi, 10052(%esp)
	xorl	%esi, %esi
	movl	%eax, 20(%esp)
	pushl	$.LC27
	.cfi_def_cfa_offset 10092
	pushl	%eax
	.cfi_def_cfa_offset 10096
	call	fopen
	movl	%eax, 24(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 10080
	testl	%eax, %eax
	je	.L278
	subl	$8, %esp
	.cfi_def_cfa_offset 10088
	pushl	$0
	.cfi_def_cfa_offset 10092
	leal	48(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 10096
	call	gettimeofday
	addl	$16, %esp
	.cfi_def_cfa_offset 10080
	leal	44(%esp), %edi
	leal	28(%esp), %esi
	.p2align 4,,10
	.p2align 3
.L252:
	subl	$4, %esp
	.cfi_def_cfa_offset 10084
	pushl	12(%esp)
	.cfi_def_cfa_offset 10088
	pushl	$5000
	.cfi_def_cfa_offset 10092
	pushl	%edi
	.cfi_def_cfa_offset 10096
	call	fgets
	addl	$16, %esp
	.cfi_def_cfa_offset 10080
	testl	%eax, %eax
	je	.L279
	subl	$8, %esp
	.cfi_def_cfa_offset 10088
	pushl	$35
	.cfi_def_cfa_offset 10092
	pushl	%edi
	.cfi_def_cfa_offset 10096
	call	strchr
	addl	$16, %esp
	.cfi_def_cfa_offset 10080
	testl	%eax, %eax
	je	.L232
	movb	$0, (%eax)
.L232:
	movl	%edi, %eax
.L233:
	movl	(%eax), %ecx
	addl	$4, %eax
	leal	-16843009(%ecx), %edx
	notl	%ecx
	andl	%ecx, %edx
	andl	$-2139062144, %edx
	je	.L233
	movl	%edx, %ecx
	shrl	$16, %ecx
	testl	$32896, %edx
	cmove	%ecx, %edx
	leal	2(%eax), %ecx
	cmove	%ecx, %eax
	addb	%dl, %dl
	sbbl	$3, %eax
	subl	%edi, %eax
	cmpl	$0, %eax
	jle	.L235
	subl	$1, %eax
	movzbl	44(%esp,%eax), %edx
	jmp	.L276
	.p2align 4,,10
	.p2align 3
.L264:
	testl	%eax, %eax
	movb	$0, (%edi,%eax)
	je	.L252
	subl	$1, %eax
	movzbl	(%edi,%eax), %edx
.L276:
	cmpb	$13, %dl
	sete	%bl
	cmpb	$32, %dl
	sete	%cl
	orb	%cl, %bl
	jne	.L264
	subl	$9, %edx
	cmpb	$1, %dl
	jbe	.L264
.L241:
	subl	$12, %esp
	.cfi_def_cfa_offset 10092
	pushl	%esi
	.cfi_def_cfa_offset 10096
	leal	48(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 10100
	leal	5064(%esp), %ebx
	pushl	%ebx
	.cfi_def_cfa_offset 10104
	pushl	$.LC87
	.cfi_def_cfa_offset 10108
	pushl	%edi
	.cfi_def_cfa_offset 10112
	call	__isoc99_sscanf
	addl	$32, %esp
	.cfi_def_cfa_offset 10080
	cmpl	$3, %eax
	je	.L237
	pushl	%esi
	.cfi_def_cfa_offset 10084
	pushl	%ebx
	.cfi_def_cfa_offset 10088
	pushl	$.LC88
	.cfi_def_cfa_offset 10092
	pushl	%edi
	.cfi_def_cfa_offset 10096
	call	__isoc99_sscanf
	addl	$16, %esp
	.cfi_def_cfa_offset 10080
	cmpl	$2, %eax
	jne	.L242
	movl	$0, 32(%esp)
	.p2align 4,,10
	.p2align 3
.L237:
	cmpb	$47, 5044(%esp)
	jne	.L245
	jmp	.L280
	.p2align 4,,10
	.p2align 3
.L246:
	leal	2(%eax), %edx
	subl	$8, %esp
	.cfi_def_cfa_offset 10088
	addl	$1, %eax
	pushl	%edx
	.cfi_def_cfa_offset 10092
	pushl	%eax
	.cfi_def_cfa_offset 10096
	call	strcpy
	addl	$16, %esp
	.cfi_def_cfa_offset 10080
.L245:
	subl	$8, %esp
	.cfi_def_cfa_offset 10088
	pushl	$.LC91
	.cfi_def_cfa_offset 10092
	pushl	%ebx
	.cfi_def_cfa_offset 10096
	call	strstr
	addl	$16, %esp
	.cfi_def_cfa_offset 10080
	testl	%eax, %eax
	jne	.L246
	movl	numthrottles, %edx
	movl	maxthrottles, %eax
	cmpl	%eax, %edx
	jl	.L247
	testl	%eax, %eax
	jne	.L248
	subl	$12, %esp
	.cfi_def_cfa_offset 10092
	movl	$100, maxthrottles
	pushl	$2400
	.cfi_def_cfa_offset 10096
	call	malloc
	addl	$16, %esp
	.cfi_def_cfa_offset 10080
	movl	%eax, throttles
.L249:
	testl	%eax, %eax
	je	.L250
	movl	numthrottles, %edx
.L251:
	leal	(%edx,%edx,2), %edx
	leal	(%eax,%edx,8), %ebp
	movl	%ebx, %eax
	call	e_strdup
	movl	%eax, 0(%ebp)
	movl	numthrottles, %eax
	movl	throttles, %edx
	leal	(%eax,%eax,2), %ecx
	addl	$1, %eax
	movl	%eax, numthrottles
	leal	(%edx,%ecx,8), %edx
	movl	28(%esp), %ecx
	movl	$0, 12(%edx)
	movl	$0, 16(%edx)
	movl	%ecx, 4(%edx)
	movl	32(%esp), %ecx
	movl	$0, 20(%edx)
	movl	%ecx, 8(%edx)
	jmp	.L252
.L235:
	je	.L252
	jmp	.L241
.L242:
	pushl	%edi
	.cfi_def_cfa_offset 10084
	movl	16(%esp), %ebx
	pushl	%ebx
	.cfi_def_cfa_offset 10088
	pushl	$.LC89
	.cfi_def_cfa_offset 10092
	pushl	$2
	.cfi_def_cfa_offset 10096
	call	syslog
	movl	%edi, (%esp)
	pushl	%ebx
	.cfi_def_cfa_offset 10100
	pushl	argv0
	.cfi_def_cfa_offset 10104
	pushl	$.LC90
	.cfi_def_cfa_offset 10108
	pushl	stderr
	.cfi_def_cfa_offset 10112
	call	fprintf
	addl	$32, %esp
	.cfi_def_cfa_offset 10080
	jmp	.L252
.L248:
	leal	(%eax,%eax), %edx
	subl	$8, %esp
	.cfi_def_cfa_offset 10088
	leal	(%edx,%eax,4), %eax
	movl	%edx, maxthrottles
	sall	$3, %eax
	pushl	%eax
	.cfi_def_cfa_offset 10092
	pushl	throttles
	.cfi_def_cfa_offset 10096
	call	realloc
	addl	$16, %esp
	.cfi_def_cfa_offset 10080
	movl	%eax, throttles
	jmp	.L249
.L247:
	movl	throttles, %eax
	jmp	.L251
.L279:
	subl	$12, %esp
	.cfi_def_cfa_offset 10092
	pushl	20(%esp)
	.cfi_def_cfa_offset 10096
	call	fclose
	addl	$16, %esp
	.cfi_def_cfa_offset 10080
	movl	10044(%esp), %eax
	xorl	%gs:20, %eax
	jne	.L281
	addl	$10060, %esp
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
.L280:
	.cfi_restore_state
	pushl	%edx
	.cfi_def_cfa_offset 10084
	pushl	%edx
	.cfi_def_cfa_offset 10088
	leal	5053(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 10092
	pushl	%ebx
	.cfi_def_cfa_offset 10096
	call	strcpy
	addl	$16, %esp
	.cfi_def_cfa_offset 10080
	jmp	.L245
.L278:
	pushl	%ecx
	.cfi_remember_state
	.cfi_def_cfa_offset 10084
	movl	16(%esp), %esi
	pushl	%esi
	.cfi_def_cfa_offset 10088
	pushl	$.LC86
	.cfi_def_cfa_offset 10092
	pushl	$2
	.cfi_def_cfa_offset 10096
	call	syslog
	movl	%esi, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L281:
	.cfi_restore_state
	call	__stack_chk_fail
.L250:
	pushl	%eax
	.cfi_def_cfa_offset 10084
	pushl	%eax
	.cfi_def_cfa_offset 10088
	pushl	$.LC92
	.cfi_def_cfa_offset 10092
	pushl	$2
	.cfi_def_cfa_offset 10096
	call	syslog
	addl	$12, %esp
	.cfi_def_cfa_offset 10084
	pushl	argv0
	.cfi_def_cfa_offset 10088
	pushl	$.LC93
	.cfi_def_cfa_offset 10092
	pushl	stderr
	.cfi_def_cfa_offset 10096
	call	fprintf
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE15:
	.size	read_throttlefile, .-read_throttlefile
	.section	.text.unlikely
.LCOLDE94:
	.text
.LHOTE94:
	.section	.rodata.str1.1
.LC95:
	.string	"-"
.LC96:
	.string	"re-opening logfile"
.LC97:
	.string	"a"
.LC98:
	.string	"re-opening %.80s - %m"
	.section	.text.unlikely
.LCOLDB99:
	.text
.LHOTB99:
	.p2align 4,,15
	.type	re_open_logfile, @function
re_open_logfile:
.LFB6:
	.cfi_startproc
	movl	no_log, %eax
	testl	%eax, %eax
	jne	.L295
	movl	hs, %eax
	testl	%eax, %eax
	je	.L295
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
	je	.L282
	movl	$.LC95, %edi
	movl	$2, %ecx
	repz; cmpsb
	jne	.L296
.L282:
	addl	$4, %esp
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
.L295:
	rep; ret
	.p2align 4,,10
	.p2align 3
.L296:
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -12
	.cfi_offset 7, -8
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	pushl	$.LC96
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	popl	%ecx
	.cfi_def_cfa_offset 28
	popl	%esi
	.cfi_def_cfa_offset 24
	pushl	$.LC97
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
	jne	.L286
	testl	%esi, %esi
	je	.L286
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
	jmp	.L295
	.p2align 4,,10
	.p2align 3
.L286:
	.cfi_restore_state
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	pushl	logfile
	.cfi_def_cfa_offset 24
	pushl	$.LC98
	.cfi_def_cfa_offset 28
	pushl	$2
	.cfi_def_cfa_offset 32
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	jmp	.L282
	.cfi_endproc
.LFE6:
	.size	re_open_logfile, .-re_open_logfile
	.section	.text.unlikely
.LCOLDE99:
	.text
.LHOTE99:
	.section	.rodata.str1.1
.LC100:
	.string	"too many connections!"
	.section	.rodata.str1.4
	.align 4
.LC101:
	.string	"the connects free list is messed up"
	.align 4
.LC102:
	.string	"out of memory allocating an httpd_conn"
	.section	.text.unlikely
.LCOLDB103:
	.text
.LHOTB103:
	.p2align 4,,15
	.type	handle_newconnect, @function
handle_newconnect:
.LFB17:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	movl	%eax, %edi
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	%edx, %esi
	subl	$16, %esp
	.cfi_def_cfa_offset 32
	movl	num_connects, %eax
.L306:
	cmpl	%eax, max_connects
	jle	.L316
	movl	first_free_connect, %ecx
	cmpl	$-1, %ecx
	je	.L300
	leal	(%ecx,%ecx,2), %ebx
	sall	$5, %ebx
	addl	connects, %ebx
	movl	(%ebx), %edx
	testl	%edx, %edx
	jne	.L300
	movl	8(%ebx), %eax
	testl	%eax, %eax
	je	.L317
.L302:
	subl	$4, %esp
	.cfi_def_cfa_offset 36
	pushl	%eax
	.cfi_def_cfa_offset 40
	pushl	%esi
	.cfi_def_cfa_offset 44
	pushl	hs
	.cfi_def_cfa_offset 48
	call	httpd_get_conn
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	je	.L305
	cmpl	$2, %eax
	jne	.L318
	movl	$1, %eax
.L299:
	addl	$16, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popl	%ebx
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
.L318:
	.cfi_restore_state
	movl	4(%ebx), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	movl	$1, (%ebx)
	movl	$-1, 4(%ebx)
	addl	$1, num_connects
	movl	%eax, first_free_connect
	movl	(%edi), %eax
	movl	$0, 72(%ebx)
	movl	$0, 76(%ebx)
	movl	%eax, 68(%ebx)
	movl	8(%ebx), %eax
	movl	$0, 92(%ebx)
	movl	$0, 52(%ebx)
	pushl	448(%eax)
	.cfi_def_cfa_offset 48
	call	httpd_set_ndelay
	addl	$12, %esp
	.cfi_def_cfa_offset 36
	pushl	$0
	.cfi_def_cfa_offset 40
	pushl	%ebx
	.cfi_def_cfa_offset 44
	movl	8(%ebx), %eax
	pushl	448(%eax)
	.cfi_def_cfa_offset 48
	call	fdwatch_add_fd
	addl	$1, stats_connections
	movl	num_connects, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	cmpl	stats_simultaneous, %eax
	jle	.L306
	movl	%eax, stats_simultaneous
	jmp	.L306
	.p2align 4,,10
	.p2align 3
.L305:
	movl	%eax, 12(%esp)
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%edi
	.cfi_def_cfa_offset 48
	call	tmr_run
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	movl	12(%esp), %eax
	addl	$16, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popl	%ebx
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
.L317:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	$456
	.cfi_def_cfa_offset 48
	call	malloc
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	movl	%eax, 8(%ebx)
	je	.L319
	movl	$0, (%eax)
	addl	$1, httpd_conn_count
	jmp	.L302
	.p2align 4,,10
	.p2align 3
.L316:
	subl	$8, %esp
	.cfi_def_cfa_offset 40
	pushl	$.LC100
	.cfi_def_cfa_offset 44
	pushl	$4
	.cfi_def_cfa_offset 48
	call	syslog
	movl	%edi, (%esp)
	call	tmr_run
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	xorl	%eax, %eax
	jmp	.L299
.L300:
	subl	$8, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pushl	$.LC101
	.cfi_def_cfa_offset 44
	pushl	$2
	.cfi_def_cfa_offset 48
	call	syslog
	movl	$1, (%esp)
	call	exit
.L319:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 36
	pushl	%eax
	.cfi_def_cfa_offset 40
	pushl	$.LC102
	.cfi_def_cfa_offset 44
	pushl	$2
	.cfi_def_cfa_offset 48
	call	syslog
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE17:
	.size	handle_newconnect, .-handle_newconnect
	.section	.text.unlikely
.LCOLDE103:
	.text
.LHOTE103:
	.section	.rodata.str1.4
	.align 4
.LC104:
	.string	"throttle sending count was negative - shouldn't happen!"
	.section	.text.unlikely
.LCOLDB105:
	.text
.LHOTB105:
	.p2align 4,,15
	.type	check_throttles, @function
check_throttles:
.LFB21:
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
	movl	%eax, %ebx
	xorl	%edi, %edi
	subl	$28, %esp
	.cfi_def_cfa_offset 48
	movl	$0, 52(%eax)
	movl	$-1, 60(%eax)
	movl	$-1, 56(%eax)
	movl	numthrottles, %eax
	testl	%eax, %eax
	jg	.L335
	jmp	.L329
	.p2align 4,,10
	.p2align 3
.L342:
	leal	1(%edx), %esi
	movl	%esi, 12(%esp)
.L325:
	movl	52(%ebx), %edx
	leal	1(%edx), %esi
	movl	%esi, 52(%ebx)
	movl	%ebp, 12(%ebx,%edx,4)
	movl	12(%esp), %edx
	movl	%edx, 20(%eax)
	movl	8(%esp), %eax
	movl	%edx, %esi
	cltd
	idivl	%esi
	movl	56(%ebx), %edx
	cmpl	$-1, %edx
	je	.L340
	cmpl	%edx, %eax
	cmovg	%edx, %eax
.L340:
	movl	%eax, 56(%ebx)
	movl	60(%ebx), %eax
	cmpl	$-1, %eax
	je	.L341
	cmpl	%eax, %ecx
	cmovl	%eax, %ecx
.L341:
	movl	%ecx, 60(%ebx)
.L323:
	addl	$1, %ebp
	cmpl	%ebp, numthrottles
	jle	.L329
	addl	$24, %edi
	cmpl	$9, 52(%ebx)
	jg	.L329
.L335:
	movl	8(%ebx), %eax
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	188(%eax)
	.cfi_def_cfa_offset 60
	movl	throttles, %eax
	pushl	(%eax,%edi)
	.cfi_def_cfa_offset 64
	call	match
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	testl	%eax, %eax
	je	.L323
	movl	throttles, %eax
	addl	%edi, %eax
	movl	4(%eax), %esi
	movl	12(%eax), %edx
	leal	(%esi,%esi), %ecx
	movl	%esi, 8(%esp)
	cmpl	%ecx, %edx
	jg	.L332
	movl	8(%eax), %ecx
	cmpl	%ecx, %edx
	jl	.L332
	movl	20(%eax), %edx
	testl	%edx, %edx
	jns	.L342
	subl	$8, %esp
	.cfi_def_cfa_offset 56
	pushl	$.LC104
	.cfi_def_cfa_offset 60
	pushl	$3
	.cfi_def_cfa_offset 64
	call	syslog
	movl	throttles, %eax
	addl	%edi, %eax
	movl	4(%eax), %ecx
	movl	$0, 20(%eax)
	movl	%ecx, 24(%esp)
	addl	$16, %esp
	.cfi_def_cfa_offset 48
	movl	8(%eax), %ecx
	movl	$1, 12(%esp)
	jmp	.L325
	.p2align 4,,10
	.p2align 3
.L329:
	addl	$28, %esp
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
.L332:
	.cfi_restore_state
	addl	$28, %esp
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
	.cfi_endproc
.LFE21:
	.size	check_throttles, .-check_throttles
	.section	.text.unlikely
.LCOLDE105:
	.text
.LHOTE105:
	.section	.text.unlikely
.LCOLDB106:
	.text
.LHOTB106:
	.p2align 4,,15
	.type	shut_down, @function
shut_down:
.LFB16:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	xorl	%edi, %edi
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subl	$24, %esp
	.cfi_def_cfa_offset 40
	movl	%gs:20, %eax
	movl	%eax, 20(%esp)
	xorl	%eax, %eax
	pushl	$0
	.cfi_def_cfa_offset 44
	leal	16(%esp), %esi
	pushl	%esi
	.cfi_def_cfa_offset 48
	call	gettimeofday
	movl	%esi, %eax
	call	logstats
	movl	max_connects, %ecx
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%ecx, %ecx
	jg	.L363
	jmp	.L349
	.p2align 4,,10
	.p2align 3
.L347:
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L348
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	httpd_destroy_conn
	addl	connects, %ebx
	popl	%eax
	.cfi_def_cfa_offset 44
	pushl	8(%ebx)
	.cfi_def_cfa_offset 48
	call	free
	subl	$1, httpd_conn_count
	movl	$0, 8(%ebx)
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L348:
	addl	$1, %edi
	cmpl	%edi, max_connects
	jle	.L349
.L363:
	leal	(%edi,%edi,2), %ebx
	movl	connects, %eax
	sall	$5, %ebx
	addl	%ebx, %eax
	movl	(%eax), %edx
	testl	%edx, %edx
	je	.L347
	subl	$8, %esp
	.cfi_def_cfa_offset 40
	pushl	%esi
	.cfi_def_cfa_offset 44
	pushl	8(%eax)
	.cfi_def_cfa_offset 48
	call	httpd_close_conn
	movl	connects, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	addl	%ebx, %eax
	jmp	.L347
	.p2align 4,,10
	.p2align 3
.L349:
	movl	hs, %ebx
	testl	%ebx, %ebx
	je	.L346
	movl	40(%ebx), %eax
	movl	$0, hs
	cmpl	$-1, %eax
	je	.L350
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	fdwatch_del_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L350:
	movl	44(%ebx), %eax
	cmpl	$-1, %eax
	je	.L351
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	fdwatch_del_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L351:
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%ebx
	.cfi_def_cfa_offset 48
	call	httpd_terminate
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L346:
	call	mmc_destroy
	call	tmr_destroy
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	connects
	.cfi_def_cfa_offset 48
	call	free
	movl	throttles, %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	je	.L343
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	free
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L343:
	movl	12(%esp), %eax
	xorl	%gs:20, %eax
	jne	.L370
	addl	$16, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
.L370:
	.cfi_restore_state
	call	__stack_chk_fail
	.cfi_endproc
.LFE16:
	.size	shut_down, .-shut_down
	.section	.text.unlikely
.LCOLDE106:
	.text
.LHOTE106:
	.section	.rodata.str1.1
.LC107:
	.string	"exiting"
	.section	.text.unlikely
.LCOLDB108:
	.text
.LHOTB108:
	.p2align 4,,15
	.type	handle_usr1, @function
handle_usr1:
.LFB3:
	.cfi_startproc
	movl	num_connects, %edx
	testl	%edx, %edx
	je	.L374
	movl	$1, got_usr1
	ret
.L374:
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	call	shut_down
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	%eax
	.cfi_def_cfa_offset 24
	pushl	$.LC107
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	call	closelog
	movl	$0, (%esp)
	call	exit
	.cfi_endproc
.LFE3:
	.size	handle_usr1, .-handle_usr1
	.section	.text.unlikely
.LCOLDE108:
	.text
.LHOTE108:
	.section	.rodata.str1.1
.LC109:
	.string	"exiting due to signal %d"
	.section	.text.unlikely
.LCOLDB110:
	.text
.LHOTB110:
	.p2align 4,,15
	.type	handle_term, @function
handle_term:
.LFB0:
	.cfi_startproc
	subl	$12, %esp
	.cfi_def_cfa_offset 16
	call	shut_down
	subl	$4, %esp
	.cfi_def_cfa_offset 20
	pushl	20(%esp)
	.cfi_def_cfa_offset 24
	pushl	$.LC109
	.cfi_def_cfa_offset 28
	pushl	$5
	.cfi_def_cfa_offset 32
	call	syslog
	call	closelog
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE0:
	.size	handle_term, .-handle_term
	.section	.text.unlikely
.LCOLDE110:
	.text
.LHOTE110:
	.section	.text.unlikely
.LCOLDB111:
	.text
.LHOTB111:
	.p2align 4,,15
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LFB34:
	.cfi_startproc
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	movl	52(%eax), %ebx
	testl	%ebx, %ebx
	jle	.L377
	movl	throttles, %ecx
	leal	12(%eax), %edx
	leal	12(%eax,%ebx,4), %ebx
	.p2align 4,,10
	.p2align 3
.L379:
	movl	(%edx), %eax
	addl	$4, %edx
	leal	(%eax,%eax,2), %eax
	subl	$1, 20(%ecx,%eax,8)
	cmpl	%ebx, %edx
	jne	.L379
.L377:
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE34:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.section	.text.unlikely
.LCOLDE111:
	.text
.LHOTE111:
	.section	.text.unlikely
.LCOLDB112:
	.text
.LHOTB112:
	.p2align 4,,15
	.type	really_clear_connection, @function
really_clear_connection:
.LFB26:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	movl	%eax, %ebx
	movl	%edx, %esi
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	movl	8(%eax), %eax
	movl	168(%eax), %edx
	addl	%edx, stats_bytes
	cmpl	$3, (%ebx)
	je	.L384
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	448(%eax)
	.cfi_def_cfa_offset 32
	call	fdwatch_del_fd
	movl	8(%ebx), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 16
.L384:
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	pushl	%esi
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	httpd_close_conn
	movl	%ebx, %eax
	call	clear_throttles.isra.0
	movl	76(%ebx), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	testl	%eax, %eax
	je	.L385
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	tmr_cancel
	movl	$0, 76(%ebx)
	addl	$16, %esp
	.cfi_def_cfa_offset 16
.L385:
	movl	first_free_connect, %eax
	movl	$0, (%ebx)
	subl	$1, num_connects
	movl	%eax, 4(%ebx)
	subl	connects, %ebx
	sarl	$5, %ebx
	imull	$-1431655765, %ebx, %ebx
	movl	%ebx, first_free_connect
	addl	$4, %esp
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE26:
	.size	really_clear_connection, .-really_clear_connection
	.section	.text.unlikely
.LCOLDE112:
	.text
.LHOTE112:
	.section	.rodata.str1.4
	.align 4
.LC113:
	.string	"replacing non-null linger_timer!"
	.align 4
.LC114:
	.string	"tmr_create(linger_clear_connection) failed"
	.section	.text.unlikely
.LCOLDB115:
	.text
.LHOTB115:
	.p2align 4,,15
	.type	clear_connection, @function
clear_connection:
.LFB25:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	movl	%eax, %ebx
	movl	%edx, %esi
	subl	$4, %esp
	.cfi_def_cfa_offset 16
	movl	72(%eax), %eax
	testl	%eax, %eax
	je	.L391
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	%eax
	.cfi_def_cfa_offset 32
	call	tmr_cancel
	movl	$0, 72(%ebx)
	addl	$16, %esp
	.cfi_def_cfa_offset 16
.L391:
	cmpl	$4, (%ebx)
	je	.L392
	movl	8(%ebx), %eax
	movl	356(%eax), %ecx
	testl	%ecx, %ecx
	je	.L394
	cmpl	$3, (%ebx)
	je	.L395
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	448(%eax)
	.cfi_def_cfa_offset 32
	call	fdwatch_del_fd
	movl	8(%ebx), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 16
.L395:
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	movl	$4, (%ebx)
	pushl	$1
	.cfi_def_cfa_offset 28
	pushl	448(%eax)
	.cfi_def_cfa_offset 32
	call	shutdown
	movl	8(%ebx), %eax
	addl	$12, %esp
	.cfi_def_cfa_offset 20
	pushl	$0
	.cfi_def_cfa_offset 24
	pushl	%ebx
	.cfi_def_cfa_offset 28
	pushl	448(%eax)
	.cfi_def_cfa_offset 32
	call	fdwatch_add_fd
	movl	76(%ebx), %edx
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	testl	%edx, %edx
	je	.L396
	subl	$8, %esp
	.cfi_def_cfa_offset 24
	pushl	$.LC113
	.cfi_def_cfa_offset 28
	pushl	$3
	.cfi_def_cfa_offset 32
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 16
.L396:
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	$0
	.cfi_def_cfa_offset 32
	pushl	$500
	.cfi_def_cfa_offset 36
	pushl	%ebx
	.cfi_def_cfa_offset 40
	pushl	$linger_clear_connection
	.cfi_def_cfa_offset 44
	pushl	%esi
	.cfi_def_cfa_offset 48
	call	tmr_create
	addl	$32, %esp
	.cfi_def_cfa_offset 16
	testl	%eax, %eax
	movl	%eax, 76(%ebx)
	je	.L402
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
	.p2align 4,,10
	.p2align 3
.L392:
	.cfi_restore_state
	subl	$12, %esp
	.cfi_def_cfa_offset 28
	pushl	76(%ebx)
	.cfi_def_cfa_offset 32
	call	tmr_cancel
	movl	8(%ebx), %eax
	movl	$0, 76(%ebx)
	addl	$16, %esp
	.cfi_def_cfa_offset 16
	movl	$0, 356(%eax)
.L394:
	addl	$4, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 12
	movl	%esi, %edx
	movl	%ebx, %eax
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	jmp	really_clear_connection
.L402:
	.cfi_restore_state
	pushl	%eax
	.cfi_def_cfa_offset 20
	pushl	%eax
	.cfi_def_cfa_offset 24
	pushl	$.LC114
	.cfi_def_cfa_offset 28
	pushl	$2
	.cfi_def_cfa_offset 32
	call	syslog
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE25:
	.size	clear_connection, .-clear_connection
	.section	.text.unlikely
.LCOLDE115:
	.text
.LHOTE115:
	.section	.text.unlikely
.LCOLDB116:
	.text
.LHOTB116:
	.p2align 4,,15
	.type	finish_connection, @function
finish_connection:
.LFB24:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	movl	%edx, %esi
	movl	%eax, %ebx
	subl	$16, %esp
	.cfi_def_cfa_offset 28
	pushl	8(%eax)
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
	.cfi_endproc
.LFE24:
	.size	finish_connection, .-finish_connection
	.section	.text.unlikely
.LCOLDE116:
	.text
.LHOTE116:
	.section	.text.unlikely
.LCOLDB117:
	.text
.LHOTB117:
	.p2align 4,,15
	.type	handle_read, @function
handle_read:
.LFB18:
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
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %esi
	subl	$12, %esp
	.cfi_def_cfa_offset 32
	movl	8(%eax), %ebx
	movl	144(%ebx), %eax
	movl	140(%ebx), %ecx
	cmpl	%ecx, %eax
	jb	.L406
	cmpl	$5000, %ecx
	jbe	.L434
.L433:
	subl	$8, %esp
	.cfi_def_cfa_offset 40
	pushl	$.LC60
	.cfi_def_cfa_offset 44
	pushl	httpd_err400form
	.cfi_def_cfa_offset 48
	pushl	$.LC60
	.cfi_def_cfa_offset 52
	pushl	httpd_err400title
	.cfi_def_cfa_offset 56
	pushl	$400
	.cfi_def_cfa_offset 60
.L432:
	pushl	%ebx
	.cfi_def_cfa_offset 64
	call	httpd_send_err
	movl	%edi, %edx
	movl	%esi, %eax
	addl	$44, %esp
	.cfi_def_cfa_offset 20
.L429:
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
.L434:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -20
	.cfi_offset 5, -8
	.cfi_offset 6, -16
	.cfi_offset 7, -12
	leal	140(%ebx), %eax
	subl	$4, %esp
	.cfi_def_cfa_offset 36
	addl	$1000, %ecx
	pushl	%ecx
	.cfi_def_cfa_offset 40
	pushl	%eax
	.cfi_def_cfa_offset 44
	leal	136(%ebx), %eax
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	httpd_realloc_str
	movl	140(%ebx), %ecx
	movl	144(%ebx), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 32
.L406:
	subl	$4, %esp
	.cfi_def_cfa_offset 36
	subl	%eax, %ecx
	pushl	%ecx
	.cfi_def_cfa_offset 40
	addl	136(%ebx), %eax
	pushl	%eax
	.cfi_def_cfa_offset 44
	pushl	448(%ebx)
	.cfi_def_cfa_offset 48
	call	read
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	je	.L433
	js	.L435
	addl	%eax, 144(%ebx)
	movl	(%edi), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%ebx
	.cfi_def_cfa_offset 48
	movl	%eax, 68(%esi)
	call	httpd_got_request
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	je	.L405
	cmpl	$2, %eax
	je	.L433
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	%ebx
	.cfi_def_cfa_offset 48
	call	httpd_parse_request
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	js	.L430
	movl	%esi, %eax
	call	check_throttles
	testl	%eax, %eax
	je	.L436
	subl	$8, %esp
	.cfi_def_cfa_offset 40
	pushl	%edi
	.cfi_def_cfa_offset 44
	pushl	%ebx
	.cfi_def_cfa_offset 48
	call	httpd_start_request
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	testl	%eax, %eax
	js	.L430
	movl	336(%ebx), %edx
	testl	%edx, %edx
	je	.L416
	movl	344(%ebx), %eax
	movl	%eax, 92(%esi)
	movl	348(%ebx), %eax
	addl	$1, %eax
	movl	%eax, 88(%esi)
.L417:
	movl	452(%ebx), %eax
	testl	%eax, %eax
	je	.L437
	movl	88(%esi), %eax
	cmpl	%eax, 92(%esi)
	jl	.L438
.L430:
	movl	%edi, %edx
	movl	%esi, %eax
	addl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 20
	jmp	.L429
.L438:
	.cfi_restore_state
	movl	(%edi), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	pushl	448(%ebx)
	.cfi_def_cfa_offset 48
	movl	$2, (%esi)
	movl	$0, 80(%esi)
	movl	%eax, 64(%esi)
	call	fdwatch_del_fd
	addl	$12, %esp
	.cfi_def_cfa_offset 36
	pushl	$1
	.cfi_def_cfa_offset 40
	pushl	%esi
	.cfi_def_cfa_offset 44
	pushl	448(%ebx)
	.cfi_def_cfa_offset 48
	call	fdwatch_add_fd
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	.p2align 4,,10
	.p2align 3
.L405:
	addl	$12, %esp
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
.L435:
	.cfi_restore_state
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L405
	cmpl	$4, %eax
	jne	.L433
	jmp	.L405
	.p2align 4,,10
	.p2align 3
.L436:
	subl	$8, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pushl	172(%ebx)
	.cfi_def_cfa_offset 44
	pushl	httpd_err503form
	.cfi_def_cfa_offset 48
	pushl	$.LC60
	.cfi_def_cfa_offset 52
	pushl	httpd_err503title
	.cfi_def_cfa_offset 56
	pushl	$503
	.cfi_def_cfa_offset 60
	jmp	.L432
	.p2align 4,,10
	.p2align 3
.L416:
	.cfi_restore_state
	movl	164(%ebx), %eax
	movl	$0, %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	movl	%eax, 88(%esi)
	jmp	.L417
.L437:
	movl	52(%esi), %edx
	testl	%edx, %edx
	jle	.L439
	movl	throttles, %ecx
	movl	168(%ebx), %ebx
	leal	12(%esi), %eax
	leal	12(%esi,%edx,4), %ebp
	.p2align 4,,10
	.p2align 3
.L422:
	movl	(%eax), %edx
	addl	$4, %eax
	leal	(%edx,%edx,2), %edx
	addl	%ebx, 16(%ecx,%edx,8)
	cmpl	%ebp, %eax
	jne	.L422
.L421:
	movl	%ebx, 92(%esi)
	jmp	.L430
.L439:
	movl	168(%ebx), %ebx
	jmp	.L421
	.cfi_endproc
.LFE18:
	.size	handle_read, .-handle_read
	.section	.text.unlikely
.LCOLDE117:
	.text
.LHOTE117:
	.section	.rodata.str1.4
	.align 4
.LC118:
	.string	"%.80s connection timed out reading"
	.align 4
.LC119:
	.string	"%.80s connection timed out sending"
	.section	.text.unlikely
.LCOLDB120:
	.text
.LHOTB120:
	.p2align 4,,15
	.type	idle, @function
idle:
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
	subl	$12, %esp
	.cfi_def_cfa_offset 32
	movl	max_connects, %ecx
	movl	36(%esp), %ebp
	testl	%ecx, %ecx
	jg	.L447
	jmp	.L440
	.p2align 4,,10
	.p2align 3
.L452:
	jl	.L442
	cmpl	$3, %eax
	jg	.L442
	movl	0(%ebp), %eax
	subl	68(%ebx), %eax
	cmpl	$299, %eax
	jg	.L451
.L442:
	addl	$1, %edi
	addl	$96, %esi
	cmpl	%edi, max_connects
	jle	.L440
.L447:
	movl	connects, %ebx
	addl	%esi, %ebx
	movl	(%ebx), %eax
	cmpl	$1, %eax
	jne	.L452
	movl	0(%ebp), %eax
	subl	68(%ebx), %eax
	cmpl	$59, %eax
	jle	.L442
	movl	8(%ebx), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	addl	$1, %edi
	addl	$96, %esi
	addl	$8, %eax
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	httpd_ntoa
	addl	$12, %esp
	.cfi_def_cfa_offset 36
	pushl	%eax
	.cfi_def_cfa_offset 40
	pushl	$.LC118
	.cfi_def_cfa_offset 44
	pushl	$6
	.cfi_def_cfa_offset 48
	call	syslog
	popl	%eax
	.cfi_def_cfa_offset 44
	popl	%edx
	.cfi_def_cfa_offset 40
	pushl	$.LC60
	.cfi_def_cfa_offset 44
	pushl	httpd_err408form
	.cfi_def_cfa_offset 48
	pushl	$.LC60
	.cfi_def_cfa_offset 52
	pushl	httpd_err408title
	.cfi_def_cfa_offset 56
	pushl	$408
	.cfi_def_cfa_offset 60
	pushl	8(%ebx)
	.cfi_def_cfa_offset 64
	call	httpd_send_err
	addl	$32, %esp
	.cfi_def_cfa_offset 32
	movl	%ebp, %edx
	movl	%ebx, %eax
	call	finish_connection
	cmpl	%edi, max_connects
	jg	.L447
	.p2align 4,,10
	.p2align 3
.L440:
	addl	$12, %esp
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
.L451:
	.cfi_restore_state
	movl	8(%ebx), %eax
	subl	$12, %esp
	.cfi_def_cfa_offset 44
	addl	$8, %eax
	pushl	%eax
	.cfi_def_cfa_offset 48
	call	httpd_ntoa
	addl	$12, %esp
	.cfi_def_cfa_offset 36
	pushl	%eax
	.cfi_def_cfa_offset 40
	pushl	$.LC119
	.cfi_def_cfa_offset 44
	pushl	$6
	.cfi_def_cfa_offset 48
	call	syslog
	movl	%ebp, %edx
	movl	%ebx, %eax
	call	clear_connection
	addl	$16, %esp
	.cfi_def_cfa_offset 32
	jmp	.L442
	.cfi_endproc
.LFE27:
	.size	idle, .-idle
	.section	.text.unlikely
.LCOLDE120:
	.text
.LHOTE120:
	.section	.rodata.str1.4
	.align 4
.LC121:
	.string	"replacing non-null wakeup_timer!"
	.align 4
.LC122:
	.string	"tmr_create(wakeup_connection) failed"
	.section	.rodata.str1.1
.LC123:
	.string	"write - %m sending %.80s"
	.section	.text.unlikely
.LCOLDB124:
	.text
.LHOTB124:
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LFB19:
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
	subl	$60, %esp
	.cfi_def_cfa_offset 80
	movl	8(%ebx), %edi
	movl	%edx, 4(%esp)
	movl	56(%ebx), %edx
	movl	%gs:20, %eax
	movl	%eax, 44(%esp)
	xorl	%eax, %eax
	movl	$1000000000, %eax
	cmpl	$-1, %edx
	je	.L454
	leal	3(%edx), %eax
	testl	%edx, %edx
	cmovns	%edx, %eax
	sarl	$2, %eax
.L454:
	movl	304(%edi), %edx
	testl	%edx, %edx
	jne	.L455
	movl	92(%ebx), %ecx
	movl	88(%ebx), %edx
	subl	$4, %esp
	.cfi_def_cfa_offset 84
	subl	%ecx, %edx
	cmpl	%edx, %eax
	cmova	%edx, %eax
	addl	452(%edi), %ecx
	pushl	%eax
	.cfi_def_cfa_offset 88
	pushl	%ecx
	.cfi_def_cfa_offset 92
	pushl	448(%edi)
	.cfi_def_cfa_offset 96
	call	write
	addl	$16, %esp
	.cfi_def_cfa_offset 80
	testl	%eax, %eax
	js	.L512
.L457:
	je	.L460
	movl	4(%esp), %esi
	movl	(%esi), %edx
	movl	%edx, 68(%ebx)
	movl	304(%edi), %edx
	testl	%edx, %edx
	je	.L466
	cmpl	%eax, %edx
	ja	.L513
	subl	%edx, %eax
	movl	$0, 304(%edi)
.L466:
	movl	92(%ebx), %esi
	movl	8(%ebx), %edx
	movl	52(%ebx), %ecx
	addl	%eax, %esi
	movl	%esi, 92(%ebx)
	movl	%esi, 8(%esp)
	movl	168(%edx), %esi
	addl	%eax, %esi
	testl	%ecx, %ecx
	movl	%esi, 12(%esp)
	movl	%esi, 168(%edx)
	jle	.L472
	movl	throttles, %esi
	leal	12(%ebx), %edx
	leal	12(%ebx,%ecx,4), %ebp
	.p2align 4,,10
	.p2align 3
.L471:
	movl	(%edx), %ecx
	addl	$4, %edx
	leal	(%ecx,%ecx,2), %ecx
	addl	%eax, 16(%esi,%ecx,8)
	cmpl	%ebp, %edx
	jne	.L471
.L472:
	movl	8(%esp), %eax
	cmpl	88(%ebx), %eax
	jge	.L514
	movl	80(%ebx), %eax
	cmpl	$100, %eax
	jg	.L515
.L473:
	movl	56(%ebx), %ecx
	cmpl	$-1, %ecx
	je	.L453
	movl	4(%esp), %eax
	movl	(%eax), %esi
	subl	64(%ebx), %esi
	movl	$1, %eax
	cmove	%eax, %esi
	movl	12(%esp), %eax
	cltd
	idivl	%esi
	cmpl	%eax, %ecx
	jge	.L453
	subl	$12, %esp
	.cfi_def_cfa_offset 92
	pushl	448(%edi)
	.cfi_def_cfa_offset 96
	movl	$3, (%ebx)
	call	fdwatch_del_fd
	movl	8(%ebx), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 80
	movl	168(%eax), %eax
	cltd
	idivl	56(%ebx)
	subl	%esi, %eax
	movl	%eax, %esi
	movl	72(%ebx), %eax
	testl	%eax, %eax
	je	.L476
	subl	$8, %esp
	.cfi_def_cfa_offset 88
	pushl	$.LC121
	.cfi_def_cfa_offset 92
	pushl	$3
	.cfi_def_cfa_offset 96
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 80
.L476:
	imull	$1000, %esi, %edx
	movl	$500, %eax
	testl	%esi, %esi
	cmovg	%edx, %eax
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 92
	pushl	$0
	.cfi_def_cfa_offset 96
	pushl	%eax
	.cfi_def_cfa_offset 100
	jmp	.L510
	.p2align 4,,10
	.p2align 3
.L455:
	.cfi_restore_state
	movl	252(%edi), %ecx
	movl	%edx, 32(%esp)
	movl	88(%ebx), %esi
	movl	92(%ebx), %edx
	movl	%ecx, 28(%esp)
	movl	452(%edi), %ecx
	subl	%edx, %esi
	addl	%edx, %ecx
	cmpl	%esi, %eax
	cmova	%esi, %eax
	movl	%ecx, 36(%esp)
	subl	$4, %esp
	.cfi_def_cfa_offset 84
	movl	%eax, 44(%esp)
	pushl	$2
	.cfi_def_cfa_offset 88
	leal	36(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 92
	pushl	448(%edi)
	.cfi_def_cfa_offset 96
	call	writev
	addl	$16, %esp
	.cfi_def_cfa_offset 80
	testl	%eax, %eax
	jns	.L457
.L512:
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L453
	cmpl	$11, %eax
	je	.L460
	cmpl	$22, %eax
	setne	%cl
	cmpl	$32, %eax
	setne	%dl
	testb	%dl, %cl
	je	.L464
	cmpl	$104, %eax
	je	.L464
	subl	$4, %esp
	.cfi_def_cfa_offset 84
	pushl	172(%edi)
	.cfi_def_cfa_offset 88
	pushl	$.LC123
	.cfi_def_cfa_offset 92
	pushl	$3
	.cfi_def_cfa_offset 96
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 80
.L464:
	movl	4(%esp), %edx
	movl	%ebx, %eax
	call	clear_connection
	jmp	.L453
	.p2align 4,,10
	.p2align 3
.L460:
	addl	$100, 80(%ebx)
	subl	$12, %esp
	.cfi_def_cfa_offset 92
	pushl	448(%edi)
	.cfi_def_cfa_offset 96
	movl	$3, (%ebx)
	call	fdwatch_del_fd
	movl	72(%ebx), %ecx
	addl	$16, %esp
	.cfi_def_cfa_offset 80
	testl	%ecx, %ecx
	je	.L463
	subl	$8, %esp
	.cfi_def_cfa_offset 88
	pushl	$.LC121
	.cfi_def_cfa_offset 92
	pushl	$3
	.cfi_def_cfa_offset 96
	call	syslog
	addl	$16, %esp
	.cfi_def_cfa_offset 80
.L463:
	subl	$12, %esp
	.cfi_def_cfa_offset 92
	pushl	$0
	.cfi_def_cfa_offset 96
	pushl	80(%ebx)
	.cfi_def_cfa_offset 100
.L510:
	pushl	%ebx
	.cfi_def_cfa_offset 104
	pushl	$wakeup_connection
	.cfi_def_cfa_offset 108
	pushl	32(%esp)
	.cfi_def_cfa_offset 112
	call	tmr_create
	addl	$32, %esp
	.cfi_def_cfa_offset 80
	testl	%eax, %eax
	movl	%eax, 72(%ebx)
	je	.L516
.L453:
	movl	44(%esp), %eax
	xorl	%gs:20, %eax
	jne	.L517
	addl	$60, %esp
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
.L515:
	.cfi_restore_state
	subl	$100, %eax
	movl	%eax, 80(%ebx)
	jmp	.L473
	.p2align 4,,10
	.p2align 3
.L513:
	movl	%edx, %esi
	movl	252(%edi), %edx
	subl	$4, %esp
	.cfi_def_cfa_offset 84
	subl	%eax, %esi
	pushl	%esi
	.cfi_def_cfa_offset 88
	addl	%edx, %eax
	pushl	%eax
	.cfi_def_cfa_offset 92
	pushl	%edx
	.cfi_def_cfa_offset 96
	call	memmove
	movl	%esi, 304(%edi)
	addl	$16, %esp
	.cfi_def_cfa_offset 80
	xorl	%eax, %eax
	jmp	.L466
	.p2align 4,,10
	.p2align 3
.L514:
	movl	4(%esp), %edx
	movl	%ebx, %eax
	call	finish_connection
	jmp	.L453
.L517:
	call	__stack_chk_fail
.L516:
	pushl	%edx
	.cfi_def_cfa_offset 84
	pushl	%edx
	.cfi_def_cfa_offset 88
	pushl	$.LC122
	.cfi_def_cfa_offset 92
	pushl	$2
	.cfi_def_cfa_offset 96
	call	syslog
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE19:
	.size	handle_send, .-handle_send
	.section	.text.unlikely
.LCOLDE124:
	.text
.LHOTE124:
	.section	.text.unlikely
.LCOLDB125:
	.text
.LHOTB125:
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LFB29:
	.cfi_startproc
	movl	4(%esp), %eax
	movl	8(%esp), %edx
	movl	$0, 76(%eax)
	jmp	really_clear_connection
	.cfi_endproc
.LFE29:
	.size	linger_clear_connection, .-linger_clear_connection
	.section	.text.unlikely
.LCOLDE125:
	.text
.LHOTE125:
	.section	.text.unlikely
.LCOLDB126:
	.text
.LHOTB126:
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LFB20:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	movl	%eax, %ebx
	movl	%edx, %esi
	subl	$4120, %esp
	.cfi_def_cfa_offset 4132
	movl	%gs:20, %eax
	movl	%eax, 4112(%esp)
	xorl	%eax, %eax
	pushl	$4096
	.cfi_def_cfa_offset 4136
	leal	20(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 4140
	movl	8(%ebx), %eax
	pushl	448(%eax)
	.cfi_def_cfa_offset 4144
	call	read
	addl	$16, %esp
	.cfi_def_cfa_offset 4128
	testl	%eax, %eax
	js	.L527
	je	.L522
.L519:
	movl	4108(%esp), %eax
	xorl	%gs:20, %eax
	jne	.L528
	addl	$4116, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
.L527:
	.cfi_restore_state
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L519
	cmpl	$4, %eax
	je	.L519
.L522:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	really_clear_connection
	jmp	.L519
.L528:
	call	__stack_chk_fail
	.cfi_endproc
.LFE20:
	.size	handle_linger, .-handle_linger
	.section	.text.unlikely
.LCOLDE126:
	.text
.LHOTE126:
	.section	.rodata.str1.1
.LC127:
	.string	"%d"
.LC128:
	.string	"getaddrinfo %.80s - %.80s"
.LC129:
	.string	"%s: getaddrinfo %s - %s\n"
	.section	.rodata.str1.4
	.align 4
.LC130:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.section	.text.unlikely
.LCOLDB131:
	.text
.LHOTB131:
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LFB35:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	pushl	%edi
	.cfi_def_cfa_offset 12
	.cfi_offset 7, -12
	movl	%ecx, %ebp
	pushl	%esi
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushl	%ebx
	.cfi_def_cfa_offset 20
	.cfi_offset 3, -20
	movl	%eax, %esi
	subl	$92, %esp
	.cfi_def_cfa_offset 112
	movl	112(%esp), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 12(%esp)
	movl	%gs:20, %eax
	movl	%eax, 76(%esp)
	xorl	%eax, %eax
.L530:
	movl	$0, 32(%esp,%eax)
	addl	$4, %eax
	cmpl	$32, %eax
	jb	.L530
	movzwl	port, %eax
	movl	$1, 32(%esp)
	movl	$1, 40(%esp)
	pushl	%eax
	.cfi_def_cfa_offset 116
	pushl	$.LC127
	.cfi_def_cfa_offset 120
	pushl	$10
	.cfi_def_cfa_offset 124
	leal	78(%esp), %ebx
	pushl	%ebx
	.cfi_def_cfa_offset 128
	call	snprintf
	leal	44(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 132
	leal	52(%esp), %eax
	pushl	%eax
	.cfi_def_cfa_offset 136
	pushl	%ebx
	.cfi_def_cfa_offset 140
	pushl	hostname
	.cfi_def_cfa_offset 144
	call	getaddrinfo
	addl	$32, %esp
	.cfi_def_cfa_offset 112
	testl	%eax, %eax
	movl	%eax, %ebx
	jne	.L552
	movl	28(%esp), %eax
	testl	%eax, %eax
	je	.L533
	xorl	%ebx, %ebx
	xorl	%edx, %edx
	jmp	.L537
	.p2align 4,,10
	.p2align 3
.L554:
	cmpl	$10, %ecx
	jne	.L534
	testl	%edx, %edx
	cmove	%eax, %edx
.L534:
	movl	28(%eax), %eax
	testl	%eax, %eax
	je	.L553
.L537:
	movl	4(%eax), %ecx
	cmpl	$2, %ecx
	jne	.L554
	testl	%ebx, %ebx
	cmove	%eax, %ebx
	movl	28(%eax), %eax
	testl	%eax, %eax
	jne	.L537
.L553:
	testl	%edx, %edx
	je	.L555
	movl	16(%edx), %ecx
	cmpl	$128, %ecx
	ja	.L556
	leal	4(%ebp), %edi
	movl	%ebp, %ecx
	movl	$0, 0(%ebp)
	movl	$0, 124(%ebp)
	subl	$4, %esp
	.cfi_def_cfa_offset 116
	andl	$-4, %edi
	subl	%edi, %ecx
	subl	$-128, %ecx
	shrl	$2, %ecx
	rep; stosl
	pushl	16(%edx)
	.cfi_def_cfa_offset 120
	pushl	20(%edx)
	.cfi_def_cfa_offset 124
	pushl	%ebp
	.cfi_def_cfa_offset 128
	call	memmove
	movl	28(%esp), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 112
	movl	$1, (%eax)
.L539:
	testl	%ebx, %ebx
	je	.L557
	movl	16(%ebx), %eax
	cmpl	$128, %eax
	ja	.L558
	leal	4(%esi), %edi
	movl	%esi, %ecx
	xorl	%eax, %eax
	movl	$0, (%esi)
	movl	$0, 124(%esi)
	subl	$4, %esp
	.cfi_def_cfa_offset 116
	andl	$-4, %edi
	subl	%edi, %ecx
	subl	$-128, %ecx
	shrl	$2, %ecx
	rep; stosl
	pushl	16(%ebx)
	.cfi_def_cfa_offset 120
	pushl	20(%ebx)
	.cfi_def_cfa_offset 124
	pushl	%esi
	.cfi_def_cfa_offset 128
	call	memmove
	movl	24(%esp), %eax
	addl	$16, %esp
	.cfi_def_cfa_offset 112
	movl	$1, (%eax)
.L542:
	subl	$12, %esp
	.cfi_def_cfa_offset 124
	pushl	40(%esp)
	.cfi_def_cfa_offset 128
	call	freeaddrinfo
	addl	$16, %esp
	.cfi_def_cfa_offset 112
	movl	76(%esp), %eax
	xorl	%gs:20, %eax
	jne	.L559
	addl	$92, %esp
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
.L555:
	.cfi_restore_state
	movl	%ebx, %eax
.L533:
	movl	12(%esp), %edi
	movl	%eax, %ebx
	movl	$0, (%edi)
	jmp	.L539
.L557:
	movl	8(%esp), %eax
	movl	$0, (%eax)
	jmp	.L542
.L552:
	subl	$12, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 124
	pushl	%eax
	.cfi_def_cfa_offset 128
	call	gai_strerror
	pushl	%eax
	.cfi_def_cfa_offset 132
	pushl	hostname
	.cfi_def_cfa_offset 136
	pushl	$.LC128
	.cfi_def_cfa_offset 140
	pushl	$2
	.cfi_def_cfa_offset 144
	call	syslog
	addl	$20, %esp
	.cfi_def_cfa_offset 124
	pushl	%ebx
	.cfi_def_cfa_offset 128
	call	gai_strerror
	movl	%eax, (%esp)
	pushl	hostname
	.cfi_def_cfa_offset 132
	pushl	argv0
	.cfi_def_cfa_offset 136
	pushl	$.LC129
	.cfi_def_cfa_offset 140
	pushl	stderr
	.cfi_def_cfa_offset 144
	call	fprintf
	addl	$20, %esp
	.cfi_def_cfa_offset 124
	pushl	$1
	.cfi_def_cfa_offset 128
	call	exit
.L559:
	.cfi_restore_state
	call	__stack_chk_fail
.L558:
	subl	$12, %esp
	.cfi_def_cfa_offset 124
	pushl	%eax
	.cfi_def_cfa_offset 128
.L551:
	pushl	$128
	.cfi_def_cfa_offset 132
	pushl	hostname
	.cfi_def_cfa_offset 136
	pushl	$.LC130
	.cfi_def_cfa_offset 140
	pushl	$2
	.cfi_def_cfa_offset 144
	call	syslog
	addl	$20, %esp
	.cfi_def_cfa_offset 124
	pushl	$1
	.cfi_def_cfa_offset 128
	call	exit
.L556:
	.cfi_def_cfa_offset 112
	subl	$12, %esp
	.cfi_def_cfa_offset 124
	pushl	%ecx
	.cfi_def_cfa_offset 128
	jmp	.L551
	.cfi_endproc
.LFE35:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.text.unlikely
.LCOLDE131:
	.text
.LHOTE131:
	.section	.rodata.str1.1
.LC132:
	.string	"can't find any valid address"
	.section	.rodata.str1.4
	.align 4
.LC133:
	.string	"%s: can't find any valid address\n"
	.section	.rodata.str1.1
.LC134:
	.string	"unknown user - '%.80s'"
.LC135:
	.string	"%s: unknown user - '%s'\n"
.LC136:
	.string	"/dev/null"
	.section	.rodata.str1.4
	.align 4
.LC137:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.align 4
.LC138:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.section	.rodata.str1.1
.LC139:
	.string	"fchown logfile - %m"
.LC140:
	.string	"fchown logfile"
.LC141:
	.string	"chdir - %m"
.LC142:
	.string	"chdir"
.LC143:
	.string	"daemon - %m"
.LC144:
	.string	"w"
.LC145:
	.string	"%d\n"
	.section	.rodata.str1.4
	.align 4
.LC146:
	.string	"fdwatch initialization failure"
	.section	.rodata.str1.1
.LC147:
	.string	"chroot - %m"
	.section	.rodata.str1.4
	.align 4
.LC148:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.align 4
.LC149:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.section	.rodata.str1.1
.LC150:
	.string	"chroot chdir - %m"
.LC151:
	.string	"chroot chdir"
.LC152:
	.string	"data_dir chdir - %m"
.LC153:
	.string	"data_dir chdir"
.LC154:
	.string	"tmr_create(occasional) failed"
.LC155:
	.string	"tmr_create(idle) failed"
	.section	.rodata.str1.4
	.align 4
.LC156:
	.string	"tmr_create(update_throttles) failed"
	.section	.rodata.str1.1
.LC157:
	.string	"tmr_create(show_stats) failed"
.LC158:
	.string	"setgroups - %m"
.LC159:
	.string	"setgid - %m"
.LC160:
	.string	"initgroups - %m"
.LC161:
	.string	"setuid - %m"
	.section	.rodata.str1.4
	.align 4
.LC162:
	.string	"started as root without requesting chroot(), warning only"
	.align 4
.LC163:
	.string	"out of memory allocating a connecttab"
	.section	.rodata.str1.1
.LC164:
	.string	"fdwatch - %m"
	.section	.text.unlikely
.LCOLDB165:
	.section	.text.startup,"ax",@progbits
.LHOTB165:
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
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
	subl	$4416, %esp
	movl	4(%ecx), %esi
	movl	(%ecx), %edi
	movl	%gs:20, %eax
	movl	%eax, -28(%ebp)
	xorl	%eax, %eax
	movl	(%esi), %ebx
	pushl	$47
	pushl	%ebx
	movl	%ebx, argv0
	call	strrchr
	leal	1(%eax), %edx
	addl	$12, %esp
	testl	%eax, %eax
	pushl	$24
	pushl	$9
	cmovne	%edx, %ebx
	pushl	%ebx
	call	openlog
	movl	%edi, %eax
	movl	%esi, %edx
	call	parse_args
	call	tzset
	leal	-4396(%ebp), %eax
	leal	-4256(%ebp), %ecx
	leal	-4400(%ebp), %edx
	movl	%eax, (%esp)
	leal	-4384(%ebp), %eax
	call	lookup_hostname.constprop.1
	movl	-4400(%ebp), %edi
	addl	$16, %esp
	testl	%edi, %edi
	jne	.L562
	cmpl	$0, -4396(%ebp)
	je	.L693
.L562:
	movl	throttlefile, %eax
	movl	$0, numthrottles
	movl	$0, maxthrottles
	movl	$0, throttles
	testl	%eax, %eax
	je	.L563
	call	read_throttlefile
.L563:
	call	getuid
	testl	%eax, %eax
	movl	$32767, -4412(%ebp)
	movl	$32767, -4416(%ebp)
	je	.L694
.L564:
	movl	logfile, %ebx
	testl	%ebx, %ebx
	je	.L633
	movl	$.LC136, %edi
	movl	$10, %ecx
	movl	%ebx, %esi
	repz; cmpsb
	je	.L695
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC95
	pushl	%ebx
	call	strcmp
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L568
	movl	stdout, %esi
.L566:
	movl	dir, %eax
	testl	%eax, %eax
	je	.L572
	subl	$12, %esp
	pushl	%eax
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	js	.L696
.L572:
	leal	-4125(%ebp), %ebx
	subl	$8, %esp
	pushl	$4096
	pushl	%ebx
	call	getcwd
	movl	%ebx, (%esp)
	call	strlen
	addl	$16, %esp
	cmpb	$47, -4126(%ebp,%eax)
	je	.L573
	movw	$47, (%ebx,%eax)
.L573:
	movl	debug, %ecx
	testl	%ecx, %ecx
	jne	.L574
	subl	$12, %esp
	pushl	stdin
	call	fclose
	movl	stdout, %eax
	addl	$16, %esp
	cmpl	%eax, %esi
	je	.L575
	subl	$12, %esp
	pushl	%eax
	call	fclose
	addl	$16, %esp
.L575:
	subl	$12, %esp
	pushl	stderr
	call	fclose
	popl	%eax
	popl	%edx
	pushl	$1
	pushl	$1
	call	daemon
	addl	$16, %esp
	testl	%eax, %eax
	js	.L697
.L576:
	movl	pidfile, %eax
	testl	%eax, %eax
	je	.L577
	pushl	%edi
	pushl	%edi
	pushl	$.LC144
	pushl	%eax
	call	fopen
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, %edi
	je	.L698
	call	getpid
	pushl	%edx
	pushl	%eax
	pushl	$.LC145
	pushl	%edi
	call	fprintf
	movl	%edi, (%esp)
	call	fclose
	addl	$16, %esp
.L577:
	call	fdwatch_get_nfiles
	testl	%eax, %eax
	movl	%eax, max_connects
	js	.L699
	subl	$10, %eax
	cmpl	$0, do_chroot
	movl	%eax, max_connects
	jne	.L700
.L580:
	movl	data_dir, %eax
	testl	%eax, %eax
	je	.L584
	subl	$12, %esp
	pushl	%eax
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	js	.L701
.L584:
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
	popl	%edi
	pushl	$handle_chld
	pushl	$17
	call	sigset
	popl	%eax
	popl	%edx
	pushl	$1
	pushl	$13
	call	sigset
	popl	%ecx
	popl	%edi
	pushl	$handle_hup
	pushl	$1
	call	sigset
	popl	%eax
	popl	%edx
	pushl	$handle_usr1
	pushl	$10
	call	sigset
	popl	%ecx
	popl	%edi
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
	popl	%edi
	popl	%eax
	xorl	%eax, %eax
	cmpl	$0, -4396(%ebp)
	leal	-4256(%ebp), %edx
	movzwl	port, %ecx
	leal	-4384(%ebp), %edi
	pushl	no_empty_referers
	pushl	local_pattern
	pushl	url_pattern
	pushl	do_global_passwd
	pushl	do_vhost
	cmove	%eax, %edx
	cmpl	$0, -4400(%ebp)
	pushl	no_symlink_check
	pushl	%esi
	pushl	no_log
	pushl	%ebx
	pushl	max_age
	pushl	p3p
	pushl	charset
	cmovne	%edi, %eax
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
	je	.L702
	subl	$12, %esp
	pushl	$1
	pushl	$120000
	pushl	JunkClientData
	pushl	$occasional
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L703
	subl	$12, %esp
	pushl	$1
	pushl	$5000
	pushl	JunkClientData
	pushl	$idle
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L704
	cmpl	$0, numthrottles
	jle	.L590
	subl	$12, %esp
	pushl	$1
	pushl	$2000
	pushl	JunkClientData
	pushl	$update_throttles
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L705
.L590:
	subl	$12, %esp
	pushl	$1
	pushl	$3600000
	pushl	JunkClientData
	pushl	$show_stats
	pushl	$0
	call	tmr_create
	addl	$32, %esp
	testl	%eax, %eax
	je	.L706
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
	jne	.L593
	pushl	%edx
	pushl	%edx
	pushl	$0
	pushl	$0
	call	setgroups
	addl	$16, %esp
	testl	%eax, %eax
	js	.L707
	subl	$12, %esp
	pushl	-4412(%ebp)
	call	setgid
	addl	$16, %esp
	testl	%eax, %eax
	js	.L708
	pushl	%eax
	pushl	%eax
	pushl	-4412(%ebp)
	pushl	user
	call	initgroups
	addl	$16, %esp
	testl	%eax, %eax
	js	.L709
.L596:
	subl	$12, %esp
	pushl	-4416(%ebp)
	call	setuid
	addl	$16, %esp
	testl	%eax, %eax
	js	.L710
	cmpl	$0, do_chroot
	je	.L711
.L593:
	movl	max_connects, %ebx
	subl	$12, %esp
	imull	$96, %ebx, %esi
	pushl	%esi
	call	malloc
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, connects
	je	.L599
	xorl	%ecx, %ecx
	testl	%ebx, %ebx
	movl	%eax, %edx
	jle	.L604
	.p2align 4,,10
	.p2align 3
.L672:
	addl	$1, %ecx
	movl	$0, (%edx)
	movl	$0, 8(%edx)
	movl	%ecx, 4(%edx)
	addl	$96, %edx
	cmpl	%ebx, %ecx
	jne	.L672
.L604:
	movl	$-1, -92(%eax,%esi)
	movl	hs, %eax
	movl	$0, first_free_connect
	movl	$0, num_connects
	movl	$0, httpd_conn_count
	testl	%eax, %eax
	je	.L605
	movl	40(%eax), %edx
	cmpl	$-1, %edx
	je	.L606
	pushl	%esi
	pushl	$0
	pushl	$0
	pushl	%edx
	call	fdwatch_add_fd
	movl	hs, %eax
	addl	$16, %esp
.L606:
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L605
	pushl	%ebx
	pushl	$0
	pushl	$0
	pushl	%eax
	call	fdwatch_add_fd
	addl	$16, %esp
.L605:
	leal	-4392(%ebp), %esi
	subl	$12, %esp
	pushl	%esi
	call	tmr_prepare_timeval
	addl	$16, %esp
	.p2align 4,,10
	.p2align 3
.L607:
	movl	terminate, %edx
	testl	%edx, %edx
	je	.L630
	cmpl	$0, num_connects
	jle	.L712
.L630:
	movl	got_hup, %eax
	testl	%eax, %eax
	jne	.L713
.L608:
	subl	$12, %esp
	pushl	%esi
	call	tmr_mstimeout
	movl	%eax, (%esp)
	call	fdwatch
	addl	$16, %esp
	testl	%eax, %eax
	movl	%eax, %ebx
	js	.L714
	subl	$12, %esp
	pushl	%esi
	call	tmr_prepare_timeval
	addl	$16, %esp
	testl	%ebx, %ebx
	je	.L715
	movl	hs, %eax
	testl	%eax, %eax
	je	.L621
	movl	44(%eax), %edx
	cmpl	$-1, %edx
	je	.L616
	subl	$12, %esp
	pushl	%edx
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L617
.L620:
	movl	hs, %eax
	testl	%eax, %eax
	je	.L621
.L616:
	movl	40(%eax), %eax
	cmpl	$-1, %eax
	je	.L621
	subl	$12, %esp
	pushl	%eax
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L716
	.p2align 4,,10
	.p2align 3
.L621:
	call	fdwatch_get_next_client_data
	cmpl	$-1, %eax
	movl	%eax, %ebx
	je	.L717
	testl	%ebx, %ebx
	je	.L621
	movl	8(%ebx), %eax
	subl	$12, %esp
	pushl	448(%eax)
	call	fdwatch_check_fd
	addl	$16, %esp
	testl	%eax, %eax
	je	.L718
	movl	(%ebx), %eax
	cmpl	$2, %eax
	je	.L624
	cmpl	$4, %eax
	je	.L625
	cmpl	$1, %eax
	jne	.L621
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_read
	jmp	.L621
.L695:
	movl	$1, no_log
	xorl	%esi, %esi
	jmp	.L566
.L574:
	call	setsid
	jmp	.L576
.L694:
	subl	$12, %esp
	pushl	user
	call	getpwnam
	addl	$16, %esp
	testl	%eax, %eax
	je	.L719
	movl	8(%eax), %edi
	movl	12(%eax), %eax
	movl	%edi, -4416(%ebp)
	movl	%eax, -4412(%ebp)
	jmp	.L564
.L693:
	pushl	%esi
	pushl	%esi
	pushl	$.LC132
	pushl	$3
	call	syslog
	addl	$12, %esp
	pushl	argv0
	pushl	$.LC133
	pushl	stderr
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L718:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	clear_connection
	jmp	.L621
.L714:
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L607
	cmpl	$4, %eax
	je	.L607
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC164
	pushl	$3
	call	syslog
	movl	$1, (%esp)
	call	exit
.L625:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_linger
	jmp	.L621
.L624:
	movl	%esi, %edx
	movl	%ebx, %eax
	call	handle_send
	jmp	.L621
.L717:
	subl	$12, %esp
	pushl	%esi
	call	tmr_run
	movl	got_usr1, %eax
	addl	$16, %esp
	testl	%eax, %eax
	je	.L607
	cmpl	$0, terminate
	jne	.L607
	movl	hs, %eax
	movl	$1, terminate
	testl	%eax, %eax
	je	.L607
	movl	40(%eax), %edx
	cmpl	$-1, %edx
	je	.L628
	subl	$12, %esp
	pushl	%edx
	call	fdwatch_del_fd
	movl	hs, %eax
	addl	$16, %esp
.L628:
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L629
	subl	$12, %esp
	pushl	%eax
	call	fdwatch_del_fd
	addl	$16, %esp
.L629:
	subl	$12, %esp
	pushl	hs
	call	httpd_unlisten
	addl	$16, %esp
	jmp	.L607
.L713:
	call	re_open_logfile
	movl	$0, got_hup
	jmp	.L608
.L715:
	subl	$12, %esp
	pushl	%esi
	call	tmr_run
	addl	$16, %esp
	jmp	.L607
.L700:
	subl	$12, %esp
	pushl	%ebx
	call	chroot
	addl	$16, %esp
	testl	%eax, %eax
	js	.L720
	movl	logfile, %edx
	testl	%edx, %edx
	je	.L582
	pushl	%edi
	pushl	%edi
	pushl	$.LC95
	pushl	%edx
	movl	%edx, -4420(%ebp)
	call	strcmp
	addl	$16, %esp
	testl	%eax, %eax
	movl	-4420(%ebp), %edx
	je	.L582
	xorl	%eax, %eax
	orl	$-1, %ecx
	movl	%ebx, %edi
	repnz; scasb
	movl	%ecx, %edi
	pushl	%ecx
	notl	%edi
	leal	-1(%edi), %eax
	pushl	%eax
	pushl	%ebx
	pushl	%edx
	call	strncmp
	addl	$16, %esp
	testl	%eax, %eax
	movl	-4420(%ebp), %edx
	jne	.L583
	pushl	%eax
	pushl	%eax
	leal	-2(%edx,%edi), %eax
	pushl	%eax
	pushl	%edx
	call	strcpy
	addl	$16, %esp
.L582:
	subl	$12, %esp
	movw	$47, -4125(%ebp)
	pushl	%ebx
	call	chdir
	addl	$16, %esp
	testl	%eax, %eax
	jns	.L580
	pushl	%eax
	pushl	%eax
	pushl	$.LC150
	pushl	$2
	call	syslog
	movl	$.LC151, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L633:
	xorl	%esi, %esi
	jmp	.L566
.L568:
	pushl	%eax
	pushl	%eax
	pushl	$.LC97
	pushl	%ebx
	call	fopen
	movl	%eax, %esi
	popl	%eax
	popl	%edx
	pushl	$384
	pushl	logfile
	call	chmod
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L636
	testl	%esi, %esi
	je	.L636
	movl	logfile, %eax
	cmpb	$47, (%eax)
	je	.L571
	pushl	%eax
	pushl	%eax
	pushl	$.LC137
	pushl	$4
	call	syslog
	addl	$12, %esp
	pushl	argv0
	pushl	$.LC138
	pushl	stderr
	call	fprintf
	addl	$16, %esp
.L571:
	subl	$12, %esp
	pushl	%esi
	call	fileno
	addl	$12, %esp
	pushl	$1
	pushl	$2
	pushl	%eax
	call	fcntl
	call	getuid
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L566
	subl	$12, %esp
	pushl	%esi
	call	fileno
	addl	$12, %esp
	pushl	-4412(%ebp)
	pushl	-4416(%ebp)
	pushl	%eax
	call	fchown
	addl	$16, %esp
	testl	%eax, %eax
	jns	.L566
	pushl	%edi
	pushl	%edi
	pushl	$.LC139
	pushl	$4
	call	syslog
	movl	$.LC140, (%esp)
	call	perror
	addl	$16, %esp
	jmp	.L566
.L696:
	pushl	%ebx
	pushl	%ebx
	pushl	$.LC141
	pushl	$2
	call	syslog
	movl	$.LC142, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L698:
	pushl	%ecx
	pushl	pidfile
	pushl	$.LC86
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L699:
	pushl	%eax
	pushl	%eax
	pushl	$.LC146
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L702:
	subl	$12, %esp
	pushl	$1
	call	exit
.L703:
	pushl	%edi
	pushl	%edi
	pushl	$.LC154
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L701:
	pushl	%eax
	pushl	%eax
	pushl	$.LC152
	pushl	$2
	call	syslog
	movl	$.LC153, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L583:
	pushl	%eax
	pushl	%eax
	pushl	$.LC148
	pushl	$4
	call	syslog
	addl	$12, %esp
	pushl	argv0
	pushl	$.LC149
	pushl	stderr
	call	fprintf
	addl	$16, %esp
	jmp	.L582
.L711:
	pushl	%eax
	pushl	%eax
	pushl	$.LC162
	pushl	$4
	call	syslog
	addl	$16, %esp
	jmp	.L593
.L705:
	pushl	%ebx
	pushl	%ebx
	pushl	$.LC156
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L697:
	pushl	%eax
	pushl	%eax
	pushl	$.LC143
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L617:
	movl	hs, %eax
	movl	44(%eax), %edx
	movl	%esi, %eax
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L607
	jmp	.L620
.L716:
	movl	hs, %eax
	movl	40(%eax), %edx
	movl	%esi, %eax
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L607
	jmp	.L621
.L706:
	pushl	%ecx
	pushl	%ecx
	pushl	$.LC157
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L707:
	pushl	%eax
	pushl	%eax
	pushl	$.LC158
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L636:
	pushl	%eax
	pushl	logfile
	pushl	$.LC86
	pushl	$2
	call	syslog
	popl	%eax
	pushl	logfile
	call	perror
	movl	$1, (%esp)
	call	exit
.L708:
	pushl	%eax
	pushl	%eax
	pushl	$.LC159
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L712:
	call	shut_down
	pushl	%eax
	pushl	%eax
	pushl	$.LC107
	pushl	$5
	call	syslog
	call	closelog
	movl	$0, (%esp)
	call	exit
.L704:
	pushl	%esi
	pushl	%esi
	pushl	$.LC155
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L720:
	pushl	%eax
	pushl	%eax
	pushl	$.LC147
	pushl	$2
	call	syslog
	movl	$.LC32, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L719:
	pushl	%ebx
	pushl	user
	pushl	$.LC134
	pushl	$2
	call	syslog
	pushl	user
	pushl	argv0
	pushl	$.LC135
	pushl	stderr
	call	fprintf
	addl	$20, %esp
	pushl	$1
	call	exit
.L599:
	pushl	%edi
	pushl	%edi
	pushl	$.LC163
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
.L709:
	pushl	%eax
	pushl	%eax
	pushl	$.LC160
	pushl	$4
	call	syslog
	addl	$16, %esp
	jmp	.L596
.L710:
	pushl	%eax
	pushl	%eax
	pushl	$.LC161
	pushl	$2
	call	syslog
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.section	.text.unlikely
.LCOLDE165:
	.section	.text.startup
.LHOTE165:
	.local	watchdog_flag
	.comm	watchdog_flag,4,4
	.local	got_usr1
	.comm	got_usr1,4,4
	.local	got_hup
	.comm	got_hup,4,4
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,4,4
	.comm	stats_connections,4,4
	.comm	stats_time,4,4
	.comm	start_time,4,4
	.globl	terminate
	.bss
	.align 4
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	4
	.local	hs
	.comm	hs,4,4
	.local	httpd_conn_count
	.comm	httpd_conn_count,4,4
	.local	first_free_connect
	.comm	first_free_connect,4,4
	.local	max_connects
	.comm	max_connects,4,4
	.local	num_connects
	.comm	num_connects,4,4
	.local	connects
	.comm	connects,4,4
	.local	maxthrottles
	.comm	maxthrottles,4,4
	.local	numthrottles
	.comm	numthrottles,4,4
	.local	throttles
	.comm	throttles,4,4
	.local	max_age
	.comm	max_age,4,4
	.local	p3p
	.comm	p3p,4,4
	.local	charset
	.comm	charset,4,4
	.local	user
	.comm	user,4,4
	.local	pidfile
	.comm	pidfile,4,4
	.local	hostname
	.comm	hostname,4,4
	.local	throttlefile
	.comm	throttlefile,4,4
	.local	logfile
	.comm	logfile,4,4
	.local	local_pattern
	.comm	local_pattern,4,4
	.local	no_empty_referers
	.comm	no_empty_referers,4,4
	.local	url_pattern
	.comm	url_pattern,4,4
	.local	cgi_limit
	.comm	cgi_limit,4,4
	.local	cgi_pattern
	.comm	cgi_pattern,4,4
	.local	do_global_passwd
	.comm	do_global_passwd,4,4
	.local	do_vhost
	.comm	do_vhost,4,4
	.local	no_symlink_check
	.comm	no_symlink_check,4,4
	.local	no_log
	.comm	no_log,4,4
	.local	do_chroot
	.comm	do_chroot,4,4
	.local	data_dir
	.comm	data_dir,4,4
	.local	dir
	.comm	dir,4,4
	.local	port
	.comm	port,2,2
	.local	debug
	.comm	debug,4,4
	.local	argv0
	.comm	argv0,4,4
	.ident	"GCC: (GNU) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
