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
	movl	termRow, %ebx
	movzbl	termColor, %esi
	movzbl	%al, %eax
	movl	termCol, %ecx
	sall	$8, %esi
	leal	(%ebx,%ebx,4), %edx
	orl	%esi, %eax
	sall	$4, %edx
	movl	termBuffer, %esi
	addl	%ecx, %edx
	movw	%ax, (%esi,%edx,2)
	leal	1(%ecx), %eax
	cmpl	$79, %ecx
	je	.L50
	popl	%ebx
	popl	%esi
	movl	%eax, termCol
	popl	%ebp
	ret
	.align 16
.L50:
	leal	1(%ebx), %eax
	cmpl	$24, %ebx
	movl	$0, %edx
	popl	%ebx
	movl	$0, termCol
	cmove	%edx, %eax
	popl	%esi
	popl	%ebp
	movl	%eax, termRow
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
	je	.L63
.L55:
	testl	%esi, %esi
	je	.L54
	movl	8(%ebp), %ebx
	addl	%ebx, %esi
	.align 16
.L57:
	movsbl	(%ebx), %eax
	subl	$12, %esp
	addl	$1, %ebx
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%ebx, %esi
	jne	.L57
.L54:
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.align 16
.L63:
	call	termInit.part.0
	jmp	.L55
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
	je	.L65
	xorl	%ebx, %ebx
	.align 16
.L66:
	addl	$1, %ebx
	cmpb	$0, (%edi,%ebx)
	jne	.L66
	testb	%dl, %dl
	je	.L78
.L70:
	xorl	%esi, %esi
	jmp	.L69
	.align 16
.L79:
	movsbl	(%edi,%esi), %eax
.L69:
	subl	$12, %esp
	addl	$1, %esi
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%esi, %ebx
	ja	.L79
.L64:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L78:
	call	termInit.part.0
	movsbl	(%edi), %eax
	jmp	.L70
	.align 16
.L65:
	testb	%dl, %dl
	jne	.L64
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	jmp	termInit.part.0
	.size	termPrint, .-termPrint
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
	je	.L91
	xorl	%ebx, %ebx
	leal	-124(%ebp), %esi
	.align 16
.L82:
	movl	$-858993459, %eax
	mull	%ecx
	movl	%ecx, %eax
	shrl	$3, %edx
	leal	(%edx,%edx,4), %edi
	addl	%edi, %edi
	subl	%edi, %eax
	movl	%ebx, %edi
	addl	$48, %eax
	movb	%al, (%esi,%ebx)
	movl	%ecx, %eax
	addl	$1, %ebx
	movl	%edx, %ecx
	cmpl	$9, %eax
	ja	.L82
	leal	2(%edi), %eax
	addl	$3, %edi
.L81:
	movzbl	-124(%ebp), %ebx
	movb	$10, -124(%ebp,%eax)
	movb	$0, -124(%ebp,%edi)
	movzbl	termInitialized, %eax
	testb	%bl, %bl
	je	.L83
	xorl	%edi, %edi
	leal	-124(%ebp), %esi
	.align 16
.L84:
	addl	$1, %edi
	cmpb	$0, (%esi,%edi)
	jne	.L84
	testb	%al, %al
	je	.L98
.L88:
	xorl	%eax, %eax
	movl	%esi, %ecx
	movl	%eax, %esi
	movsbl	%bl, %eax
	movl	%ecx, %ebx
	jmp	.L87
	.align 16
.L99:
	movsbl	(%ebx,%esi), %eax
.L87:
	subl	$12, %esp
	addl	$1, %esi
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%esi, %edi
	ja	.L99
.L80:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L98:
	call	termInit.part.0
	jmp	.L88
	.align 16
.L83:
	testb	%al, %al
	jne	.L80
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	jmp	termInit.part.0
	.align 16
.L91:
	movl	$2, %edi
	movl	$1, %eax
	jmp	.L81
	.size	termPrintInt, .-termPrintInt
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
	movl	termCol, %eax
	movl	8(%ebp), %ebx
	movl	$79, termCol
	movzbl	termInitialized, %edx
	movl	%eax, -28(%ebp)
	movsbl	(%ebx), %eax
	testb	%al, %al
	je	.L101
	xorl	%edi, %edi
	.align 16
.L102:
	addl	$1, %edi
	cmpb	$0, (%ebx,%edi)
	jne	.L102
	testb	%dl, %dl
	je	.L115
.L106:
	xorl	%esi, %esi
	jmp	.L105
	.align 16
.L116:
	movsbl	(%ebx,%esi), %eax
.L105:
	subl	$12, %esp
	addl	$1, %esi
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%esi, %edi
	ja	.L116
