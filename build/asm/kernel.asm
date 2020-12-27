	.file	"kernel.c"
	.text
	.align 16
	.type	termInit.part.0, @function
termInit.part.0:
	movl	$0, termRow
	movl	$753824, %ecx
	movl	$7, %eax
	movl	$0, termCol
	movb	$7, termColor
	movl	$753664, termBuffer
	.align 16
.L2:
	leal	-160(%ecx), %edx
	jmp	.L5
	.align 16
.L3:
	movzbl	termColor, %eax
.L5:
	sall	$8, %eax
	addl	$2, %edx
	orl	$32, %eax
	movw	%ax, -2(%edx)
	cmpl	%edx, %ecx
	jne	.L3
	addl	$160, %ecx
	cmpl	$757824, %ecx
	je	.L4
	movzbl	termColor, %eax
	jmp	.L2
.L4:
	movb	$1, termInitialized
	ret
	.size	termInit.part.0, .-termInit.part.0
	.align 16
	.globl	strLen
	.type	strLen, @function
strLen:
	pushl	%ebp
	xorl	%eax, %eax
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	cmpb	$0, (%edx)
	je	.L7
	.align 16
.L9:
	addl	$1, %eax
	cmpb	$0, (%edx,%eax)
	jne	.L9
.L7:
	popl	%ebp
	ret
	.size	strLen, .-strLen
	.align 16
	.globl	strcpy
	.type	strcpy, @function
strcpy:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	16(%ebp), %ebx
	movl	8(%ebp), %esi
	movl	%ebx, %eax
	orl	20(%ebp), %eax
	je	.L14
	movl	12(%ebp), %eax
	movl	%esi, %edx
	addl	%eax, %ebx
	.align 16
.L15:
	movzbl	(%eax), %ecx
	addl	$1, %eax
	addl	$1, %edx
	movb	%cl, -1(%edx)
	cmpl	%ebx, %eax
	jne	.L15
.L14:
	movl	%esi, %eax
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	strcpy, .-strcpy
	.align 16
	.globl	strCmp
	.type	strCmp, @function
strCmp:
	pushl	%ebp
	xorl	%edx, %edx
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$4, %esp
	movl	8(%ebp), %ebx
	movl	12(%ebp), %ecx
	movzbl	(%ebx), %esi
	movzbl	(%ecx), %edi
	movl	%esi, %eax
	testb	%al, %al
	je	.L22
	.align 16
.L23:
	addl	$1, %edx
	cmpb	$0, (%ebx,%edx)
	jne	.L23
	movl	%edi, %eax
	testb	%al, %al
	je	.L32
.L25:
	xorl	%eax, %eax
	.align 16
.L27:
	addl	$1, %eax
	cmpb	$0, (%ecx,%eax)
	jne	.L27
	movb	$0, -13(%ebp)
	cmpl	%edx, %eax
	jne	.L21
	addl	%ebx, %eax
	leal	1(%ebx), %edx
	addl	$1, %ecx
	movl	%esi, %ebx
	movl	%eax, %esi
	movl	%edi, %eax
	jmp	.L28
	.align 16
.L38:
	cmpl	%edx, %esi
	je	.L33
	movzbl	(%edx), %ebx
	movzbl	(%ecx), %eax
	addl	$1, %edx
	addl	$1, %ecx
.L28:
	cmpb	%al, %bl
	jne	.L38
.L32:
	movb	$0, -13(%ebp)
.L21:
	movzbl	-13(%ebp), %eax
	addl	$4, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L22:
	movl	%edi, %eax
	testb	%al, %al
	jne	.L25
.L33:
	movb	$1, -13(%ebp)
	movzbl	-13(%ebp), %eax
	addl	$4, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	strCmp, .-strCmp
	.align 16
	.globl	termInit
	.type	termInit, @function
termInit:
	cmpb	$0, termInitialized
	jne	.L39
	jmp	termInit.part.0
