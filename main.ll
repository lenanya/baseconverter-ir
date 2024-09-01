target triple = "x86_64-pc-linux-gnu"

@.stringformat = constant [4 x i8] c"%s\0A\00"
@.numformat = constant [4 x i8] c"%d\0A\00"
@.err_nearg = constant [22 x i8] c"Not enough arguments\0A\00"
@.digs = constant [16 x i8] c"0123456789ABCDEF"

define i32 @main(i32 noundef %argc, ptr noundef %argv) {
entry:
	%argcm = alloca i32
	%argvm = alloca ptr
	store i32 %argc, ptr %argcm
	store ptr %argv, ptr %argvm
	%lt3args = icmp slt i32 %argc, 3
	br i1 %lt3args, label %reterr_nearg, label %mainbody

mainbody:
	%num = alloca i32
	%base = alloca i32
	%res = alloca [32 x i8]
	%counter = alloca i32
	store i32 0, ptr %counter
	%argv1 = load ptr, ptr %argvm
	%argv1p = getelementptr inbounds ptr, ptr %argv1, i32 1
	%argv1p1 = load ptr, ptr %argv1p
	%argv1n = call i32 @atoi(ptr noundef %argv1p1)
	store i32 %argv1n, ptr %num
	%argv2 = load ptr, ptr %argvm
	%argv2p = getelementptr inbounds ptr, ptr %argv2, i32 2
	%argv2p1 = load ptr, ptr %argv2p
	%argv2n = call i32 @atoi(ptr noundef %argv2p1)
	store i32 %argv2n, ptr %base
	br label %loop

loop:
	%numc = load i32, ptr %num
	%ne0 = icmp ne i32 %numc, 0
	br i1 %ne0, label %loopbody, label %revres

loopbody:
	%numo = load i32, ptr %num
	%base1 = load i32, ptr %base
	%d = srem i32 %numo, %base1
	%dvp = getelementptr [16 x i8], [16 x i8]* @.digs, i32 0, i32 %d
	%dv = load i8, ptr %dvp
	%counterc = load i32, ptr %counter
	%resindp = getelementptr [32 x i8], [32 x i8]* %res, i32 0, i32 %counterc
	store i8 %dv, ptr %resindp
	%numnew = sdiv i32 %numo, %base1
	store i32 %numnew, ptr %num
	br label %inc

inc:
	%counterold = load i32, ptr %counter
	%counternew = add i32 1, %counterold
	store i32 %counternew, ptr %counter
	br label %loop

reterr_nearg:
	call i32 @printf(ptr noundef @.stringformat, ptr noundef @.err_nearg)
	ret i32 1

revres:
	%rescounter = alloca i32
	%len = call i32 @strlen(ptr noundef %res)
	%len_t = sub i32 %len, 1
	store i32 %len_t, ptr %rescounter
	%resr = alloca [32 x i8]
	%resr_end = getelementptr [32 x i8], [32 x i8]* %resr, i32 0, i32 %len
	store i8 0, ptr %resr_end
	br label %revresloop

revresloop:
	%rcounter = load i32, ptr %rescounter
	%lt0 = icmp slt i32 %rcounter, 0
	br i1 %lt0, label %printres, label %rloopbody

rloopbody:
	%ind = load i32, ptr %rescounter
	%indr = sub i32 %len_t, %ind
	%res_indp = getelementptr [32 x i8], [32 x i8]* %res, i32 0, i32 %ind
	%res_indv = load i8, ptr %res_indp
	%resr_indp = getelementptr [32 x i8], [32 x i8]* %resr, i32 0, i32 %indr
	store i8 %res_indv, ptr %resr_indp
	br label %dec

dec:
	%indc = load i32, ptr %rescounter
	%indn = sub i32 %indc, 1
	store i32 %indn, ptr %rescounter
	br label %revresloop

printres:
	call i32 @printf(ptr noundef @.stringformat, ptr noundef %resr)
	ret i32 0

}

declare i32 @printf(ptr noundef, ...)
declare i32 @atoi(ptr noundef)
declare i32 @strlen(ptr noundef)