.L104:
	movzbl	-28(%ebp), %esi
	movl	%esi, termCol
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L115:
	call	termInit.part.0
	movsbl	(%ebx), %eax
	jmp	.L106
	.align 16
.L101:
	testb	%dl, %dl
	jne	.L104
	call	termInit.part.0
	jmp	.L104
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
	movl	termCol, %eax
	movl	8(%ebp), %ebx
	movl	$239, termCol
	movzbl	termInitialized, %edx
	movl	%eax, -28(%ebp)
	movsbl	(%ebx), %eax
	testb	%al, %al
	je	.L118
	xorl	%edi, %edi
	.align 16
.L119:
	addl	$1, %edi
	cmpb	$0, (%ebx,%edi)
	jne	.L119
	testb	%dl, %dl
	je	.L132
.L123:
	xorl	%esi, %esi
	jmp	.L122
	.align 16
.L133:
	movsbl	(%ebx,%esi), %eax
.L122:
	subl	$12, %esp
	addl	$1, %esi
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%esi, %edi
	ja	.L133
.L121:
	movzbl	-28(%ebp), %esi
	movl	%esi, termCol
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L132:
	call	termInit.part.0
	movsbl	(%ebx), %eax
	jmp	.L123
	.align 16
.L118:
	testb	%dl, %dl
	jne	.L121
	call	termInit.part.0
	jmp	.L121
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
	je	.L134
	.align 16
.L141:
	xorl	%eax, %eax
	.align 16
.L137:
	addl	$1, %eax
	cmpb	$0, (%edx,%eax)
	jne	.L137
	cmpl	%eax, %ecx
	jnb	.L134
	movsbw	(%edx,%ecx), %ax
	orl	%ebx, %eax
	movw	%ax, 753664(%ecx,%ecx)
	addl	$1, %ecx
	cmpb	$0, (%edx)
	jne	.L141
.L134:
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
	je	.L142
	.align 16
.L149:
	xorl	%eax, %eax
	.align 16
.L145:
	addl	$1, %eax
	cmpb	$0, (%edx,%eax)
	jne	.L145
	cmpl	%eax, %ecx
	jnb	.L142
	movsbw	(%edx,%ecx), %ax
	addl	$2, %ebx
	addl	$1, %ecx
	orb	$79, %ah
	movw	%ax, -2(%ebx)
	cmpb	$0, (%edx)
	jne	.L149
.L142:
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
	je	.L150
	.align 16
.L157:
	xorl	%eax, %eax
	.align 16
.L153:
	addl	$1, %eax
	cmpb	$0, (%edx,%eax)
	jne	.L153
	cmpl	%eax, %ecx
	jnb	.L150
	movsbw	(%edx,%ecx), %ax
	addl	$2, %ebx
	addl	$1, %ecx
	orw	$-4352, %ax
	movw	%ax, -2(%ebx)
	cmpb	$0, (%edx)
	jne	.L157
.L150:
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	alertWarning, .-alertWarning
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"0123456789abcdef"
	.text
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
	je	.L161
	.align 16
.L160:
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
	jne	.L160
.L161:
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
	jmp	.L171
.L169:
	movzbl	.LC1(%eax), %edx
.L171:
	movb	%dl, -1024(%ebp,%eax)
	addl	$1, %eax
	cmpl	$11, %eax
	jne	.L169
	leal	-1013(%ebp), %eax
	movl	$.LC0+1, %edx
	leal	-965(%ebp), %ebx
	movl	$48, %ecx
	jmp	.L170
	.align 16
.L197:
	movzbl	(%edx), %ecx
	addl	$1, %edx
.L170:
	movb	$48, (%eax)
	addl	$3, %eax
	movb	%cl, -2(%eax)
	movb	$32, -1(%eax)
	cmpl	%ebx, %eax
	jne	.L197
	movl	-1048(%ebp), %eax
	leal	-906(%ebp), %esi
	movb	$10, -965(%ebp)
	movl	$0, -1040(%ebp)
	movl	$138, -1044(%ebp)
	leal	-60(%eax), %edi
	leal	-964(%ebp), %eax
	movl	%eax, -1036(%ebp)
.L179:
	movl	-1036(%ebp), %eax
	movl	-1048(%ebp), %ebx
	movl	$28, %ecx
	addl	-1040(%ebp), %ebx
	.align 16
.L173:
	movl	%ebx, %edx
	addl	$1, %eax
	shrl	%cl, %edx
	subl	$4, %ecx
	andl	$15, %edx
	movzbl	.LC0(%edx), %edx
	movb	%dl, -1(%eax)
	cmpl	$-4, %ecx
	jne	.L173
	movb	$124, -50(%esi)
	leal	-48(%esi), %eax
	movb	$32, -49(%esi)
	.align 16