.L39:
	ret
	.size	termInit, .-termInit
	.align 16
	.globl	termSetColor
	.type	termSetColor, @function
termSetColor:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	popl	%ebp
	movb	%al, termColor
	ret
	.size	termSetColor, .-termSetColor
	.align 16
	.globl	termSetChar
	.type	termSetChar, @function
termSetChar:
	pushl	%ebp
	movl	%esp, %ebp
	movzbl	12(%ebp), %edx
	movl	20(%ebp), %eax
	movl	%edx, %ecx
	movzbl	8(%ebp), %edx
	leal	(%eax,%eax,4), %eax
	sall	$8, %ecx
	sall	$4, %eax
	addl	16(%ebp), %eax
	orl	%ecx, %edx
	movl	termBuffer, %ecx
	movw	%dx, (%ecx,%eax,2)
	popl	%ebp
	ret
	.size	termSetChar, .-termSetChar
	.align 16
	.globl	termPushChar
	.type	termPushChar, @function
termPushChar:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	movl	8(%ebp), %eax
	pushl	%ebx
	cmpb	$9, %al
	je	.L46
	cmpb	$10, %al
	jne	.L47
	addl	$1, termRow
	movl	$0, termCol
.L45:
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.align 16
.L46:
	movl	termCol, %eax
	andl	$-4, %eax
	addl	$5, %eax
	movl	%eax, termCol
	cmpl	$79, %eax
	jbe	.L45
	popl	%ebx
	addl	$1, termRow
	popl	%esi
	popl	%ebp
	ret
	.align 16
.L47:
	movsbw	%al, %dx
	subl	$32, %eax
	movl	termRow, %ecx
	movzbl	termColor, %esi
	cmpb	$95, %al
	movl	$63, %eax
	movl	termCol, %ebx
	cmovnb	%eax, %edx
	sall	$8, %esi
	leal	(%ecx,%ecx,4), %eax
	sall	$4, %eax
	orl	%esi, %edx
	movl	termBuffer, %esi
	addl	%ebx, %eax
	addl	$1, %ebx
	movw	%dx, (%esi,%eax,2)
	cmpl	$79, %ebx
	jbe	.L55
	addl	$1, %ecx
	movl	$0, %eax
	popl	%ebx
	popl	%esi
	movl	$0, termCol
	cmpl	$24, %ecx
	popl	%ebp
	cmova	%eax, %ecx
	movl	%ecx, termRow
	ret
	.align 16
.L55:
	movl	%ebx, termCol
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	termPushChar, .-termPushChar
	.align 16
	.globl	termPushString
	.type	termPushString, @function
termPushString:
	pushl	%ebp
	cmpb	$0, termInitialized
	movl	%esp, %ebp
	pushl	%esi
	movl	12(%ebp), %esi
	pushl	%ebx
	je	.L65
.L57:
	testl	%esi, %esi
	je	.L56
	movl	8(%ebp), %ebx
	addl	%ebx, %esi
	.align 16
.L59:
	movsbl	(%ebx), %eax
	subl	$12, %esp
	addl	$1, %ebx
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%ebx, %esi
	jne	.L59
.L56:
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.align 16
.L65:
	call	termInit.part.0
	jmp	.L57
	.size	termPushString, .-termPushString
	.align 16
	.globl	termPrint
	.type	termPrint, @function
termPrint:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$12, %esp
	movl	8(%ebp), %edi
	movzbl	termInitialized, %edx
	movsbl	(%edi), %eax
	testb	%al, %al
	je	.L67
	xorl	%ebx, %ebx
	.align 16
.L68:
	addl	$1, %ebx
	cmpb	$0, (%edi,%ebx)
	jne	.L68
	testb	%dl, %dl
	je	.L80
.L72:
	xorl	%esi, %esi
	jmp	.L71
	.align 16
.L81:
	movsbl	(%edi,%esi), %eax
.L71:
	subl	$12, %esp
	addl	$1, %esi
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%esi, %ebx
	ja	.L81
.L66:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L80:
	call	termInit.part.0
	movsbl	(%edi), %eax
	jmp	.L72
	.align 16
.L67:
	testb	%dl, %dl
	jne	.L66
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	jmp	termInit.part.0
	.size	termPrint, .-termPrint
	.align 16
	.globl	termPrintln
	.type	termPrintln, @function
termPrintln:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$12, %esp
	movl	8(%ebp), %ebx
	movzbl	termInitialized, %edx
	movsbl	(%ebx), %eax
	testb	%al, %al
	je	.L83
	xorl	%esi, %esi
	.align 16
.L84:
	addl	$1, %esi
	cmpb	$0, (%ebx,%esi)
	jne	.L84
	testb	%dl, %dl
	je	.L97
.L88:
	xorl	%edi, %edi
	jmp	.L87
	.align 16
.L98:
	movsbl	(%ebx,%edi), %eax
.L87:
	subl	$12, %esp
	addl	$1, %edi
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%edi, %esi
	ja	.L98
.L86:
	addl	$1, termRow
	movl	$0, termCol
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L97:
	call	termInit.part.0
	movsbl	(%ebx), %eax
	jmp	.L88
	.align 16
.L83:
	testb	%dl, %dl
	jne	.L86
	call	termInit.part.0
	jmp	.L86
	.size	termPrintln, .-termPrintln
	.align 16
	.globl	termPrintInt
	.type	termPrintInt, @function
termPrintInt:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$124, %esp
	movl	8(%ebp), %ecx
	testl	%ecx, %ecx
	je	.L102
	xorl	%ebx, %ebx
	leal	-124(%ebp), %esi
	.align 16
.L101:
	movl	$-858993459, %eax
	mull	%ecx
	movl	%ecx, %eax
	shrl	$3, %edx
	leal	(%edx,%edx,4), %edi
	addl	%edi, %edi
	subl	%edi, %eax
	addl	$48, %eax
	movb	%al, (%esi,%ebx)
	movl	%ecx, %eax
	movl	%edx, %ecx
	movl	%ebx, %edx
	addl	$1, %ebx
	cmpl	$9, %eax
	ja	.L101
	addl	$2, %edx
.L100:
	subl	$12, %esp
	movb	$0, -124(%ebp,%edx)
	pushl	%esi
	call	termPrintln
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L102:
	movl	$1, %edx
	leal	-124(%ebp), %esi
	jmp	.L100
	.size	termPrintInt, .-termPrintInt
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"0123456789abcdef"
	.text
	.align 16
	.globl	termPrintHex
	.type	termPrintHex, @function
termPrintHex:
	pushl	%ebp
	movl	$28, %ecx
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	leal	-19(%ebp), %esi
	movl	%esi, %eax
	subl	$16, %esp
	movl	8(%ebp), %ebx
	.align 16
.L106:
	movl	%ebx, %edx
	addl	$1, %eax
	shrl	%cl, %edx
	subl	$4, %ecx
	andl	$15, %edx
	movzbl	.LC0(%edx), %edx
	movb	%dl, -1(%eax)
	cmpl	$-4, %ecx
	jne	.L106
	subl	$12, %esp
	movb	$0, -10(%ebp)
	pushl	%esi
	call	termPrintln
	addl	$16, %esp
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	termPrintHex, .-termPrintHex
	.align 16
	.globl	termError
	.type	termError, @function
termError:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$28, %esp
	movzbl	termColor, %eax
	movl	8(%ebp), %ebx
	movb	$79, termColor
	movzbl	termInitialized, %edx
	movb	%al, -25(%ebp)
	movsbl	(%ebx), %eax
	testb	%al, %al
	je	.L110
	xorl	%edi, %edi
	.align 16
.L111:
	addl	$1, %edi
	cmpb	$0, (%ebx,%edi)
	jne	.L111
	testb	%dl, %dl
	je	.L124
.L115:
	xorl	%esi, %esi
	jmp	.L114
	.align 16