.L174:
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
	jne	.L174
	movl	-1036(%ebp), %ecx
	xorl	%eax, %eax
	movl	$32, %edx
	jmp	.L176
	.align 16
.L198:
	movzbl	.LC2(%eax), %edx
.L176:
	movb	%dl, 58(%ecx,%eax)
	addl	$1, %eax
	cmpl	$4, %eax
	jne	.L198
	movl	-1044(%ebp), %ebx
	leal	-16(%ebx), %eax
	.align 16
.L178:
	movzbl	-62(%edi,%eax), %edx
	leal	-32(%edx), %ecx
	cmpb	$95, %cl
	movl	$46, %ecx
	cmovnb	%ecx, %edx
	movb	%dl, -1024(%ebp,%eax)
	addl	$1, %eax
	cmpl	%ebx, %eax
	jne	.L178
	leal	79(%eax), %ebx
	movb	$10, 20(%esi)
	subl	$63, %edi
	addl	$79, %esi
	addl	$16, -1040(%ebp)
	addl	$79, -1036(%ebp)
	movl	%ebx, -1044(%ebp)
	cmpl	$849, %eax
	jne	.L179
	movsbl	-1024(%ebp), %eax
	movb	$0, -174(%ebp)
	movzbl	termInitialized, %edx
	testb	%al, %al
	je	.L180
	xorl	%ebx, %ebx
.L181:
	addl	$1, %ebx
	cmpb	$0, -1024(%ebp,%ebx)
	jne	.L181
	testb	%dl, %dl
	je	.L199
.L185:
	xorl	%esi, %esi
	jmp	.L184
.L200:
	movsbl	-1024(%ebp,%esi), %eax
.L184:
	subl	$12, %esp
	addl	$1, %esi
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%esi, %ebx
	ja	.L200
.L168:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L199:
	movb	%al, -1036(%ebp)
	call	termInit.part.0
	movsbl	-1036(%ebp), %eax
	jmp	.L185
.L180:
	testb	%dl, %dl
	jne	.L168
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
	subl	$24, %esp
	pushl	multibootTable
	call	dbgPrintMemory
	movl	multibootTable, %eax
	addl	$16, %esp
	movl	(%eax), %ebx
	andl	$64, %ebx
	je	.L209
	leal	-12(%ebp), %esp
	movl	$1, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L209:
	movl	termCol, %esi
	movl	$79, termCol
	.align 16
.L203:
	addl	$1, %ebx
	cmpb	$0, .LC3(%ebx)
	jne	.L203
	cmpb	$0, termInitialized
	je	.L210
.L204:
	movl	$.LC3+1, %edi
	addl	$.LC3, %ebx
	movl	$102, %eax
	jmp	.L206
	.align 16
.L211:
	movsbl	(%edi), %eax
	addl	$1, %edi
.L206:
	subl	$12, %esp
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%edi, %ebx
	jne	.L211
	andl	$255, %esi
	movl	$1, %eax
	movl	%esi, termCol
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L210:
	call	termInit.part.0
	jmp	.L204
	.size	multibootSaveData, .-multibootSaveData
	.align 16
	.globl	kernelInit
	.type	kernelInit, @function
kernelInit:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$24, %esp
	pushl	multibootTable
	call	dbgPrintMemory
	movl	multibootTable, %eax
	addl	$16, %esp
	movl	(%eax), %ebx
	andl	$64, %ebx
	je	.L220
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L220:
	movl	termCol, %esi
	movl	$79, termCol
	.align 16
.L214:
	addl	$1, %ebx
	cmpb	$0, .LC3(%ebx)
	jne	.L214
	cmpb	$0, termInitialized
	je	.L221
.L215:
	movl	$.LC3+1, %edi
	addl	$.LC3, %ebx
	movl	$102, %eax
	jmp	.L217
	.align 16
.L222:
	movsbl	(%edi), %eax
	addl	$1, %edi
.L217:
	subl	$12, %esp
	pushl	%eax
	call	termPushChar
	addl	$16, %esp
	cmpl	%edi, %ebx
	jne	.L222
	andl	$255, %esi
	movl	%esi, termCol
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.align 16
.L221:
	call	termInit.part.0
	jmp	.L215
	.size	kernelInit, .-kernelInit
	.align 16
	.globl	kernelMain
	.type	kernelMain, @function
kernelMain:
	ret
	.size	kernelMain, .-kernelMain
	.globl	multibootMmapEntries
	.section	.bss
	.align 32
	.type	multibootMmapEntries, @object
	.size	multibootMmapEntries, 280
multibootMmapEntries:
	.zero	280
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
	.type	termColor, @object
	.size	termColor, 1
termColor:
	.zero	1
	.globl	termCol
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