.L125:
	movsbl	(%ebx,%esi), %eax
.L114:
	subl	$12, %esp
	addl	$1, %esi
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%esi, %edi
	ja	.L125
.L113:
	movzbl	-25(%ebp), %eax
	movb	%al, termColor
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L124:
	call	termInit.part.0
	movsbl	(%ebx), %eax
	jmp	.L115
	.align 16
.L110:
	testb	%dl, %dl
	jne	.L113
	call	termInit.part.0
	jmp	.L113
	.size	termError, .-termError
	.align 16
	.globl	termWarning
	.type	termWarning, @function
termWarning:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$28, %esp
	movzbl	termColor, %eax
	movl	8(%ebp), %ebx
	movb	$-17, termColor
	movzbl	termInitialized, %edx
	movb	%al, -25(%ebp)
	movsbl	(%ebx), %eax
	testb	%al, %al
	je	.L127
	xorl	%edi, %edi
	.align 16
.L128:
	addl	$1, %edi
	cmpb	$0, (%ebx,%edi)
	jne	.L128
	testb	%dl, %dl
	je	.L141
.L132:
	xorl	%esi, %esi
	jmp	.L131
	.align 16
.L142:
	movsbl	(%ebx,%esi), %eax
.L131:
	subl	$12, %esp
	addl	$1, %esi
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%esi, %edi
	ja	.L142
.L130:
	movzbl	-25(%ebp), %eax
	movb	%al, termColor
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L141:
	call	termInit.part.0
	movsbl	(%ebx), %eax
	jmp	.L132
	.align 16
.L127:
	testb	%dl, %dl
	jne	.L130
	call	termInit.part.0
	jmp	.L130
	.size	termWarning, .-termWarning
	.align 16
	.globl	alert
	.type	alert, @function
alert:
	pushl	%ebp
	xorl	%ecx, %ecx
	movl	%esp, %ebp
	pushl	%ebx
	movl	8(%ebp), %edx
	movzbl	12(%ebp), %ebx
	sall	$8, %ebx
	cmpb	$0, (%edx)
	je	.L143
	.align 16
.L150:
	xorl	%eax, %eax
	.align 16
.L146:
	addl	$1, %eax
	cmpb	$0, (%edx,%eax)
	jne	.L146
	cmpl	%eax, %ecx
	jnb	.L143
	movsbw	(%edx,%ecx), %ax
	orl	%ebx, %eax
	movw	%ax, 753664(%ecx,%ecx)
	addl	$1, %ecx
	cmpb	$0, (%edx)
	jne	.L150
.L143:
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	alert, .-alert
	.align 16
	.globl	alertError
	.type	alertError, @function
alertError:
	pushl	%ebp
	xorl	%ecx, %ecx
	movl	%esp, %ebp
	pushl	%ebx
	movl	$753664, %ebx
	movl	8(%ebp), %edx
	cmpb	$0, (%edx)
	je	.L151
	.align 16
.L158:
	xorl	%eax, %eax
	.align 16
.L154:
	addl	$1, %eax
	cmpb	$0, (%edx,%eax)
	jne	.L154
	cmpl	%eax, %ecx
	jnb	.L151
	movsbw	(%edx,%ecx), %ax
	addl	$2, %ebx
	addl	$1, %ecx
	orb	$79, %ah
	movw	%ax, -2(%ebx)
	cmpb	$0, (%edx)
	jne	.L158
.L151:
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	alertError, .-alertError
	.align 16
	.globl	alertWarning
	.type	alertWarning, @function
alertWarning:
	pushl	%ebp
	xorl	%ecx, %ecx
	movl	%esp, %ebp
	pushl	%ebx
	movl	$753664, %ebx
	movl	8(%ebp), %edx
	cmpb	$0, (%edx)
	je	.L159
	.align 16
.L166:
	xorl	%eax, %eax
	.align 16
.L162:
	addl	$1, %eax
	cmpb	$0, (%edx,%eax)
	jne	.L162
	cmpl	%eax, %ecx
	jnb	.L159
	movsbw	(%edx,%ecx), %ax
	addl	$2, %ebx
	addl	$1, %ecx
	orw	$-4352, %ax
	movw	%ax, -2(%ebx)
	cmpb	$0, (%edx)
	jne	.L166
.L159:
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	alertWarning, .-alertWarning
	.align 16
	.globl	dbgWriteHex
	.type	dbgWriteHex, @function
dbgWriteHex:
	pushl	%ebp
	xorl	%eax, %eax
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	movl	16(%ebp), %esi
	pushl	%ebx
	movl	12(%ebp), %edi
	leal	-4(,%esi,4), %ecx
	testl	%esi, %esi
	je	.L170
	.align 16
.L169:
	movl	20(%ebp), %ebx
	movl	8(%ebp), %edx
	shrl	%cl, %ebx
	addl	%eax, %edx
	addl	$1, %eax
	addl	(%edi), %edx
	andl	$15, %ebx
	subl	$4, %ecx
	movzbl	.LC0(%ebx), %ebx
	movb	%bl, (%edx)
	cmpl	%eax, %esi
	jne	.L169
.L170:
	addl	%esi, (%edi)
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	dbgWriteHex, .-dbgWriteHex
	.section	.rodata.str1.1
.LC1:
	.string	"\n          "
.LC2:
	.string	"    "
	.text
	.align 16
	.globl	dbgPrintMemory
	.type	dbgPrintMemory, @function
dbgPrintMemory:
	pushl	%ebp
	movl	$10, %edx
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$1036, %esp
	movl	8(%ebp), %eax
	movl	%eax, -1048(%ebp)
	xorl	%eax, %eax
	jmp	.L179
.L206:
	movzbl	.LC1(%eax), %edx
.L179:
	movb	%dl, -1024(%ebp,%eax)
	addl	$1, %eax
	cmpl	$11, %eax
	jne	.L206
	movl	-1048(%ebp), %edx
	leal	-1013(%ebp), %eax
	leal	-965(%ebp), %ebx
	andl	$15, %edx
	.align 16
.L180:
	movl	%edx, %ecx
	movb	$32, 2(%eax)
	addl	$3, %eax
	shrl	$4, %ecx
	movzbl	.LC0(%ecx), %ecx
	movb	%cl, -3(%eax)
	movl	%edx, %ecx
	addl	$1, %edx
	andl	$15, %ecx
	movzbl	.LC0(%ecx), %ecx
	movb	%cl, -2(%eax)
	cmpl	%eax, %ebx
	jne	.L180
	movl	-1048(%ebp), %eax
	leal	-906(%ebp), %esi
	movb	$10, -965(%ebp)
	movl	$0, -1040(%ebp)
	movl	$138, -1044(%ebp)
	leal	-60(%eax), %edi
	leal	-964(%ebp), %eax
	movl	%eax, -1036(%ebp)
.L187:
	movl	-1036(%ebp), %eax
	movl	-1048(%ebp), %ebx
	movl	$28, %ecx
	addl	-1040(%ebp), %ebx
	.align 16
.L181:
	movl	%ebx, %edx
	addl	$1, %eax
	shrl	%cl, %edx
	subl	$4, %ecx
	andl	$15, %edx
	movzbl	.LC0(%edx), %edx
	movb	%dl, -1(%eax)
	cmpl	$-4, %ecx
	jne	.L181
	movb	$124, -50(%esi)
	leal	-48(%esi), %eax
	movb	$32, -49(%esi)
	.align 16
.L182:
	movzbl	(%ebx), %ecx
	movb	$32, 2(%eax)
	addl	$3, %eax
	addl	$1, %ebx
	movl	%ecx, %edx
	andl	$15, %ecx
	shrb	$4, %dl
	movzbl	%dl, %edx
	movzbl	.LC0(%edx), %edx
	movb	%dl, -3(%eax)
	movzbl	.LC0(%ecx), %edx
	movb	%dl, -2(%eax)
	cmpl	%eax, %esi
	jne	.L182
	movl	-1036(%ebp), %ecx
	xorl	%eax, %eax
	movl	$32, %edx
	jmp	.L184
	.align 16
.L207:
	movzbl	.LC2(%eax), %edx
.L184:
	movb	%dl, 58(%ecx,%eax)
	addl	$1, %eax
	cmpl	$4, %eax
	jne	.L207
	movl	-1044(%ebp), %ebx
	leal	-16(%ebx), %eax
	.align 16
.L186:
	movzbl	-62(%edi,%eax), %edx
	leal	-32(%edx), %ecx
	cmpb	$95, %cl
	movl	$46, %ecx
	cmovnb	%ecx, %edx
	movb	%dl, -1024(%ebp,%eax)
	addl	$1, %eax
	cmpl	%ebx, %eax
	jne	.L186
	leal	79(%eax), %ebx
	movb	$10, 20(%esi)
	subl	$63, %edi
	addl	$79, %esi
	addl	$16, -1040(%ebp)
	addl	$79, -1036(%ebp)
	movl	%ebx, -1044(%ebp)
	cmpl	$849, %eax
	jne	.L187
	movsbl	-1024(%ebp), %eax
	movb	$0, -174(%ebp)
	movzbl	termInitialized, %edx
	testb	%al, %al
	je	.L188
	xorl	%ebx, %ebx
.L189:
	addl	$1, %ebx
	cmpb	$0, -1024(%ebp,%ebx)
	jne	.L189
	testb	%dl, %dl
	je	.L208
.L193:
	xorl	%esi, %esi
	jmp	.L192
.L209:
	movsbl	-1024(%ebp,%esi), %eax
.L192:
	subl	$12, %esp
	addl	$1, %esi
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%esi, %ebx
	ja	.L209
.L177:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L208:
	movb	%al, -1036(%ebp)
	call	termInit.part.0
	movsbl	-1036(%ebp), %eax
	jmp	.L193
.L188:
	testb	%dl, %dl
	jne	.L177
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	jmp	termInit.part.0
	.size	dbgPrintMemory, .-dbgPrintMemory
	.section	.rodata.str1.1
.LC3:
	.string	"flag 6 not set!"
	.text
	.align 16
	.globl	multibootSaveData
	.type	multibootSaveData, @function
multibootSaveData:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$44, %esp
	movl	multibootTable, %eax
	movl	%eax, -32(%ebp)
	testb	$32, (%eax)
	je	.L225
	movl	-32(%ebp), %eax
	xorl	%edi, %edi
	movl	44(%eax), %ecx
	movzbl	multibootNumMmapEntries, %eax
	movl	%ecx, -52(%ebp)
	testl	%ecx, %ecx
	je	.L219
	movb	%al, -25(%ebp)
	movl	%edi, %ecx
	.align 16
.L218:
	movl	-32(%ebp), %edi
	movl	48(%edi), %eax
	addl	%ecx, %eax
	movl	4(%eax), %esi
	movl	8(%eax), %edi
	movl	(%eax), %edx
	movl	12(%eax), %ebx
	movl	%esi, -40(%ebp)
	movl	16(%eax), %esi
	movl	%edi, -36(%ebp)
	movl	24(%eax), %edi
	leal	4(%edx,%ecx), %ecx
	movl	%esi, -44(%ebp)
	movl	20(%eax), %esi
	movzbl	-25(%ebp), %eax
	movl	%ebx, -48(%ebp)
	addb	$1, -25(%ebp)
	imull	$28, %eax, %eax
	leal	multibootMmapEntries(%eax), %ebx
	movl	%edx, multibootMmapEntries(%eax)
	movl	-40(%ebp), %eax
	movl	-36(%ebp), %edx
	movl	%esi, 20(%ebx)
	movl	%eax, 4(%ebx)
	movl	-48(%ebp), %eax
	movl	%edx, 8(%ebx)
	movl	-44(%ebp), %edx
	movl	%eax, 12(%ebx)
	movzbl	-25(%ebp), %eax
	movl	%edx, 16(%ebx)
	movl	%edi, 24(%ebx)
	movb	%al, multibootNumMmapEntries
	cmpl	%ecx, -52(%ebp)
	ja	.L218
.L219:
	leal	-12(%ebp), %esp
	xorl	%eax, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L225:
	movzbl	termColor, %esi
	movb	$79, termColor
	xorl	%ebx, %ebx
	.align 16
.L212:
	addl	$1, %ebx
	cmpb	$0, .LC3(%ebx)
	jne	.L212
	cmpb	$0, termInitialized
	je	.L226
.L213:
	movl	$.LC3+1, %edi
	addl	$.LC3, %ebx
	movl	$102, %eax
	jmp	.L215
	.align 16
.L227:
	movsbl	(%edi), %eax
	addl	$1, %edi
.L215:
	subl	$12, %esp
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%edi, %ebx
	jne	.L227
	movl	%esi, %eax
	movb	%al, termColor
	leal	-12(%ebp), %esp
	movl	$1, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L226:
	call	termInit.part.0
	jmp	.L213
	.size	multibootSaveData, .-multibootSaveData
	.section	.rodata.str1.1
.LC4:
	.string	"Entry:\n"
	.text
	.align 16
	.globl	multibootPrintMmap
	.type	multibootPrintMmap, @function
multibootPrintMmap:
	pushl	%ebp
	movl	$249, %ecx
	xorl	%eax, %eax
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	leal	-1020(%ebp), %edi
	pushl	%ebx
	subl	$1036, %esp
	movl	$0, -1024(%ebp)
	rep stosl
	movzbl	multibootNumMmapEntries, %ecx
	testb	%cl, %cl
	je	.L245
	imull	$43, %ecx, %esi
	leal	-1024(%ebp), %eax
	movl	$multibootMmapEntries, %edx
	movl	$0, -1036(%ebp)
	movl	%esi, -1044(%ebp)
	.align 16
.L236:
	xorl	%ecx, %ecx
	movl	$69, %ebx
	jmp	.L231
	.align 16
.L256:
	movzbl	.LC4(%ecx), %ebx
.L231:
	movb	%bl, (%eax,%ecx)
	addl	$1, %ecx
	cmpl	$7, %ecx
	jne	.L256
	movl	%eax, -1040(%ebp)
	movl	(%edx), %esi
	leal	7(%eax), %ebx
	movl	$28, %ecx
	.align 16
.L232:
	movl	%esi, %edi
	addl	$1, %ebx
	shrl	%cl, %edi
	subl	$4, %ecx
	andl	$15, %edi
	movzbl	.LC0(%edi), %eax
	movb	%al, -1(%ebx)
	cmpl	$-4, %ecx
	jne	.L232
	movl	-1040(%ebp), %eax
	movl	4(%edx), %esi
	movl	$28, %ecx
	movb	$10, 15(%eax)
	leal	16(%eax), %ebx
	.align 16
.L233:
	movl	%esi, %edi
	addl	$1, %ebx
	shrl	%cl, %edi
	subl	$4, %ecx
	andl	$15, %edi
	movzbl	.LC0(%edi), %eax
	movb	%al, -1(%ebx)
	cmpl	$-4, %ecx
	jne	.L233
	movl	-1040(%ebp), %eax
	movl	12(%edx), %esi
	movl	$28, %ecx
	movb	$10, 24(%eax)
	leal	25(%eax), %ebx
	.align 16
.L234:
	movl	%esi, %edi
	addl	$1, %ebx
	shrl	%cl, %edi
	subl	$4, %ecx
	andl	$15, %edi
	movzbl	.LC0(%edi), %eax
	movb	%al, -1(%ebx)
	cmpl	$-4, %ecx
	jne	.L234
	movl	-1040(%ebp), %eax
	movl	20(%edx), %esi
	movl	$28, %ecx
	movb	$10, 33(%eax)
	leal	34(%eax), %ebx
	.align 16
.L235:
	movl	%esi, %edi
	addl	$1, %ebx
	shrl	%cl, %edi
	subl	$4, %ecx
	andl	$15, %edi
	movzbl	.LC0(%edi), %eax
	movb	%al, -1(%ebx)
	cmpl	$-4, %ecx
	jne	.L235
	movl	-1040(%ebp), %eax
	addl	$43, -1036(%ebp)
	addl	$28, %edx
	movl	-1036(%ebp), %esi
	movb	$10, 42(%eax)
	addl	$43, %eax
	cmpl	-1044(%ebp), %esi
	jne	.L236
.L229:
	movl	-1044(%ebp), %eax
	movb	$0, -1024(%ebp,%eax)
	movzbl	-1024(%ebp), %ebx
	movzbl	termInitialized, %eax
	testb	%bl, %bl
	je	.L237
	xorl	%esi, %esi
	.align 16
.L238:
	addl	$1, %esi
	cmpb	$0, -1024(%ebp,%esi)
	jne	.L238
	testb	%al, %al
	je	.L257
.L242:
	xorl	%edi, %edi
	movsbl	%bl, %eax
	jmp	.L241
	.align 16
.L258:
	movsbl	-1024(%ebp,%edi), %eax
.L241:
	subl	$12, %esp
	addl	$1, %edi
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%edi, %esi
	ja	.L258
.L228:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L257:
	call	termInit.part.0
	jmp	.L242
.L237:
	testb	%al, %al
	jne	.L228
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	jmp	termInit.part.0
.L245:
	movl	$0, -1044(%ebp)
	jmp	.L229
	.size	multibootPrintMmap, .-multibootPrintMmap
	.align 16
	.globl	kernelInit
	.type	kernelInit, @function
kernelInit:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	call	multibootSaveData
	leave
	jmp	multibootPrintMmap
	.size	kernelInit, .-kernelInit
	.section	.rodata.str1.1
.LC5:
	.string	"Hello console"
	.text
	.align 16
	.globl	kernelMain
	.type	kernelMain, @function
kernelMain:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	xorl	%ebx, %ebx
	.align 16
.L262:
	addl	$1, %ebx
	cmpb	$0, .LC5(%ebx)
	jne	.L262
	cmpb	$0, termInitialized
	je	.L268
.L263:
	movl	$.LC5+1, %esi
	addl	$.LC5, %ebx
	movl	$72, %eax
	jmp	.L265
	.align 16
.L269:
	movsbl	(%esi), %eax
	addl	$1, %esi
.L265:
	subl	$12, %esp
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%esi, %ebx
	jne	.L269
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.align 16
.L268:
	call	termInit.part.0
	jmp	.L263
	.size	kernelMain, .-kernelMain
	.globl	multibootMmapEntries
	.section	.bss
	.align 32
	.type	multibootMmapEntries, @object
	.size	multibootMmapEntries, 280
multibootMmapEntries:
	.zero	280
	.globl	multibootNumMmapEntries
	.type	multibootNumMmapEntries, @object
	.size	multibootNumMmapEntries, 1
multibootNumMmapEntries:
	.zero	1
	.globl	termInitialized
	.type	termInitialized, @object
	.size	termInitialized, 1
termInitialized:
	.zero	1
	.globl	termBuffer
	.align 4
	.type	termBuffer, @object
	.size	termBuffer, 4
termBuffer:
	.zero	4
	.globl	termColor
	.data
	.type	termColor, @object
	.size	termColor, 1
termColor:
	.byte	112
	.globl	termCol
	.section	.bss
	.align 4
	.type	termCol, @object
	.size	termCol, 4
termCol:
	.zero	4
	.globl	termRow
	.align 4
	.type	termRow, @object
	.size	termRow, 4
termRow:
	.zero	4
	.ident	"GCC: (GNU) 10.2.0"
